library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity print_module_tb is
end print_module_tb;

architecture behav of print_module_tb is

    -- Declare the component
    component print_module
        port (
            data_in      : in std_logic_vector(15 downto 0);
            print_enable : in std_logic;
            digits_out   : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Internal signals
    signal data_in_tb      : std_logic_vector(15 downto 0);
    signal print_enable_tb : std_logic := '0';
    signal digits_out_tb   : std_logic_vector(15 downto 0);

begin

    -- Instantiate UUT (Unit Under Test)
    uut: print_module
    port map (
        data_in      => data_in_tb,
        print_enable => print_enable_tb,
        digits_out   => digits_out_tb
    );

    -- Stimulus process
    process
    begin
        -- Initial state
        data_in_tb <= (others => '0');
        print_enable_tb <= '0';
        wait for 5 ns;

        -- Test positive number: 0x0015 (21)
        data_in_tb <= x"0015"; -- 0001_0101
        print_enable_tb <= '1';
        wait for 10 ns;

        assert digits_out_tb = x"0021"
            report "Failed: Expected 0021 for input 0x15" severity error;

        -- Test negative number: 0x00FD (-3)
        data_in_tb <= x"00FD"; -- 1111_1101
        print_enable_tb <= '1';
        wait for 10 ns;

        assert digits_out_tb = x"0003"
            report "Failed: Expected 0003 for input 0xFD (-3)" severity error;

        -- Test zero
        data_in_tb <= x"0000";
        print_enable_tb <= '1';
        wait for 10 ns;

        assert digits_out_tb = x"0000"
            report "Failed: Expected 0000 for input 0x00" severity error;

        -- Test bigger positive number: 0x007B (123)
        data_in_tb <= x"007B"; -- 0111_1011
        print_enable_tb <= '1';
        wait for 10 ns;

        assert digits_out_tb = x"0123"
            report "Failed: Expected 0123 for input 0x7B" severity error;

        -- End of test
        assert false report "End of print_module testbench." severity note;
        wait;
    end process;

end behav;
