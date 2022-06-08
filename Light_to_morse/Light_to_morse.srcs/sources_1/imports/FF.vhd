----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2022 11:14:25 AM
-- Design Name: 
-- Module Name: FF - Behavioral
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


Library IEEE;
USE IEEE.Std_logic_1164.all;

entity FF is 
   port(
      Q : out std_logic;    
      clk :in std_logic;   
      D :in  std_logic    
   );
end FF;
architecture Behavioral of FF is  
begin  
 process(clk)
 begin 
    if(rising_edge(clk)) then
   Q <= D; 
    end if;       
 end process;  
end Behavioral; 
