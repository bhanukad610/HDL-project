----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2020 07:02:50 AM
-- Design Name: 
-- Module Name: uart_tx_only - Behavioral
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

entity uart_tx_only is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           finished_sending : in STD_LOGIC;
           send_all : in STD_LOGIC;
           
           addrb : out STD_LOGIC_VECTOR (8 downto 0) := (others => '0');
           doutb : in STD_LOGIC_VECTOR (7 downto 0);
           
           tx : out STD_LOGIC := '1');
end uart_tx_only;

architecture Behavioral of uart_tx_only is

component up_counter_helper is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           ready : in STD_LOGIC;
           counter_en : out STD_LOGIC := '0';
           send : out STD_LOGIC := '0';
           finished_sending : in STD_LOGIC;
           send_all : in STD_LOGIC);
end component;

component uart_up_counter is
    Port ( clock : in STD_LOGIC;
           enable : in STD_LOGIC;
           reset : in STD_LOGIC;
           counter_out : out STD_LOGIC_VECTOR (8 downto 0));
end component;

component UART_TX_CTRL is
    Port ( SEND : in  STD_LOGIC;
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
           READY : out  STD_LOGIC;
           UART_TX : out  STD_LOGIC);
end component;

signal ready : STD_LOGIC;
signal conter_en : STD_LOGIC;
signal send : STD_LOGIC;

begin

helper1 : up_counter_helper
    port map ( clk => clk,
           reset => reset,
           ready => ready,
           counter_en => conter_en,
           send => send,
           finished_sending => finished_sending,
           send_all => send_all);

counter1 : uart_up_counter
    port map ( clock => clk,
           enable => conter_en,
           reset=> reset,
           counter_out => addrb);
           
uart_tx_ctrl1 : UART_TX_CTRL
    port map ( SEND => send,
           DATA => doutb,
           CLK => clk,
           READY => ready,
           UART_TX => tx);         
           
end Behavioral;
