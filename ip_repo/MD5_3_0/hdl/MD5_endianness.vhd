----------------------------------------------------------------------------------
-- Najprej zamenja endianness vsakega 32 bit bloka, na koncu pa še celotnega 512 bit bloka
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MD5_endianness is
    Port (        
        data_in: in std_logic_vector(511 downto 0);
        data_out : out std_logic_vector (511 downto 0)
    );
end entity;

architecture Behavioral of MD5_endianness is

    signal word00, word01, word02, word03, word04, word05, word06, word07, word08, word09, word10, word11, word12, word13, word14, word15 : std_logic_vector(31 downto 0);
  
    signal data_i : std_logic_vector (511 downto 0);
      
    function swap_endianness(vector : std_logic_vector) return std_logic_vector is
        variable ret      : std_logic_vector(vector'range);
        constant byte_count : integer := vector'length / 8;
    begin
    
        for i in 0 to byte_count-1 loop
            for j in 7 downto 0 loop
                ret(8*i + j) := vector(8*(byte_count-1-i) + j);
            end loop;
        end loop;
    
        return ret;
    end function;
    

begin
                 
    word00 <= data_in(511 downto 480); 
    word01 <= data_in(479 downto 448); 
    word02 <= data_in(447 downto 416); 
    word03 <= data_in(415 downto 384);
    word04 <= data_in(383 downto 352);
    word05 <= data_in(351 downto 320);
    word06 <= data_in(319 downto 288);
    word07 <= data_in(287 downto 256);
    word08 <= data_in(255 downto 224);
    word09 <= data_in(223 downto 192);
    word10 <= data_in(191 downto 160);
    word11 <= data_in(159 downto 128);
    word12 <= data_in(127 downto 96);
    word13 <= data_in(95 downto 64);
    word14 <= data_in(63 downto 32);
    word15 <= data_in(31 downto 0);
            
    data_i <=  swap_endianness(word00) &
                    swap_endianness(word01) &
                    swap_endianness(word02) &
                    swap_endianness(word03) &
                    swap_endianness(word04) &
                    swap_endianness(word05) &
                    swap_endianness(word06) &
                    swap_endianness(word07) &
                    swap_endianness(word08) &
                    swap_endianness(word09) &
                    swap_endianness(word10) &
                    swap_endianness(word11) &
                    swap_endianness(word12) &
                    swap_endianness(word13) &
                    swap_endianness(word14) &
                    swap_endianness(word15);
               
    data_out <= swap_endianness(data_i);

end architecture;
