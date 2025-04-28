library ieee;
use ieee.std_logic_1164.all;

entity main_alu is
    Port ( 
        A       : in  std_logic_vector(15 downto 0);
        B       : in  std_logic_vector(15 downto 0);
        clk     : in  std_logic;
        control : in  std_logic_vector(1 downto 0);
        result  : out std_logic_vector(15 downto 0)
    );
end main_alu;

architecture Behavioral of main_alu is

    -- Declare the adder16bit component
    component adder16bit
        port (
            A   : in  std_logic_vector(15 downto 0);
            B   : in  std_logic_vector(15 downto 0);
            S   : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Internal signal to hold adder result
    signal adder_result : std_logic_vector(15 downto 0) := (others => '0');

begin

    -- Instantiate the 16-bit adder
    U1: adder16bit
    port map (
        A => A,
        B => B,
        S => adder_result
    );

    -- ALU operations
    process(clk)
    begin
        if rising_edge(clk) then
            case control is
                when "00" => -- ADD (full 16-bit addition)
                    result <= adder_result;

                when "01" => -- SWAP halves of A
                    result <= A(7 downto 0) & A(15 downto 8);

                when "10" => -- FORWARD A
                    result <= A;

                when "11" => -- COMPARE lower halves
                    if (A(7 downto 0) = B(7 downto 0)) then
                        result <= (others => '0');
                        result(0) <= '1'; -- Set bit 0 to 1 if equal
                    else
                        result <= (others => '0'); -- Otherwise all zeros
                    end if;

                when others =>
                    result <= (others => '0');
            end case;
        end if;
    end process;

end Behavioral;
