----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2020 07:57:56 AM
-- Design Name: 
-- Module Name: uart_tx_only_test - Behavioral
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

entity uart_tx_only_test is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           
           finished_sending : in STD_LOGIC;
           send_all : in STD_LOGIC;
           
           tx : out STD_LOGIC := '1');
end uart_tx_only_test;

architecture Behavioral of uart_tx_only_test is

component uart_tx_only is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           finished_sending : in STD_LOGIC;
           send_all : in STD_LOGIC;
           
           addrb : out STD_LOGIC_VECTOR (8 downto 0) := (others => '0');
           doutb : in STD_LOGIC_VECTOR (7 downto 0);
           
           tx : out STD_LOGIC := '1');
end component;

component bram is
    Port ( addr : in STD_LOGIC_VECTOR (8 downto 0);
           clk: in std_logic;
           din: in std_logic_vector (7 downto 0);
           dout : out STD_LOGIC_VECTOR (7 downto 0);
           -- en: in std_logic;
           we: in std_logic_vector (0 downto 0));
end component;

signal addrb : STD_LOGIC_VECTOR (8 downto 0);
signal doutb : STD_LOGIC_VECTOR (7 downto 0);

signal dina : STD_LOGIC_VECTOR (7 downto 0);
-- signal ena : STD_LOGIC;
signal wea : STD_LOGIC_VECTOR (0 downto 0);

begin

dina <= (others => '0');
-- ena <= '1';
wea <= (others => '0');

uart_tx_only1 : uart_tx_only
    port map ( clk => clk,
           reset => reset,
           finished_sending => finished_sending,
           send_all => send_all,
           
           addrb => addrb,
           doutb => doutb,
           
           tx => tx);
           
bram1: bram
    port map ( addr => addrb,
           clk => clk,
           din => dina,
           dout => doutb,
           -- en => ena,
           we => wea);

end Behavioral;
