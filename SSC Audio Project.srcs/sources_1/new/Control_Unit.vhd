library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Unit is
    Port(
        Clk : in std_logic;
        Rec : in std_logic;
        Play : in std_logic;
        Converter_EN : out std_logic;
        Mem_WR_EN : out std_logic;
        Mem_RD_EN : out std_logic;
        Recording_indicator : out std_logic;
        Playing_indicator : out std_logic
    );
end Control_Unit;

architecture Behavioral of Control_Unit is

    type STATES is (idle, recording, playing);
    signal state : STATES := idle;
    -- Clock frequency is 2 MHz => 2.000.000 clocks / second
    -- for counting 3 seconds we need to count 2.000.000 * 3 = 6.000.000 clocks
    signal counter : integer range 0 to 5999999 := 0;
    -- 2.000.000 / 64 (bits per sample) = 31250 samples per second
    -- 3 seconds => 3 * 31250 = 93750 samples in total
    --signal address : integer range 0 to 93749 := 0;
    signal bits_counter : integer range 0 to 63 := 0;
    
begin
    
    state_process:
    process(Clk)
    begin
        if rising_edge(Clk)then
            case state is
                when idle =>
                    if Rec = '1' then
                        state <= recording;
                        counter <= 0;
                    elsif Play = '1' then
                        state <= playing;
                        counter <= 0;
                    end if;
                    
                when recording =>
                    if counter = 5999999 then
                        state <= idle;
                    else
                        counter <= counter + 1;
                    end if;
                when playing =>
                    if counter = 5999999 then
                        state <= idle;
                    else
                        counter <= counter + 1;
                    end if;
            end case;
        end if;
    end process;
    
    control_process:
    process(Clk)
    begin
        if rising_edge(Clk)then
            case state is
                when idle =>
                    Converter_EN <= '0'; Mem_WR_EN <= '0'; Mem_RD_EN<= '0'; Recording_indicator <= '0'; Playing_indicator <= '0';
                when recording =>
                    Converter_EN <= '0'; Mem_WR_EN <= '1'; Mem_RD_EN<= '0'; Recording_indicator <= '1'; Playing_indicator <= '0';
                when playing =>
                    Converter_EN <= '1'; Mem_WR_EN <= '0'; Mem_RD_EN<= '1'; Recording_indicator <= '0'; Playing_indicator <= '1';
            end case;
        end if;
    end process;

end Behavioral;
