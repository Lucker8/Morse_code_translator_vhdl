library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package mem_pkg is
  type mem_array is array(31 downto 0) of std_logic_vector(7 downto 0);
end package;

library work;
use work.mem_pkg.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram_8by32 is
 generic(
    width: integer := 8; --Bits per word
    depth: integer := 32 --amount of words 
 );

 Port (
    DATA_IN: in std_logic_vector(7 downto 0);
    DATA_OUT: out std_logic_vector(7 downto 0);
    clk: in std_logic := '0';
    head_addr : integer; --pointer to address input
    tail_addr : integer; --pointer to address output
    memory : buffer mem_array:= (others => (others => '0')); -- intialize array, doesnt have to be a port, but port is used to view memory in upper components
    enable_in: in std_logic := '0'; --insert 8 bit data into input
    enable_out: in std_logic := '0' --extract 8 bit data and put into output
  );
end ram_8by32;


architecture Behavioral of ram_8by32 is
begin
    process(clk)
    begin
        if clk'event and clk = '1' and enable_in = '1' then -- input and rising edges
            memory(head_addr) <= DATA_IN;
            
        end if;
        
        if clk'event and clk = '1' and enable_out = '1' then -- output and rising edges
            
            DATA_OUT <= memory(tail_addr);
        end if;
    
    end process;


end Behavioral;

