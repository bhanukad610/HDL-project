----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2020 09:15:24 AM
-- Design Name: 
-- Module Name: uart_test - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_test is
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
end uart_test;

architecture Behavioral of uart_test is

component uart_lite_comm_unit is
    Generic (mem_addr_size_g   : integer := 9; --holds memory address length.
             pixel_data_size_g : integer := 8; --holds pixel data bit length.
             base_val_g        : integer := 0);--holds basic initialization value(0).
             
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           rx : in STD_LOGIC;
           tx : out STD_LOGIC;
           
           start_op_in            : in STD_LOGIC;
           finished_op_out        : out STD_LOGIC := '0';
           send_rec_select_in     : in STD_LOGIC;
           ioi_addra_out          : out STD_LOGIC_VECTOR (mem_addr_size_g -1 downto 0) := std_logic_vector(to_unsigned(base_val_g, mem_addr_size_g));
           ioi_dina_out           : out STD_LOGIC_VECTOR (pixel_data_size_g -1 downto 0) := std_logic_vector(to_unsigned(base_val_g, pixel_data_size_g));
           ioi_douta_in           : in STD_LOGIC_VECTOR (pixel_data_size_g -1 downto 0);
           ioi_wea_out            : out STD_LOGIC_VECTOR (0 downto 0) := "0");
end component;

component blk_mem_gen_1 is
    Port ( addra : in STD_LOGIC_VECTOR (8 downto 0);
           clka : in STD_LOGIC;
           dina: in std_logic_vector (7 downto 0);
           -- ena: in std_logic;
           wea: in std_logic_vector (0 downto 0);
           
           addrb : in STD_LOGIC_VECTOR (8 downto 0);
           clkb : in STD_LOGIC;
           doutb : out STD_LOGIC_VECTOR (7 downto 0)
           -- enb: in std_logic
           );
end component;

-- signal addra : STD_LOGIC_VECTOR (8 downto 0);
signal dina: std_logic_vector (7 downto 0);
signal douta : STD_LOGIC_VECTOR (7 downto 0);
-- signal ena: std_logic;
signal wea: std_logic_vector (0 downto 0);
           
-- signal addrb : STD_LOGIC_VECTOR (8 downto 0);
signal doutb : STD_LOGIC_VECTOR (7 downto 0);
-- signal enb: std_logic;
signal addr : STD_LOGIC_VECTOR (8 downto 0);
-- signal addra : STD_LOGIC_VECTOR (8 downto 0);
-- signal addrb : STD_LOGIC_VECTOR (8 downto 0);
-- signal en: std_logic;

begin

-- en <= '1';

uart_lite_com_unit1 : uart_lite_comm_unit
port map (clk => clk,
           reset => reset,
           rx => rx,
           tx => tx,
           
           start_op_in => start_op_in,
           finished_op_out => finished_op_out,
           send_rec_select_in => send_rec_select_in,
           ioi_addra_out => addr,
           ioi_dina_out => dina,
           ioi_douta_in => doutb,
           ioi_wea_out => wea);
           
uart_lite_com_unit2 : uart_lite_comm_unit
port map (clk => clk,
           reset => reset,
           rx => rx,
           tx => tx,
           
           start_op_in => start_op_in,
           finished_op_out => finished_op_out,
           send_rec_select_in => send_rec_select_in,
           ioi_addra_out => addr,
           ioi_dina_out => dina,
           ioi_douta_in => doutb,
           ioi_wea_out => wea);       
           
bram1 : blk_mem_gen_1
    port map ( addra => addr,
           clka => clk,
           dina => dina,
           -- ena => en,
           wea => wea,
           
           addrb => addr,
           clkb => clk,
           doutb =>  doutb
           -- enb => en
           );

end Behavioral;
