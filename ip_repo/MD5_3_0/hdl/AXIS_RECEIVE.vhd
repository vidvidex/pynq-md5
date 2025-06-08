library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXIS_RECEIVE is
	generic (
     	DATA_WIDTH	: integer	:= 512;
     	FIFO_DEPTH	: integer	:= 128
	);
	port (       
        S_AXIS_ACLK	: in std_logic;
        S_AXIS_ARESETN	: in std_logic; 
        S_AXIS_TREADY	: out std_logic;
        S_AXIS_TDATA	: in std_logic_vector(DATA_WIDTH-1 downto 0);
        S_AXIS_TVALID	: in std_logic;
        S_AXIS_TLAST	: in std_logic;
        
        DATA_AVAILABLE : out std_logic;
        READ_ENABLE : in std_logic;
        DATA : out std_logic_vector(DATA_WIDTH-1 downto 0);
        DATA_VALID : out std_logic;
        
        RECEIVE_DONE : out std_logic;
        PROCESSING_DONE : in std_logic
	);
end entity;

architecture behavioral of AXIS_RECEIVE is
    
    type fifo_t is array (0 to FIFO_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal fifo : fifo_t;
    
    signal head, tail : integer range 0 to FIFO_DEPTH-1;
    signal fill_count_i : integer range FIFO_DEPTH - 1 downto 0;
    
    procedure incr(signal index : inout integer range 0 to FIFO_DEPTH-1) is
    begin
        if index = FIFO_DEPTH-1 then
            index <= 0;
        else
            index <= index + 1;
        end if;
    end procedure;
    
begin
   
    S_AXIS_TREADY <= '1';
    DATA_AVAILABLE <= '1' when fill_count_i > 0 else '0';
      
    process(S_AXIS_ACLK)                                                          
    begin    
                                                                         
        if rising_edge (S_AXIS_ACLK) then  
            if S_AXIS_ARESETN = '0' then                                             
                DATA <= (others => '0');  
                RECEIVE_DONE <= '0';
            else
                DATA <= fifo(tail);
                                
                if S_AXIS_TLAST = '1' then
                    RECEIVE_DONE <= '1';
                elsif PROCESSING_DONE = '1' then
                    RECEIVE_DONE <= '0';
                end if;
                                                       
            end if;                                                        
        end if;

    end process;
   
   process(S_AXIS_ACLK)
    begin
        if rising_edge(S_AXIS_ACLK) then
            if S_AXIS_ARESETN = '0' then
                head <= 0;
                tail <= 0;
            else
                if S_AXIS_TVALID = '1' and fill_count_i < FIFO_DEPTH then
                    incr(head);
                end if;
                
                if READ_ENABLE = '1' then
                    incr(tail);
                    DATA_VALID <= '1';
                else
                    DATA_VALID <= '0';
                end if;

                fifo(head) <= S_AXIS_TDATA;
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

