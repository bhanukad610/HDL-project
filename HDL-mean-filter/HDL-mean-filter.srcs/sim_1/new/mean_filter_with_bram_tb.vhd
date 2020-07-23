library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity mean_filter_with_bram_tb is
end;

architecture bench of mean_filter_with_bram_tb is

  component mean_filter_with_bram
    Port (row : in STD_LOGIC_VECTOR (4 downto 0);
             col : in STD_LOGIC_VECTOR (4 downto 0);
             clock : in STD_LOGIC;
             size : in STD_LOGIC_VECTOR (4 downto 0);
             pixel_out_filter :out STD_LOGIC_VECTOR (7 downto 0));
  end component;

  signal row: STD_LOGIC_VECTOR (4 downto 0);
  signal col: STD_LOGIC_VECTOR (4 downto 0);
  signal clock: STD_LOGIC;
  signal size: STD_LOGIC_VECTOR (4 downto 0) ;
  signal pixel_out_filter: STD_LOGIC_VECTOR (7 downto 0);
  constant clock_period: time := 20 ns;

begin

  uut: mean_filter_with_bram port map ( row   => row,
                                        col   => col,
                                        clock => clock,
                                        size  => size,
                                        pixel_out_filter => pixel_out_filter );

  stimulus: process
  begin
  
     -- Put initialisation code here
    row <= "10100";
    col <= "00100";
    size <= "10000";
    -- Put test bench stimulus code here

    wait;
  end process;
  
  clocking: process
      begin
         clock <= '0', '1' after clock_period / 2;
         wait for clock_period;
      end process;
end;