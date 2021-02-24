library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Clk_divider_100MHz_to_2MHz is
    Port(
        Clk_100MHz : in std_logic;
        Clk_2MHz : out std_logic
    );
end Clk_divider_100MHz_to_2MHz;

architecture Behavioral of Clk_divider_100MHz_to_2MHz is
    
    -- 100 Mhz / 2 MHz = 50 / 2 = 25
    -- 2 MHz clk will be constant for 25 periods of the 100 MHz clk
    -- => counter range is 0 to 24
    signal counter : integer range 0 to 24 := 0;
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
    
    Clk_2MHz <= divided_clk;
    
end Behavioral;
