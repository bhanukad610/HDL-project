library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity uart_transmit_with_uartlite_tb is
end;

architecture bench of uart_transmit_with_uartlite_tb is

  component uart_transmit_with_uartlite
      Port ( clk : in STD_LOGIC;
             rst_n : in STD_LOGIC;
             start_op_in : in STD_LOGIC;
             finished_op_out : out STD_LOGIC;
             rx : in std_logic;
             tx : out std_logic);
  end component;

  signal clk: STD_LOGIC;
  signal rst_n: STD_LOGIC;
  signal start_op_in: STD_LOGIC;
  signal finished_op_out: STD_LOGIC;
  signal rx: std_logic;
  signal tx: std_logic;
  
  constant clock_period: time := 10 ns;

begin

  uut: uart_transmit_with_uartlite port map ( clk             => clk,
                                              rst_n           => rst_n,
                                              start_op_in     => start_op_in,
                                              finished_op_out => finished_op_out,
                                              rx              => rx,
                                              tx              => tx );

  stimulus: process
  begin
  
    -- Put initialisation code here
    rst_n <= '0';
    start_op_in <= '0';
    rx <= '0';
    wait for 12.5 ns;
    
    rst_n <= '1';
    wait for 5 ns;
    
    rst_n <= '0';
    wait for 5 ns;
    
    start_op_in <= '1';
    -- Put test bench stimulus code here

    wait;
  end process;
  
  clocking: process
  begin
     clk <= '0', '1' after clock_period / 2;
     wait for clock_period;
  end process;

end;