----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2022 11:20:22 AM
-- Design Name: 
-- Module Name: counterSm - Behavioral
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

entity counterSm is
  Port (
         clk,rst: in std_logic;
         i: in std_logic;
         a_o,b_o: out integer:=0 
         
   );
end counterSm;

architecture Behavioral of counterSm is

type state_type is (s,s0, s1, s2);

signal index,a,b: integer:=0;
signal temp: unsigned(0 downto 0);
signal state: state_type;


begin

    process(clk)
    begin
        if rst = '1' then 
            state <= s;
        elsif (rising_edge(clk)) then
            case state is
                when s=>
                    state<=s0;
                when s0=>
                    if (i='1') then
                        state<=s0;
                    else
                        state<=s1;
                    end if;
                when s1=>
                    if(i = '1') then
                        state <= s2;
                    else
                        state <= s1;
                    end if;
               when s2 =>
                    state<=s0;
            end case;
         end if;
    end process;
                    
     process(state,clk,i)
     begin
     if(rising_edge(clk)) then
        case state is
            when s=>
            
            when s0=>
                a<=a+1;
            when s1=>
                b<=b+1;
            when s2 =>
                a_o<=a;
                b_o<=b;
                a<=0;
                b<=0;    
        end case;
    end if;

    end process;

end Behavioral;



if(index = 0) then
                            if(dah_f = '0') then
                            --it's a dit
                                temp_o<= (others=>'0');
                                out_v<=temp_o;
                                                        
                            elsif(dah_f = '1') then
                            --it's a dah
                                temp_o(0)<='1';
                                out_v<=temp_o;  
                                dah_f<='0';  
                                                   
                            end if;
 
                         elsif(index=1) then
                             temp_o<= (0=>temp_o(0),others=>'0');--temp_o(0)&"00000"; --size 1 =00
                         elsif(index=2) then
                             temp_o<=temp_o(0 to 1)&"0001"; --size 2=01
                         elsif(index=3) then
                             temp_o<=temp_o(0 to 2)&"010"; --size 3=10
                         elsif(index>=4) then
                             temp_o<=temp_o(0 to 3)&"11"; --size 4=11
                         end if;