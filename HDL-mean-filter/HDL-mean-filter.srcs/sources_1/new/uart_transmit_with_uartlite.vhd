----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/27/2020 02:20:35 PM
-- Design Name: 
-- Module Name: uart_transmit_with_uartlite - Behavioral
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

entity uart_transmit_with_uartlite is
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           start_op_in : in STD_LOGIC;
           finished_op_out : out STD_LOGIC;
           rx : in std_logic;
           tx : out std_logic);
end uart_transmit_with_uartlite;

architecture Behavioral of uart_transmit_with_uartlite is

component uart_transmit is

    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           --oignal to start the communication process.
           start_op_in : in STD_LOGIC;
           --outputs finish signal of the communication process.
           finished_op_out : out STD_LOGIC := '0';
           --interrupt signal from axi uartlite communication unit.
           uart_interrupt_in : in STD_LOGIC;
           --write address to axi uartlite communication unit.
           uart_s_axi_awaddr_out : out STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
           --write address valid signal to axi uartlite communication unit.
           uart_s_axi_awvalid_out : out STD_LOGIC := '0';
           --write address ready signal from axi uartlite communication unit.
           uart_s_axi_awready_in : in STD_LOGIC;
           --write data to axi uartlite communication unit.
           uart_s_axi_wdata_out : out STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
           ----write strobe selection to axi uartlite communication unit.
           uart_s_axi_wstrb_out : out STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
           --write data valid signal to axi uartlite communication unit.
           uart_s_axi_wvalid_out : out STD_LOGIC := '0';
           --write data ready signal from axi uartlite communication unit.
           uart_s_axi_wready_in : in STD_LOGIC;
           --write response from axi uartlite communication unit.
           uart_s_axi_bresp_in : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           --write reponse valid signal from axi uartlite communication unit.
           uart_s_axi_bvalid_in : in STD_LOGIC;
           --write response ready signal to axi uartlite communication unit.
           uart_s_axi_bready_out : out STD_LOGIC := '0';
           --read address to axi uartlite communication unit.
           uart_s_axi_araddr_out : out STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
           --read address valid signal to axi uartlite communication unit.
           uart_s_axi_arvalid_out : out STD_LOGIC := '0';
           --read address ready signal from axi uartlite communication unit.
           uart_s_axi_arready_in : in STD_LOGIC;
           --read data from axi uartlite communication unit.
           uart_s_axi_rdata_in : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           --read data response from axi uartlite communication unit.
           uart_s_axi_rresp_in : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           --read data valid signal from axi uartlite communication unit.
           uart_s_axi_rvalid_in : in STD_LOGIC;
           --read ready signal to axi uartlite communication unit.
           uart_s_axi_rready_out : out STD_LOGIC := '0');

end component;

component axi_uartlite_0 is

    Port ( s_axi_aclk : in std_logic;
           s_axi_aresetn : in std_logic;
           --interrupt signal from axi uartlite communication unit.
           interrupt : out STD_LOGIC;
           --write address to axi uartlite communication unit.
           s_axi_awaddr : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           --write address valid signal to axi uartlite communication unit.
           s_axi_awvalid : in STD_LOGIC := '0';
           --write address ready signal from axi uartlite communication unit.
           s_axi_awready : out STD_LOGIC;
           --write data to axi uartlite communication unit.
           s_axi_wdata : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           ----write strobe selection to axi uartlite communication unit.
           s_axi_wstrb : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           --write data valid signal to axi uartlite communication unit.
           s_axi_wvalid : in STD_LOGIC;
           --write data ready signal from axi uartlite communication unit.
           s_axi_wready : out STD_LOGIC;
           --write response from axi uartlite communication unit.
           s_axi_bresp : out STD_LOGIC_VECTOR(1 DOWNTO 0);
           --write reponse valid signal from axi uartlite communication unit.
           s_axi_bvalid : out STD_LOGIC;
           --write response ready signal to axi uartlite communication unit.
           s_axi_bready : in STD_LOGIC := '0';
           --read address to axi uartlite communication unit.
           s_axi_araddr : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           --read address valid signal to axi uartlite communication unit.
           s_axi_arvalid : in STD_LOGIC := '0';
           --read address ready signal from axi uartlite communication unit.
           s_axi_arready : out STD_LOGIC;
           --read data from axi uartlite communication unit.
           s_axi_rdata : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           --read data response from axi uartlite communication unit.
           s_axi_rresp : out STD_LOGIC_VECTOR(1 DOWNTO 0);
           --read data valid signal from axi uartlite communication unit.
           s_axi_rvalid : out STD_LOGIC;
           --read ready signal to axi uartlite communication unit.
           s_axi_rready : in STD_LOGIC;
           rx : in std_logic;
           tx : out std_logic);

end component;

signal reset : std_logic := '1';

signal interrupt : STD_LOGIC;
signal uart_s_axi_awaddr_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal uart_s_axi_awvalid_out : STD_LOGIC;
signal uart_s_axi_awready_in : STD_LOGIC;
signal uart_s_axi_wdata_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal uart_s_axi_wstrb_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal uart_s_axi_wvalid_out : STD_LOGIC;
signal uart_s_axi_wready_in : STD_LOGIC;
signal uart_s_axi_bresp_in : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal uart_s_axi_bvalid_in : STD_LOGIC;
signal uart_s_axi_bready_out : STD_LOGIC;
signal uart_s_axi_araddr_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal uart_s_axi_arvalid_out : STD_LOGIC;
signal uart_s_axi_arready_in : STD_LOGIC;
signal uart_s_axi_rdata_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal uart_s_axi_rresp_in : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal uart_s_axi_rvalid_in : STD_LOGIC;
signal uart_s_axi_rready_out : STD_LOGIC;

begin

uart_transmit_1 : uart_transmit
    port map ( clk => clk,
           rst_n => rst_n,
           start_op_in => start_op_in,
           finished_op_out => finished_op_out,
           uart_interrupt_in => interrupt,
           uart_s_axi_awaddr_out => uart_s_axi_awaddr_out,
           uart_s_axi_awvalid_out => uart_s_axi_awvalid_out,
           uart_s_axi_awready_in => uart_s_axi_awready_in,
           uart_s_axi_wdata_out => uart_s_axi_wdata_out,
           uart_s_axi_wstrb_out => uart_s_axi_wstrb_out,
           uart_s_axi_wvalid_out => uart_s_axi_wvalid_out,
           uart_s_axi_wready_in => uart_s_axi_wready_in,
           uart_s_axi_bresp_in => uart_s_axi_bresp_in,
           uart_s_axi_bvalid_in => uart_s_axi_bvalid_in,
           uart_s_axi_bready_out => uart_s_axi_bready_out,
           uart_s_axi_araddr_out => uart_s_axi_araddr_out,
           uart_s_axi_arvalid_out => uart_s_axi_arvalid_out,
           uart_s_axi_arready_in => uart_s_axi_arready_in,
           uart_s_axi_rdata_in => uart_s_axi_rdata_in,
           uart_s_axi_rresp_in => uart_s_axi_rresp_in,
           uart_s_axi_rvalid_in => uart_s_axi_rvalid_in,
           uart_s_axi_rready_out => uart_s_axi_rready_out);
           
uartlite_1 : axi_uartlite_0
    port map ( s_axi_aclk => clk,
           s_axi_aresetn => reset,
           interrupt => interrupt,
           s_axi_awaddr => uart_s_axi_awaddr_out,
           s_axi_awvalid => uart_s_axi_awvalid_out,
           s_axi_awready => uart_s_axi_awready_in,
           s_axi_wdata => uart_s_axi_wdata_out,
           s_axi_wstrb => uart_s_axi_wstrb_out,
           s_axi_wvalid => uart_s_axi_wvalid_out,
           s_axi_wready => uart_s_axi_wready_in,
           s_axi_bresp => uart_s_axi_bresp_in,
           s_axi_bvalid => uart_s_axi_bvalid_in,
           s_axi_bready => uart_s_axi_bready_out,
           s_axi_araddr => uart_s_axi_araddr_out,
           s_axi_arvalid => uart_s_axi_arvalid_out,
           s_axi_arready => uart_s_axi_arready_in,
           s_axi_rdata => uart_s_axi_rdata_in,
           s_axi_rresp => uart_s_axi_rresp_in,
           s_axi_rvalid => uart_s_axi_rvalid_in,
           s_axi_rready => uart_s_axi_rready_out,
           rx => rx,
           tx => tx);

end Behavioral;
