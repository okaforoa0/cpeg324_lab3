library ieee;
use ieee.std_logic_1164.all;

entity adder8bit is
    port (
        A   : in  std_logic_vector(7 downto 0);
        B   : in  std_logic_vector(7 downto 0);
        S   : out std_logic_vector(7 downto 0)
    );
end adder8bit;

architecture Behavioral of adder8bit is

    component full_adder
        port (
            a    : in  std_logic;
            b    : in  std_logic;
            cin  : in  std_logic;
            sum  : out std_logic;
            cout : out std_logic
        );
    end component;

    signal carry : std_logic_vector(8 downto 0); -- 9 bits, carry(0) = 0

begin

    -- Initialize carry in
    carry(0) <= '0';

    -- Generate full adders
    FA0: full_adder port map (A(0), B(0), carry(0), S(0), carry(1));
    FA1: full_adder port map (A(1), B(1), carry(1), S(1), carry(2));
    FA2: full_adder port map (A(2), B(2), carry(2), S(2), carry(3));
    FA3: full_adder port map (A(3), B(3), carry(3), S(3), carry(4));
    FA4: full_adder port map (A(4), B(4), carry(4), S(4), carry(5));
    FA5: full_adder port map (A(5), B(5), carry(5), S(5), carry(6));
    FA6: full_adder port map (A(6), B(6), carry(6), S(6), carry(7));
    FA7: full_adder port map (A(7), B(7), carry(7), S(7), carry(8));

end Behavioral;
