library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity timer_variable is
    Port (
    zedboard_clk: in std_logic;
    enable: in std_logic;
    reset: in std_logic;
    timerOutput: out std_logic
     );
end timer_variable;

architecture Behavioral of timer_variable is
    signal timer_value: integer := 0;
begin
    process(zedboard_clk)
    begin
        if zedboard_clk'event and zedboard_clk = '1' and enable = '1' then -- rising edges         
            
            
            --set when to overflow, time/10ns
            if timer_value = 100000 then --10ms/10ns = 1000000
                timerOutput <= '1';
                timer_value <= 0;
            else
                timerOutput <= '0';
                timer_value <= timer_value + 1; -- increment timer 
            end if;
            
            if reset = '1' then
                timer_value <= 0;
            end if;
            
        end if;
    end process;
    
end Behavioral;

