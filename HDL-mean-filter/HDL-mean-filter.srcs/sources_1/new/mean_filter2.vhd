----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/20/2020 11:54:01 AM
-- Design Name: 
-- Module Name: mean_filter - Behavioral
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
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or signed values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mean_filter2 is
    Generic (img_size  : INTEGER := 16;
             img_size2  : INTEGER := 256;
             row_n_width : INTEGER := 4;
             addr_width : INTEGER := 8;
             data_width : INTEGER := 7
             );

  Port ( row : in STD_LOGIC_VECTOR (row_n_width downto 0);
           col : in STD_LOGIC_VECTOR (row_n_width downto 0);
           init_single_op : in STD_LOGIC;
           finish_flag_single_op : out STD_LOGIC := '0';
           addr_in_img : out  STD_LOGIC_VECTOR (addr_width downto 0);
           addr_out_img : out  STD_LOGIC_VECTOR (addr_width downto 0);
           pixel_in : in STD_LOGIC_VECTOR (data_width downto 0);
           pixel_out :out STD_LOGIC_VECTOR (data_width downto 0);
           clk  : in STD_LOGIC;
           reset_in :in STD_LOGIC);
end mean_filter2;

architecture Behavioral of mean_filter2 is

TYPE FILTER_STATE IS (idle, wait0, wait1, accu0, accu1, accu2, accu3, accu4, accu5, accu6, accu7, accu8, div, write);
signal main_state : FILTER_STATE;

signal row_dec  : integer range 0 to img_size2;
signal col_dec : integer range 0 to img_size2;

signal iaddr_in_img : unsigned (8 downto 0);
signal iaddr_out_img : integer;
signal dout_bram : STD_LOGIC_VECTOR (7 downto 0);

shared variable sum : INTEGER := 0;
shared variable row_offset : INTEGER := -1;
shared variable col_offset : INTEGER := -1;

begin


 convolve : process (clk, reset_in)
    
    begin
    if (reset_in = '1') then
        main_state <= idle;
        row_dec <= to_integer(unsigned(row)) + 1;
        col_dec <= to_integer(unsigned(col)) + 1;
        row_offset := -1;
        col_offset := -1;
        iaddr_in_img <= to_unsigned((row_dec + row_offset) * img_size + (col_dec + col_offset), iaddr_in_img'length);
        iaddr_out_img <= (to_integer(unsigned(row)) + row_offset) * img_size + (to_integer(unsigned(col)) + col_offset);
        dout_bram <= (others => '0');
        sum := 0;
    elsif (clk'EVENT AND clk = '1') then
        case main_state is
            when idle =>
                if (init_single_op = '1') then
                    main_state <= wait0;
                    -- set pixel 1 address
                    row_offset := -1;
                    col_offset := -1;
                    iaddr_in_img <= to_unsigned((row_dec + row_offset) * img_size + (col_dec + col_offset), iaddr_in_img'length);
                    addr_in_img <= std_logic_vector(iaddr_in_img);
                end if;
            when wait0 =>
                main_state <= wait1;
                -- set pixel 1 address
                col_offset := 0;
                iaddr_in_img <= to_unsigned((row_dec + row_offset) * img_size + (col_dec + col_offset), iaddr_in_img'length);
                addr_in_img <= std_logic_vector(iaddr_in_img);
            when wait1 =>
                main_state <= accu0;
                -- read pixel 0 value and accumulate
                sum := sum + to_integer(unsigned(pixel_in));
                -- set pixel 2 address
                col_offset := 1;
                iaddr_in_img <= to_unsigned((row_dec + row_offset) * img_size + (col_dec + col_offset), iaddr_in_img'length);
                addr_in_img <= std_logic_vector(iaddr_in_img);
            when accu0 =>
                main_state <= accu1;
                -- read pixel 1 value and accumulate
                sum := sum + to_integer(unsigned(pixel_in));
                -- set pixel 3 address
                col_offset := -1;
                row_offset := 0;
                iaddr_in_img <= to_unsigned((row_dec + row_offset) * img_size + (col_dec + col_offset), iaddr_in_img'length);
                addr_in_img <= std_logic_vector(iaddr_in_img);
            when accu1 =>
                main_state <= accu2;
                -- read pixel 2 value and accumulate
                sum := sum + to_integer(unsigned(pixel_in));
                -- set pixel 4 address
                col_offset := 0;
                iaddr_in_img <= to_unsigned((row_dec + row_offset) * img_size + (col_dec + col_offset), iaddr_in_img'length);
                addr_in_img <= std_logic_vector(iaddr_in_img);
            when accu2 =>
                main_state <= accu3;
                -- read pixel 3 value and accumulate
                sum := sum + to_integer(unsigned(pixel_in));
                -- set pixel 5 address
                col_offset := 1;
                iaddr_in_img <= to_unsigned((row_dec + row_offset) * img_size + (col_dec + col_offset), iaddr_in_img'length);
                addr_in_img <= std_logic_vector(iaddr_in_img);
            when accu3 =>
                main_state <= accu4;
                -- read pixel 4 value and accumulate
                sum := sum + to_integer(unsigned(pixel_in));
                -- set pixel 6 address
                col_offset := -1;
                row_offset := 1;
                iaddr_in_img <= to_unsigned((row_dec + row_offset) * img_size + (col_dec + col_offset), iaddr_in_img'length);
                addr_in_img <= std_logic_vector(iaddr_in_img);
            when accu4 =>
                main_state <= accu5;
                -- read pixel 5 value and accumulate
                sum := sum + to_integer(unsigned(pixel_in));
                -- set pixel 7 address
                col_offset := 0;
                iaddr_in_img <= to_unsigned((row_dec + row_offset) * img_size + (col_dec + col_offset), iaddr_in_img'length);
                addr_in_img <= std_logic_vector(iaddr_in_img);
            when accu5 =>
                main_state <= accu6;
                -- read pixel 6 value and accumulate
                sum := sum + to_integer(unsigned(pixel_in));
                -- set pixel 8 address
                col_offset := 1;
                iaddr_in_img <= to_unsigned((row_dec + row_offset) * img_size + (col_dec + col_offset), iaddr_in_img'length);
                addr_in_img <= std_logic_vector(iaddr_in_img);
            when accu6 =>
                main_state <= accu7;
                -- read pixel 7 value and accumulate
                sum := sum + to_integer(unsigned(pixel_in));
            when accu7 =>
                main_state <= accu8;
                -- read pixel 8 value and accumulate
                sum := sum + to_integer(unsigned(pixel_in));
            when accu8 =>
                main_state <= div;
                -- divide value by 9
                dout_bram <= std_logic_vector(to_unsigned((sum / 9), dout_bram'length));
            when div =>
                main_state <= write;
                iaddr_out_img <= (to_integer(unsigned(row)) + row_offset) * img_size + (to_integer(unsigned(col)) + col_offset);
                pixel_out <= dout_bram;
            when write =>
                main_state <= idle;     
        end case;
    end if;

    
 end process;
 
end Behavioral;
