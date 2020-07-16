library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity bram_tb is
end;

architecture bench of bram_tb is

  component bram
      Port ( addr : in STD_LOGIC_VECTOR (8 downto 0);
             clk: in std_logic;
             din: in std_logic_vector (7 downto 0);
             dout : out STD_LOGIC_VECTOR (7 downto 0);
             en: in std_logic;
             we: in std_logic_vector (0 downto 0));
  end component;
  
  constant clock_period: time := 20 ns;
  shared variable ptr: integer := 0;

  signal addr: STD_LOGIC_VECTOR (8 downto 0);
  signal clk: std_logic;
  signal din: std_logic_vector (7 downto 0);
  signal dout: STD_LOGIC_VECTOR (7 downto 0);
  signal en: std_logic;
  signal we: std_logic_vector (0 downto 0);

begin

  uut: bram port map ( addr => addr,
                       clk  => clk,
                       din  => din,
                       dout => dout,
                       en   => en,
                       we   => we );

  stimulus: process
  begin
  
    -- Put initialisation code here
    addr <= (others => '0');
    din <= (others => '0');
    en <= '1';
    we <= "0";
    wait for 35 ns;
    
    while (ptr < 325) loop
        addr <= std_logic_vector(to_unsigned(ptr, 9));
        ptr := ptr + 1;
        wait for 20 ns;
    end loop;
    -- Put test bench stimulus code here

    wait;
  end process;
  
  clocking: process
  begin
     clk <= '0', '1' after clock_period / 2;
     wait for clock_period;
  end process;

end;