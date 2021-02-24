library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Clk_divider_100MHz_to_3KHz is
    Port(
        Clk_100MHz : in std_logic;
        Clk_3KHz : out std_logic
    );
end Clk_divider_100MHz_to_3KHz;

architecture Behavioral of Clk_divider_100MHz_to_3KHz is
    
    -- 100 Mhz / 3 KHz = 33332 / 2 = 16666
    -- 3 KHz clk will be constant for 16666 periods of the 100 MHz clk
    -- => counter range is 0 to 16665
    signal counter : integer range 0 to 16665 := 0;
    signal divided_clk : std_logic := '0';

begin

    process(Clk_100MHz)
    begin
        if rising_edge(Clk_100MHz) then
            if counter = 16665 then
                divided_clk <= not divided_clk;
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    Clk_3KHz <= divided_clk;
    
end Behavioral;
