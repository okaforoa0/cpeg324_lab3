library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extend4to16 is
    port (
        input_4bit  : in std_logic_vector(3 downto 0);
        output_16bit : out std_logic_vector(15 downto 0)
    );
end sign_extend4to16;

architecture Behavioral of sign_extend4to16 is
begin
    process(input_4bit)
    begin
        if input_4bit(3) = '0' then
            output_16bit <= (11 downto 0 => '0') & input_4bit;
        else
            output_16bit <= (11 downto 0 => '1') & input_4bit;
        end if;
    end process;
end Behavioral;
