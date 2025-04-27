library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_component is 
    Port (
      Rs : in STD_LOGIC_vector(1 downto 0); 				 
      Rt : in STD_LOGIC_vector(1 downto 0); 
      Rd : in STD_LOGIC_vector(1 downto 0); 
      write_data : in STD_LOGIC_vector(15 downto 0);
      write_en : in std_logic;
      clk : in std_logic;  				 
      --control : out STD_LOGIC_vector; 				 
      Rd1_out : out STD_LOGIC_vector(15 downto 0); 
      Rd2_out : out STD_LOGIC_vector(15 downto 0)
    ); 
end reg_component;

architecture behav of reg_component is
    type reg_array is array (0 to 3) of std_logic_vector(15 downto 0);
    signal registers : reg_array := (others => (others => '0'));

begin
    Rd1_out <= registers(to_integer(unsigned(Rs)));
    Rd2_out <= registers(to_integer(unsigned(Rt)));

    process(clk)
    begin
        if rising_edge(clk) then
            if write_en = '1' then
                registers(to_integer(unsigned(Rd))) <= write_data;
                end if;
            end if;
        end process;
end behav;