library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port (
        op            : in  std_logic_vector(1 downto 0); -- opcode from instruction
        control       : in  std_logic;                    -- additional bit (to distinguish swap/display)
        ALU_result    : in  std_logic_vector(15 downto 0); -- ALU result for comparison
        alu_op        : out std_logic_vector(1 downto 0); -- ALU control
        A_mux         : out std_logic;
        B_mux         : out std_logic;
        print_control : out std_logic;
        skip_control  : out std_logic;
        write_control : out std_logic
    );
end controller;

architecture Behavioral of controller is
begin

    -- combinational process, not clocked
    gen_signals: process(op, control, ALU_result)
    begin
        -- default all signals to zeros
        alu_op        <= "00";
        A_mux         <= '0';
        B_mux         <= '0';
        print_control <= '0';
        skip_control  <= '0';
        write_control <= '0';

        -- decode based on op and control
        if (op = "00") then -- ADD
            alu_op        <= "00"; -- ADD
            A_mux         <= '1';
            B_mux         <= '1';
            write_control <= '1';

        elsif (op = "01") then -- LOAD immediate
            alu_op        <= "10"; -- Forward A
            A_mux         <= '0';
            B_mux         <= '0';
            write_control <= '1';

        elsif (op = "10") then -- COMPARE
            alu_op        <= "11"; -- Compare lower halves
            A_mux         <= '1';
            B_mux         <= '1';
            write_control <= '0'; -- No writing during compare
            -- Check lower half result for skip
            if (ALU_result(7) = '0' and ALU_result(7 downto 0) /= "00000000") then
                skip_control <= '1';
            else
                skip_control <= '0';
            end if;

        elsif (op = "11") then
            if (control = '1') then -- SWAP
                alu_op        <= "01"; -- Swap halves
                A_mux         <= '1';
                write_control <= '1';
            else -- DISPLAY
                print_control <= '1'; -- Activate print module
            end if;

        else -- Undefined op, default safe
            alu_op        <= "00";
            A_mux         <= '0';
            B_mux         <= '0';
            print_control <= '0';
            skip_control  <= '0';
            write_control <= '0';
        end if;
    end process;

end Behavioral;
