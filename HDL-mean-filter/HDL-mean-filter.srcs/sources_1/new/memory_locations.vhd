----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/20/2020 01:16:16 PM
-- Design Name: 
-- Module Name: memory_locations - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;



-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory_locations is
    Port ( row : in STD_LOGIC_VECTOR (3 downto 0);
           col : in STD_LOGIC_VECTOR (3 downto 0);
           size : in STD_LOGIC_VECTOR (3 downto 0);
           loc_1 : out STD_LOGIC_VECTOR (7 downto 0);
           loc_2 : out STD_LOGIC_VECTOR (7 downto 0);
           loc_3 : out STD_LOGIC_VECTOR (7 downto 0);
           loc_4 : out STD_LOGIC_VECTOR (7 downto 0);
           loc_5 : out STD_LOGIC_VECTOR (7 downto 0);
           loc_6 : out STD_LOGIC_VECTOR (7 downto 0);
           loc_7 : out STD_LOGIC_VECTOR (7 downto 0);
           loc_8 : out STD_LOGIC_VECTOR (7 downto 0);
           loc_9 : out STD_LOGIC_VECTOR (7 downto 0));
end memory_locations;



architecture Behavioral of memory_locations is
signal row_dec  : integer;
signal col_dec : integer;
signal size_dec : integer;

signal loc_1_dec : integer;
signal loc_2_dec : integer;
signal loc_3_dec : integer;
signal loc_4_dec : integer;
signal loc_5_dec : integer;
signal loc_6_dec : integer;
signal loc_7_dec : integer;
signal loc_8_dec : integer;
signal loc_9_dec : integer;

component bram is
    Port ( addr : in STD_LOGIC_VECTOR (8 downto 0);
           clk: in std_logic;
           din: in std_logic_vector (7 downto 0);
           dout : out STD_LOGIC_VECTOR (7 downto 0);
           en: in std_logic;
           we: in std_logic_vector (0 downto 0));
end component;

 

begin

row_dec <= to_integer(signed(row)) + 1;
col_dec <= to_integer(signed(col)) + 1;
size_dec <= to_integer(signed(size));

loc_1_dec <= (col_dec - 1) * size_dec + (row_dec - 1);
loc_2_dec <= (col_dec - 1) * size_dec + row_dec;
loc_3_dec <= (col_dec - 1) * size_dec + (row_dec + 1);
loc_4_dec <= col_dec * size_dec + (row_dec - 1);
loc_5_dec <= col_dec * size_dec + row_dec;
loc_6_dec <= col_dec * size_dec + (row_dec + 1);
loc_7_dec <= (col_dec + 1) * size_dec + (row_dec - 1);
loc_8_dec <= (col_dec + 1) * size_dec + row_dec;
loc_9_dec <= (col_dec + 1) * size_dec + (row_dec + 1);

loc_1 <= std_logic_vector(to_unsigned(loc_1_dec, loc_1'length));
loc_2 <= std_logic_vector(to_unsigned(loc_2_dec, loc_2'length));
loc_3 <= std_logic_vector(to_unsigned(loc_3_dec, loc_3'length));
loc_4 <= std_logic_vector(to_unsigned(loc_4_dec, loc_4'length));
loc_5 <= std_logic_vector(to_unsigned(loc_5_dec, loc_5'length));
loc_6 <= std_logic_vector(to_unsigned(loc_6_dec, loc_6'length));
loc_7 <= std_logic_vector(to_unsigned(loc_7_dec, loc_7'length));
loc_8 <= std_logic_vector(to_unsigned(loc_8_dec, loc_8'length));
loc_9 <= std_logic_vector(to_unsigned(loc_9_dec, loc_9'length));

end Behavioral;
