----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/27/2020 07:29:46 PM
-- Design Name: 
-- Module Name: UART_RX_handeller - Behavioral
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

entity UART_RX_handeller is
    Port ( rx_serial : in STD_LOGIC;
           rx_enable : out STD_LOGIC;
           rx_byte : out STD_LOGIC_VECTOR (7 downto 0);
           addr_to_write : out STD_LOGIC_VECTOR (7 downto 0);           
           reset : in STD_LOGIC;
           clock : in STD_LOGIC);
end UART_RX_handeller;

architecture Behavioral of UART_RX_handeller is

component UART_RX is
  generic (
    g_CLKS_PER_BIT : integer := 10416     
    );
  port (
    i_Clk       : in  std_logic;
    i_RX_Serial : in  std_logic;
    o_RX_DV     : out std_logic;
    o_RX_Byte   : out std_logic_vector(7 downto 0)
    );
end component;

component uart_up_counter is
    Port ( enable : in STD_LOGIC;
           reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           counter_out : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal en : std_logic;

begin

uart_rx_module : UART_RX
    port map (i_Clk => clock,
              i_RX_Serial => rx_serial,
              o_RX_DV => en,
              o_RX_Byte => rx_byte);

up_counter : uart_up_counter
    port map (enable => en,
              reset => reset,
              clock => clock,
              counter_out => addr_to_write);

rx_enable <= en;
end Behavioral;
