----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2020 12:06:14 PM
-- Design Name: 
-- Module Name: up_counter_helper_tb - Behavioral
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

entity up_counter_helper_tb is
--  Port ( );
end up_counter_helper_tb;

architecture Behavioral of up_counter_helper_tb is

component up_counter_helper is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           ready : in STD_LOGIC;
           counter_en : out STD_LOGIC := '0';
           send : out STD_LOGIC := '0';
           finished_sending : in STD_LOGIC;
           send_all : in STD_LOGIC);
end component;

signal clk : STD_LOGIC;
signal reset : STD_LOGIC;
signal ready : STD_LOGIC;
signal counter_en : STD_LOGIC;
signal send : STD_LOGIC;
signal finished_sending : STD_LOGIC;
signal send_all : STD_LOGIC;

constant clock_period: time := 10 ns;

begin

uut: up_counter_helper port map ( clk => clk,
                                  reset => reset,
                                  ready => ready,
                                  counter_en => counter_en,
                                  send => send,
                                  finished_sending => finished_sending,
                                  send_all => send_all);
                                  
  stimulus: process
  begin
  
    -- Put initialisation code here
    reset <= '0';
    ready <= '1';
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
