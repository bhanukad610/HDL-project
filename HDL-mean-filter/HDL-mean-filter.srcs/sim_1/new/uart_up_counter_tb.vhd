----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2020 12:50:17 PM
-- Design Name: 
-- Module Name: uart_up_counter_tb - Behavioral
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

entity uart_up_counter_tb is
--  Port ( );
end uart_up_counter_tb;

architecture Behavioral of uart_up_counter_tb is

component uart_up_counter is
    Port ( clock : in STD_LOGIC;
           enable : in STD_LOGIC;
           reset : in STD_LOGIC;
           counter_out : out STD_LOGIC_VECTOR (8 downto 0));
end component;

signal clock : STD_LOGIC;
signal enable : STD_LOGIC;
signal reset : STD_LOGIC;
signal counter_out : STD_LOGIC_VECTOR (8 downto 0);

constant clock_period: time := 10 ns;

begin

uut: uart_up_counter port map ( clock => clock,
                                  enable => enable,
                                  reset => reset,
                                  counter_out => counter_out);

  stimulus: process
  begin
  
    -- Put initialisation code here
    reset <= '0';
    enable <= '0';
    wait for 5 ns;

    reset <= '1';
    wait for 5 ns;
    
    reset <= '0'; 
    wait for 5 ns;
    
    enable <= '1';
    wait for 15 ns;
    
    enable <= '0';
    wait;
  end process;
  
  clocking: process
  begin
    clock <= '0', '1' after clock_period / 2;
    wait for clock_period;
  end process;
  
end Behavioral;
