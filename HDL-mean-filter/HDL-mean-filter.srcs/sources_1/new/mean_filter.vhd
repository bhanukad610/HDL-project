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
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mean_filter is
  Port ( row : in STD_LOGIC_VECTOR (3 downto 0);
           col : in STD_LOGIC_VECTOR (3 downto 0);
           size : in STD_LOGIC_VECTOR (3 downto 0);
           addr_in : out  STD_LOGIC_VECTOR (8 downto 0);
           pixel_in : in STD_LOGIC_VECTOR (7 downto 0);
           pixel_out :out STD_LOGIC_VECTOR (7 downto 0));
end mean_filter;

architecture Behavioral of mean_filter is

signal row_dec  : integer;
signal col_dec : integer;
signal size_dec : integer;




signal sum : integer;

signal row_offset : integer := -1;
signal col_offset : integer:= -1;
signal addr_int : integer;
signal dout_bram : STD_LOGIC_VECTOR (7 downto 0);
signal clock : STD_LOGIC_VECTOR (1 downto 0);

begin

row_dec <= to_integer(signed(row)) + 1;
col_dec <= to_integer(signed(col)) + 1;
size_dec <= to_integer(signed(size));

process
  begin
  if (row_offset = 1 and col_offset = 1) then
        addr_int <= (col_dec + col_offset) * size_dec + (row_dec + row_offset);
        addr_in <= std_logic_vector(to_unsigned(addr_int, addr_in'length));
        dout_bram <= pixel_in;
        sum <= sum + to_integer(signed(dout_bram));
        col_offset <= col_offset + 1;
        if col_offset = 1 then
            col_offset <= -1;
            row_offset <= row_offset + 1;
        end if;
  end if;
  sum <= sum / 9;
 end process;
 
end Behavioral;
