----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Suck My Kurt
-- 
-- Create Date: 09.05.2022 09:34:18
-- Design Name: 
-- Module Name: translation_interface - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 6.90
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

entity pulse_stable_conversion is
  Port ( 
    input: in std_logic_vector (7 downto 0):= "00000000";
    output: out std_logic_vector (7 downto 0);
    new_output: out std_logic := '0';
    clk: in std_logic
  );
end pulse_stable_conversion;

architecture Behavioral of pulse_stable_conversion is
begin
    process(clk)
    begin
        if clk'event and clk = '1' then --every rising edge
            if input = "00000000" then
                --do nothing
                new_output <= '0';
            else
                output <= input;
                new_output <= '1';
            end if;
            
            
        end if;
    end process;

end Behavioral;
