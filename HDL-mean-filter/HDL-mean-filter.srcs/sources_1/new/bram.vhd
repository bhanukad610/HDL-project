----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/12/2020 06:24:13 PM
-- Design Name: 
-- Module Name: bram - Behavioral
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

entity bram is
    Port ( addr : in STD_LOGIC_VECTOR (8 downto 0);
           clk: in std_logic;
           din: in std_logic_vector (7 downto 0);
           dout : out STD_LOGIC_VECTOR (7 downto 0);
           -- en: in std_logic;
           we: in std_logic_vector (0 downto 0));
end bram;

architecture Behavioral of bram is

component blk_mem_gen_2 is
    Port ( addra : in STD_LOGIC_VECTOR (8 downto 0);
           clka : in STD_LOGIC;
           dina: in std_logic_vector (7 downto 0);
           douta : out STD_LOGIC_VECTOR (7 downto 0);
           -- ena: in std_logic;
           wea: in std_logic_vector (0 downto 0));
end component;

begin

mem_block_1 : blk_mem_gen_2
    port map ( addra => addr,
               clka => clk,
               dina => din,
               douta => dout,
               -- ena => en,
               wea => we);

end Behavioral;
