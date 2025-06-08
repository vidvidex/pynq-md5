----------------------------------------------------------------------------------
-- MD5 iteracija G
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MD5_iter_G is
  Port (
    clock : in std_logic;
    resetn : in std_logic;
    
    enable : in std_logic;
    i : in integer range 16 to 31;
    
    A_in : in std_logic_vector(31 downto 0);
    B_in : in std_logic_vector(31 downto 0);
    C_in : in std_logic_vector(31 downto 0);
    D_in : in std_logic_vector(31 downto 0);
    data_in: in std_logic_vector(511 downto 0);
    valid_in : in std_logic;
    orig_in : in std_logic_vector(127 downto 0);
        
    A_out : out std_logic_vector(31 downto 0);
    B_out : out std_logic_vector(31 downto 0);
    C_out : out std_logic_vector(31 downto 0);
    D_out : out std_logic_vector(31 downto 0);
    data_out: out std_logic_vector(511 downto 0);
    valid_out : out std_logic;
    orig_out : out std_logic_vector(127 downto 0)
  );
end entity;

architecture Behavioral of MD5_iter_G is

    signal temp : unsigned (31 downto 0);
    signal g : integer range 0 to 15;
    signal shiftov : integer range 0 to 31;
    signal konstanta : unsigned (31 downto 0);
    
begin
    
    konstanta_lookup: entity work.MD5_ROM_K(Behavioral)
    port map(
        index => i,
        konstanta => konstanta
    );
    
    shift_lookup: entity work.MD5_ROM_S(Behavioral)
    port map(
        index => i,
        shiftov => shiftov
    );
        
    g <= (i*5+1) mod 16;
    temp <= unsigned(B_in) + rotate_left(unsigned(A_in) + unsigned((D_in and B_in) or ((not D_in) and C_in)) + unsigned(data_in(511-g*32 downto 511-g*32-31)) + konstanta, shiftov);

    process (clock)
    begin
        
        if rising_edge(clock) then
        
            if resetn = '0' then
                A_out <= (others => '0');
                B_out <= (others => '0');
                C_out <= (others => '0');
                D_out <= (others => '0');
                
                valid_out <= '0';
                data_out <= (others => '0');
                orig_out <= (others => '0');
            elsif enable = '1' then
                A_out <= D_in;   
                D_out <= C_in; 
                C_out <= B_in;
                B_out <= std_logic_vector(temp);
                
                valid_out <= valid_in;
                data_out <= data_in;  
                orig_out <= orig_in;
            end if;

        end if;
   
    end process;
   
end architecture;
