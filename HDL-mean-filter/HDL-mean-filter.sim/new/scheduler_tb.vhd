library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity scheduler_tb is
      Generic (row_n_width : INTEGER := 4);
end;

architecture bench of scheduler_tb is

  component scheduler
      Port ( clk : in STD_LOGIC;
             reset : in STD_LOGIC;
             init_process : in STD_LOGIC;
             finish_flag_single_op : in STD_LOGIC;
             init_single_op : out STD_LOGIC := '0';
             finish_flag_process : out STD_LOGIC := '0';
             row : out STD_LOGIC_VECTOR (row_n_width downto 0) := (others => '0');
             column : out STD_LOGIC_VECTOR (row_n_width downto 0) := (others => '0'));
  end component;

  signal clk: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal init_process: STD_LOGIC;
  signal finish_flag_single_op: STD_LOGIC;
  signal init_single_op: STD_LOGIC := '0';
  signal finish_flag_process: STD_LOGIC := '0';
  signal row: STD_LOGIC_VECTOR (row_n_width downto 0) := (others => '0');
  signal column: STD_LOGIC_VECTOR (row_n_width downto 0) := (others => '0');

  constant clock_period: time := 10 ns;
begin

  uut: scheduler port map ( clk                   => clk,
                            reset                 => reset,
                            init_process          => init_process,
                            finish_flag_single_op => finish_flag_single_op,
                            init_single_op        => init_single_op,
                            finish_flag_process   => finish_flag_process,
                            row                   => row,
                            column                => column );

  stimulus: process
  begin
  
    -- Put initialisation code here
    reset <= '0';
    init_process <= '1';
    finish_flag_single_op <= '0';
    wait for 30 ns; -- (20 + 5)
    
    init_process <= '0';
    finish_flag_single_op <= '1';
    wait for 1010 ns; -- (500 - (20 - 5))
    
    reset <= '1';
    wait for 30 ns;
    
    reset <= '0';
    wait for 10 ns;
    
    init_process <= '1';
    wait for 30 ns;
    
    init_process <= '0';
    wait for 10 ns;
    wait for 10 ms; -- (500 - (20 - 5))
    -- Put test bench stimulus code here

    wait;
  end process;

  clocking: process
  begin
    clk <= '0', '1' after clock_period / 2;
    wait for clock_period;
  end process;

end;