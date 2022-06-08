library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.mem_pkg.all;


entity fifo_w_signal_control is

 Port (
     data_in: in std_logic_vector(7 downto 0) := "00000000" ;
     data_out: out std_logic_vector(7 downto 0):= "00000000" ;
     clk: std_logic;
     enable_input: std_logic := '0';
     enable_output: std_logic := '0';
     full: out std_logic := '0';
     empty: out std_logic := '0';
     mem_check: buffer mem_array := (others => (others => '0'));
     head : buffer integer:= 0;
     tail : buffer integer:= 0
  );
end fifo_w_signal_control;


architecture Behavioral of fifo_w_signal_control is
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
    
    component task1
        port (
            button : in std_logic;
            clk : in std_logic;
            result : out std_logic
        ); 
    end component;
    --signal full: std_logic := '0';
    --signal empty: std_logic := '0';
    
    --signal head : integer:= 0;
    --signal tail : integer:= 0;
    
    signal input_de: std_logic := '0';
    signal inputflag1: std_logic := '0';
    signal inputflag2: std_logic := '0';
    signal inputsignal: std_logic := '0';
    
    signal output_de: std_logic := '0'; 
    signal outputflag1: std_logic := '0';
    signal outputflag2: std_logic := '0';
    signal outputsignal: std_logic := '0';

    
begin
    ram : ram_8by32 port map(data_in, data_out, clk, head, tail, mem_check, inputsignal, outputsignal);
    --in_db: task1 port map(enable_input,clk,input_de);
    --out_db: task1 port map(enable_output,clk,output_de);
-------------------------------------------------------------------------------------------------------------
--INPUT
    process(clk)
    begin
        if clk'event and clk = '1' and enable_input = '1' and inputflag1 = '0' then --only rising edges and input on
            
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
            inputflag1 <= '1';

        end if;
        
        if inputflag2 = '0' and inputflag1 = '1' then
                inputsignal <= '1';
                inputflag2 <= '1';
            elsif inputflag2 = '1' then
                inputsignal <= '0';
            end if;  
        
        if enable_input = '0' then
        inputflag1 <= '0';
        inputflag2 <= '0';
        end if;
        
    end process;        
        
-------------------------------------------------------------------------------------------------------------
--OUTPUT
    process(clk)
    begin
        if clk'event and clk = '1' and enable_output = '1' and outputflag1 = '0' then --only rising edges and output      
        
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
            
            outputflag1 <= '1';

        end if;     
        
        if outputflag2 = '0' and outputflag1 = '1' then
                outputsignal <= '1';
                outputflag2 <= '1';
        elsif outputflag2 = '1' then
                outputsignal <= '0';
        end if;
        
        if enable_output = '0' then
        outputflag1 <= '0';
        outputflag2 <= '0';
        end if;
    end process;
    


end Behavioral;
