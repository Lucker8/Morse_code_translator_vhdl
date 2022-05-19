----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/19/2022 10:47:43 AM
-- Design Name: 
-- Module Name: mejn - Behavioral
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

entity mejn is
  Port (
            --inp         : in std_logic:='0'; 
            clk         : in std_logic;
            oled_sdin   : out std_logic;
            oled_sclk   : out std_logic;
            oled_dc     : out std_logic;
            oled_res    : out std_logic;
            oled_vbat   : out std_logic;
            oled_vdd    : out std_logic;
            adc_d1: in std_logic; --adc d1
            pin_adc: out std_logic_vector(1 downto 0); --adc_cs, adc_sclk
            c_btn: in std_logic; --calibration button
            c_led: inout std_logic; --calibration led
            b_s: in std_logic; --start button
            rst        : in std_logic --Print screen
            
  );
end mejn;

architecture Behavioral of mejn is

component fifo_oled_connection

 port (    clkC         : in std_logic;
            oled_sdinC   : out std_logic;
            oled_sclkC   : out std_logic;
            oled_dcC     : out std_logic;
            oled_resC    : out std_logic;
            oled_vbatC   : out std_logic;
            oled_vddC    : out std_logic;       
            rstC         : in std_logic; --Print screen
            inputC       : in std_logic_vector (7 downto 0); -- data input
            fifo_to_oled : inout std_logic_vector (7 downto 0)
            );
end component;

component translation_interface

Port ( 
    --inp         : in std_logic:='0';
    adc_d1: in std_logic; --adc d1
    pin_adc: out std_logic_vector(1 downto 0); --adc_cs, adc_sclk
    c_btn: in std_logic; --calibration button
    c_led: inout std_logic; --calibration led
    output: out std_logic_vector(7 downto 0):=(others=>'0'); --ascii
    clk: in std_logic;
    b: in std_logic
  
  );
  
end component;
signal input_to_fifo   : std_logic_vector (7 downto 0):=(others=>'0'); -- data input
signal fifo_2_oled : std_logic_vector (7 downto 0);

begin

ti: translation_interface port map(adc_d1,pin_adc,c_btn,c_led,input_to_fifo,clk,b_s);
fifo_oled: fifo_oled_connection port map(clk, oled_sdin ,oled_sclk ,oled_dc ,oled_res ,oled_vbat ,oled_vdd,rst , input_to_fifo, fifo_2_oled);

end Behavioral;
