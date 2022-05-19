----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Suck My Kurt
-- 
-- Create Date: 09.05.2022 09:34:18
-- Design Name: 
-- Module Name: translation_interface - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

library work;
use work.mem_pkg.all;

entity fifo_oled_connection is
  port (    clkC         : in std_logic;
            oled_sdinC   : out std_logic;
            oled_sclkC   : out std_logic;
            oled_dcC     : out std_logic;
            oled_resC    : out std_logic;
            oled_vbatC   : out std_logic;
            oled_vddC    : out std_logic;
            
            
            rstC         : in std_logic; --Print screen
            inputC       : in std_logic_vector (7 downto 0):=(others=>'0'); -- data input
            fifo_to_oled : inout std_logic_vector (7 downto 0)
         
            );
end fifo_oled_connection;

architecture Behavioral of fifo_oled_connection is
    component oled_ctrl
        port (  clk         : in std_logic;
            rst         : in std_logic;
            oled_sdin   : out std_logic;
            oled_sclk   : out std_logic;
            oled_dc     : out std_logic;
            oled_res    : out std_logic;
            oled_vbat   : out std_logic;
            oled_vdd    : out std_logic;
            btn         : in std_logic;
           --btn_val     : in std_logic;
            input       : in std_logic_vector (7 downto 0):=(others=>'0')
            );
    end component;
    
    component fifo_w_signal_control
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
    end component;
    
    component task1
        port(
            button : in std_logic;
            clk : in std_logic;
            result : out std_logic
        );
    end component;
    
    component timer_variable
        Port (
            zedboard_clk: in std_logic;
            enable: in std_logic;
            reset: in std_logic;
            timerOutput: out std_logic
        );
    end component;
    
    component pulse_stable_conversion
        Port ( 
            input: in std_logic_vector (7 downto 0):= "00000000";
            output: out std_logic_vector (7 downto 0);
            new_output: out std_logic := '0';
            clk: in std_logic
        );
    end component;
    
    --signal fifo_to_oled: std_logic_vector (7 downto 0); --conection between fifo output and oled input
    signal enb_save: std_logic := '0'; -- activates save button on oled
    signal de_rst: std_logic;
    signal de_input: std_logic;
    signal de_output: std_logic;
    signal mem_checkC: mem_array := (others => (others => '0'));
    signal saveflag1: std_logic := '0';  
    signal saveflag2: integer := 0;
    
    signal headC: integer := 0;
    signal tailC: integer := 0;
    
    signal slowclk_enb: std_logic := '1';
    signal slowclk_rst: std_logic := '0';
    signal slowclk_out: std_logic := '0';
    
    signal translate_to_fifo: std_logic_vector (7 downto 0);
    signal enb_fifo: std_logic := '0';
    
    signal fullC: std_logic := '0';
    signal emptyC: std_logic := '0';
    
begin
    
--    db_save: task1 port map(
--                button => btnC,
--                clk => clkC,
--                result => enb_save
--            );

            
    db_reset: task1 port map(
                button => RsTC,
                clk => clkC,
                result => de_rst
            );
            
--    db_input: task1 port map(
--                button => enb_in,
--                clk => clkC,
--                result => de_input
--            );        
    
--    db_output: task1 port map(
--                button => enb_out,
--                clk => clkC,
--                result => de_output
--            );  

    slowclk: timer_variable port map(
        zedboard_clk => cLkC,
        enable => slowclk_eNb,
        reset => slowclk_rst,
        timerOutput => slowclk_out
    );       
            
    
    oled: oled_ctrl port map(
        clk => clkC, 
        rst => de_rst, 
        oled_sdin => oled_sdinC, 
        oled_sclk => oled_sclkC, 
        oled_dc => oled_dcC, 
        oled_res => oled_resC, 
        oled_vbat => oled_vbatC, 
        oled_vdd => oled_vddC, 
        btn => enb_save, 
        input => fifo_to_oled
    );
    
    
    
    fifo: fifo_w_signal_control port map(
        data_in => translate_to_fifo, 
        data_out => fifo_to_oled, 
        clk => clkC, 
        enable_input => enb_fifo, 
        enable_output => slowclk_out, 
        full => fullC, 
        empty => emptyC,
        mem_check => mem_checkC,
        head => headC,
        tail => tailC
    );
    
    component_input: pulse_stable_conversion port map(
        input => inputC,
        output => translate_to_fifo,
        new_output => enb_fifo,
        clk => clkC
    );
    
    
    
    process(slowclk_out)
    begin
        if slowclk_out'event and slowclk_out = '1' then --every rising edge
            if emptyC = '0' then
                saveflag1 <= '1';
            end if;
            
            if saveflag1 = '1' then
                saveflag2 <= saveflag2 + 1;
            end if;
            
            if saveflag2 = 2 then
                enb_save <= '1';
            elsif saveflag2 = 3 then --3 for 1 clock cycle
                enb_save <= '0';
                saveflag1 <= '0';
                saveflag2 <= 0;
            end if;
        
        end if;
    
    
    end process;
    
     
end Behavioral;




