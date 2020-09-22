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

entity scheduler2 is
    Generic (row_n_width : INTEGER := 4);

    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           init_process : in STD_LOGIC;
           finish_flag_single_op : in STD_LOGIC;
           
           init_single_op : out STD_LOGIC := '0';
           finish_flag_process : out STD_LOGIC := '0';
           row : out STD_LOGIC_VECTOR (row_n_width downto 0) := (others => '0');
           column : out STD_LOGIC_VECTOR (row_n_width downto 0) := (others => '0'));
end scheduler2;

architecture Behavioral of scheduler2 is
    type SCHEDULER_STATE is (idle, busy, done);
    signal schdlr_stat : SCHEDULER_STATE;
    
    type OP_STATE is (idle, init0, init1, operating, done);
    signal op_stat : OP_STATE;    

    shared variable irow : integer range 0 to 16 := 0;
    shared variable icolumn : integer range 0 to 16 := 0;
begin

scheduling: process (clk, reset, init_process, finish_flag_single_op)
begin

if (reset = '1') then
    schdlr_stat <= idle;
    op_stat <= idle;
    irow := 0;
    icolumn := 0;
    row <= (others => '0');
    column <= (others => '0');
    finish_flag_process <= '0'; 
elsif (clk'event and clk = '1') then
    case schdlr_stat is
        when idle =>
            if (init_process = '1') then
                schdlr_stat <= busy;
                irow := 0;
                icolumn := 0;
                op_stat <= idle;
            end if;
        when busy =>
            if (irow > 15) then
               schdlr_stat <= done;
            else
                case op_stat is
                    when idle =>
                        row <= std_logic_vector(to_unsigned(irow, row'length));
                        column <= std_logic_vector(to_unsigned(icolumn, column'length));
                        op_stat <= init0;
                    when init0 =>
                        init_single_op <= '1';
                        op_stat <= init1;
                    when init1 =>
                        init_single_op <= '0';
                        op_stat <= operating;
                    when operating =>
                        if (finish_flag_single_op = '1') then
                           op_stat <= done; 
                        end if;
                    when done =>
                        if (icolumn > 14) then
                            icolumn := 0;
                            irow := irow + 1;
                        else
                            icolumn := icolumn + 1;                            
                        end if;
                        op_stat <= idle;
                end case;
            end if;
        when done =>
            finish_flag_process <= '1';
    end case;
end if;

end process scheduling;

end Behavioral;
