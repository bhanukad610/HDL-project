----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2020 04:04:27 AM
-- Design Name: 
-- Module Name: schdlr_filter_bram_tb - Behavioral
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

entity schdlr_filter_tb is
    Generic (img_size  : INTEGER := 16;
             img_size2  : INTEGER := 256;
             row_n_width : INTEGER := 4;
             addr_width : INTEGER := 8;
             data_width : INTEGER := 7
             );
end schdlr_filter_tb;

architecture Behavioral of schdlr_filter_tb is

component schdlr_filter is

  Generic (img_size  : INTEGER := 16;
             img_size2  : INTEGER := 256;
             row_n_width : INTEGER := 4;
             addr_width : INTEGER := 8;
             data_width : INTEGER := 7);
             
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           init_process : in STD_LOGIC;
           finish_flag_process : out STD_LOGIC;
           
                      
           addr_in_img_bram1 : out  STD_LOGIC_VECTOR (addr_width downto 0) := (others => '0');
           addr_out_img_bram2 : out  STD_LOGIC_VECTOR (addr_width downto 0) := (others => '0');
           pixel_in_bram1 : in STD_LOGIC_VECTOR (data_width downto 0);
           pixel_out_bram2 :out STD_LOGIC_VECTOR (data_width downto 0) := (others => '0');
           we_bram2 : out STD_LOGIC_VECTOR (0 downto 0) := "0");
           
end component;

signal clk : STD_LOGIC;
signal reset : STD_LOGIC;
signal init_process : STD_LOGIC;
signal finish_flag_process : STD_LOGIC;

signal addr_in_img_bram1 : STD_LOGIC_VECTOR (addr_width downto 0);
signal addr_out_img_bram2 : STD_LOGIC_VECTOR (addr_width downto 0);
signal pixel_in_bram1 : STD_LOGIC_VECTOR (data_width downto 0);
signal pixel_out_bram2 : STD_LOGIC_VECTOR (data_width downto 0);
signal we_bram2 : STD_LOGIC_VECTOR (0 downto 0);

constant clock_period: time := 10 ns;

begin

  uut: schdlr_filter port map ( clk                   => clk,
                                reset                 => reset,
                                init_process          => init_process,
                                finish_flag_process   => finish_flag_process,
                                addr_in_img_bram1     => addr_in_img_bram1,
                                addr_out_img_bram2    => addr_out_img_bram2,
                                pixel_in_bram1        => pixel_in_bram1,
                                pixel_out_bram2       => pixel_out_bram2,
                                we_bram2              => we_bram2);

  stimulus: process
  begin
  
    -- Put initialisation code here
    reset <= '0';
    init_process <= '0';
    -- finish_flag_process <= '0';
    wait for 2.5 ns;
    
    reset <= '1';
    wait for 5ns;
    
    reset <= '0';
    wait for 5ns;
    
    init_process <= '1';
    wait for 15ns;
    
    init_process <= '0';
    wait for 5ns;
    wait;
  end process;

  clocking: process
  begin
    clk <= '0', '1' after clock_period / 2;
    wait for clock_period;
  end process;                          
                            
end Behavioral;
