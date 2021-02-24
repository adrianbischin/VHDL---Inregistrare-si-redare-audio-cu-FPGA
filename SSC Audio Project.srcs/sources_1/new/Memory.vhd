library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Memory is
    Port(
        Clk : in std_logic;
        RD_EN : in std_logic;
        WR_EN : in std_logic;
        WR : in std_logic;
        Data_in : in std_logic_vector(6 downto 0);
        Data_out : out std_logic_vector(6 downto 0)
    );
end Memory;

architecture Behavioral of Memory is

    -- 1 second of recording at 2MHz => 2.000.000 clocks per second
    -- 6.000.000 (3 seconds of recording) / 64 (bits per sample) = 93750 samples
    type RAM is array (0 to 93749) of std_logic_vector(6 downto 0);
    signal memory : RAM := (others => "0000000");
    signal address : integer range 0 to 93749 := 0;
    signal counter_64 : integer range 0 to 63 := 0;

begin

    process(Clk)
    begin
        if rising_edge(Clk) then
            if WR_EN = '1' then
                if WR = '1' then
                    memory(address) <= Data_in;
                    if address = 93749 then
                        address <= 0;
                    else
                        address <= address + 1;
                    end if;
                end if;
            elsif RD_EN = '1' then
                Data_out <= memory(address); -- each value must stay on output for 64 clock cycles for the converter,
                                             -- in order to correctly translate the PDM signal into a PWM signal
                if counter_64 >= 63 then -- increase the memory address every 64 clock cycles
                    counter_64 <= 0;
                    if address >= 93749 then
                        address <= 0;
                    else
                        address <= address + 1;
                    end if;
                else
                    counter_64 <= counter_64 + 1;
                end if;
            end if;
        end if;
    end process;

end Behavioral;