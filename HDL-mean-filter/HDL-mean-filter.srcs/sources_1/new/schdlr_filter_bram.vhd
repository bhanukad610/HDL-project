----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/16/2020 07:27:35 PM
-- Design Name: 
-- Module Name: schdlr_filter_bram - Behavioral
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

entity schdlr_filter_bram is
  Generic (img_size  : INTEGER := 16;
             img_size2  : INTEGER := 256;
             row_n_width : INTEGER := 4;
             addr_width : INTEGER := 8;
             data_width : INTEGER := 7
             );
             
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           init_process : in STD_LOGIC;
           finish_flag_process : out STD_LOGIC);
           
end schdlr_filter_bram;

architecture Behavioral of schdlr_filter_bram is

component scheduler2 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           init_process : in STD_LOGIC;
           finish_flag_single_op : in STD_LOGIC;
           
           init_single_op : out STD_LOGIC := '0';
           finish_flag_process : out STD_LOGIC := '0';
           row : out STD_LOGIC_VECTOR (row_n_width downto 0) := (others => '0');
           column : out STD_LOGIC_VECTOR (row_n_width downto 0) := (others => '0'));
end component;

component mean_filter2 is
  Port ( row : in STD_LOGIC_VECTOR (row_n_width downto 0);
           col : in STD_LOGIC_VECTOR (row_n_width downto 0);
           init_single_op : in STD_LOGIC;
           finish_flag_single_op : out STD_LOGIC := '1';
           addr_in_img : out  STD_LOGIC_VECTOR (addr_width downto 0) := (others => '0');
           addr_out_img : out  STD_LOGIC_VECTOR (addr_width downto 0) := (others => '0');
           pixel_in : in STD_LOGIC_VECTOR (data_width downto 0);
           pixel_out :out STD_LOGIC_VECTOR (data_width downto 0) := (others => '0');
           clk  : in STD_LOGIC;
           reset_in :in STD_LOGIC;
           we : out STD_LOGIC_VECTOR (0 downto 0) := "0");
end component;

component bram is
    Port ( addr : in STD_LOGIC_VECTOR (8 downto 0);
           clk: in std_logic;
           din: in std_logic_vector (7 downto 0);
           dout : out STD_LOGIC_VECTOR (7 downto 0);
           -- en: in std_logic;
           we: in std_logic_vector (0 downto 0));
end component;

signal row : STD_LOGIC_VECTOR (row_n_width downto 0);
signal col : STD_LOGIC_VECTOR (row_n_width downto 0);
signal init_single_op : STD_LOGIC;
signal finish_flag_single_op : STD_LOGIC;
signal addr_in_img_bram1 : STD_LOGIC_VECTOR (addr_width downto 0);
signal addr_out_img_bram2 : STD_LOGIC_VECTOR (addr_width downto 0);
signal pixel_in_bram1 : STD_LOGIC_VECTOR (data_width downto 0);
signal pixel_out_bram2 : STD_LOGIC_VECTOR (data_width downto 0);
signal we_bram2 : STD_LOGIC_VECTOR (0 downto 0);

signal reset_inverted : STD_LOGIC;

signal dout_bram2 : STD_LOGIC_VECTOR (data_width downto 0);

begin

mean_filter1 : mean_filter2
port map (row => row,
           col => col,
           init_single_op => init_single_op,
           finish_flag_single_op => finish_flag_single_op,
           addr_in_img => addr_in_img_bram1,
           addr_out_img => addr_out_img_bram2,
           pixel_in => pixel_in_bram1,
           pixel_out => pixel_out_bram2,
           clk => clk,
           reset_in => reset,
           we => we_bram2);
           
scheduler1 : scheduler2
port map (clk => clk,
           reset => reset,
           init_process => init_process,
           finish_flag_single_op => finish_flag_single_op,
           
           init_single_op => init_single_op,
           finish_flag_process => finish_flag_process,
           row => row,
           column => col);

reset_inverted <= not reset;
         
bram_in : bram
port map (     addr => addr_in_img_bram1,
               clk => clk,
               din => (others => '0'),
               dout => pixel_in_bram1,
               -- en => reset_inverted,
               we => "0");
               
bram_out : bram
port map (     addr => addr_out_img_bram2,
               clk => clk,
               din => pixel_out_bram2,
               dout => dout_bram2,
               -- en => reset_inverted,
               we => we_bram2);        

end Behavioral;
