library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PDM_to_PWM_Converter is
    Port(
        Clk : in std_logic;
        EN : in std_logic;
        DutyCycle : in std_logic_vector(6 downto 0);
        PWM_out : out std_logic
    );
end PDM_to_PWM_Converter;

architecture Behavioral of PDM_to_PWM_Converter is

    signal counter : integer range 0 to 63 := 0;
    signal PWM_signal : std_logic := '0';

begin

    process(Clk, EN)
    begin
        if rising_edge(Clk) then
	    if EN = '1' then
	        if counter = 0 then
                    PWM_signal <= '1';
                end if;
                if counter = conv_integer(DutyCycle) then
                    PWM_signal <= 'Z';
                end if;
                if counter = 63 then
                    counter <= 0;
                else
                    counter <= counter + 1;
                end if;
	    else
		counter <= 0;
            end if;
	end if;
    end process;

    PWM_out <= PWM_signal when EN = '1' else '0';

end Behavioral;