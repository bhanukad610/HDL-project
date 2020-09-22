----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2020 04:08:51 PM
-- Design Name: 
-- Module Name: uart_test_tb - Behavioral
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

entity uart_test_tb is
--  Port ( );
end uart_test_tb;

architecture Behavioral of uart_test_tb is

component uart_test is
    Generic (mem_addr_size_g   : integer := 9; --holds memory address length.
             pixel_data_size_g : integer := 8; --holds pixel data bit length.
             base_val_g        : integer := 0);--holds basic initialization value(0).
             
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           rx : in STD_LOGIC;
           tx : out STD_LOGIC;
           
           start_op_in            : in STD_LOGIC;
           finished_op_out        : out STD_LOGIC := '0';
           send_rec_select_in     : in STD_LOGIC);
end component;

signal clk : STD_LOGIC;
signal reset : STD_LOGIC;
signal rx : STD_LOGIC;
signal tx : STD_LOGIC;
           
signal start_op_in            : STD_LOGIC;
signal finished_op_out        : STD_LOGIC;
signal send_rec_select_in     : STD_LOGIC;

constant clock_period: time := 10 ns;

begin

  uut: uart_test port map ( clk                 => clk,
                            reset               => reset,
                            rx                  => rx,
                            tx                  => tx,
                            start_op_in         => start_op_in,
                            finished_op_out     => finished_op_out,
                            send_rec_select_in  => send_rec_select_in);
  
  stimulus: process
  begin
  
    -- Put initialisation code here
    reset <= '1';
    rx <= '1';
    start_op_in <= '0';
    send_rec_select_in <= '0';
    wait for 5 ns;

    reset <= '0';
    wait for 5 ns;
    
    reset <= '1'; 
    wait for 5 ns;
    
    start_op_in <= '1';
    wait for 15 ns;
    
    start_op_in <= '0';
    wait;
  end process;
                            
  clocking: process
  begin
    clk <= '0', '1' after clock_period / 2;
    wait for clock_period;
  end process;                            

end Behavioral;
