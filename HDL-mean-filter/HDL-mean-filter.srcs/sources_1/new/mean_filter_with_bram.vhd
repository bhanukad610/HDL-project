----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/16/2020 10:21:44 PM
-- Design Name: 
-- Module Name: mean_filter_with_bram - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mean_filter_with_bram is
  Port (row : in STD_LOGIC_VECTOR (3 downto 0);
           col : in STD_LOGIC_VECTOR (3 downto 0);
           size : in STD_LOGIC_VECTOR (3 downto 0) );
end mean_filter_with_bram;

architecture Behavioral of mean_filter_with_bram is
component bram is
    Port ( addr : in STD_LOGIC_VECTOR (8 downto 0);
           clk: in std_logic;
           din: in std_logic_vector (7 downto 0);
           dout : out STD_LOGIC_VECTOR (7 downto 0);
           en: in std_logic;
           we: in std_logic_vector (0 downto 0));
end component;

component mean_filter is
  Port ( row : in STD_LOGIC_VECTOR (3 downto 0);
           col : in STD_LOGIC_VECTOR (3 downto 0);
           size : in STD_LOGIC_VECTOR (3 downto 0);
           addr_in : out  STD_LOGIC_VECTOR (8 downto 0);
           addr_in_img : in  STD_LOGIC_VECTOR (8 downto 0);
           addr_out_img : out  STD_LOGIC_VECTOR (8 downto 0);
           pixel_in : in STD_LOGIC_VECTOR (7 downto 0);
           pixel_out :out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal addr : STD_LOGIC_VECTOR (8 downto 0);
signal addr_in_img : STD_LOGIC_VECTOR (8 downto 0);
signal pixel_in : STD_LOGIC_VECTOR (7 downto 0);
signal clock : STD_LOGIC;

signal din_input : STD_LOGIC_VECTOR (7 downto 0);
signal en : STD_LOGIC;
signal we : std_logic_vector (0 downto 0);

signal pixel_out : STD_LOGIC_VECTOR (7 downto 0);
signal addr_out_img : STD_LOGIC_VECTOR (8 downto 0);
signal bram_out_din : STD_LOGIC_VECTOR (7 downto 0);

begin
mean_filter_1 : mean_filter
port map (     row => row,
               col => col,
               size => size,
               addr_in => addr,
               addr_in_img => addr_in_img,
               addr_out_img => addr_out_img,
               pixel_in => pixel_in,
               pixel_out => pixel_out);

bram_in : bram
port map (     addr => addr,
               clk => clock,
               din => din_input,
               dout => pixel_in,
               en => en,
               we => we);
               
bram_out : bram
port map (     addr => addr_out_img,
               clk => clock,
               din => pixel_out,
               dout => bram_out_din,
               en => en,
               we => we);

end Behavioral;
