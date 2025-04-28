library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end pc_tb;

architecture behav of pc_tb is

    -- declare the component under test
    component pc
        port (
            clk    : in  std_logic;
            reset  : in  std_logic;
            skip   : in  std_logic;
            pc_out : out std_logic_vector(4 downto 0)
        );
    end component;

    -- signals for connecting
    signal clk_tb    : std_logic := '0';
    signal reset_tb  : std_logic := '0';
    signal skip_tb   : std_logic := '0';
    signal pc_out_tb : std_logic_vector(4 downto 0);

begin

    -- instantiate the PC
    uut: pc
    port map (
        clk    => clk_tb,
        reset  => reset_tb,
        skip   => skip_tb,
        pc_out => pc_out_tb
    );

    -- clock generation
    clk_process: process
    begin
        while true loop
            clk_tb <= '0';
            wait for 5 ns;
            clk_tb <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Test process
    stimulus: process
    begin
        -- Start with reset
        reset_tb <= '1';
        wait for 10 ns;
        reset_tb <= '0';

        -- Normal operation (no skip)
        skip_tb <= '0';
        wait for 20 ns;

        -- Skip instruction
        skip_tb <= '1';
        wait for 10 ns;

        -- Back to normal increment
        skip_tb <= '0';
        wait for 20 ns;

        -- Done
        assert false report "End of PC Testbench" severity note;
        wait;
    end process;
--s
end behav;
