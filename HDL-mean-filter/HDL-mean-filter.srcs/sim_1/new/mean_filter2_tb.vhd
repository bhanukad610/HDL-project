library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity mean_filter2_tb is
    Generic (img_size  : INTEGER := 16;
             row_n_width : INTEGER := 4;
             addr_width : INTEGER := 8;
             data_width : INTEGER := 7
             );
end;

architecture bench of mean_filter2_tb is

  component mean_filter2
  Port ( row : in STD_LOGIC_VECTOR (row_n_width downto 0);
           col : in STD_LOGIC_VECTOR (row_n_width downto 0);
           init_single_op : in STD_LOGIC;
           finish_flag_single_op : out STD_LOGIC := '0';
           addr_in_img : out  STD_LOGIC_VECTOR (addr_width downto 0);
           addr_out_img : out  STD_LOGIC_VECTOR (addr_width downto 0);
           pixel_in : in STD_LOGIC_VECTOR (data_width downto 0);
           pixel_out :out STD_LOGIC_VECTOR (data_width downto 0);
           clk  : in STD_LOGIC;
           reset_in :in STD_LOGIC;
           we : out STD_LOGIC_VECTOR (0 downto 0) := "0");
  end component;

signal row : STD_LOGIC_VECTOR (row_n_width downto 0);
signal col : STD_LOGIC_VECTOR (row_n_width downto 0);
signal init_single_op : STD_LOGIC;
signal finish_flag_single_op : STD_LOGIC;
signal addr_in_img : STD_LOGIC_VECTOR (addr_width downto 0);
signal addr_out_img : STD_LOGIC_VECTOR (addr_width downto 0);
signal pixel_in : STD_LOGIC_VECTOR (data_width downto 0);
signal pixel_out : STD_LOGIC_VECTOR (data_width downto 0);
signal clk  : STD_LOGIC;
signal reset_in : STD_LOGIC;
signal we : STD_LOGIC_VECTOR (0 downto 0);

constant clock_period: time := 10 ns;
-- signal stop_the_clock: boolean;

begin

  uut: mean_filter2 port map ( row => row,
                               col =>  col,
                               init_single_op => init_single_op,
                               finish_flag_single_op =>  finish_flag_single_op,
                               addr_in_img => addr_in_img,
                               addr_out_img =>  addr_out_img,
                               pixel_in => pixel_in,
                               pixel_out =>  pixel_out,
                               clk => clk,
                               reset_in =>  reset_in,
                               we => we);

  stimulus: process
  begin
  
    -- Put initialisation code here
    row <= "00100";
    col <= "01000";
    init_single_op <= '0';
    pixel_in <= (others => '0');
    reset_in <= '0';
    wait for 2.5ns;
    
    reset_in <= '1';
    wait for 5ns;
    
    reset_in <= '0';
    wait for 5ns;
    
    init_single_op <= '1';
    wait for 5ns;
    
    init_single_op <= '0';
    wait for 35ns;
    
    pixel_in <= (others => '1');
    wait for 10ns;
    
    pixel_in <= (others => '0');
    wait for 10ns;
    
    pixel_in <= (7 => '1', 6 => '1', 5 => '1', 4 => '1', others => '0');
    wait for 10ns;
    
    pixel_in <= (others => '0');
    wait for 10ns;
    
    pixel_in <= (3 => '1', 2 => '1', 1 => '1', 0 => '1', others => '0');
    wait for 10ns;
    
    pixel_in <= (others => '1');
    wait for 10ns;
    
    pixel_in <= (others => '0');
    wait for 20ns;
    
    pixel_in <= (others => '1');
    wait for 10ns;
    
    pixel_in <= (others => '0');
    wait for 10ns;              
    -- Put test bench stimulus code here

    -- stop_the_clock <= true;
    wait;
  end process;

  clocking: process
      begin
         clk <= '0', '1' after clock_period / 2;
         wait for clock_period;
      end process;

end;