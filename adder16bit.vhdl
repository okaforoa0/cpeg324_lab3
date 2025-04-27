library ieee;
use ieee.std_logic_1164.all;

entity adder16bit is
    port (
        A   : in  std_logic_vector(15 downto 0);
        B   : in  std_logic_vector(15 downto 0);
        S   : out std_logic_vector(15 downto 0)
    );
end adder16bit;

architecture Behavioral of adder16bit is

    component full_adder
        port (
            a    : in  std_logic;
            b    : in  std_logic;
            cin  : in  std_logic;
            sum  : out std_logic;
            cout : out std_logic
        );
    end component;

    signal carry : std_logic_vector(16 downto 0) := (others => '0'); -- 17 carry bits, carry(0) = 0

begin

    --carry(0) <= '0'; -- Initial carry-in is zero

    -- Chain 16 full adders
    FA0: full_adder port map (A(0), B(0), carry(0), S(0), carry(1));
    FA1: full_adder port map (A(1), B(1), carry(1), S(1), carry(2));
    FA2: full_adder port map (A(2), B(2), carry(2), S(2), carry(3));
    FA3: full_adder port map (A(3), B(3), carry(3), S(3), carry(4));
    FA4: full_adder port map (A(4), B(4), carry(4), S(4), carry(5));
    FA5: full_adder port map (A(5), B(5), carry(5), S(5), carry(6));
    FA6: full_adder port map (A(6), B(6), carry(6), S(6), carry(7));
    FA7: full_adder port map (A(7), B(7), carry(7), S(7), carry(8));
    FA8: full_adder port map (A(8), B(8), carry(8), S(8), carry(9));
    FA9: full_adder port map (A(9), B(9), carry(9), S(9), carry(10));
    FA10: full_adder port map (A(10), B(10), carry(10), S(10), carry(11));
    FA11: full_adder port map (A(11), B(11), carry(11), S(11), carry(12));
    FA12: full_adder port map (A(12), B(12), carry(12), S(12), carry(13));
    FA13: full_adder port map (A(13), B(13), carry(13), S(13), carry(14));
    FA14: full_adder port map (A(14), B(14), carry(14), S(14), carry(15));
    FA15: full_adder port map (A(15), B(15), carry(15), S(15), carry(16));

end Behavioral;
