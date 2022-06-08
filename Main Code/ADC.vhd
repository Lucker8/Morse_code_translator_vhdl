----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2022 09:04:56 AM
-- Design Name: 
-- Module Name: adcinput - Behavioral
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
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dit_dah is
  Port (clk : in std_logic;
        ADC_D1 : in std_logic;
        ADC_CS : out std_logic;
        ADC_SCLK : out std_logic;
        set_button : in std_logic;
        sout : inout std_logic;
        sout1 : out std_logic
        );
end dit_dah;

architecture Behavioral of dit_dah is

component pmod_adc
    Port ( clk : in  STD_LOGIC;
           ADC_CS : out  STD_LOGIC;
           ADC_SCLK : out  STD_LOGIC;
           ADC_D1 : in  STD_LOGIC;
           flag1 : out std_logic;
           leds : out STD_LOGIC_VECTOR(11 downto 0)
           );
end component;

component debouncer
port (clk : in std_logic;
    button : in std_logic;
    result : out std_logic);
end component;

component signal_debouncer
port (clk : in std_logic;
    button : in std_logic;
    result : out std_logic);
end component;

signal b1_set : std_logic;
signal temp : std_logic_vector(11 downto 0);
signal data : std_logic_vector(11 downto 0);
signal temp2 : std_logic_vector(11 downto 0);
signal counter : std_logic_vector(27 downto 0);
signal flag1 : std_logic;
signal cali1 : std_logic_vector(11 downto 0);
signal cali2 : std_logic_vector(11 downto 0);
signal cali3 : std_logic_vector(11 downto 0);
signal sum : std_logic_vector(13 downto 0);
signal result : std_logic_vector(11 downto 0);

begin
pmod_adc1 : pmod_adc port map(clk => clk, leds => data, ADC_D1 => ADC_D1, ADC_CS => ADC_CS, ADC_SCLK => ADC_SCLK, flag1 => flag1);
debouncer1 : debouncer port map(clk => clk, button => set_button, result => b1_set);
signal_debouncer1 : signal_debouncer port map(clk => clk, button => sout, result => sout1);
calibrate : process(b1_set, clk)
begin
--if(rising_edge(flag1)) then
--    if (b1_set = '1') then
--        temp(11 downto 0) <= data(11 downto 0);
--    end if;
--end if;
if (flag1 = '1') then
    if (rising_edge(clk)) then
        counter <= counter + x"1";
    end if;
end if;
    if (counter(5) = '1') then
                cali1(11 downto 0) <= data(11 downto 0);
            elsif (counter(20) = '1') then
                cali2(11 downto 0) <= data(11 downto 0);
            elsif (counter(22) = '1') then
                cali3(11 downto 0) <= data(11 downto 0);
            elsif (counter(27) = '1') then
                temp(11 downto 0) <= data(11 downto 0);
end if;
if (rising_edge(b1_set)) then
    sum(11 downto 0) <= temp(11 downto 0) + cali1(11 downto 0) + cali2(11 downto 0) + cali3(11 downto 0);
    result <= sum(13 downto 2) + sum(1);
end if;
end process calibrate;
main : process(clk, data, temp)
begin
if (rising_edge(flag1)) then 
    temp2 <= data;
    if (temp2 > result) then
        sout <= '1';
        elsif (result > temp2) then
            sout <= '0';
        elsif (temp2 = result) then
            sout <= '0';
    end if;
end if;
end process main;
end Behavioral;
