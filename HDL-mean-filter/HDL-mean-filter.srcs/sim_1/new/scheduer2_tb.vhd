library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity scheduler2_tb is
      Generic (row_n_width : INTEGER := 4);
end;

architecture bench of scheduler2_tb is

  component scheduler2
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
  shared variable c : integer range 0 to 258 := 0;
  shared variable b : boolean := True;
  
begin

  uut: scheduler2 port map ( clk                   => clk,
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
    c := 0;
    b := True;
    reset <= '0';
    init_process <= '0';
    finish_flag_single_op <= '0';
    wait for 5 ns;

    reset <= '1';
    wait for 5 ns;
    
    reset <= '0'; 
    wait for 5 ns;
    
    init_process <= '1';
    wait for 15 ns;
    
    init_process <= '0';  
    
    while (b = True) loop
        wait for 50 ns;
        finish_flag_single_op <= '1';
        wait for 20 ns;    
        finish_flag_single_op <= '0';    
    end loop;
    wait;
  end process;
  
  clocking: process
  begin
    clk <= '0', '1' after clock_period / 2;
    wait for clock_period;
  end process;

end;