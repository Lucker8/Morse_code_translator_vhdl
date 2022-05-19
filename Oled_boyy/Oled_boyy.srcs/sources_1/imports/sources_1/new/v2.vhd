----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2022 03:34:43 PM
-- Design Name: 
-- Module Name: v2 - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity v2 is
 Port (
        --i: buffer std_logic_vector(0 to 15):="1011101110111000";
        b1: in std_logic;
        i: in std_logic:='0'; --i for input from adc
        clk: in std_logic;
        out_v: buffer std_logic_vector(0 to 5):=(others=>'0');--:=(others=>'0');
        o_f,n_w: buffer std_logic:='0';
        
        nothing: buffer bit:='1'
        
         );
end v2;

architecture Behavioral of v2 is
type ar is array(0 to 0) of std_logic;

signal count,d_f: integer:=0;
signal index: integer range 0 to 4:=0;
signal prev_s,dah_f,suck_me,f_c,dd_f: std_logic:='0';
signal a1: ar;
signal temp_o: std_logic_vector(0 to 5):=(others=>'0');
begin

counter : process(clk)
    begin
        if (rising_edge(clk)) then
            if(suck_me='1') then
                case index is
                    when 0=>    
                     when 1=>
                          temp_o<= (0=>temp_o(0),others=>'0');   
                     when 2=>   
                          temp_o<=temp_o(0 to 1)&"0001";
                     when 3=>
                          temp_o<=temp_o(0 to 2)&"010";
                     when 4=>
                          temp_o<=temp_o(0 to 3)&"11";
                     end case; 
                
                --temp_o <= (others => '0');
                suck_me <= '0'; --vector rdy
                f_c<='1';
               
            
            end if;
            
            if(suck_me = '0' and f_c = '1') then
                out_v<= temp_o;
                index<=0;
                o_f <= '1'; --output set
                f_c<= '0';
            end if;
            if(o_f = '1' and f_c = '0') then
                temp_o<=(others=>'0');
                o_f <= '0'; --temp reset
            end if;
            
            if(count > 1230000000 and b1='1') then
                count<=0;
                n_w<='1';
                --b1 <= '0';
                if(d_f>0) then
                if(dah_f = '0') then
                    --it's a dit
                    temp_o(index)<= '0';
                    --out_v<=temp_o;
                   index<=index+1;       
                elsif(dah_f = '1') then
                    --suck_me<='1';
                    --it's a dah
                    temp_o(index)<='1';
                    --out_v<=temp_o;
                    dah_f<='0';
                    index<=index+1;       
                end if;       
                suck_me<='1';
                end if;
            else
                n_w<='0'; 
            end if;
            if (b1 = '0' or o_f = '0') then --or o_f = '0' for test
                
                nothing <= '1';
            else
                nothing <= '0';
            end if;
            if (prev_s = i) then
                count <= count + 1;
                prev_s <= i;
            else
                if prev_s = '1' then --if it was constant 1 before
                
                    if (count>7000000 and count<12000000) then --count > x"6ACFC0" and count < x"B71B00" then --if count is more than 70 ms and less than 120ms
                        -- it's a dit
                        dah_f <= '0';
                        d_f<= d_f + 1; --the session started
                    elsif (count > 28000000) then--x"2255100" then -- if its more than ~3 times dit time
                        dah_f <= '1';
                        d_f<= d_f + 1;
                        -- it's a dah
                    
                    end if;
                    --maybe if it's nothing pick the closest?
                elsif(d_f > 0) then --it was a constant 0
                
                    if(count>7000000 and count < 12000000) then   --if count is more than 70 ms and less than 120ms ##1unit     and count < 12000000
                        --it's a new boolean (dit|dah)
                        --suck_me<='1';
                        if(dah_f = '0') then
                            --it's a dit
                            temp_o(index)<='0';
                            index<= index+1;
                                                        
                        elsif(dah_f = '1') then
                            --it's a dah
                            temp_o(index)<='1';
                            dah_f<='0'; 
                            index<= index+1;                      
                        end if;
                        
                        
                    elsif(count > 28000000  and count < 41000000 ) then -- if count is more than 360ms and less than 410ms ##3 units
                        --it's a new letter
                        --somehting with index
                        
                        if(dah_f = '0') then
                            --it's a dit
                            temp_o(index)<= '0';
                            --out_v<=temp_o;
                            index<=index+1;       
                        elsif(dah_f = '1') then
                            --suck_me<='1';
                            --it's a dah
                            temp_o(index)<='1';
                            --out_v<=temp_o;
                            dah_f<='0';
                            index<=index+1;       
                        end if;  
                       
                         suck_me<='1';
                         --out_v<= temp_o;
                         --temp_o <= (others => '0');
                         --index<= 0;
                    elsif(count > 123000000) then --count is 3* 410 ms## 9 units
                         --it's a new word
                         --n_w<='1';       
                    end if;
                    --d_f <= 0;
                    count<=0; --reset the edge counter
                    prev_s<=i;
                
                end if; --const 0
                count<=0; --reset the edge counter
                prev_s<=i;
           end if; --changed
    
        
         
     end if; --rising edge
     
end process counter;

end Behavioral;
