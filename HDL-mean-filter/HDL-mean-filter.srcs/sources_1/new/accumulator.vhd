----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/29/2020 07:23:30 AM
-- Design Name: 
-- Module Name: accumulator - Behavioral
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

entity accumulator is
    Port ( row : in STD_LOGIC;
           column : in STD_LOGIC;
           init : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (31 downto 0);
           
           done : out STD_LOGIC;
           address : out STD_LOGIC_VECTOR (31 downto 0);
           sum : out STD_LOGIC_VECTOR (11 downto 0));
end accumulator;

architecture Behavioral of accumulator is

begin


end Behavioral;
