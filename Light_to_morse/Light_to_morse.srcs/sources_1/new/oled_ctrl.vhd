--
-- Written by Ryan Kim, Digilent Inc.
-- Modified by Michael Mattioli
--
-- Description: Top level controller that controls the OLED display.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity oled_ctrl is
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
            input       : in std_logic_vector (7 downto 0)
            );
end oled_ctrl;
        

architecture behavioral of oled_ctrl is

   component task1 
        port (button : in std_logic;
             clk : in std_logic;
             result : out std_logic
        );
    end component;


    component oled_init is
        port (  clk         : in std_logic;
                rst         : in std_logic;
                en          : in std_logic;
                sdout       : out std_logic;
                oled_sclk   : out std_logic;
                oled_dc     : out std_logic;
                oled_res    : out std_logic;
                oled_vbat   : out std_logic;
                oled_vdd    : out std_logic;
                fin         : out std_logic);
    end component;

    component oled_ex is
        port (  clk         : in std_logic;
                rst         : in std_logic;
                en          : in std_logic;
                sdout       : out std_logic;
                oled_sclk   : out std_logic;
                oled_dc     : out std_logic;
                input       : in std_logic_vector (7 downto 0);
                fin         : out std_logic;
                btn         : in std_logic);
    end component;

    type states is (Idle, OledInitialize, OledExample, Done);

    signal current_state : states := Idle;

    signal init_en          : std_logic := '0';
    signal init_done        : std_logic;
    signal init_sdata       : std_logic;
    signal init_spi_clk     : std_logic;
    signal init_dc          : std_logic;

    signal example_en       : std_logic := '0';
    signal example_sdata    : std_logic;
    signal example_spi_clk  : std_logic;
    signal example_dc       : std_logic;
    signal input_nr         : std_logic_vector (7 downto 0);
    signal example_done     : std_logic;
    
    signal printf: std_logic:='0';

begin

    print: task1 port map (rst, clk, printf);
  
    Initialize: oled_init port map (clk,
                                    printf,
                                    init_en,
                                    init_sdata,
                                    init_spi_clk,
                                    init_dc,
                                    oled_res,
                                    oled_vbat,
                                    oled_vdd,
                                    init_done);

    Example: oled_ex port map ( clk,
                                printf,
                                example_en,
                                example_sdata,
                                example_spi_clk,
                                example_dc,
                                input,
                                example_done,
                                btn
                                
                                );


    -- MUXes to indicate which outputs are routed out depending on which block is enabled
    oled_sdin <= init_sdata when current_state = OledInitialize else example_sdata;
    oled_sclk <= init_spi_clk when current_state = OledInitialize else example_spi_clk;
    oled_dc <= init_dc when current_state = OledInitialize else example_dc;
    -- End output MUXes

    -- MUXes that enable blocks when in the proper states
    init_en <= '1' when current_state = OledInitialize else '0';
    example_en <= '1' when current_state = OledExample else '0';
    -- End enable MUXes
 
 
  --assign: process (clk)
  -- begin
   --  if rising_edge(clk) then
   --     if btn_val = '1' then
   --     for j in 0 to 7 loop
   --         input_nr(j)<= input(j);
   --     end loop;
    --     end if;
   --  end if;
   -- end process;
    
    main:process (clk)
    begin
        if rising_edge(clk) then
            if printf = '1' then
                current_state <= Idle;
            else
                case current_state is
                    when Idle =>
                        current_state <= OledInitialize;
                    -- Go through the initialization sequence
                    when OledInitialize =>
                        if init_done = '1' then
                            current_state <= OledExample;
                        end if;
                    -- Do example and do nothing when finished
                    when OledExample =>
                        if example_done = '1' then
                            current_state <= Done;
                        end if;
                    -- Do nthing
                    when Done =>
                        current_state <= Done;
                    when others =>
                        current_state <= Idle;
                end case;
            end if;
        end if;
    end process;

end behavioral;