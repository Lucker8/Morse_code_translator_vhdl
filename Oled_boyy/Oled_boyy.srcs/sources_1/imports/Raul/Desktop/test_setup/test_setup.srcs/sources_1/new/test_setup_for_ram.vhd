library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.mem_pkg.all;

entity test_setup_for_ram is
  Port ( 
         data_inT: in std_logic_vector(7 downto 0);
         data_outT: out std_logic_vector(7 downto 0);
         clkT: std_logic;
         enable_inputT: std_logic;
         enable_outputT: std_logic
  );
end test_setup_for_ram;

architecture Behavioral of test_setup_for_ram is
      component fifo_8by32
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
    end component;
    
    component task1
        port (
            button : in std_logic;
            clk : in std_logic;
            result : out std_logic
        );
    end component;
    
    
    
    signal fullT: std_logic := '0';
    signal emptyT: std_logic := '0';
    signal mem_checkT: mem_array;
    signal deinput: std_logic;
    signal deoutput: std_logic;
    signal inputbuffer: std_logic_vector(7 downto 0);
    signal inputflag1: std_logic := '0';
    signal inputflag2: std_logic := '0';
    signal inputsignal: std_logic := '0';
    
    signal outputbuffer: std_logic_vector(7 downto 0);
    signal outputflag1: std_logic := '0';
    signal outputflag2: std_logic := '0';
    signal outputsignal: std_logic := '0';

begin
    fifo: fifo_8by32 port map(inputbuffer,outputbuffer,clkT,inputsignal,outputsignal,fullT,emptyT,mem_checkT);
    debounce_input: task1 port map(enable_inputT, clkT, deinput);
    debounce_output: task1 port map(enable_outputT, clkT, deoutput);
    
    process(clkT)
    begin
    
    
        if deinput ='1' and inputflag1 = '0' then
            inputbuffer <= data_inT; 
            
            if inputflag2 = '0' then
                inputsignal <= '1';
                inputflag2 <= '1';
            elsif inputflag2 = '1' then
                inputsignal <= '0';
                inputflag1 <= '1';
            end if;     
        end if;      
  
        if deinput = '0' then
        inputflag1 <= '0';
        inputflag2 <= '0';
        end if;
--------------------------------------------------------------------------------------------------------------        
        if deoutput ='1' and outputflag1 = '0' then
            data_outT <= outputbuffer;
            
            if outputflag2 = '0' then
                outputsignal <= '1';
                outputflag2 <= '1';
            elsif outputflag2 = '1' then
                outputsignal <= '0';
                outputflag1 <= '1';
            end if;     
        end if;      
  
        if deoutput = '0' then
        outputflag1 <= '0';
        outputflag2 <= '0';
        end if;
  
    end process;
    
    
end Behavioral;
