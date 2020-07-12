----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/20/2020 12:11:06 PM
-- Design Name: 
-- Module Name: filter - Behavioral
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

entity filter is
    Port ( row : in STD_LOGIC_VECTOR (3 downto 0);
           col : in STD_LOGIC_VECTOR (3 downto 0);
           int_op : in STD_LOGIC;
           buff_address : out STD_LOGIC_VECTOR (7 downto 0);
           buff_data : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0);
           wr_en : out STD_LOGIC;
           adress_buff2 : out STD_LOGIC_VECTOR (7 downto 0));
end filter;

architecture Behavioral of filter is

begin


end Behavioral;
