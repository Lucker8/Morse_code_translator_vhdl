
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.mem_pkg.all;


entity fifo_8by32 is

 Port (
     data_in: in std_logic_vector(7 downto 0);
     data_out: out std_logic_vector(7 downto 0);
     clk: std_logic;
     enable_input: std_logic;
     enable_output: std_logic;
     full: out std_logic := '0';
     empty: out std_logic := '0';
     mem_check: buffer mem_array
  );
end fifo_8by32;


architecture Behavioral of fifo_8by32 is
    component ram_8by32
    Port (
    DATA_IN: in std_logic_vector(7 downto 0);
    DATA_OUT: out std_logic_vector(7 downto 0);
    clk: in std_logic := '0';
    head_addr : integer; --pointer to address input
    tail_addr : integer; --pointer to address output
    memory : buffer mem_array; -- intialize array
    enable_in: in std_logic := '0';
    enable_out: in std_logic := '0'
    );
    
    end component;
    
    signal head : integer:= 0;
    signal tail : integer:= 0;
    
    signal signal_data_in: std_logic_vector(7 downto 0);
    signal signal_data_out: std_logic_vector(7 downto 0);

    
begin
    ram : ram_8by32 port map(data_in, data_out, clk, head, tail, mem_check, enable_input, enable_output);
-------------------------------------------------------------------------------------------------------------
--INPUT
    process(clk)
    begin
        if clk'event and clk = '1' and enable_input = '1' then --only rising edges and input on
            
            if tail <= head then --If head leads or equal
                if head-tail = 31 then -- check if full
                    --do nothing
                    full <= '1'; --test bits
                else
                    full <= '0'; --test bits
                    --data_in; --insert data into fifo
                    if head = 31 then
                        head <= 0;
                        else 
                        head <= head+1;   
                    end if;
                end if;
            end if;
            
            if head < tail then --If tail leads
                if head+31-tail = 31 then -- check if full
                    --do nothing
                    full <= '1'; --test bits
                else
                    full <= '0'; --test bits
                    --data_in; --insert data into fifo
                    if head = 31 then --Increment until data limit, then loop around
                        head <= 0;
                        else 
                        head <= head+1;   
                    end if;
                end if;
            end if;
        end if;
    end process;        
        
-------------------------------------------------------------------------------------------------------------
--OUTPUT
    process(clk)
    begin
        if clk'event and clk = '1' and enable_output = '1' then --only rising edges and output      
            if tail <= head then --If head leads or equal
                if head-tail = 0 then -- check if empty
                    --do nothing
                    empty <= '1';
                else
                    empty <= '0';
                    --data_out <= signal_data_out; -- Output current ram data
                    if tail = 31 then
                        tail <= 0;
                    else
                        tail <= tail + 1;
                    end if;
                end if;
            end if;
            
            if head < tail then --If tail leads
                if head+31-tail = 0 then -- check if empty
                    --do nothing
                    empty <= '1';
                else
                    empty <= '0';
                    --data_out <= signal_data_out; -- Output current ram data
                    if tail = 31 then
                        tail <= 0;
                    else
                        tail <= tail + 1;
                    end if;
                end if;
            end if;  
        end if;     
    end process;


end Behavioral;
