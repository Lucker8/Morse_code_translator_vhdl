
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pulse_stable_conversion is
  Port ( 
    input: in std_logic_vector (7 downto 0):= "00000000";
    output: out std_logic_vector (7 downto 0);
    new_output: out std_logic := '0';
    clk: in std_logic;
    clr: in std_logic := '0';
    spacebar: in std_logic := '0'
    
  );
end pulse_stable_conversion;

architecture Behavioral of pulse_stable_conversion is
     
     
     component task1 --debouncer 
        port(
            button : in std_logic;
            clk : in std_logic;
            result : out std_logic
        );
    end component;
    
    signal clrflag1: std_logic := '0';
    signal de_clr: std_logic := '0';
    
    signal spaceflag1: std_logic := '0';
    signal de_space: std_logic := '0';
    
begin
    debounce_clr: task1 port map(
        button => clr,
        clk => clk,
        result => de_clr
    );
    
    debounce_space: task1 port map(
        button => spacebar,
        clk => clk,
        result => de_space
    );
    


    process(clk)
    begin
        if clk'event and clk = '1' then --every rising edge
        
            if input = "00000000" then
            
                if de_clr = '1' and clrflag1 = '0' then
                    output <= "11111111";
                    new_output <= '1';
                    clrflag1 <= '1';
                
                elsif de_space = '1' and spaceflag1 = '0' then
                    output <= "00100000";
                    new_output <= '1';
                    spaceflag1 <= '1';      
                else
                    --do nothing
                    new_output <= '0';
                end if;
      
                
            elsif clrflag1 = '1' then
                --do nothing
                new_output <= '0';
           
           elsif spaceflag1 = '1' then
                --do nothing
                new_output <= '0';
    
            else
                output <= input;
                new_output <= '1';
            end if;
            
            ------------------------------clear flags
            
            if de_space = '0' and spaceflag1 = '1' then
                spaceflag1 <= '0';
            end if;
            
            if de_clr = '0' and clrflag1 = '1' then
                clrflag1 <= '0';
            end if;
            
        end if;
    end process;

end Behavioral;
