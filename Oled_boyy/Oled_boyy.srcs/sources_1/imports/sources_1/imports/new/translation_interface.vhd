library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity translation_interface is
  Port ( 
    --i: buffer std_logic:='0';
    inp: in std_logic:='0';

    adc_d1: in std_logic; --adc d1
    pin_adc: out std_logic_vector(1 downto 0); --adc_cs, adc_sclk
    c_btn: in std_logic; --calibration button
    c_led: inout std_logic; --calibration led
    --input: in std_logic_vector(0 to 5); --dit_dah_size vector
    output: out std_logic_vector(7 downto 0):=(others=>'0'); --ascii
    clk: in std_logic;
    b: in std_logic
  
  );
end translation_interface;

architecture Behavioral of translation_interface is

component dit_dah
Port (clk : in std_logic;
        ADC_D1 : in std_logic;
        ADC_CS : out std_logic;
        ADC_SCLK : out std_logic;
        set_button : in std_logic;
        sout : inout std_logic;
        sout1 : out std_logic
        );
end component;

component v2
 Port (
        --i: buffer std_logic_vector(0 to 15):="1011101110111000";
        b1: in std_logic;
        i: in std_logic:='0'; --i for input from adc
        clk: in std_logic;
        out_v: buffer std_logic_vector(0 to 5):=(others=>'0');--:=(others=>'0');
        o_f,n_w,new_word: buffer std_logic;
        nothing: buffer bit:='1'
         );
end component;

signal n_wf, b_f ,o_f ,new_word: std_logic:='0';
signal nothing: bit:='1';
signal sout1 : std_logic;
signal input:  std_logic_vector(0 to 5);
signal new_word_temp: std_logic_vector(0 to 1);
begin

dit_in: dit_dah port map(clk,adc_d1,pin_adc(0),pin_adc(1),c_btn,c_led,sout1);
dit: v2 port map(b_f,inp ,clk ,input ,o_f,n_wf,new_word,nothing);


process(clk)
    begin
        if rising_edge(clk) then --only rising edges
        
        if(b='1') then
            b_f <= '1';
       
        --elsif (n_wf = '1') then
           -- b_f<='0';
         end if;
        if(new_word = '1') then
            --output <= "00100000";
            new_word_temp(0)<='1';
        end if;
        if(new_word_temp(1) <= '1') then
            output <= "00100000";
            new_word_temp(1) <= '0';    
        end if;
        
        if(nothing = '1') then --not started yet
            output<=(others=>'0');
        else    
                if(new_word_temp(0) <= '1') then
                    new_word_temp(1)<='1';
                    new_word_temp(0)<='0';
                end if;
                if input(4 to 5) = "00" then --check first 2 bits, 1 sign
                    
                    if input(0) = '0' then -- E
                        output <= "01000101";
                    end if;
                    if input(0) = '1' then -- T
                        output <= "01010100";
                    end if;    
                                   
                end if;
                
                if input(4 to 5) = "01" then --check first 2 bits, 2 signs
                    
                    if input(0 to 1) = "00" then -- I
                        output <= "01001001";
                    end if;
                    
                    if input(0 to 1) = "01" then -- A
                        output <= "01000001";
                    end if;
                    
                    if input(0 to 1) = "10" then -- N
                        output <= "01001110";
                    end if;
                    
                    if input(0 to 1) = "11" then -- M
                        output <= "01001101";
                    end if;
                                       
                end if;
                
                if input(4 to 5) = "10" then --check first 2 bits, 3 signs
                
                    if input(0 to 2) = "000" then -- S
                        output <= "01010011";
                    end if;
                    
                    if input(0 to 2) = "001" then -- U
                        output <= "01010101";
                    end if;
                    
                    if input(0 to 2) = "010" then -- R
                        output <= "01010010";
                    end if;
                    
                    if input(0 to 2) = "011" then -- W
                        output <= "01010111";
                    end if;
                    
                    if input(0 to 2) = "100" then -- D
                        output <= "01000100";
                    end if;
                    
                    if input(0 to 2) = "101" then -- K
                        output <= "01001011";
                    end if;
                    
                    if input(0 to 2) = "110" then -- G
                        output <= "01000111";
                    end if;
                    
                    if input(0 to 2) = "111" then -- O
                        output <= "01001111";
                    end if;
                      
                end if;
                
                if input(4 to 5) = "11" then --check first 2 bits, 4 signs
                    if input(0 to 3) = "0000" then -- H
                        output <= "01001000";
                    end if;
                    
                    if input(0 to 3) = "0001" then -- V
                        output <= "01010110";
                    end if;
                    
                    if input(0 to 3) = "0010" then -- F
                        output <= "01000110";
                    end if;
                    
                    if input(0 to 3) = "0100" then -- L
                        output <= "01010110";
                    end if;
                    
                    if input(0 to 3) = "0110" then -- P
                        output <= "01010000";
                    end if;
                    
                    if input(0 to 3) = "0111" then -- J
                        output <= "01001010";
                    end if;
                    
                    if input(0 to 3) = "1000" then -- B
                        output <= "01000010";
                    end if;
                    
                    if input(0 to 3) = "1001" then -- X
                        output <= "01011000";
                    end if;
                    
                    if input(0 to 3) = "1010" then -- C
                        output <= "01000011";
                    end if;
                    
                    if input(0 to 3) = "1011" then -- Y
                        output <= "01011001";
                    end if;
                    
                    if input(0 to 3) = "1100" then -- Z
                        output <= "01011010";
                    end if;
                    
                    if input(0 to 3) = "1101" then -- Q
                        output <= "01010001";
                    end if;
    
                end if;
                
           end if; 
        end if;
    end process;
end Behavioral;
