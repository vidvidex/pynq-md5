----------------------------------------------------------------------------------
-- Modul za racunanje MD5 hasha (64 stopenjski cevovod)
--
-- Dobi podatke in dol�ino podatkov ter vrne hash in podatke pri katerih je ta hash bil izracunan
-- (zaradi pipelina niso isti kot tisti, ki jih v tistem trenutku damo noter)
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity MD5_calc_64 is
   Port (
        clock : in std_logic;
        resetn : in std_logic;
        
        enable : in std_logic;
                
        in_data: in std_logic_vector(511 downto 0);
        in_valid : in std_logic;
        in_A : in std_logic_vector(31 downto 0);
        in_B : in std_logic_vector(31 downto 0);
        in_C : in std_logic_vector(31 downto 0);
        in_D : in std_logic_vector(31 downto 0); 
        
        original_in : in std_logic_vector(127 downto 0);
        original_out : out std_logic_vector(127 downto 0);
        final_out : out std_logic_vector(127 downto 0);
              
        out_data: out std_logic_vector(511 downto 0);
        out_valid : out std_logic;
        out_A : out std_logic_vector(31 downto 0);
        out_B : out std_logic_vector(31 downto 0);
        out_C : out std_logic_vector(31 downto 0);
        out_D : out std_logic_vector(31 downto 0)
   );
end entity;

architecture Behavioral of MD5_calc_64 is

    signal data_endianness : std_logic_vector(511 downto 0);

    signal F00_data, F01_data, F02_data, F03_data, F04_data, F05_data, F06_data, F07_data, F08_data, F09_data, F10_data, F11_data, F12_data, F13_data, F14_data, F15_data: std_logic_vector(511 downto 0);
    signal G00_data, G01_data, G02_data, G03_data, G04_data, G05_data, G06_data, G07_data, G08_data, G09_data, G10_data, G11_data, G12_data, G13_data, G14_data, G15_data : std_logic_vector(511 downto 0);
    signal H00_data, H01_data, H02_data, H03_data, H04_data, H05_data, H06_data, H07_data, H08_data, H09_data, H10_data, H11_data, H12_data, H13_data, H14_data, H15_data : std_logic_vector(511 downto 0);
    signal I00_data, I01_data, I02_data, I03_data, I04_data, I05_data, I06_data, I07_data, I08_data, I09_data, I10_data, I11_data, I12_data, I13_data, I14_data, I15_data : std_logic_vector(511 downto 0);
    
    signal F00_A, F01_A, F02_A, F03_A, F04_A, F05_A, F06_A, F07_A, F08_A, F09_A, F10_A, F11_A, F12_A, F13_A, F14_A, F15_A : std_logic_vector(31 downto 0);
    signal G00_A, G01_A, G02_A, G03_A, G04_A, G05_A, G06_A, G07_A, G08_A, G09_A, G10_A, G11_A, G12_A, G13_A, G14_A, G15_A : std_logic_vector(31 downto 0);
    signal H00_A, H01_A, H02_A, H03_A, H04_A, H05_A, H06_A, H07_A, H08_A, H09_A, H10_A, H11_A, H12_A, H13_A, H14_A, H15_A : std_logic_vector(31 downto 0);
    signal I00_A, I01_A, I02_A, I03_A, I04_A, I05_A, I06_A, I07_A, I08_A, I09_A, I10_A, I11_A, I12_A, I13_A, I14_A, I15_A : std_logic_vector(31 downto 0); 
    
    signal F00_B, F01_B, F02_B, F03_B, F04_B, F05_B, F06_B, F07_B, F08_B, F09_B, F10_B, F11_B, F12_B, F13_B, F14_B, F15_B : std_logic_vector(31 downto 0);
    signal G00_B, G01_B, G02_B, G03_B, G04_B, G05_B, G06_B, G07_B, G08_B, G09_B, G10_B, G11_B, G12_B, G13_B, G14_B, G15_B : std_logic_vector(31 downto 0);
    signal H00_B, H01_B, H02_B, H03_B, H04_B, H05_B, H06_B, H07_B, H08_B, H09_B, H10_B, H11_B, H12_B, H13_B, H14_B, H15_B : std_logic_vector(31 downto 0);
    signal I00_B, I01_B, I02_B, I03_B, I04_B, I05_B, I06_B, I07_B, I08_B, I09_B, I10_B, I11_B, I12_B, I13_B, I14_B, I15_B : std_logic_vector(31 downto 0); 
       
    signal F00_C, F01_C, F02_C, F03_C, F04_C, F05_C, F06_C, F07_C, F08_C, F09_C, F10_C, F11_C, F12_C, F13_C, F14_C, F15_C : std_logic_vector(31 downto 0);
    signal G00_C, G01_C, G02_C, G03_C, G04_C, G05_C, G06_C, G07_C, G08_C, G09_C, G10_C, G11_C, G12_C, G13_C, G14_C, G15_C : std_logic_vector(31 downto 0);
    signal H00_C, H01_C, H02_C, H03_C, H04_C, H05_C, H06_C, H07_C, H08_C, H09_C, H10_C, H11_C, H12_C, H13_C, H14_C, H15_C : std_logic_vector(31 downto 0);
    signal I00_C, I01_C, I02_C, I03_C, I04_C, I05_C, I06_C, I07_C, I08_C, I09_C, I10_C, I11_C, I12_C, I13_C, I14_C, I15_C : std_logic_vector(31 downto 0); 
    
    signal F00_D, F01_D, F02_D, F03_D, F04_D, F05_D, F06_D, F07_D, F08_D, F09_D, F10_D, F11_D, F12_D, F13_D, F14_D, F15_D : std_logic_vector(31 downto 0);
    signal G00_D, G01_D, G02_D, G03_D, G04_D, G05_D, G06_D, G07_D, G08_D, G09_D, G10_D, G11_D, G12_D, G13_D, G14_D, G15_D : std_logic_vector(31 downto 0);
    signal H00_D, H01_D, H02_D, H03_D, H04_D, H05_D, H06_D, H07_D, H08_D, H09_D, H10_D, H11_D, H12_D, H13_D, H14_D, H15_D : std_logic_vector(31 downto 0);
    signal I00_D, I01_D, I02_D, I03_D, I04_D, I05_D, I06_D, I07_D, I08_D, I09_D, I10_D, I11_D, I12_D, I13_D, I14_D, I15_D : std_logic_vector(31 downto 0);
    
    signal F00_orig, F01_orig, F02_orig, F03_orig, F04_orig, F05_orig, F06_orig, F07_orig, F08_orig, F09_orig, F10_orig, F11_orig, F12_orig, F13_orig, F14_orig, F15_orig : std_logic_vector(127 downto 0);
    signal G00_orig, G01_orig, G02_orig, G03_orig, G04_orig, G05_orig, G06_orig, G07_orig, G08_orig, G09_orig, G10_orig, G11_orig, G12_orig, G13_orig, G14_orig, G15_orig : std_logic_vector(127 downto 0);
    signal H00_orig, H01_orig, H02_orig, H03_orig, H04_orig, H05_orig, H06_orig, H07_orig, H08_orig, H09_orig, H10_orig, H11_orig, H12_orig, H13_orig, H14_orig, H15_orig : std_logic_vector(127 downto 0);
    signal I00_orig, I01_orig, I02_orig, I03_orig, I04_orig, I05_orig, I06_orig, I07_orig, I08_orig, I09_orig, I10_orig, I11_orig, I12_orig, I13_orig, I14_orig, I15_orig : std_logic_vector(127 downto 0);
    
    signal F00_valid, F01_valid, F02_valid, F03_valid, F04_valid, F05_valid, F06_valid, F07_valid, F08_valid, F09_valid, F10_valid, F11_valid, F12_valid, F13_valid, F14_valid, F15_valid : std_logic;
    signal G00_valid, G01_valid, G02_valid, G03_valid, G04_valid, G05_valid, G06_valid, G07_valid, G08_valid, G09_valid, G10_valid, G11_valid, G12_valid, G13_valid, G14_valid, G15_valid : std_logic;
    signal H00_valid, H01_valid, H02_valid, H03_valid, H04_valid, H05_valid, H06_valid, H07_valid, H08_valid, H09_valid, H10_valid, H11_valid, H12_valid, H13_valid, H14_valid, H15_valid : std_logic;
    signal I00_valid, I01_valid, I02_valid, I03_valid, I04_valid, I05_valid, I06_valid, I07_valid, I08_valid, I09_valid, I10_valid, I11_valid, I12_valid, I13_valid, I14_valid, I15_valid : std_logic;
    
    signal original_out_i : std_logic_vector(127 downto 0);
    
    signal original_A, original_B, original_C, original_D : std_logic_vector(31 downto 0);
    signal final_A, final_B, final_C, final_D : std_logic_vector(31 downto 0);
     
    signal out_valid_i : std_logic;
    
begin

    F00_orig <= original_in;
    
    F00_A <= in_A;
    F00_B <= in_B;
    F00_C <= in_C;
    F00_D <= in_D;
    
    original_out <= original_out_i;
    final_out <= final_D & final_C & final_B & final_A;

    original_A <= original_out_i(31 downto 0);
    original_B <= original_out_i(63 downto 32);
    original_C <= original_out_i(95 downto 64);
    original_D <= original_out_i(127 downto 96);
    
    out_A <= std_logic_vector(unsigned(original_A) + unsigned(final_A)) when out_valid_i = '1' else (others => '0');
    out_B <= std_logic_vector(unsigned(original_B) + unsigned(final_B)) when out_valid_i = '1' else (others => '0');
    out_C <= std_logic_vector(unsigned(original_C) + unsigned(final_C)) when out_valid_i = '1' else (others => '0');
    out_D <= std_logic_vector(unsigned(original_D) + unsigned(final_D)) when out_valid_i = '1' else (others => '0');
                    
    F00_data <= data_endianness when in_valid = '1' else (others => '0');
              
    out_valid <= out_valid_i when enable = '1' else '0';
    
    swap_endianness: entity work.MD5_endianness(Behavioral)
    port map (
        data_in => in_data,
        data_out => data_endianness
    );
    
    iterF_00: entity work.MD5_iter_F(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 0,

        A_in => F00_A,
        B_in => F00_B,
        C_in => F00_C,
        D_in => F00_D,
        data_in => F00_data,
        valid_in => in_valid,
        orig_in => F00_orig,
        

        A_out => F01_A,
        B_out => F01_B,
        C_out => F01_C,
        D_out => F01_D,
        data_out => F01_data,
        valid_out => F01_valid,
        orig_out => F01_orig
    );

    iterF_01: entity work.MD5_iter_F(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 1,

        A_in => F01_A,
        B_in => F01_B,
        C_in => F01_C,
        D_in => F01_D,
        data_in => F01_data,
        valid_in => F01_valid,
        orig_in => F01_orig,
        
        A_out => F02_A,
        B_out => F02_B,
        C_out => F02_C,
        D_out => F02_D,
        data_out => F02_data,
        valid_out => F02_valid,
        orig_out => F02_orig
    );

    iterF_02: entity work.MD5_iter_F(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 2,

        A_in => F02_A,
        B_in => F02_B,
        C_in => F02_C,
        D_in => F02_D,
        data_in => F02_data,
        valid_in => F02_valid,
        orig_in => F02_orig,
        
        A_out => F03_A,
        B_out => F03_B,
        C_out => F03_C,
        D_out => F03_D,
        data_out => F03_data,
        valid_out => F03_valid,
        orig_out => F03_orig
    );

    iterF_03: entity work.MD5_iter_F(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 3,

        A_in => F03_A,
        B_in => F03_B,
        C_in => F03_C,
        D_in => F03_D,
        data_in => F03_data,
        valid_in => F03_valid,
        orig_in => F03_orig,
        
        A_out => F04_A,
        B_out => F04_B,
        C_out => F04_C,
        D_out => F04_D,
        data_out => F04_data,
        valid_out => F04_valid,
        orig_out => F04_orig
    );

    iterF_04: entity work.MD5_iter_F(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 4,

        A_in => F04_A,
        B_in => F04_B,
        C_in => F04_C,
        D_in => F04_D,
        data_in => F04_data,
        valid_in => F04_valid,
        orig_in => F04_orig,
        
        A_out => F05_A,
        B_out => F05_B,
        C_out => F05_C,
        D_out => F05_D,
        data_out => F05_data,
        valid_out => F05_valid,
        orig_out => F05_orig
    );

    iterF_05: entity work.MD5_iter_F(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 5,

        A_in => F05_A,
        B_in => F05_B,
        C_in => F05_C,
        D_in => F05_D,
        data_in => F05_data,
        valid_in => F05_valid,
        orig_in => F05_orig,
        
        A_out => F06_A,
        B_out => F06_B,
        C_out => F06_C,
        D_out => F06_D,
        data_out => F06_data,
        valid_out => F06_valid,
        orig_out => F06_orig
    );

    iterF_06: entity work.MD5_iter_F(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 6,

        A_in => F06_A,
        B_in => F06_B,
        C_in => F06_C,
        D_in => F06_D,
        data_in => F06_data,
        valid_in => F06_valid,
        orig_in => F06_orig,
        
        A_out => F07_A,
        B_out => F07_B,
        C_out => F07_C,
        D_out => F07_D,
        data_out => F07_data,
        valid_out => F07_valid,
        orig_out => F07_orig
    );

    iterF_07: entity work.MD5_iter_F(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 7,

        A_in => F07_A,
        B_in => F07_B,
        C_in => F07_C,
        D_in => F07_D,
        data_in => F07_data,
        valid_in => F07_valid,
        orig_in => F07_orig,

        A_out => F08_A,
        B_out => F08_B,
        C_out => F08_C,
        D_out => F08_D,
        data_out => F08_data,
        valid_out => F08_valid,
        orig_out => F08_orig
    );

    iterF_08: entity work.MD5_iter_F(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 8,

        A_in => F08_A,
        B_in => F08_B,
        C_in => F08_C,
        D_in => F08_D,
        data_in => F08_data,
        valid_in => F08_valid,
        orig_in => F08_orig,
        
        A_out => F09_A,
        B_out => F09_B,
        C_out => F09_C,
        D_out => F09_D,
        data_out => F09_data,
        valid_out => F09_valid,
        orig_out => F09_orig
    );

    iterF_09: entity work.MD5_iter_F(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 9,

        A_in => F09_A,
        B_in => F09_B,
        C_in => F09_C,
        D_in => F09_D,
        data_in => F09_data,
        valid_in => F09_valid,
        orig_in => F09_orig,

        A_out => F10_A,
        B_out => F10_B,
        C_out => F10_C,
        D_out => F10_D,
        data_out => F10_data,
        valid_out => F10_valid,
        orig_out => F10_orig
    );

    iterF_10: entity work.MD5_iter_F(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 10,

        A_in => F10_A,
        B_in => F10_B,
        C_in => F10_C,
        D_in => F10_D,
        data_in => F10_data,
        valid_in => F10_valid,
        orig_in => F10_orig,
        
        A_out => F11_A,
        B_out => F11_B,
        C_out => F11_C,
        D_out => F11_D,
        data_out => F11_data,
        valid_out => F11_valid,
        orig_out => F11_orig
    );

    iterF_11: entity work.MD5_iter_F(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 11,

        A_in => F11_A,
        B_in => F11_B,
        C_in => F11_C,
        D_in => F11_D,
        data_in => F11_data,
        valid_in => F11_valid,
        orig_in => F11_orig,
        
        A_out => F12_A,
        B_out => F12_B,
        C_out => F12_C,
        D_out => F12_D,
        data_out => F12_data,
        valid_out => F12_valid,
        orig_out => F12_orig
    );

    iterF_12: entity work.MD5_iter_F(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 12,

        A_in => F12_A,
        B_in => F12_B,
        C_in => F12_C,
        D_in => F12_D,
        data_in => F12_data,
        valid_in => F12_valid,
        orig_in => F12_orig,
        
        A_out => F13_A,
        B_out => F13_B,
        C_out => F13_C,
        D_out => F13_D,
        data_out => F13_data,
        valid_out => F13_valid,
        orig_out => F13_orig
    );

    iterF_13: entity work.MD5_iter_F(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 13,

        A_in => F13_A,
        B_in => F13_B,
        C_in => F13_C,
        D_in => F13_D,
        data_in => F13_data,
        valid_in => F13_valid,
        orig_in => F13_orig,
        
        A_out => F14_A,
        B_out => F14_B,
        C_out => F14_C,
        D_out => F14_D,
        data_out => F14_data,
        valid_out => F14_valid,
        orig_out => F14_orig
    );

    iterF_14: entity work.MD5_iter_F(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 14,

        A_in => F14_A,
        B_in => F14_B,
        C_in => F14_C,
        D_in => F14_D,
        data_in => F14_data,
        valid_in => F14_valid,
        orig_in => F14_orig,
        
        A_out => F15_A,
        B_out => F15_B,
        C_out => F15_C,
        D_out => F15_D,
        data_out => F15_data,
        valid_out => F15_valid,
        orig_out => F15_orig
    );

    iterF_15: entity work.MD5_iter_F(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 15,

        A_in => F15_A,
        B_in => F15_B,
        C_in => F15_C,
        D_in => F15_D,
        data_in => F15_data,
        valid_in => F15_valid,
        orig_in => F15_orig,
        
        A_out => G00_A,
        B_out => G00_B,
        C_out => G00_C,
        D_out => G00_D,
        data_out => G00_data,
        valid_out => G00_valid,
        orig_out => G00_orig
    );

    iterG_00: entity work.MD5_iter_G(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 16,

        A_in => G00_A,
        B_in => G00_B,
        C_in => G00_C,
        D_in => G00_D,
        data_in => G00_data,
        valid_in => G00_valid,
        orig_in => G00_orig,
        
        A_out => G01_A,
        B_out => G01_B,
        C_out => G01_C,
        D_out => G01_D,
        data_out => G01_data,
        valid_out => G01_valid,
        orig_out => G01_orig
    );

    iterG_01: entity work.MD5_iter_G(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 17,

        A_in => G01_A,
        B_in => G01_B,
        C_in => G01_C,
        D_in => G01_D,
        data_in => G01_data,
        valid_in => G01_valid,
        orig_in => G01_orig,
        
        A_out => G02_A,
        B_out => G02_B,
        C_out => G02_C,
        D_out => G02_D,
        data_out => G02_data,
        valid_out => G02_valid,
        orig_out => G02_orig
    );

    iterG_02: entity work.MD5_iter_G(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 18,

        A_in => G02_A,
        B_in => G02_B,
        C_in => G02_C,
        D_in => G02_D,
        data_in => G02_data,
        valid_in => G02_valid,
        orig_in => G02_orig,
        
        A_out => G03_A,
        B_out => G03_B,
        C_out => G03_C,
        D_out => G03_D,
        data_out => G03_data,
        valid_out => G03_valid,
        orig_out => G03_orig
    );

    iterG_03: entity work.MD5_iter_G(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 19,

        A_in => G03_A,
        B_in => G03_B,
        C_in => G03_C,
        D_in => G03_D,
        data_in => G03_data,
        valid_in => G03_valid,
        orig_in => G03_orig,
        
        A_out => G04_A,
        B_out => G04_B,
        C_out => G04_C,
        D_out => G04_D,
        data_out => G04_data,
        valid_out => G04_valid,
        orig_out => G04_orig
    );

    iterG_04: entity work.MD5_iter_G(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 20,

        A_in => G04_A,
        B_in => G04_B,
        C_in => G04_C,
        D_in => G04_D,
        data_in => G04_data,
        valid_in => G04_valid,
        orig_in => G04_orig,
        
        A_out => G05_A,
        B_out => G05_B,
        C_out => G05_C,
        D_out => G05_D,
        data_out => G05_data,
        valid_out => G05_valid,
        orig_out => G05_orig
    );

    iterG_05: entity work.MD5_iter_G(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 21,

        A_in => G05_A,
        B_in => G05_B,
        C_in => G05_C,
        D_in => G05_D,
        data_in => G05_data,
        valid_in => G05_valid,
        orig_in => G05_orig,
        
        A_out => G06_A,
        B_out => G06_B,
        C_out => G06_C,
        D_out => G06_D,
        data_out => G06_data,
        valid_out => G06_valid,
        orig_out => G06_orig
    );

    iterG_06: entity work.MD5_iter_G(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 22,

        A_in => G06_A,
        B_in => G06_B,
        C_in => G06_C,
        D_in => G06_D,
        data_in => G06_data,
        valid_in => G06_valid,
        orig_in => G06_orig,
        
        A_out => G07_A,
        B_out => G07_B,
        C_out => G07_C,
        D_out => G07_D,
        data_out => G07_data,
        valid_out => G07_valid,
        orig_out => G07_orig
    );

    iterG_07: entity work.MD5_iter_G(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 23,

        A_in => G07_A,
        B_in => G07_B,
        C_in => G07_C,
        D_in => G07_D,
        data_in => G07_data,
        valid_in => G07_valid,
        orig_in => G07_orig,
        
        A_out => G08_A,
        B_out => G08_B,
        C_out => G08_C,
        D_out => G08_D,
        data_out => G08_data,
        valid_out => G08_valid,
        orig_out => G08_orig
    );

    iterG_08: entity work.MD5_iter_G(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 24,

        A_in => G08_A,
        B_in => G08_B,
        C_in => G08_C,
        D_in => G08_D,
        data_in => G08_data,
        valid_in => G08_valid,
        orig_in => G08_orig,
        
        A_out => G09_A,
        B_out => G09_B,
        C_out => G09_C,
        D_out => G09_D,
        data_out => G09_data,
        valid_out => G09_valid,
        orig_out => G09_orig
    );

    iterG_09: entity work.MD5_iter_G(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 25,

        A_in => G09_A,
        B_in => G09_B,
        C_in => G09_C,
        D_in => G09_D,
        data_in => G09_data,
        valid_in => G09_valid,
        orig_in => G09_orig,
        
        A_out => G10_A,
        B_out => G10_B,
        C_out => G10_C,
        D_out => G10_D,
        data_out => G10_data,
        valid_out => G10_valid,
        orig_out => G10_orig
    );

    iterG_10: entity work.MD5_iter_G(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 26,

        A_in => G10_A,
        B_in => G10_B,
        C_in => G10_C,
        D_in => G10_D,
        data_in => G10_data,
        valid_in => G10_valid,
        orig_in => G10_orig,
        
        A_out => G11_A,
        B_out => G11_B,
        C_out => G11_C,
        D_out => G11_D,
        data_out => G11_data,
        valid_out => G11_valid,
        orig_out => G11_orig
    );

    iterG_11: entity work.MD5_iter_G(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 27,

        A_in => G11_A,
        B_in => G11_B,
        C_in => G11_C,
        D_in => G11_D,
        data_in => G11_data,
        valid_in => G11_valid,
        orig_in => G11_orig,
        
        A_out => G12_A,
        B_out => G12_B,
        C_out => G12_C,
        D_out => G12_D,
        data_out => G12_data,
        valid_out => G12_valid,
        orig_out => G12_orig
    );

    iterG_12: entity work.MD5_iter_G(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 28,

        A_in => G12_A,
        B_in => G12_B,
        C_in => G12_C,
        D_in => G12_D,
        data_in => G12_data,
        valid_in => G12_valid,
        orig_in => G12_orig,
        
        A_out => G13_A,
        B_out => G13_B,
        C_out => G13_C,
        D_out => G13_D,
        data_out => G13_data,
        valid_out => G13_valid,
        orig_out => G13_orig
    );

    iterG_13: entity work.MD5_iter_G(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 29,

        A_in => G13_A,
        B_in => G13_B,
        C_in => G13_C,
        D_in => G13_D,
        data_in => G13_data,
        valid_in => G13_valid,
        orig_in => G13_orig,
        
        A_out => G14_A,
        B_out => G14_B,
        C_out => G14_C,
        D_out => G14_D,
        data_out => G14_data,
        valid_out => G14_valid,
        orig_out => G14_orig
    );

    iterG_14: entity work.MD5_iter_G(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 30,

        A_in => G14_A,
        B_in => G14_B,
        C_in => G14_C,
        D_in => G14_D,
        data_in => G14_data,
        valid_in => G14_valid,
        orig_in => G14_orig,
        
        A_out => G15_A,
        B_out => G15_B,
        C_out => G15_C,
        D_out => G15_D,
        data_out => G15_data,
        valid_out => G15_valid,
        orig_out => G15_orig
    );

    iterG_15: entity work.MD5_iter_G(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 31,

        A_in => G15_A,
        B_in => G15_B,
        C_in => G15_C,
        D_in => G15_D,
        data_in => G15_data,
        valid_in => G15_valid,
        orig_in => G15_orig,
        
        A_out => H00_A,
        B_out => H00_B,
        C_out => H00_C,
        D_out => H00_D,
        data_out => H00_data,
        valid_out => H00_valid,
        orig_out => H00_orig
    );

    iterH_00: entity work.MD5_iter_H(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 32,

        A_in => H00_A,
        B_in => H00_B,
        C_in => H00_C,
        D_in => H00_D,
        data_in => H00_data,
        valid_in => H00_valid,
        orig_in => H00_orig,
        
        A_out => H01_A,
        B_out => H01_B,
        C_out => H01_C,
        D_out => H01_D,
        data_out => H01_data,
        valid_out => H01_valid,
        orig_out => H01_orig
    );

    iterH_01: entity work.MD5_iter_H(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 33,

        A_in => H01_A,
        B_in => H01_B,
        C_in => H01_C,
        D_in => H01_D,
        data_in => H01_data,
        valid_in => H01_valid,
        orig_in => H01_orig,

        A_out => H02_A,
        B_out => H02_B,
        C_out => H02_C,
        D_out => H02_D,
        data_out => H02_data,
        valid_out => H02_valid,
        orig_out => H02_orig
    );

    iterH_02: entity work.MD5_iter_H(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 34,

        A_in => H02_A,
        B_in => H02_B,
        C_in => H02_C,
        D_in => H02_D,
        data_in => H02_data,
        valid_in => H02_valid,
        orig_in => H02_orig,
        
        A_out => H03_A,
        B_out => H03_B,
        C_out => H03_C,
        D_out => H03_D,
        data_out => H03_data,
        valid_out => H03_valid,
        orig_out => H03_orig
    );

    iterH_03: entity work.MD5_iter_H(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 35,

        A_in => H03_A,
        B_in => H03_B,
        C_in => H03_C,
        D_in => H03_D,
        data_in => H03_data,
        valid_in => H03_valid,
        orig_in => H03_orig,
        
        A_out => H04_A,
        B_out => H04_B,
        C_out => H04_C,
        D_out => H04_D,
        data_out => H04_data,
        valid_out => H04_valid,
        orig_out => H04_orig
    );

    iterH_04: entity work.MD5_iter_H(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 36,

        A_in => H04_A,
        B_in => H04_B,
        C_in => H04_C,
        D_in => H04_D,
        data_in => H04_data,
        valid_in => H04_valid,
        orig_in => H04_orig,
        
        A_out => H05_A,
        B_out => H05_B,
        C_out => H05_C,
        D_out => H05_D,
        data_out => H05_data,
        valid_out => H05_valid,
        orig_out => H05_orig
    );

    iterH_05: entity work.MD5_iter_H(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 37,

        A_in => H05_A,
        B_in => H05_B,
        C_in => H05_C,
        D_in => H05_D,
        data_in => H05_data,
        valid_in => H05_valid,
        orig_in => H05_orig,
        
        A_out => H06_A,
        B_out => H06_B,
        C_out => H06_C,
        D_out => H06_D,
        data_out => H06_data,
        valid_out => H06_valid,
        orig_out => H06_orig
    );

    iterH_06: entity work.MD5_iter_H(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 38,

        A_in => H06_A,
        B_in => H06_B,
        C_in => H06_C,
        D_in => H06_D,
        data_in => H06_data,
        valid_in => H06_valid,
        orig_in => H06_orig,
        
        A_out => H07_A,
        B_out => H07_B,
        C_out => H07_C,
        D_out => H07_D,
        data_out => H07_data,
        valid_out => H07_valid,
        orig_out => H07_orig
    );

    iterH_07: entity work.MD5_iter_H(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 39,

        A_in => H07_A,
        B_in => H07_B,
        C_in => H07_C,
        D_in => H07_D,
        data_in => H07_data,
        valid_in => H07_valid,
        orig_in => H07_orig,
        
        A_out => H08_A,
        B_out => H08_B,
        C_out => H08_C,
        D_out => H08_D,
        data_out => H08_data,
        valid_out => H08_valid,
        orig_out => H08_orig
    );

    iterH_08: entity work.MD5_iter_H(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 40,

        A_in => H08_A,
        B_in => H08_B,
        C_in => H08_C,
        D_in => H08_D,
        data_in => H08_data,
        valid_in => H08_valid,
        orig_in => H08_orig,
        
        A_out => H09_A,
        B_out => H09_B,
        C_out => H09_C,
        D_out => H09_D,
        data_out => H09_data,
        valid_out => H09_valid,
        orig_out => H09_orig
    );

    iterH_09: entity work.MD5_iter_H(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 41,

        A_in => H09_A,
        B_in => H09_B,
        C_in => H09_C,
        D_in => H09_D,
        data_in => H09_data,
        valid_in => H09_valid,
        orig_in => H09_orig,
        
        A_out => H10_A,
        B_out => H10_B,
        C_out => H10_C,
        D_out => H10_D,
        data_out => H10_data,
        valid_out => H10_valid,
        orig_out => H10_orig
    );

    iterH_10: entity work.MD5_iter_H(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 42,

        A_in => H10_A,
        B_in => H10_B,
        C_in => H10_C,
        D_in => H10_D,
        data_in => H10_data,
        valid_in => H10_valid,
        orig_in => H10_orig,
        
        A_out => H11_A,
        B_out => H11_B,
        C_out => H11_C,
        D_out => H11_D,
        data_out => H11_data,
        valid_out => H11_valid,
        orig_out => H11_orig
    );

    iterH_11: entity work.MD5_iter_H(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 43,

        A_in => H11_A,
        B_in => H11_B,
        C_in => H11_C,
        D_in => H11_D,
        data_in => H11_data,
        valid_in => H11_valid,
        orig_in => H11_orig,
        
        A_out => H12_A,
        B_out => H12_B,
        C_out => H12_C,
        D_out => H12_D,
        data_out => H12_data,
        valid_out => H12_valid,
        orig_out => H12_orig
    );

    iterH_12: entity work.MD5_iter_H(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 44,

        A_in => H12_A,
        B_in => H12_B,
        C_in => H12_C,
        D_in => H12_D,
        data_in => H12_data,
        valid_in => H12_valid,
        orig_in => H12_orig,
        
        A_out => H13_A,
        B_out => H13_B,
        C_out => H13_C,
        D_out => H13_D,
        data_out => H13_data,
        valid_out => H13_valid,
        orig_out => H13_orig
    );

    iterH_13: entity work.MD5_iter_H(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 45,

        A_in => H13_A,
        B_in => H13_B,
        C_in => H13_C,
        D_in => H13_D,
        data_in => H13_data,
        valid_in => H13_valid,
        orig_in => H13_orig,
        
        A_out => H14_A,
        B_out => H14_B,
        C_out => H14_C,
        D_out => H14_D,
        data_out => H14_data,
        valid_out => H14_valid,
        orig_out => H14_orig
    );

    iterH_14: entity work.MD5_iter_H(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 46,

        A_in => H14_A,
        B_in => H14_B,
        C_in => H14_C,
        D_in => H14_D,
        data_in => H14_data,
        valid_in => H14_valid,
        orig_in => H14_orig,
        
        A_out => H15_A,
        B_out => H15_B,
        C_out => H15_C,
        D_out => H15_D,
        data_out => H15_data,
        valid_out => H15_valid,
        orig_out => H15_orig
    );

    iterH_15: entity work.MD5_iter_H(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 47,

        A_in => H15_A,
        B_in => H15_B,
        C_in => H15_C,
        D_in => H15_D,
        data_in => H15_data,
        valid_in => H15_valid,
        orig_in => H15_orig,
        
        A_out => I00_A,
        B_out => I00_B,
        C_out => I00_C,
        D_out => I00_D,
        data_out => I00_data,
        valid_out => I00_valid,
        orig_out => I00_orig
    );

    iterI_00: entity work.MD5_iter_I(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 48,

        A_in => I00_A,
        B_in => I00_B,
        C_in => I00_C,
        D_in => I00_D,
        data_in => I00_data,
        valid_in => I00_valid,
        orig_in => I00_orig,
        
        A_out => I01_A,
        B_out => I01_B,
        C_out => I01_C,
        D_out => I01_D,
        data_out => I01_data,
        valid_out => I01_valid,
        orig_out => I01_orig
    );

    iterI_01: entity work.MD5_iter_I(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 49,

        A_in => I01_A,
        B_in => I01_B,
        C_in => I01_C,
        D_in => I01_D,
        data_in => I01_data,
        valid_in => I01_valid,
        orig_in => I01_orig,
        
        A_out => I02_A,
        B_out => I02_B,
        C_out => I02_C,
        D_out => I02_D,
        data_out => I02_data,
        valid_out => I02_valid,
        orig_out => I02_orig
    );

    iterI_02: entity work.MD5_iter_I(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 50,

        A_in => I02_A,
        B_in => I02_B,
        C_in => I02_C,
        D_in => I02_D,
        data_in => I02_data,
        valid_in => I02_valid,
        orig_in => I02_orig,
        
        A_out => I03_A,
        B_out => I03_B,
        C_out => I03_C,
        D_out => I03_D,
        data_out => I03_data,
        valid_out => I03_valid,
        orig_out => I03_orig
    );

    iterI_03: entity work.MD5_iter_I(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 51,

        A_in => I03_A,
        B_in => I03_B,
        C_in => I03_C,
        D_in => I03_D,
        data_in => I03_data,
        valid_in => I03_valid,
        orig_in => I03_orig,
        
        A_out => I04_A,
        B_out => I04_B,
        C_out => I04_C,
        D_out => I04_D,
        data_out => I04_data,
        valid_out => I04_valid,
        orig_out => I04_orig
    );

    iterI_04: entity work.MD5_iter_I(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 52,

        A_in => I04_A,
        B_in => I04_B,
        C_in => I04_C,
        D_in => I04_D,
        data_in => I04_data,
        valid_in => I04_valid,
        orig_in => I04_orig,
        
        A_out => I05_A,
        B_out => I05_B,
        C_out => I05_C,
        D_out => I05_D,
        data_out => I05_data,
        valid_out => I05_valid,
        orig_out => I05_orig
    );

    iterI_05: entity work.MD5_iter_I(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 53,

        A_in => I05_A,
        B_in => I05_B,
        C_in => I05_C,
        D_in => I05_D,
        data_in => I05_data,
        valid_in => I05_valid,
        orig_in => I05_orig,
        
        A_out => I06_A,
        B_out => I06_B,
        C_out => I06_C,
        D_out => I06_D,
        data_out => I06_data,
        valid_out => I06_valid,
        orig_out => I06_orig
    );

    iterI_06: entity work.MD5_iter_I(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 54,

        A_in => I06_A,
        B_in => I06_B,
        C_in => I06_C,
        D_in => I06_D,
        data_in => I06_data,
        valid_in => I06_valid,
        orig_in => I06_orig,
        
        A_out => I07_A,
        B_out => I07_B,
        C_out => I07_C,
        D_out => I07_D,
        data_out => I07_data,
        valid_out => I07_valid,
        orig_out => I07_orig
    );

    iterI_07: entity work.MD5_iter_I(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 55,

        A_in => I07_A,
        B_in => I07_B,
        C_in => I07_C,
        D_in => I07_D,
        data_in => I07_data,
        valid_in => I07_valid,
        orig_in => I07_orig,
                
        A_out => I08_A,
        B_out => I08_B,
        C_out => I08_C,
        D_out => I08_D,
        data_out => I08_data,
        valid_out => I08_valid,
        orig_out => I08_orig
    );

    iterI_08: entity work.MD5_iter_I(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 56,

        A_in => I08_A,
        B_in => I08_B,
        C_in => I08_C,
        D_in => I08_D,
        data_in => I08_data,
        valid_in => I08_valid,
        orig_in => I08_orig,
        
        A_out => I09_A,
        B_out => I09_B,
        C_out => I09_C,
        D_out => I09_D,
        data_out => I09_data,
        valid_out => I09_valid,
        orig_out => I09_orig
    );

    iterI_09: entity work.MD5_iter_I(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 57,

        A_in => I09_A,
        B_in => I09_B,
        C_in => I09_C,
        D_in => I09_D,
        data_in => I09_data,
        valid_in => I09_valid,
        orig_in => I09_orig,
        
        A_out => I10_A,
        B_out => I10_B,
        C_out => I10_C,
        D_out => I10_D,
        data_out => I10_data,
        valid_out => I10_valid,
        orig_out => I10_orig
    );

    iterI_10: entity work.MD5_iter_I(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 58,

        A_in => I10_A,
        B_in => I10_B,
        C_in => I10_C,
        D_in => I10_D,
        data_in => I10_data,
        valid_in => I10_valid,
        orig_in => I10_orig,
        
        A_out => I11_A,
        B_out => I11_B,
        C_out => I11_C,
        D_out => I11_D,
        data_out => I11_data,
        valid_out => I11_valid,
        orig_out => I11_orig
    );

    iterI_11: entity work.MD5_iter_I(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 59,

        A_in => I11_A,
        B_in => I11_B,
        C_in => I11_C,
        D_in => I11_D,
        data_in => I11_data,
        valid_in => I11_valid,
        orig_in => I11_orig,
        
        A_out => I12_A,
        B_out => I12_B,
        C_out => I12_C,
        D_out => I12_D,
        data_out => I12_data,
        valid_out => I12_valid,
        orig_out => I12_orig
    );

    iterI_12: entity work.MD5_iter_I(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 60,

        A_in => I12_A,
        B_in => I12_B,
        C_in => I12_C,
        D_in => I12_D,
        data_in => I12_data,
        valid_in => I12_valid,
        orig_in => I12_orig,
        
        A_out => I13_A,
        B_out => I13_B,
        C_out => I13_C,
        D_out => I13_D,
        data_out => I13_data,
        valid_out => I13_valid,
        orig_out => I13_orig
    );

    iterI_13: entity work.MD5_iter_I(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 61,

        A_in => I13_A,
        B_in => I13_B,
        C_in => I13_C,
        D_in => I13_D,
        data_in => I13_data,
        valid_in => I13_valid,
        orig_in => I13_orig,
        
        A_out => I14_A,
        B_out => I14_B,
        C_out => I14_C,
        D_out => I14_D,
        data_out => I14_data,
        valid_out => I14_valid,
        orig_out => I14_orig
    );

    iterI_14: entity work.MD5_iter_I(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 62,

        A_in => I14_A,
        B_in => I14_B,
        C_in => I14_C,
        D_in => I14_D,
        data_in => I14_data,
        valid_in => I14_valid,
        orig_in => I14_orig,
        
        A_out => I15_A,
        B_out => I15_B,
        C_out => I15_C,
        D_out => I15_D,
        data_out => I15_data,
        valid_out => I15_valid,
        orig_out => I15_orig
    );

    iterI_15: entity work.MD5_iter_I(Behavioral)
    port map(
        clock => clock, 
        enable => enable,
        resetn => resetn,
        i => 63,

        A_in => I15_A,
        B_in => I15_B,
        C_in => I15_C,
        D_in => I15_D,
        data_in => I15_data,
        valid_in => I15_valid,
        orig_in => I15_orig,
        
        A_out => final_A,
        B_out => final_B,
        C_out => final_C,
        D_out => final_D,
        data_out => out_data,
        valid_out => out_valid_i,
        orig_out => original_out_i
    );
  
end architecture;
