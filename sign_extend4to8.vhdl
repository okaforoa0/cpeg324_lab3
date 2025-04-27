library ieee;
use ieee.std_logic_1164.all;

entity sign_extend4to8 is
    port (
        input_4bit  : in std_logic_vector(3 downto 0);
        output_8bit : out std_logic_vector(7 downto 0)
    );
end sign_extend4to8;

architecture Behavioral of sign_extend4to8 is
begin
    process(input_4bit)
    begin
        if input_4bit(3) = '1' then
            output_8bit <= (7 downto 4 => '1') & input_4bit;
        else
            output_8bit <= (7 downto 4 => '0') & input_4bit;
        end if;
    end process;
end Behavioral;
