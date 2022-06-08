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
        --inp: in std_logic:='0';
        b1: in std_logic;
        i: in std_logic:='0'; --i for input from adc
        clk: in std_logic;
        out_v: buffer std_logic_vector(0 to 5):=(others=>'0');--:=(others=>'0');
        o_f,n_w,new_word: buffer std_logic:='0';
        
        nothing: buffer bit:='1'
        
         );
end v2;

architecture Behavioral of v2 is

signal count,d_f: integer:=0;
signal index: integer range 0 to 4:=0;
signal prev_s,dah_f,translate,f_c,dd_f: std_logic:='0';
signal temp_o: std_logic_vector(0 to 5):=(others=>'0');
begin

counter : process(clk)
    begin
        if (rising_edge(clk)) then
            if(translate='1') then
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
                
          
                translate <= '0'; --vector rdy
                f_c<='1';
                new_word <= '0';
               
            
            end if;
            
            if(translate = '0' and f_c = '1') then
                out_v<= temp_o;
                index<=0;
                o_f <= '1'; --output set
                f_c<= '0';
            end if;
            if(o_f = '1' and f_c = '0') then
                temp_o<=(others=>'0');
                o_f <= '0'; 
            end if;
            
            if(count > 410000000 and b1='1') then
                count<=0;
                n_w<='1';
                if(d_f>0) then
                if(dah_f = '0') then
                    --it's a dit
                    temp_o(index)<= '0';
                   index<=index+1;       
                elsif(dah_f = '1') then
                    --it's a dah
                    temp_o(index)<='1';
                    dah_f<='0';
                    index<=index+1;       
                end if;       
                translate<='1';
                end if;
            else
                n_w<='0'; 
            end if;
            if (b1 = '0' or o_f = '0') then 
                
                nothing <= '1';
            else
                
                nothing <= '0';
            end if;
            if (prev_s = i ) then 
                count <= count + 1;
                prev_s <= i;
            else 
                if prev_s = '1' then --if it was constant 1 before
                
                    if (count>7000000 and count < 22000000) then --if count is more than 70 ms and less than 220ms
                        -- it's a dit
                        dah_f <= '0';
                        d_f<= d_f + 1; --the session started
                    elsif (count > 22000000) then -- if its more than ~3 times dit time
                        dah_f <= '1';
                        d_f<= d_f + 1;
                        -- it's a dah
                    
                    end if;
                elsif(d_f > 0) then --it was a constant 0
                
                    if(count>5000000 and count < 20000000) then   --if count is more than 70 ms and less than 120ms ##1unit     and count < 12000000
                        --it's a new boolean (dit|dah)
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
                        
                        
                    elsif(count > 24000000  and count < 56000000 ) then -- if count is more than 360ms and less than 410ms ##3 units
                        --it's a new letter                        
                        if(dah_f = '0') then
                            --it's a dit
                            temp_o(index)<= '0';
                            index<=index+1;       
                        elsif(dah_f = '1') then
                            --it's a dah
                            temp_o(index)<='1';
                            dah_f<='0';
                            index<=index+1;       
                        end if;  
                       
                         translate<='1';
                    elsif(count > 58000000 and count < 100000000  ) then --count is 7*100 ms## 7 units
                         --it's a new word
                         new_word <= '1';
                         if(dah_f = '0') then
                            --it's a dit
                            temp_o(index)<= '0';
                            index<=index+1;       
                         elsif(dah_f = '1') then
                            --it's a dah
                            temp_o(index)<='1';
                            --out_v<=temp_o;
                            dah_f<='0';
                            index<=index+1;       
                         end if;  
                       
                         translate<='1';      
                    end if;
                    d_f <= 0;
                    count<=0; --reset the edge counter
                    prev_s<=i;
                
                end if; --const 0
                count<=0; --reset the edge counter
                prev_s<=i;
           end if; --changed
    
        
         
     end if; --rising edge
     
end process counter;

end Behavioral;
