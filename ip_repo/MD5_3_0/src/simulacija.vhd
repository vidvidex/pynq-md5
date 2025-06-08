library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity simulacija is
--  Port ( );
end simulacija;

architecture Behavioral of simulacija is

    constant clock_period : time := 10 ns;
    
    constant IN_DATA_WIDTH	: integer	:= 512;
    constant OUT_DATA_WIDTH	: integer	:= 128;
        
    signal clock : std_logic := '0';
    signal resetn : std_logic := '0';
    
    signal m00_axis_tdata	: std_logic_vector(OUT_DATA_WIDTH-1 downto 0);
    signal m00_axis_tready	: std_logic;
    signal m00_axis_tvalid	: std_logic;
    signal m00_axis_tlast	: std_logic;
    
    signal s00_axis_tdata	: std_logic_vector(IN_DATA_WIDTH-1 downto 0);
    signal s00_axis_tready	: std_logic;
    signal s00_axis_tvalid	: std_logic;
    signal s00_axis_tlast	: std_logic;
    
    
    type int_buf_t is array(0 to 127) of std_logic_vector(IN_DATA_WIDTH-1 downto 0);
    signal data : int_buf_t;
    
    signal pause : integer;
    
begin
    
    pause <= 5;
    
    --data(0)  <= x"61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161";
    --data(1)  <= x"0000000000000008" & (IN_DATA_WIDTH-1-64 downto 16 => '0') & x"8061";  -- a
    --data(2)  <= x"00000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080";
    
    data(0) <= x"61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161";
    data(1) <= x"62626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262";
    data(2) <= x"63636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363";
    data(3) <= x"64646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464";
    data(4) <= x"65656565656565656565656565656565656565656565656565656565656565656565656565656565656565656565656565656565656565656565656565656565";
    data(5) <= x"66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666";
    data(6) <= x"67676767676767676767676767676767676767676767676767676767676767676767676767676767676767676767676767676767676767676767676767676767";
    data(7) <= x"68686868686868686868686868686868686868686868686868686868686868686868686868686868686868686868686868686868686868686868686868686868";
    
    data(8) <= x"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    
    data(9) <= x"00000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080";
    
    UUT: entity work.MD5(behavioral)
    port map(
        axis_aclk => clock,
		axis_resetn => resetn,
		
		m00_axis_tdata => m00_axis_tdata,
		m00_axis_tvalid => m00_axis_tvalid,
		m00_axis_tready => m00_axis_tready,
		m00_axis_tlast => m00_axis_tlast,

        s00_axis_tdata => s00_axis_tdata,
        s00_axis_tvalid	 => s00_axis_tvalid,
		s00_axis_tready => s00_axis_tready,
		s00_axis_tlast => s00_axis_tlast		
   );

    -- Stimuli
    stimulus_clk: process 
    begin 
        clock <= not clock;
        wait for clock_period/2;
    end process;
    
    stimuli_other: process 
    begin
        
        -- Long reset 
        resetn <= '0';
        wait for clock_period*2;
--        m00_axis_tready <= '1';
      
        -- Remove reset 
        resetn <= '1';
        wait for clock_period*2;
              

        for i in 0 to 7 loop
            s00_axis_tdata <= data(i);
            s00_axis_tvalid <= '1';
            wait for clock_period;
            
            s00_axis_tvalid <= '0';
            wait for clock_period*pause; 
        end loop;
        
        for i in 8 to 63 loop
            s00_axis_tdata <= data(8);
            s00_axis_tvalid <= '1';
            wait for clock_period;
            
            s00_axis_tvalid <= '0';
            wait for clock_period*pause; 
        end loop;
        
        for i in 64 to 71 loop
            s00_axis_tdata <= data(9);
            s00_axis_tvalid <= '1';
            wait for clock_period;
            
            s00_axis_tvalid <= '0';
            wait for clock_period*pause; 
        end loop;
        
        for i in 72 to 126 loop
            s00_axis_tdata <= data(8);
            s00_axis_tvalid <= '1';
            wait for clock_period;
            
            s00_axis_tvalid <= '0';
            wait for clock_period*pause; 
        end loop;

        s00_axis_tdata <= data(8);
        s00_axis_tvalid <= '1';
        s00_axis_tlast <= '1';
        
        wait for clock_period;
        
        s00_axis_tvalid <= '0';
        s00_axis_tlast <= '0';
        
        wait for clock_period*3 + clock_period*0.5;
        
        m00_axis_tready <= '1';
         
        wait for clock_period*10;
         
--        m00_axis_tready <= '0';
                
        wait;
        
    end process;


end Behavioral;
