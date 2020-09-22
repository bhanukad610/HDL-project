----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2020 08:08:34 AM
-- Design Name: 
-- Module Name: uart_lite_comm_unit - Behavioral
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

entity uart_lite_comm_unit is
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
end uart_lite_comm_unit;

architecture Behavioral of uart_lite_comm_unit is

component uart_comm_unit is
    Generic (mem_addr_size_g   : integer := 9; --holds memory address length.
             pixel_data_size_g : integer := 8; --holds pixel data bit length.
             base_val_g        : integer := 0);--holds basic initialization value(0).

    port ( clk                    : in STD_LOGIC;
           rst_n                  : in STD_LOGIC;
           start_op_in            : in STD_LOGIC;
           finished_op_out        : out STD_LOGIC := '0';
           send_rec_select_in     : in STD_LOGIC;
           ioi_addra_out          : out STD_LOGIC_VECTOR (mem_addr_size_g -1 downto 0) := std_logic_vector(to_unsigned(base_val_g, mem_addr_size_g));
           ioi_dina_out           : out STD_LOGIC_VECTOR (pixel_data_size_g -1 downto 0) := std_logic_vector(to_unsigned(base_val_g, pixel_data_size_g));
           ioi_douta_in           : in STD_LOGIC_VECTOR (pixel_data_size_g -1 downto 0);
           ioi_wea_out            : out STD_LOGIC_VECTOR (0 downto 0) := "0";
           uart_interrupt_in      : in STD_LOGIC;
           uart_s_axi_awaddr_out  : out STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
           uart_s_axi_awvalid_out : out STD_LOGIC := '0';
           uart_s_axi_awready_in  : in STD_LOGIC;
           uart_s_axi_wdata_out   : out STD_LOGIC_VECTOR(31 DOWNTO 0) := std_logic_vector(to_unsigned(base_val_g, 32));
           uart_s_axi_wstrb_out   : out STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
           uart_s_axi_wvalid_out  : out STD_LOGIC := '0';
           uart_s_axi_wready_in   : in STD_LOGIC;
           uart_s_axi_bresp_in    : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           uart_s_axi_bvalid_in   : in STD_LOGIC;
           uart_s_axi_bready_out  : out STD_LOGIC := '0';
           uart_s_axi_araddr_out  : out STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
           uart_s_axi_arvalid_out : out STD_LOGIC := '0';
           uart_s_axi_arready_in : in STD_LOGIC;
           uart_s_axi_rdata_in   : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           uart_s_axi_rresp_in   : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           uart_s_axi_rvalid_in  : in STD_LOGIC;
           uart_s_axi_rready_out : out STD_LOGIC := '0');
end component;

component axi_uartlite_0 is
    Port (s_axi_aclk    : IN STD_LOGIC;
          s_axi_aresetn : IN STD_LOGIC;
          interrupt     : OUT STD_LOGIC;
          s_axi_awaddr  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          s_axi_awvalid : IN STD_LOGIC;
          s_axi_awready : OUT STD_LOGIC;
          s_axi_wdata   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
          s_axi_wstrb   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          s_axi_wvalid  : IN STD_LOGIC;
          s_axi_wready  : OUT STD_LOGIC;
          s_axi_bresp   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          s_axi_bvalid  : OUT STD_LOGIC;
          s_axi_bready  : IN STD_LOGIC;
          s_axi_araddr  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          s_axi_arvalid : IN STD_LOGIC;
          s_axi_arready : OUT STD_LOGIC;
          s_axi_rdata   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
          s_axi_rresp   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          s_axi_rvalid  : OUT STD_LOGIC;
          s_axi_rready  : IN STD_LOGIC;
          rx            : IN STD_LOGIC;
          tx            : OUT STD_LOGIC);
end component;

signal interrupt : STD_LOGIC;
signal s_axi_awaddr  : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal s_axi_awvalid : STD_LOGIC;
signal s_axi_awready : STD_LOGIC;
signal s_axi_wdata   : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal s_axi_wstrb   : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal s_axi_wvalid  : STD_LOGIC;
signal s_axi_wready  : STD_LOGIC;
signal s_axi_bresp   : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal s_axi_bvalid  : STD_LOGIC;
signal s_axi_bready  : STD_LOGIC;
signal s_axi_araddr  : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal s_axi_arvalid : STD_LOGIC;
signal s_axi_arready : STD_LOGIC;
signal s_axi_rdata   : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal s_axi_rresp   : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal s_axi_rvalid  : STD_LOGIC;
signal s_axi_rready  : STD_LOGIC;

begin

uart_comm_unit1 : uart_comm_unit
    port map (clk                    => clk,
              rst_n                  => reset,
              start_op_in            => start_op_in,
              finished_op_out        => finished_op_out,
              send_rec_select_in     => send_rec_select_in,
              ioi_addra_out          => ioi_addra_out,
              ioi_douta_in           => ioi_douta_in,
              ioi_dina_out           => ioi_dina_out,
              ioi_wea_out            => ioi_wea_out,
              uart_interrupt_in      => interrupt,
              uart_s_axi_awaddr_out  => s_axi_awaddr,
              uart_s_axi_awvalid_out => s_axi_awvalid,
              uart_s_axi_awready_in  => s_axi_awready,
              uart_s_axi_wdata_out   => s_axi_wdata,
              uart_s_axi_wstrb_out   => s_axi_wstrb,
              uart_s_axi_wvalid_out  => s_axi_wvalid,
              uart_s_axi_wready_in   => s_axi_wready,
              uart_s_axi_bresp_in    => s_axi_bresp,
              uart_s_axi_bvalid_in   => s_axi_bvalid,
              uart_s_axi_bready_out  => s_axi_bready,
              uart_s_axi_araddr_out  => s_axi_araddr,
              uart_s_axi_arvalid_out => s_axi_arvalid,
              uart_s_axi_arready_in  => s_axi_arready,
              uart_s_axi_rdata_in    => s_axi_rdata,
              uart_s_axi_rresp_in    => s_axi_rresp,
              uart_s_axi_rvalid_in   => s_axi_rvalid,
              uart_s_axi_rready_out  => s_axi_rready);

axi_uartlite1 : axi_uartlite_0
    port map (s_axi_aclk    => clk,
              s_axi_aresetn => reset,
              interrupt     => interrupt,
              s_axi_awaddr  => s_axi_awaddr,
              s_axi_awvalid => s_axi_awvalid,
              s_axi_awready => s_axi_awready,
              s_axi_wdata   => s_axi_wdata,
              s_axi_wstrb   => s_axi_wstrb,
              s_axi_wvalid  => s_axi_wvalid,
              s_axi_wready  => s_axi_wready,
              s_axi_bresp   => s_axi_bresp,
              s_axi_bvalid  => s_axi_bvalid,
              s_axi_bready  => s_axi_bready,
              s_axi_araddr  => s_axi_araddr,
              s_axi_arvalid => s_axi_arvalid,
              s_axi_arready => s_axi_arready,
              s_axi_rdata   => s_axi_rdata,
              s_axi_rresp   => s_axi_rresp,
              s_axi_rvalid  => s_axi_rvalid,
              s_axi_rready  => s_axi_rready,
              rx            => rx,
              tx            => tx);          

end Behavioral;
