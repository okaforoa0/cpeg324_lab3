library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

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

    -- Declare the sign extend component
    component sign_extend4to8
        port (
            input_4bit  : in std_logic_vector(3 downto 0);
            output_8bit : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Internal signals
    signal A_tb, B_tb : std_logic_vector(15 downto 0);
    signal clk_tb     : std_logic := '0';
    signal control_tb : std_logic_vector(1 downto 0);
    signal result_tb  : std_logic_vector(15 downto 0);
    signal immediate_4bit : std_logic_vector(3 downto 0);
    signal extended_imm : std_logic_vector(7 downto 0);

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

    -- Instantiate the sign extender (4 bits to 8 bits)
    se: sign_extend4to8
    port map (
        input_4bit => immediate_4bit,
        output_8bit => extended_imm
    );

    -- Main process
    process
        -- Define a record for inputs and expected outputs
        type pattern_type is record
            is_immediate : boolean;
            A_value      : std_logic_vector(15 downto 0);
            B_value      : std_logic_vector(15 downto 0);
            imm4         : std_logic_vector(3 downto 0);
            control      : std_logic_vector(1 downto 0);
            expected_result : std_logic_vector(15 downto 0);
        end record;

        -- Array of test patterns
        type pattern_array is array (natural range <>) of pattern_type;

        constant patterns : pattern_array := (
            -- Load 2 into r2 (immediate 2)
            (is_immediate => true,  A_value => (others => '0'), B_value => (others => '0'), imm4 => "0010", control => "10", expected_result => x"0002"),

            -- Load -1 into r3 (immediate 1111)
            (is_immediate => true,  A_value => (others => '0'), B_value => (others => '0'), imm4 => "1111", control => "10", expected_result => x"00FF"),

            -- Add r2 + r3 (0x0002 + 0x00FF = 0x0001)
            (is_immediate => false, A_value => x"0002", B_value => x"00FF", imm4 => "0000", control => "00", expected_result => x"0001"),

            -- Swap halves of r1
            (is_immediate => false, A_value => x"0001", B_value => (others => '0'), imm4 => "0000", control => "01", expected_result => x"0100"),

            -- Compare r1 and r2
            (is_immediate => false, A_value => x"0100", B_value => x"0002", imm4 => "0000", control => "11", expected_result => x"0000")
        );

    begin
        -- Loop over patterns
        for n in patterns'range loop
            if patterns(n).is_immediate then
                immediate_4bit <= patterns(n).imm4;
                wait for 1 ns; -- wait for sign extension to happen
                --A_tb <= (15 downto 8 => (others => '0')) & extended_imm;
                A_tb <= (others => '0');
                A_tb(7 downto 0) <= extended_imm;
                B_tb <= patterns(n).B_value;
            else
                A_tb <= patterns(n).A_value;
                B_tb <= patterns(n).B_value;
            end if;

            control_tb <= patterns(n).control;

            -- Simulate a clock rising edge
            clk_tb <= '0';
            wait for 1 ns;
            clk_tb <= '1';
            wait for 1 ns;
            clk_tb <= '0';

            wait for 1 ns;


            -- Check output
            assert result_tb = patterns(n).expected_result
            report "Test failed at pattern " & integer'image(n)
            severity error;
        end loop;

        -- End of test
        assert false report "End of ALU testbench." severity note;
        wait;
    end process;

end behav;
