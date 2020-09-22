----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2020 08:42:21 AM
-- Design Name: 
-- Module Name: uart_tx_only_test_tb - Behavioral
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

entity uart_tx_only_test_tb is
--  Port ( );
end uart_tx_only_test_tb;

architecture Behavioral of uart_tx_only_test_tb is

component uart_tx_only_test is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           
           finished_sending : in STD_LOGIC;
           send_all : in STD_LOGIC;
           
           tx : out STD_LOGIC := '1');
end component;

signal clk : STD_LOGIC;
signal reset : STD_LOGIC;
           
signal finished_sending : STD_LOGIC;
signal send_all : STD_LOGIC;
           
signal tx : STD_LOGIC;

constant clock_period: time := 10 ns;

begin

uut: uart_tx_only_test port map ( clk => clk,
                           reset => reset,
                           
                           finished_sending => finished_sending,
                           send_all => send_all,
                           
                           tx => tx);

  stimulus: process
  begin
  
    -- Put initialisation code here
    reset <= '0';
    finished_sending <= '0';
    send_all <= '0';
    wait for 5 ns;

    reset <= '1';
    wait for 5 ns;
    
    reset <= '0'; 
    wait for 5 ns;
    
    send_all <= '1';
    wait for 15 ns;
    
    send_all <= '0';
    wait;
  end process;
  
  clocking: process
  begin
    clk <= '0', '1' after clock_period / 2;
    wait for clock_period;
  end process;

end Behavioral;
