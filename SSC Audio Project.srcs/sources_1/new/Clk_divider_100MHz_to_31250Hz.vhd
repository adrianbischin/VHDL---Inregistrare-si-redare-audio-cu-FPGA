library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Clk_divider_100MHz_to_31250Hz is
    Port(
        Clk_100MHz : in std_logic;
        Clk_31250Hz : out std_logic
    );
end Clk_divider_100MHz_to_31250Hz;

architecture Behavioral of Clk_divider_100MHz_to_31250Hz is
    
    -- 100 Mhz / 31250 Hz = 64 / 2 = 32
    -- 31250 Hz clk will be constant for 32 periods of the 100 MHz clk
    -- => counter range is 0 to 31
    signal counter : integer range 0 to 31 := 0;
    signal divided_clk : std_logic := '0';

begin

    process(Clk_100MHz)
    begin
        if rising_edge(Clk_100MHz) then
            if counter = 24 then
                divided_clk <= not divided_clk;
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    Clk_31250Hz <= divided_clk;
    
end Behavioral;
