----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2022 11:11:25 AM
-- Design Name: 
-- Module Name: task1 - Behavioral
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
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity task1 is
  port (button : in std_logic;
        clk : in std_logic;
        result : out std_logic
        );
end task1;

architecture Behavioral of task1 is
    component FF
    port (clk : in std_logic;
        D : in std_logic;
        Q : out std_logic);
    end component;

    signal Q1, Q2 : std_logic;
    signal SCLR : std_logic;
    signal c1 : std_logic;
    signal temp : std_logic;
    signal count1 : std_logic;
    signal count : std_logic_vector (21 downto 0) := (others=>'0');
    signal enable : std_logic;
    
begin
FF1 : FF port map (clk => clk, D => button, Q => Q1);
FF2 : FF port map (clk => clk, D => Q1, Q => Q2);
FF3 : FF port map (clk => temp, D => Q2, Q => result);
process (clk, SCLR) begin
if (SCLR = '1') then
            count <= (others=>'0');
            count1 <= '0';
        elsif (rising_edge(clk)) then
            if (enable = '1') then
                count <= count + x"1";
                --count1 <= count(7);
            end if;
        end if;
SCLR <= Q1 xor Q2;
temp <= clk and c1;
count1 <= count(21);
c1 <= count1;
enable <= not(c1);
end process;
end Behavioral;
