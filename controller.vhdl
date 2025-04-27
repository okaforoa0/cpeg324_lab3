library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port (
        op            : in  std_logic_vector(1 downto 0); -- opcode from instruction
        control       : in  std_logic;                    -- additional control (to distinguish swap/display)
        ALU_result    : in  std_logic_vector(15 downto 0); -- result from ALU (for compare)
        clk           : in  std_logic;
        alu_op        : out std_logic_vector(1 downto 0); -- ALU operation control
        A_mux         : out std_logic;                    -- select input A
        B_mux         : out std_logic;                    -- select input B
        print_control : out std_logic;                    -- control for display/print
        skip_control  : out std_logic;                    -- control for PC skip
        write_control : out std_logic                     -- write enable for register file
    );
end controller;

architecture Behavioral of controller is
begin

    gen_signals: process(clk)
    begin 
        if rising_edge(clk) then
            if (op = "00") then -- ADD
                alu_op <= "00";
                A_mux <= '1';
                B_mux <= '1';
                print_control <= '0';
                skip_control <= '0';
                write_control <= '1';

            elsif (op = "01") then -- LOAD
                alu_op <= "10";
                A_mux <= '0';
                B_mux <= '0';
                print_control <= '0';
                skip_control <= '0';
                write_control <= '1';

            elsif (op = "10") then -- COMPARE
                alu_op <= "11";
                A_mux <= '1';
                B_mux <= '1';
                print_control <= '0';
                write_control <= '0';
                -- Check lower half for greater
                if (ALU_result(7) = '0' and ALU_result(7 downto 0) /= "00000000") then 
                    skip_control <= '1'; 
                else
                    skip_control <= '0';
                end if;

            elsif (op = "11" and control = '0') then -- DISPLAY
                print_control <= '1';
                skip_control <= '0';
                write_control <= '0';
                -- alu_op, A_mux, B_mux don't care

            elsif (op = "11" and control = '1') then -- SWAP
                alu_op <= "01";
                A_mux <= '1';
                print_control <= '0';
                skip_control <= '0';
                write_control <= '1';
                -- B_mux is don't care

            else -- DEFAULT
                alu_op <= "00";
                A_mux <= '0';
                B_mux <= '0';
                print_control <= '0';
                skip_control <= '0';
                write_control <= '0';
            end if;
        end if;
    end process;

end Behavioral;
