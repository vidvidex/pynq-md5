----------------------------------------------------------------------------------
-- Lookup tabela za konstante
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity MD5_ROM_K is
  Port (
    index : in integer range 0 to 63;
    konstanta : out unsigned(31 downto 0)
  );
end entity;

architecture Behavioral of MD5_ROM_K is

type ROM_type is array (0 to 63) of unsigned(konstanta'length-1 downto 0);

signal ROM_konstante : rom_type := (
                            x"d76aa478",
                            x"e8c7b756",
                            x"242070db",
                            x"c1bdceee",
                            x"f57c0faf",
                            x"4787c62a",
                            x"a8304613",
                            x"fd469501",
                            x"698098d8",
                            x"8b44f7af",
                            x"ffff5bb1",
                            x"895cd7be",
                            x"6b901122",
                            x"fd987193",
                            x"a679438e",
                            x"49b40821",
                            x"f61e2562",
                            x"c040b340",
                            x"265e5a51",
                            x"e9b6c7aa",
                            x"d62f105d",
                            x"02441453",
                            x"d8a1e681",
                            x"e7d3fbc8",
                            x"21e1cde6",
                            x"c33707d6",
                            x"f4d50d87",
                            x"455a14ed",
                            x"a9e3e905",
                            x"fcefa3f8",
                            x"676f02d9",
                            x"8d2a4c8a",
                            x"fffa3942",
                            x"8771f681",
                            x"6d9d6122",
                            x"fde5380c",
                            x"a4beea44",
                            x"4bdecfa9",
                            x"f6bb4b60",
                            x"bebfbc70",
                            x"289b7ec6",
                            x"eaa127fa",
                            x"d4ef3085",
                            x"04881d05",
                            x"d9d4d039",
                            x"e6db99e5",
                            x"1fa27cf8",
                            x"c4ac5665",
                            x"f4292244",
                            x"432aff97",
                            x"ab9423a7",
                            x"fc93a039",
                            x"655b59c3",
                            x"8f0ccc92",
                            x"ffeff47d",
                            x"85845dd1",
                            x"6fa87e4f",
                            x"fe2ce6e0",
                            x"a3014314",
                            x"4e0811a1",
                            x"f7537e82",
                            x"bd3af235",
                            x"2ad7d2bb",
                            x"eb86d391"
                            ); 

begin

    konstanta <= ROM_konstante(index);

end architecture;
