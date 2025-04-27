library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder16bit is
	Port (
        A   : in  std_logic_vector(15 downto 0);
        B   : in  std_logic_vector(15 downto 0);
        S   : out std_logic_vector(15 downto 0)
    );
end adder16bit;

architecture behav of adder16bit is

    -- Component declaration for addsub4bit
    component addsub4bit
        port(
            a     : in std_logic_vector(3 downto 0);
            b     : in std_logic_vector(3 downto 0);
            sub   : in std_logic;
            s     : out std_logic_vector(3 downto 0);
            over  : out std_logic;
            under : out std_logic
        );
    end component;

    signal sum0, sum1, sum2, sum3 : std_logic_vector(3 downto 0);
    signal carry1, carry2, carry3 : std_logic; -- for chaining carrie
    signal dummy_over, dummy_under : std_logic; -- won't use these for now

begin

    -- Instantiate 4 addsub4bit blocks

    -- Lower 4 bits
    adder0: addsub4bit port map(
        a => A(3 downto 0),
        b => B(3 downto 0),
        sub => '0', -- 0 for addition (not subtraction)
        s => sum0,
        over => dummy_over,
        under => dummy_under
    );

    -- Next 4 bits
    adder1: addsub4bit port map(
        a => A(7 downto 4),
        b => B(7 downto 4),
        sub => '0',
        s => sum1,
        over => dummy_over,
        under => dummy_under
    );

    -- Next 4 bits
    adder2: addsub4bit port map(
        a => A(11 downto 8),
        b => B(11 downto 8),
        sub => '0',
        s => sum2,
        over => dummy_over,
        under => dummy_under
    );

    -- Top 4 bits
    adder3: addsub4bit port map(
        a => A(15 downto 12),
        b => B(15 downto 12),
        sub => '0',
        s => sum3,
        over => dummy_over,
        under => dummy_under
    );

    -- combine all partial sums into final output
    S <= sum3 & sum2 & sum1 & sum0;

end behav;
