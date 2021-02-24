library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Audio_with_PDM_and_PWM is
    Port(
        Clk : in std_logic;
        Rec : in std_logic;
        Play : in std_logic;
        PDM_data : in std_logic;
        L_R_select : out std_logic := '0';
        Mic_clk : out std_logic;
        PWM_out : out std_logic;
        Recording_indicator : out std_logic;
        Playing_indicator : out std_logic;
        PDM_Input_Data : out std_logic
    );
end Audio_with_PDM_and_PWM;

architecture Behavioral of Audio_with_PDM_and_PWM is

    signal debounced_rec, debounced_play, div_clk, EN_conv, EN_RD, EN_WR, WR : std_logic := '0';
    signal mem_in, mem_out : std_logic_vector(6 downto 0) := (others => '0');

begin

    Mic_clk <= div_clk;

    record_debouncer:
    entity WORK.debouncer
    port map(
        Clk => div_clk,
        Din => Rec,
        Qout => debounced_rec
    );
    
    play_debouncer:
    entity WORK.debouncer
    port map(
        Clk => div_clk,
        Din => Play,
        Qout => debounced_play
    );

    clk_divider:
    entity WORK.Clk_divider_100MHz_to_2MHz
    port map(
        Clk_100MHz => Clk,
        Clk_2MHz => div_clk
    );
    
    countrol_unit:
    entity WORK.Control_Unit
    port map(
        Clk => div_clk,
        Rec => debounced_rec,
        Play => debounced_play,
        Converter_EN => EN_conv,
        Mem_WR_EN => EN_WR,
        Mem_RD_EN => EN_RD,
        Recording_indicator => Recording_indicator,
        Playing_indicator => Playing_indicator
    );
    
    PDM_Deserializator:
    entity WORK.PDM_Deserializator
    port map(
        Clk => div_clk,
        data_in => PDM_data,
        sample_duty_cycle => mem_in,
        WR => WR,
        PDM_Input_Data => PDM_Input_Data
    );
    
    Memory:
    entity WORK.Memory
    port map(
        Clk => div_clk,
        WR => WR,
        WR_EN => EN_WR,
        RD_EN => EN_RD,
        Data_in => mem_in,
        Data_out => mem_out
    );
    
    PDM_to_PWM_converter:
    entity WORK.PDM_to_PWM_Converter
    port map(
        Clk => div_clk,
        EN => EN_conv,
        DutyCycle => mem_out,
        PWM_out => PWM_out
    );

end Behavioral;
