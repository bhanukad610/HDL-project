----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2020 03:36:08 AM
-- Design Name: 
-- Module Name: up_counter_helper - Behavioral
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

entity up_counter_helper is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           ready : in STD_LOGIC;
           counter_en : out STD_LOGIC := '0';
           send : out STD_LOGIC := '0';
           finished_sending : in STD_LOGIC;
           send_all : in STD_LOGIC);
end up_counter_helper;

architecture Behavioral of up_counter_helper is

type CHELPER_STATE is (idle, aaa, wait0, wait1, sending0, sending1, done);
signal helper_state : CHELPER_STATE;

type SENDING_STATE is (idle, sending);
signal sending_state1 : SENDING_STATE;

begin

helping: process (clk, reset)
begin
if (reset = '1') then
    helper_state <= idle;
    sending_state1 <= idle;
elsif (clk'event and clk = '1') then
    case sending_state1 is
        when idle =>
            if (send_all = '1') then
                sending_state1 <= sending;
            end if;
        when sending =>
            if (finished_sending = '1') then
                sending_state1 <= idle;
            else
                case helper_state is
                    when idle =>
                        counter_en <= '0';
                        if (ready = '1') then
                            helper_state <= wait0;
                        end if;
                    when wait0 =>
                            helper_state <= wait1;
                    when wait1 =>
                            helper_state <= sending0;
                    when sending0 =>
                            send <= '1';
                            helper_state <= sending1;
                    when sending1 =>
                            helper_state <= aaa;
                    when aaa =>
                            send <= '0';
                            counter_en <= '1';
                            helper_state <= done;
                    when done =>
                            helper_state <= idle;
                end case;
            end if;
    end case;
end if;
end process helping;

end Behavioral;
