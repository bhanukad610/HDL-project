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
  Port ( row : in STD_LOGIC_VECTOR (4 downto 0);
           col : in STD_LOGIC_VECTOR (4 downto 0);           
           addr_in : out  STD_LOGIC_VECTOR (8 downto 0);
           addr_in_img : in  STD_LOGIC_VECTOR (8 downto 0);
           addr_out_img : out  STD_LOGIC_VECTOR (8 downto 0);
           pixel_in : in STD_LOGIC_VECTOR (7 downto 0);
           pixel_out :out STD_LOGIC_VECTOR (7 downto 0);
           clk  : in STD_LOGIC;
           reset_in :in STD_LOGIC);
end mean_filter;

architecture Behavioral of mean_filter is

signal row_dec  : integer;
signal col_dec : integer;

signal addr_int : integer;
signal dout_bram : STD_LOGIC_VECTOR (7 downto 0);
signal clock : STD_LOGIC_VECTOR (1 downto 0);

begin

row_dec <= to_integer(signed(row)) + 1;
col_dec <= to_integer(signed(col)) + 1;

 convolve : process ( clk )
    constant size : INTEGER := 16;
    variable sum : INTEGER;
    variable row_offset : INTEGER := -1;
    variable col_offset : INTEGER:= -1;
    variable ctrl_tick_v    : INTEGER := 0;
    
    
    begin
    if (reset_in = '1') then
        sum := 0;
        ctrl_tick_v  := 0;
      
    if (row_offset /= 1 and col_offset /= 1) then
        addr_int <= (col_dec + col_offset) * size + (row_dec + row_offset);
        addr_in <= std_logic_vector(to_unsigned(addr_int, addr_in'length));
    
        if ( clk 'event and clk = '1' ) then
            if (ctrl_tick_v=0 or ctrl_tick_v=1) then  -- behavior in the first 2 ticks.
                ctrl_tick_v:=ctrl_tick_v+1;
            elsif ctrl_tick_v=2 then
                dout_bram <= pixel_in;
                sum := sum + to_integer(signed(dout_bram));
                col_offset := col_offset + 1;
                
                if col_offset = 1 then
                    col_offset := -1;
                    row_offset := row_offset + 1;
                end if;
     if (row_offset = 1 and col_offset = 1) then
          sum := sum / 9;
          addr_out_img <= std_logic_vector(to_unsigned(sum, addr_out_img'length));
          pixel_out <= std_logic_vector(to_unsigned(sum, pixel_out'length));   
        end if;
        end if;
    end if;
    end if;
    end if;
    
 end process;
 
end Behavioral;
