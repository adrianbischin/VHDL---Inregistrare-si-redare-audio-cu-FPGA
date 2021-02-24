library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PDM_Deserializator is
    Port(
        Clk : in std_logic;
        data_in : in std_logic;
        sample_duty_cycle : out std_logic_vector(6 downto 0);
        WR: out std_logic;
        PDM_Input_Data : out std_logic
    );
end PDM_Deserializator;

architecture Behavioral of PDM_Deserializator is

    signal bits_received : integer range 0 to 63 := 0;
    signal duty_cycle : std_logic_vector(6 downto 0) := (others => '0');
    signal memorize : std_logic := '0';

begin
    
    process(Clk)
    begin
        if rising_edge(Clk) then
            if bits_received = 63 then
                memorize <= '1';
                bits_received <= 0;
                duty_cycle <= (others => '0');
                sample_duty_cycle <= duty_cycle + data_in;
            else
                memorize <= '0';
                bits_received <= bits_received + 1;
                duty_cycle <= duty_cycle + data_in;
            end if;
        end if;
    end process;

    WR <= memorize;
    PDM_Input_Data <= data_in;

end Behavioral;