library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Debouncer is
    Generic(n : integer := 2000);
    Port (
        Clk : in STD_LOGIC;
        Din : in STD_LOGIC;
        Qout : out STD_LOGIC
    );
end Debouncer;

architecture Debounce_architecture of Debouncer is

    signal buff : std_logic_vector(n downto 0) := (others => '0');

begin
    
    process(Clk)
    begin
        if rising_edge(Clk)then
            for k in n downto 1 loop
                buff(k) <= buff(k-1);
            end loop;
            buff(0) <= Din;
            if unsigned(buff(n downto 1)) = 2**n - 1 and buff(0) = '0' then
                Qout <= '1';
            else
                Qout <= '0';
            end if;
        end if;
    end process;
    
end Debounce_architecture;