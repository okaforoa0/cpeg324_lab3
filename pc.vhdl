-- PROGRAM COUNTER

library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ProgramCounter is 
    Port (
            clk : in std_logic;
            reset : in std_logic;
            sel : in std_logic;
            PC_out: out std_logic_vector(15 downto 0)
    );
end ProgramCounter;

architecture Behavioral of ProgramCounter is 
    signal PC : unsigned(15 downto 0) := (others <= '0');
    signal Pc_next : unsigned(15 downto 0);
begin
    -- this handles the next PC logic with MUX and adder
    process( sel, PC)
    begin 
        if sel = '0' then 
            PC_next <= PC + 4;
        else 
            PC_next <= PC + 8;
        end if;
    end process; 
    
   -- pc register with reset
   process(clk)
   begin
        if rising_edge(clk) then
            if reset = '1' then
                PC <= (others => '0');
            else 
                PC <= PC_next;
            end if;
        end if;
    end process;
    
    Pc_out <= std_logic_vector(PC);
end Behavioral;     


