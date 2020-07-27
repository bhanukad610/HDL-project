----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/26/2020 06:43:33 AM
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

entity uart_transmit is
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           --oignal to start the communication process.
           start_op_in : in STD_LOGIC;
           --outputs finish signal of the communication process.
           finished_op_out : out STD_LOGIC := '0';
           --select the operation of the process (send/receive).
           -- send_rec_select_in : in STD_LOGIC;
           --address for input/output ram
           -- ioi_addra_out : out STD_LOGIC_VECTOR (mem_addr_size_g -1 downto 0) := std_logic_vector(to_unsigned(base_val_g, mem_addr_size_g));
           --data in bus for input/output ram.
           -- ioi_dina_out : out STD_LOGIC_VECTOR (pixel_data_size_g -1 downto 0) := std_logic_vector(to_unsigned(base_val_g, pixel_data_size_g));
           --data out bus from input/output ram.
           -- ioi_douta_in : in STD_LOGIC_VECTOR (pixel_data_size_g -1 downto 0);
           --write enable signal for input/output ram
           -- ioi_wea_out : out STD_LOGIC_VECTOR (0 downto 0) := "0";
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
end uart_transmit;

architecture Behavioral of uart_transmit is

type main_state is (Idle, Set_CTRL_Reg, Sending, Done);
signal comm_state : main_state;

type axi_state is (Set_Rx_Write_Up, Wait_Rx_Ready, Set_Tx_Write_Down,
                   Set_Write_Resp_Up, Set_Write_Resp_Down, Wait_Tx_Done,
                   Set_CR_Write_Up, Wait_CR_Ready, Set_CR_Write_Down,
                   Set_CR_Normal, Get_Rx_Data, Set_Read_Ready_High,
                   Set_Read_Ready_Low, Interrupt_wait,
                   Set_Tx_Write_Up, Wait_Tx_Ready);
                   
signal axi_tx_sub_state : axi_state;
signal axi_set_cr_sub_state : axi_state;

shared variable data_to_send : integer := 65;

begin

process (clk, rst_n)
    --holds the input/output ram size.
    -- constant mem_size : integer := 625;
    -- time to wait after writing to input/output ram.
    -- constant write_wait_delay : integer := 3;
    -- time to wait after setting read address to input/output ram.
    -- constant fetch_wait_delay : integer := 3;
    --holds next memory location address.
    -- variable mem_addra : integer := 0;
    --holds how much time waited in the write wait. 
    -- variable write_wait : integer := 0;
    --holds how much time waited in the fetch wait
    -- variable fetch_wait : integer := 0;
    --holds the progress of setting uart control register.
    variable clear_rx_tx : STD_LOGIC := '1';
    
    begin
       --active low reset. Resets all progress back to Idle state.
            if (rst_n = '0') then
                comm_state <= Idle;
                clear_rx_tx := '1';
                finished_op_out <= '0';
            elsif (clk 'event and clk = '1') then
                case comm_state is
                    when Idle =>
                        if (start_op_in = '1') then
                            --with start signal, read and save the operation
                            --select signal and move to Set_CTRL_Reg state.
                            comm_state <= Set_CTRL_Reg;
                            clear_rx_tx := '1';
                        end if;
                    when Set_CTRL_Reg =>
                        case axi_set_cr_sub_state is
                            when Set_CR_Write_Up =>
                                --set axi write address to uart control reg address.
                                --set to read from last 8bit of the data.
                                uart_s_axi_awaddr_out <= "1100";
                                uart_s_axi_wstrb_out <= "0001";
                                --select between values to the control register.
                                if (clear_rx_tx = '1') then
                                    --set control reg to enable uart interrupt
                                    --and to clear rx and tx fifo.
                                    uart_s_axi_wdata_out <= "00000000000000000000000000010011";
                                else
                                    --set control reg to enable uart interrupt
                                    --and not to clear rx and tx fifo.
                                    uart_s_axi_wdata_out <= "00000000000000000000000000010000";
                                end if;
                                --set write address and write data valid.
                                uart_s_axi_awvalid_out <= '1';
                                uart_s_axi_wvalid_out <= '1';
                                axi_set_cr_sub_state <= Wait_CR_Ready;
                            when Wait_CR_Ready =>
                                --wait till write ready signal.
                                if (uart_s_axi_awready_in = '1' and uart_s_axi_wready_in = '1') then
                                    axi_set_cr_sub_state <= Set_CR_Write_Down;
                                end if;
                            when Set_CR_Write_Down =>
                                --set write address and write data invalid.
                                uart_s_axi_awvalid_out <= '0';
                                uart_s_axi_wvalid_out <= '0';
                                axi_set_cr_sub_state <= Set_Write_Resp_Up;
                            when Set_Write_Resp_Up =>
                                --wait till write response from slave.
                                if (uart_s_axi_bvalid_in = '1') then
                                    --set master write response high.
                                    uart_s_axi_bready_out <= '1';
                                    axi_set_cr_sub_state <= Set_Write_Resp_Down;
                                end if;
                            when Set_Write_Resp_Down =>
                                --set master write response low.
                                uart_s_axi_bready_out <= '0';
                                axi_set_cr_sub_state <= Set_CR_Normal;
                            when Set_CR_Normal =>
                                --switch between values to the control register.
                                if (clear_rx_tx = '1') then
                                    clear_rx_tx := '0';
                                    axi_set_cr_sub_state <= Set_CR_Write_Up;
                                end if;
                            when others =>
                                null;
                        end case;
                    when Sending =>
                        case axi_tx_sub_state is
                            when Set_Tx_Write_Up =>
                                --set write address to uart tx fifo.
                                --set fetched pixel data as write data.
                                uart_s_axi_awaddr_out <= "0100";
                                uart_s_axi_wdata_out <= std_logic_vector(to_unsigned(data_to_send, 32));
                                --set write address and write data valid.
                                uart_s_axi_awvalid_out <= '1';
                                uart_s_axi_wvalid_out <= '1';
                                axi_tx_sub_state <= Wait_Tx_Ready;
                            when Wait_Tx_Ready =>
                                --wait til  slave signals write ready.
                                if (uart_s_axi_awready_in = '1' and uart_s_axi_wready_in = '1') then
                                    axi_tx_sub_state <= Set_Tx_Write_Down;
                                end if;
                            when Set_Tx_Write_Down =>
                                --set write address and data invalid.
                                uart_s_axi_awvalid_out <= '0';
                                uart_s_axi_wvalid_out <= '0';
                                axi_tx_sub_state <= Set_Write_Resp_Up;
                            when Set_Write_Resp_Up =>
                                --wait till slaves write response.
                                if (uart_s_axi_bvalid_in = '1') then
                                    --set master write response high.
                                    uart_s_axi_bready_out <= '1';
                                    axi_tx_sub_state <= Set_Write_Resp_Down;
                                end if;
                            when Set_Write_Resp_Down =>
                                --set master write response low.
                                uart_s_axi_bready_out <= '0';
                                axi_tx_sub_state <= Wait_Tx_Done;
                            when Wait_Tx_Done =>
                                --wait till the interrupt signalling tx fifo
                                --is empty and move to acqure next memory
                                --location to fetch.
                                if (uart_interrupt_in = '1') then
                                    axi_tx_sub_state <= Set_Tx_Write_Up;
                                end if;
                            when others =>
                                null;
                        end case;
                    when others =>
                        null;
                end case;
            end if;
        end process;

end Behavioral;
