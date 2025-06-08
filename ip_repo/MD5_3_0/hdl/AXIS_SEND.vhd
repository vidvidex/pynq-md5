library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXIS_SEND is
	generic (
     	DATA_WIDTH	: integer	:= 128;
     	FIFO_DEPTH	: integer	:= 64
	);
	port (
        M_AXIS_ACLK	: in std_logic;
		M_AXIS_ARESETN	: in std_logic;
		
        DATA : in std_logic_vector(DATA_WIDTH-1 downto 0);
        DATA_VALID : in std_logic;
        
		M_AXIS_TVALID	: out std_logic;
		M_AXIS_TDATA	: out std_logic_vector(DATA_WIDTH-1 downto 0);
		M_AXIS_TREADY	: in std_logic;
		M_AXIS_TLAST	: out std_logic
	);
end AXIS_SEND;

architecture behavioral of AXIS_SEND is
	
	signal axis_tvalid	: std_logic;
	signal axis_tvalid_delay	: std_logic;
	signal axis_tlast	: std_logic;
	signal axis_tlast_delay	: std_logic;
	signal stream_data_out	: std_logic_vector(DATA_WIDTH-1 downto 0);

    type fifo_t is array (0 to FIFO_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal fifo : fifo_t := (others => (others => '0'));

    signal head, tail : integer range 0 to FIFO_DEPTH-1;
    signal empty_i, full_i : std_logic;
    signal fill_count_i : integer range FIFO_DEPTH - 1 downto 0;
    
    signal sending, sending_old : std_logic;
    signal valid, valid_old : std_logic;
    
    procedure incr(signal index : inout integer range 0 to FIFO_DEPTH-1) is
    begin
        if index = FIFO_DEPTH-1 then
            index <= 0;
        else
            index <= index + 1;
        end if;
    end procedure;
        
begin

	M_AXIS_TVALID <= axis_tvalid_delay;
	M_AXIS_TDATA <= stream_data_out;
	M_AXIS_TLAST <= '1' when axis_tlast = '1' and empty_i = '1' else '0';

	valid <= '1' when empty_i = '0' else '0';
	axis_tvalid <= '1' when empty_i = '0' else '0';
	axis_tlast <= '1' when sending = '0' and sending_old = '1' else '0';  
	                   
    empty_i <= '1' when fill_count_i = 0 else '0';
    full_i <= '1' when fill_count_i >= FIFO_DEPTH - 1 else '0';
    
    sending <= '1' when M_AXIS_TREADY = '1' and axis_tvalid = '1' else '0';                                                                          
                                
    -- Delay the axis_tvalid and axis_tlast signal by one clock cycle                              
    -- to match the latency of M_AXIS_TDATA
    process(M_AXIS_ACLK)                                                                           
    begin                                                                                          
        if rising_edge (M_AXIS_ACLK) then                                                          
            if M_AXIS_ARESETN = '0' then                                                              
                axis_tvalid_delay <= '0';                                                                
            else                                                                                       
                axis_tvalid_delay <= axis_tvalid;        
                
                sending_old <= sending;                                                       
                valid_old <= valid;                                                       
            end if;                                                                                    
        end if;                                                                                      
    end process;                                                                                   
                                                                   
    process(M_AXIS_ACLK)                                                          
    begin    
                                                                         
        if rising_edge (M_AXIS_ACLK) then  
            if M_AXIS_ARESETN = '0' then                                             
                stream_data_out <= (others => '0');  
            else
                stream_data_out <= fifo(tail);
            end if;                                                        
        end if;

    end process;
    

    process(M_AXIS_ACLK)
    begin
        if rising_edge(M_AXIS_ACLK) then
            if M_AXIS_ARESETN = '0' then
                head <= 0;
                tail <= 0;
            else
                if DATA_VALID = '1' and full_i = '0' then
                    incr(head);
                end if;
                
                if sending = '1' then
                    incr(tail);
                end if;

                fifo(head) <= DATA;
            end if;
        end if;
    end process;
 
    process(head, tail)
    begin
        if head < tail then
            fill_count_i <= head - tail + FIFO_DEPTH;
        else
            fill_count_i <= head - tail;
        end if;
    end process;                                                      

end architecture;