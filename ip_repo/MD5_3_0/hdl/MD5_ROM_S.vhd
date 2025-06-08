----------------------------------------------------------------------------------
-- Lookup tabela za število shiftov
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity MD5_ROM_S is
  Port (
    index : in integer range 0 to 63;
    shiftov : out integer range 0 to 31
  );
end entity;

architecture Behavioral of MD5_ROM_S is

type ROM_type is array (0 to 63) of integer range 0 to 31;

signal ROM_shifti : rom_type := (
                            7,
                            12,
                            17,
                            22,
                            7,
                            12,
                            17,
                            22,
                            7,
                            12,
                            17,
                            22,
                            7,
                            12,
                            17,
                            22,
                            5,
                            9,
                            14,
                            20,
                            5,
                            9,
                            14,
                            20,
                            5,
                            9,
                            14,
                            20,
                            5,
                            9,
                            14,
                            20,
                            4,
                            11,
                            16,
                            23,
                            4,
                            11,
                            16,
                            23,
                            4,
                            11,
                            16,
                            23,
                            4,
                            11,
                            16,
                            23,
                            6,
                            10,
                            15,
                            21,
                            6,
                            10,
                            15,
                            21,
                            6,
                            10,
                            15,
                            21,
                            6,
                            10,
                            15,
                            21
                            );

begin

    shiftov <= ROM_shifti(index);

end architecture;
