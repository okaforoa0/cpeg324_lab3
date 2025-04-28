library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator_tb is
end calculator_tb;

architecture Behavioral of calculator_tb is

    -- Declare the component to be tested
    component calculator
        port (
            clk         : in std_logic;
            reset       : in std_logic;
            instr       : in std_logic_vector(7 downto 0);
            digits_out  : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Internal signals
    signal clk_tb       : std_logic := '0';
    signal reset_tb     : std_logic := '0';
    signal instr_tb     : std_logic_vector(7 downto 0) := (others => '0');
    signal digits_out_tb: std_logic_vector(15 downto 0);

    constant clk_period : time := 5 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: calculator
        port map (
            clk => clk_tb,
            reset => reset_tb,
            instr => instr_tb,
            digits_out => digits_out_tb
        );

    -- Clock generation process
    clk_process: process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period/2;
            clk_tb <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- stimulus process
    stim_proc: process
    begin
        -- reset sequence
        reset_tb <= '1';
        wait for clk_period;
        reset_tb <= '0';
        wait for clk_period;

        -- insert two NOPs (no operation)
        instr_tb <= "00000000";
        wait for clk_period;
        instr_tb <= "00000000";
        wait for clk_period;

        -- Load 2 into r2
        --instr_tb <= "01001010";
        instr_tb <= "01100010";
        wait for clk_period;

        --instr_tb <= "00000000";
        --wait for clk_period;

        -- Load -1 into r3
        instr_tb <= "01111111";
        wait for clk_period;

        --instr_tb <= "00000000";
        --wait for clk_period;

        -- Add r2 and r3, store in r1
        instr_tb <= "00101101";
        wait for clk_period;

        -- Swap the two halves of r1
        instr_tb <= "11011000";
        wait for clk_period;

        -- Compare r1 and r2
        instr_tb <= "10011000";
        wait for clk_period;

        -- Load 4 into r1 (only if not skipped)
        --instr_tb <= "01010001";
        instr_tb <= "01010100";
        wait for clk_period;

        -- Display r1 lower half
        instr_tb <= "11010000";
        wait for clk_period;

        -- Finish simulation
        wait for clk_period*10;
        assert false report "Simulation completed successfully." severity note;
        wait;
    end process;

end Behavioral;
