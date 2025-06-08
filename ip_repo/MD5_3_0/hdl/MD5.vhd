library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MD5 is
	generic (
		IN_DATA_WIDTH	: integer	:= 512;
		OUT_DATA_WIDTH	: integer	:= 128
	);
	port (
		axis_aclk	: in std_logic;
		axis_resetn	: in std_logic;
		
		m00_axis_tdata	: out std_logic_vector(OUT_DATA_WIDTH-1 downto 0);
		m00_axis_tready	: in std_logic;
		m00_axis_tvalid	: out std_logic;
		m00_axis_tlast	: out std_logic;
	
		s00_axis_tdata	: in std_logic_vector(IN_DATA_WIDTH-1 downto 0);
        s00_axis_tready	: out std_logic;
        s00_axis_tvalid	: in std_logic;
        s00_axis_tlast	: in std_logic
	);
end entity;

architecture behavioral of MD5 is
    
    signal pipeline_enable : std_logic;
             
    signal hash : std_logic_vector(127 downto 0);
    signal original_in : std_logic_vector(127 downto 0);
            
    signal in_A, in_B, in_C, in_D : std_logic_vector(31 downto 0);
    signal out_A, out_B, out_C, out_D : std_logic_vector(31 downto 0);
    
    signal input_data_available : std_logic;
    signal input_data_available_old : std_logic;
    
    signal receive_done : std_logic;
    signal receive_done_old : std_logic;
    signal processing_done : std_logic;
    
    signal input_data : std_logic_vector(IN_DATA_WIDTH-1 downto 0);
    signal input_data_valid : std_logic;

    signal md5_valid, insert_to_send_fifo, insert_to_send_fifo_old : std_logic;
        
    signal first : std_logic;
    
begin

    process (axis_aclk)
    begin
        if rising_edge(axis_aclk) then
       
            if axis_resetn = '0' then
                first <= '1';
                processing_done <= '0';
            else
                input_data_available_old <= input_data_available;
                insert_to_send_fifo_old <= insert_to_send_fifo;
        
                if md5_valid = '1' then
                    first <= '0';
                end if;
                
                if receive_done = '1' and insert_to_send_fifo = '0' and insert_to_send_fifo_old = '1' then
                    processing_done <= '1';
                elsif processing_done = '1' then
                    processing_done <= '0';
                end if;
                
            end if;
            
        end if;
    end process;  
    
    in_A <= x"67452301" when first = '1' and md5_valid = '0' else out_A;
    in_B <= x"efcdab89" when first = '1' and md5_valid = '0' else out_B;
    in_C <= x"98badcfe" when first = '1' and md5_valid = '0' else out_C;
    in_D <= x"10325476" when first = '1' and md5_valid = '0' else out_D;
        
    original_in <= in_D & in_C & in_B & in_A;
        
    AXIS_RECEIVE : entity work.AXIS_RECEIVE(behavioral)
	generic map (
		DATA_WIDTH	=> IN_DATA_WIDTH
	)
	port map (
		S_AXIS_ACLK	=> axis_aclk,
		S_AXIS_ARESETN	=> axis_resetn,
		S_AXIS_TREADY	=> s00_axis_tready,
		S_AXIS_TDATA	=> s00_axis_tdata,
		S_AXIS_TVALID	=> s00_axis_tvalid,
		S_AXIS_TLAST	=> s00_axis_tlast,
		
        DATA_AVAILABLE => input_data_available,
        READ_ENABLE => input_data_available,

        DATA => input_data,
        DATA_VALID => input_data_valid,
        
        RECEIVE_DONE => receive_done,
        PROCESSING_DONE => processing_done
	);
	
    pipeline_enable <= '1' when (input_data_valid = '1') or (receive_done = '1' and input_data_available = '0') else '0';
	
    MD5_calc: entity work.MD5_calc_64(behavioral)
	port map (
        clock => axis_aclk,
        resetn => axis_resetn,
        enable  => pipeline_enable,


        in_data => input_data,
        in_valid => input_data_valid,
        in_A => in_A,
        in_B => in_B,
        in_C => in_C,
        in_D => in_D,
        original_in => original_in,
        
        out_valid => md5_valid,
        out_A => out_A,
        out_B => out_B,
        out_C => out_C,
        out_D => out_D
	);
           
	hash <= out_D & out_C & out_B & out_A;
    insert_to_send_fifo <= '1' when md5_valid = '1' and input_data_available = '0' and input_data_available_old = '0' and receive_done = '1' else '0';
           
    AXIS_SEND : entity work.AXIS_SEND(behavioral)
	generic map (
		DATA_WIDTH	=> OUT_DATA_WIDTH
	)
	port map (
		M_AXIS_ACLK	=> axis_aclk,
		M_AXIS_ARESETN	=> axis_resetn,
		M_AXIS_TVALID	=> m00_axis_tvalid,
		M_AXIS_TDATA	=> m00_axis_tdata,
		M_AXIS_TREADY	=> m00_axis_tready,
		M_AXIS_TLAST	=> m00_axis_tlast,
		
		DATA => hash,
		DATA_VALID => insert_to_send_fifo
	);   


end architecture;
