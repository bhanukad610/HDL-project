----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2020 01:08:25 PM
-- Design Name: 
-- Module Name: new_uart_test_tb - Behavioral
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

entity new_uart_test_tb is
--  Port ( );
end new_uart_test_tb;

architecture Behavioral of new_uart_test_tb is

component UART_TX_CTRL is
    Port ( SEND : in  STD_LOGIC;
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
           READY : out  STD_LOGIC;
           UART_TX : out  STD_LOGIC);
end component;

signal SEND : STD_LOGIC;
signal DATA : STD_LOGIC_VECTOR (7 downto 0);
signal CLK : STD_LOGIC;
signal READY : STD_LOGIC;
signal UART_TX : STD_LOGIC;

constant clock_period: time := 10 ns;

begin

uut: UART_TX_CTRL port map ( SEND => SEND,
                             DATA => DATA,
                             CLK => CLK,
                             READY => READY,
                             UART_TX => UART_TX);
                             
  stimulus: process
  begin
  
    -- Put initialisation code here
    SEND <= '0';
    DATA <= "10011011";
    -- finish_flag_process <= '0';
    wait for 2.5 ns;
    
    SEND <= '1';
    wait;
  end process;

  clocking: process
  begin
    clk <= '0', '1' after clock_period / 2;
    wait for clock_period;
  end process;                              
    
end Behavioral;
