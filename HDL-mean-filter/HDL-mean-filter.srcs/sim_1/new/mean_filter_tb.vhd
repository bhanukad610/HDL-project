library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity mean_filter_tb is
end;

architecture bench of mean_filter_tb is

  component mean_filter
    Port ( row : in STD_LOGIC_VECTOR (4 downto 0);
             col : in STD_LOGIC_VECTOR (4 downto 0);           
             addr_in : out  STD_LOGIC_VECTOR (8 downto 0);
             addr_in_img : in  STD_LOGIC_VECTOR (8 downto 0);
             addr_out_img : out  STD_LOGIC_VECTOR (8 downto 0);
             pixel_in : in STD_LOGIC_VECTOR (7 downto 0);
             pixel_out :out STD_LOGIC_VECTOR (7 downto 0);
             clk  : in STD_LOGIC;
             reset_in :in STD_LOGIC);
  end component;

  signal row: STD_LOGIC_VECTOR (4 downto 0);
  signal col: STD_LOGIC_VECTOR (4 downto 0);
  signal addr_in: STD_LOGIC_VECTOR (8 downto 0);
  signal addr_in_img: STD_LOGIC_VECTOR (8 downto 0);
  signal addr_out_img: STD_LOGIC_VECTOR (8 downto 0);
  signal pixel_in: STD_LOGIC_VECTOR (7 downto 0);
  signal pixel_out: STD_LOGIC_VECTOR (7 downto 0);
  signal clk: STD_LOGIC;
  signal reset_in: STD_LOGIC;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: mean_filter port map ( row          => row,
                              col          => col,
                              addr_in      => addr_in,
                              addr_in_img  => addr_in_img,
                              addr_out_img => addr_out_img,
                              pixel_in     => pixel_in,
                              pixel_out    => pixel_out,
                              clk          => clk,
                              reset_in     => reset_in );

  stimulus: process
  begin
  
    -- Put initialisation code here
    row <= "10100";
    col <= "00100";
    reset_in <= '1';
    addr_in_img <= "100100101";
    
    wait for 2.5ns;
    pixel_in <= "10110100";
    wait for 20ns;
    pixel_in <= "10010100";
    wait for 20ns;
    pixel_in <= "10010101";
    wait for 20ns;
    pixel_in <= "10010111";
    wait for 20ns;
    pixel_in <= "10010100";
    wait for 20ns;
    pixel_in <= "10011100";
    wait for 20ns;
    pixel_in <= "10110100";
    
    

    -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
      begin
         clk <= '0', '1' after clock_period / 2;
         wait for clock_period;
      end process;

end;