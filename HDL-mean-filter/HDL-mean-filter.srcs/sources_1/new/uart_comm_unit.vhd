----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/19/2020 06:05:14 PM
-- Design Name: 
-- Module Name: uart_receive - Behavioral
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


entity uart_comm_unit is
    Generic (mem_addr_size_g : integer := 10; --holds memory address length.
             pixel_data_size_g : integer := 8; --holds pixel data bit length.
             base_val_g : integer := 0);--holds basic initialization value(0).

    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           --oignal to start the communication process.
           start_op_in : in STD_LOGIC;
           --outputs finish signal of the communication process.
           finished_op_out : out STD_LOGIC := '0';
           --select the operation of the process (send/receive).
           send_rec_select_in : in STD_LOGIC;
           --address for input/output ram
           ioi_addra_out : out STD_LOGIC_VECTOR (mem_addr_size_g -1 downto 0) := std_logic_vector(to_unsigned(base_val_g, mem_addr_size_g));
           --data in bus for input/output ram.
           ioi_dina_out : out STD_LOGIC_VECTOR (pixel_data_size_g -1 downto 0) := std_logic_vector(to_unsigned(base_val_g, pixel_data_size_g));
           --data out bus from input/output ram.
           ioi_douta_in : in STD_LOGIC_VECTOR (pixel_data_size_g -1 downto 0);
           --write enable signal for input/output ram
           ioi_wea_out : out STD_LOGIC_VECTOR (0 downto 0) := "0";
           --interrupt signal from axi uartlite communication unit.
           uart_interrupt_in : in STD_LOGIC;
           --write address to axi uartlite communication unit.
           uart_s_axi_awaddr_out : out STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
           --write address valid signal to axi uartlite communication unit.
           uart_s_axi_awvalid_out : out STD_LOGIC := '0';
           --write address ready signal from axi uartlite communication unit.
           uart_s_axi_awready_in : in STD_LOGIC;
           --write data to axi uartlite communication unit.
           uart_s_axi_wdata_out : out STD_LOGIC_VECTOR(31 DOWNTO 0) := std_logic_vector(to_unsigned(base_val_g, 32));
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
end uart_comm_unit;

architecture Behavioral of uart_comm_unit is

-- There are 9 main states in this fsm.
-- 1. Idle - The fsm waits in the Idle state untill the start_op_in signal gets
-- high. With start signal, it also receives the operation select signal which
-- determines the send of reveive operation to conduct. Then it goes to
-- Set_CTRL_Reg state.
-- 2. Set_CTRL_Reg - In this state, the fsm goes through series of sub states
-- of axi related data teansfer, which are responsible for setting up the
-- control register of axi uart lite communication unit. After this setup,
-- fsm moves to Fetching(send) of Receiving(receive) state based on the
-- operation select signal reveived on the Idle state.
-- 3. Fetching - In fetching state, fsm fetches the data in the next location
-- to be sent on the input/output ram. After acuqiring the data, fsm moves to
-- sending state.
-- 4. Sending - In the sending state, the fsm goes through a series of sub states
-- of axi related data transfer, which are responsible for writing the previously
-- fetched value to the uart tx fifo. After successfully completing the data
-- write, fsm moves into Incermenting_Send state.
-- 5. Incermenting_Send - In the incermenting_Send state, fsm evaluate the
-- current memory address. If the address is the final one, then the fsm moves
-- to Done state. If there are more locations, fsm increments the address by 1
-- and moves to Fetching state again.
-- 6. Receiving - In the receiving state, the fsm waits till an interrupt from
-- the axi uart lite communication unit, with it fsm move through a series of sub
-- states of axi related data transfer, which are responsible for reading the
-- uart rx fifo for received data. After successfully reading the data, fsm moves
-- to Storing state.
-- 7. Storing - In this state, the previously received data is written in to the
-- next location of the input/outut ram. After writing the data, fsm moves to
-- Increment_Rec state.
-- 8. Increment_Rec - In this state, fsm evaluate the current memory address.
-- If the address is the final one, then the fsm moves to Done state. If there
-- are more locations, fsm increments the address by 1 and moves to Receiving
-- state again.
-- 9. Done - In the done state, fsm signals the finished_op_out signal and
-- moves to Idle state.

type main_state is (Idle, Set_CTRL_Reg, Fetching, Sending, Receiving, Storing, Incrementing_Send, Incrementing_Rec, Done);
signal comm_state : main_state;

-- There are 16 states which are related to axi data transfer operations.
-- These states represents the process of axi-4 lite read and write
-- operations

type axi_state is (Set_Rx_Write_Up, Wait_Rx_Ready, Set_Tx_Write_Down,
                   Set_Write_Resp_Up, Set_Write_Resp_Down, Wait_Tx_Done,
                   Set_CR_Write_Up, Wait_CR_Ready, Set_CR_Write_Down,
                   Set_CR_Normal, Get_Rx_Data, Set_Read_Ready_High,
                   Set_Read_Ready_Low, Interrupt_wait,
                   Set_Tx_Write_Up, Wait_Tx_Ready);
--siganl to hold axi substates of reading the uart rx fifo buffer.
signal axi_rx_sub_state : axi_state;
--siganl to hold axi substates of writing to the uart tx fifo buffer.
signal axi_tx_sub_state : axi_state;
--siganl to hold axi substates of writing to the uart control register.
signal axi_set_cr_sub_state : axi_state;
--signal to hold the pixel data.
signal pix_data : STD_LOGIC_VECTOR (pixel_data_size_g -1 downto 0);
--signal to hold the send/receive operation.
signal rec_op : STD_LOGIC;

begin

    process (clk, rst_n)
        --holds the input/output ram size.
        constant mem_size : integer := 625;
        -- time to wait after writing to input/output ram.
        constant write_wait_delay : integer := 3;
        -- time to wait after setting read address to input/output ram.
        constant fetch_wait_delay : integer := 3;
        --holds next memory location address.
        variable mem_addra : integer := 0;
        --holds how much time waited in the write wait. 
        variable write_wait : integer := 0;
        --holds how much time waited in the fetch wait
        variable fetch_wait : integer := 0;
        --holds the progress of setting uart control register.
        variable clear_rx_tx : STD_LOGIC := '1';
        begin
            --active low reset. Resets all progress back to Idle state.
            if (rst_n = '0') then
                comm_state <= Idle;
                pix_data <= std_logic_vector(to_unsigned(base_val_g, pix_data 'length));
                mem_addra := 0;
                write_wait := 0;
                clear_rx_tx := '1';
                finished_op_out <= '0';
                rec_op <= '0';
            elsif (clk 'event and clk = '1') then
                case comm_state is
                    when Idle =>
                        ioi_wea_out <= "0";
                        finished_op_out <= '0';
                        pix_data <= std_logic_vector(to_unsigned(base_val_g, pix_data 'length));
                        if (start_op_in = '1') then
                            --with start signal, read and save the operation
                            --select signal and move to Set_CTRL_Reg state.
                            if (send_rec_select_in = '1') then
                                rec_op <= '1';
                            else
                                rec_op <= '0';
                            end if;
                            comm_state <= Set_CTRL_Reg;
                            axi_set_cr_sub_state <= Set_CR_Write_Up;
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
                                else
                                    --select between next states based on the
                                    --operation to perform.
                                    if (rec_op = '1') then
                                        comm_state <= Receiving;
                                        axi_rx_sub_state <= Interrupt_wait;
                                    else
                                        comm_state <= Fetching;
                                    end if;
                                end if;
                            when others =>
                                null;
                        end case;
                    when Receiving =>
                        case axi_rx_sub_state is
                            when Interrupt_wait =>
                                --wait till the interrupt signalling new data
                                --present in the rx fifo.
                                if(uart_interrupt_in = '1') then
                                    axi_rx_sub_state <= Set_Rx_Write_Up;
                                end if;
                            when Set_Rx_Write_Up =>
                                --set read address to uart rx fifo address.
                                --set read address valid.
                                uart_s_axi_araddr_out <= "0000";
                                uart_s_axi_arvalid_out <= '1';
                                axi_rx_sub_state <= Wait_Rx_Ready;
                            when Wait_Rx_Ready =>
                                --wait till read address ready signal.
                                if (uart_s_axi_arready_in = '1') then
                                    axi_rx_sub_state <= Get_Rx_Data;
                                end if;
                            when Get_Rx_Data =>
                                --set read address invalid.
                                uart_s_axi_arvalid_out <= '0';
                                axi_rx_sub_state <= Set_Read_Ready_High;
                            when Set_Read_Ready_High =>
                                --set read ready signal.
                                uart_s_axi_rready_out<='1';
                                if (uart_s_axi_rvalid_in = '1') then
                                    --if read data valid, read it.
                                    pix_data <= std_logic_vector(resize(unsigned(uart_s_axi_rdata_in), ioi_dina_out 'length));
                                    axi_rx_sub_state <= Set_Read_Ready_Low;
                                end if;
                            when Set_Read_Ready_Low =>
                                --set read ready signal low and move to storing.
                                uart_s_axi_rready_out <= '0';
                                axi_rx_sub_state <= Interrupt_wait;
                                comm_state <= Storing;
                            when others =>
                                null;
                        end case;
                    when Storing =>
                        if (write_wait = 0) then
                            --write received data to current memory loaction and wait.
                            ioi_addra_out <= std_logic_vector(to_unsigned(mem_addra, ioi_addra_out 'length));
                            ioi_dina_out <= pix_data;
                            ioi_wea_out <= "1";
                            write_wait := 1;
                        elsif (write_wait = write_wait_delay) then
                            --if write wait is over, move to Increment_Rec to
                            --obtain next write address.
                            ioi_wea_out <= "0";
                            write_wait := 0;
                            comm_state <= Incrementing_Rec;
                        else
                            write_wait := write_wait + 1;
                        end if;
                    when Fetching =>
                        if (fetch_wait = 0) then
                            --set address to read from current memory loaction.
                            ioi_wea_out <= "0";
                            ioi_addra_out <= std_logic_vector(to_unsigned(mem_addra, ioi_addra_out 'length));
                            fetch_wait := 1;
                        elsif (fetch_wait = fetch_wait_delay) then
                            --if read wait is over, read the data and move to
                            --sending state. 
                            pix_data <= ioi_douta_in;
                            fetch_wait := 0;
                            comm_state <= Sending;
                            axi_tx_sub_state <= Set_Tx_Write_Up;
                        else
                            fetch_wait := fetch_wait + 1;
                        end if;
                    when Sending =>
                        case axi_tx_sub_state is
                            when Set_Tx_Write_Up =>
                                --set write address to uart tx fifo.
                                --set fetched pixel data as write data.
                                uart_s_axi_awaddr_out <= "0100";
                                uart_s_axi_wdata_out <= std_logic_vector(resize(unsigned(pix_data), uart_s_axi_wdata_out 'length));
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
                                    comm_state <= Incrementing_Send;
                                end if;
                            when others =>
                                null;
                        end case;
                    when Incrementing_Rec =>
                        ioi_wea_out <= "0";
                        if (mem_addra = mem_size-1) then
                            --if all data is recieved, move to done state.
                            comm_state <= Done;
                        else
                            --get the nect memory loaction to reecive.
                            mem_addra := mem_addra + 1;
                            comm_state <= Receiving;
                        end if;
                    when Incrementing_Send =>
                        if (mem_addra = mem_size-1) then
                            --if all data is sent, move to done state.
                            comm_state <= Done;
                        else
                            --get the next memnry location to send.
                            mem_addra := mem_addra + 1;
                            comm_state <= Fetching;
                        end if;
                    when Done =>
                        --if operation is done, signal the finished_op_out
                        --and move to Idle state.
                        mem_addra := 0;
                        write_wait := 0;
                        fetch_wait := 0;
                        pix_data <= std_logic_vector(to_unsigned(base_val_g, pix_data 'length));
                        comm_state <= Idle;
                        finished_op_out <= '1';
                    when others =>
                        null;
                end case;
            end if;
        end process;
end Behavioral;

