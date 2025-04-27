library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_component_tb is 
end reg_component_tb;

architecture behav of reg_component_tb is 

    component reg_component
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
    end component;

    signal Rs_tb, Rt_tb, Rd_tb : std_logic_vector(1 downto 0);
    signal write_data_tb : std_logic_vector(15 downto 0);
    signal write_en_tb : std_logic;
    signal clk_tb : std_logic := '0';
    signal Rd1_out_tb : std_logic_vector(15 downto 0);
    signal Rd2_out_tb : std_logic_vector(15 downto 0);

 begin 
 
    uut: reg_component
    port map (
        Rs => Rs_tb,				 
        Rt => Rt_tb,
        Rd => Rd_tb,
        write_data => write_data_tb,	
        write_en => write_en_tb,
        clk => clk_tb,			 
        --control => write_en_tb, 				 
        Rd1_out => Rd1_out_tb, 
        Rd2_out => Rd2_out_tb
    );    

    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for 5 ns;
            clk_tb <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Stimulus process
    stimulus : process
    begin
        -- Initially no write
        write_en_tb <= '0';
        write_data_tb <= (others => '0');
        Rd_tb <= "00";
        Rs_tb <= "00";
        Rt_tb <= "00";
        wait for 0 ns;

        -- Write 0x1234 into register 0
        write_data_tb <= x"1234";
        Rd_tb <= "00";
        write_en_tb <= '1';
        wait for 10 ns;

        -- Write 0x5678 into register 1
        write_data_tb <= x"5678";
        Rd_tb <= "01";
        write_en_tb <= '1';
        wait for 10 ns;

        -- Disable write
        write_en_tb <= '0';

        -- Read register 0 and register 1
        Rs_tb <= "00"; -- Read reg0
        Rt_tb <= "01"; -- Read reg1
        wait for 10 ns;

        -- Check outputs
        assert (Rd1_out_tb = x"1234") report "Register 0 read wrong" severity error;
        assert (Rd2_out_tb = x"5678") report "Register 1 read wrong" severity error;

        -- Done
        assert false report "End of register file testbench" severity note;
        wait;
    end process;

end behav;
