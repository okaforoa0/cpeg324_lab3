library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity main_alu_tb is
end main_alu_tb;

architecture behav of main_alu_tb is

    -- Declare the component to be tested
    component main_alu
        port (
            A       : in  std_logic_vector(15 downto 0);
            B       : in  std_logic_vector(15 downto 0);
            clk     : in  std_logic;
            control : in  std_logic_vector(1 downto 0);
            result  : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Internal signals
    signal A_tb, B_tb : std_logic_vector(15 downto 0);
    signal clk_tb     : std_logic := '0';
    signal control_tb : std_logic_vector(1 downto 0);
    signal result_tb  : std_logic_vector(15 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: main_alu
    port map (
        A => A_tb,
        B => B_tb,
        clk => clk_tb,
        control => control_tb,
        result => result_tb
    );

    -- Main process
    process
        -- Define a record for inputs and expected outputs
        type pattern_type is record
            A       : std_logic_vector(15 downto 0);
            B       : std_logic_vector(15 downto 0);
            control : std_logic_vector(1 downto 0);
            expected_result : std_logic_vector(15 downto 0);
        end record;

        -- Array of test patterns
        type pattern_array is array (natural range <>) of pattern_type;

        constant patterns : pattern_array := (
            -- ADD test: 3 + 5 = 8
            (A => x"0003", B => x"0005", control => "00", expected_result => x"0008"),
            -- SWAP test: 0xABCD -> 0xCDAB
            (A => x"ABCD", B => x"0000", control => "01", expected_result => x"CDAB"),
            -- FORWARD test: 0x1234
            (A => x"1234", B => x"0000", control => "10", expected_result => x"1234"),
            -- COMPARE test (equal): lower halves equal, output 0x0001
            (A => x"00AA", B => x"11AA", control => "11", expected_result => x"0001"),
            -- COMPARE test (not equal): lower halves different, output 0x0000
            (A => x"00AA", B => x"11BB", control => "11", expected_result => x"0000")
        );

    begin
        -- Loop over patterns
        for n in patterns'range loop
            -- Apply inputs
            A_tb <= patterns(n).A;
            B_tb <= patterns(n).B;
            control_tb <= patterns(n).control;

            -- Simulate a clock rising edge
            clk_tb <= '0';
            wait for 1 ns;
            clk_tb <= '1';
            wait for 1 ns;
            clk_tb <= '0'; -- Drop clock after edge

            -- Wait a moment for outputs to update
            wait for 1 ns;

            -- Check the output
            assert result_tb = patterns(n).expected_result
            report "Test failed at pattern " & integer'image(n)
                & ": expected " & to_hstring(patterns(n).expected_result)
                & ", got " & to_hstring(result_tb)
            severity error;
        end loop;

        -- End of test
        assert false report "End of ALU testbench." severity note;
        wait;
    end process;

end behav;
