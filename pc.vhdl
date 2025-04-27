library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
    port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        skip   : in  std_logic; -- 0 = normal increment by 4, 1 = skip next instruction (increment by 8)
        pc_out : out std_logic_vector(4 downto 0) -- Assuming 5 bits for address
    );
end pc;

architecture behav of pc is

    signal pc_reg : unsigned(4 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                pc_reg <= (others => '0');
            else
                if skip = '1' then
                    pc_reg <= pc_reg + 8; -- Skip: jump 2 instructions ahead
                else
                    pc_reg <= pc_reg + 4; -- Normal: move to next instruction
                end if;
            end if;
        end if;
    end process;

    pc_out <= std_logic_vector(pc_reg);

end behav;
