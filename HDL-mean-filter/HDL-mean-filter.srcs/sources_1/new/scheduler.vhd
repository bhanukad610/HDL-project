----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/29/2020 06:52:27 AM
-- Design Name: 
-- Module Name: counter - Behavioral
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
use IEEE.numeric_std.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity scheduler is
    Generic (row_n_width : INTEGER := 4);

    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           init_process : in STD_LOGIC;
           finish_flag_single_op : in STD_LOGIC;
           
           init_single_op : out STD_LOGIC := '0';
           finish_flag_process : out STD_LOGIC := '0';
           row : out STD_LOGIC_VECTOR (row_n_width downto 0) := (others => '0');
           column : out STD_LOGIC_VECTOR (row_n_width downto 0) := (others => '0'));
end scheduler;

architecture Behavioral of scheduler is
    shared variable irow : integer range 0 to 16 := 0;
    shared variable icolumn : integer range 0 to 16 := 0;
    shared variable scheduler_busy : boolean := false;
    -- constant high_time : time := 25 ns;
    shared variable counter : integer range 0 to 2 := 0;
    shared variable init_single_op_status : boolean := False;
begin

scheduling: process (clk, reset, init_process, finish_flag_single_op)
begin
	if reset = '1' then
	   scheduler_busy := false;
	   irow := 0;
	   icolumn := 0;
	   row  <= std_logic_vector(to_unsigned(irow, row'length));
	   column  <= std_logic_vector(to_unsigned(icolumn, column'length));
	   init_single_op <= '0';
	   finish_flag_process <= '0';
	   counter := 0;
	   init_single_op_status := False;
	end if;
	
	if (init_single_op_status = True) then
	   if (counter > 1) then
	       init_single_op <= '0';
	       init_single_op_status := False;
	       counter := 0;
	   else
	       counter := counter + 1;
	   end if;
	end if;
	
	if rising_edge(clk) and init_process = '1' then
	   scheduler_busy := true;
	   row  <= std_logic_vector(to_unsigned(irow, row'length));
	   column  <= std_logic_vector(to_unsigned(icolumn, column'length));
	   init_single_op <= '1';
	   init_single_op_status := True;
	end if;
	
	if rising_edge(clk) and scheduler_busy = true and finish_flag_single_op = '1' then
	   if icolumn > 14 and irow > 14 then
           scheduler_busy := false;
           irow := 0;
           icolumn := 0;
           row  <= std_logic_vector(to_unsigned(irow, row'length));
           column  <= std_logic_vector(to_unsigned(icolumn, column'length));
	       finish_flag_process <= '1';
	   elsif icolumn > 14 and irow < 15 then
           irow := irow + 1 ;
           icolumn := 0;
           row  <= std_logic_vector(to_unsigned(irow, row'length));
           column  <= std_logic_vector(to_unsigned(icolumn, column'length));
           init_single_op <= '1';
           init_single_op_status := True;
        else
           icolumn := icolumn + 1;
           row  <= std_logic_vector(to_unsigned(irow, row'length));
           column  <= std_logic_vector(to_unsigned(icolumn, column'length));
           init_single_op <= '1';
           init_single_op_status := True;
	   end if;
	end if;
end process scheduling;

end Behavioral;
