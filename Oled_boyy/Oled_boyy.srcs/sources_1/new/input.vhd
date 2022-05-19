----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/11/2022 12:00:15 PM
-- Design Name: 
-- Module Name: input - Behavioral
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

entity input_part is
  Port ( 
  input     : in std_logic_vector (7 downto 0);
  btn       : in std_logic;
  clk       : in std_logic;
  output    : out std_logic_vector (7 downto 0) 
  );
  
end input_part;

architecture Behavioral of input_part is

begin

bnutton: process (btn,clk)
    begin
        if btn ='1' then
            for j in 0 to 15 loop
                   output(j) <= input(j);
            end loop;
        end if;
    end process;

end Behavioral;
