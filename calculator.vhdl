--declare headers
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        instr   : in  std_logic_vector(7 downto 0);
        digits_out : out std_logic_vector(15 downto 0)
    );
end calculator;

architecture Behavioral of calculator is

    -- signals between modules
    signal alu_result : std_logic_vector(15 downto 0) := (others => '0');
    signal rd1, rd2   : std_logic_vector(15 downto 0) := (others => '0');
    signal write_data : std_logic_vector(15 downto 0) := (others => '0');
    signal alu_op     : std_logic_vector(1 downto 0) := (others => '0');
    signal a_mux_sel  : std_logic := '0';
    signal b_mux_sel  : std_logic := '0';
    signal print_en   : std_logic := '0';
    signal skip       : std_logic := '0';
    signal we         : std_logic := '0';
    signal pc_value   : std_logic_vector(7 downto 0) := (others => '0');
    signal immediate_extended : std_logic_vector(15 downto 0) := (others => '0');
    signal mux_output : std_logic_vector(15 downto 0) := (others => '0');
    signal instr_internal : std_logic_vector(7 downto 0) := (others => '0');
    --signal instr_for_alu : std_logic_vector(7 downto 0) := (others => '0');




    -- for immediate extension
    component sign_extend4to16
        port (
            input_4bit  : in std_logic_vector(3 downto 0);
            output_16bit : out std_logic_vector(15 downto 0)
        );
    end component;

    --controller comp
    component controller
        port (
            op            : in  std_logic_vector(1 downto 0);
            control       : in  std_logic;
            ALU_result    : in  std_logic_vector(15 downto 0);
            --clk           : in  std_logic;
            alu_op        : out std_logic_vector(1 downto 0);
            a_mux         : out std_logic;
            b_mux         : out std_logic;
            print_control : out std_logic;
            skip_control  : out std_logic;
            write_control : out std_logic
        );
    end component;

    --reg comp
    component reg_component
        port (
            Rs : in std_logic_vector(1 downto 0);
            Rt : in std_logic_vector(1 downto 0);
            Rd : in std_logic_vector(1 downto 0);
            write_data : in std_logic_vector(15 downto 0);
            write_en : in std_logic;
            clk : in std_logic;
            Rd1_out : out std_logic_vector(15 downto 0);
            Rd2_out : out std_logic_vector(15 downto 0)
        );
    end component;

    -- main alu comp
    component main_alu
        port (
            A       : in std_logic_vector(15 downto 0);
            B       : in std_logic_vector(15 downto 0);
            clk     : in std_logic;
            control : in std_logic_vector(1 downto 0);
            result  : out std_logic_vector(15 downto 0)
        );
    end component;

    -- pc comp
    component pc
        port (
            clk : in std_logic;
            reset : in std_logic;
            skip : in std_logic;
            pc_out : out std_logic_vector(7 downto 0)
        );
    end component;

    -- print mod comp
    component print_module
        port (
            data_in      : in std_logic_vector(15 downto 0);
            print_enable : in std_logic;
            digits_out   : out std_logic_vector(15 downto 0)
        );
    end component;

begin

    --feed instr_internal sig to instr
    process(clk)
    begin
        if rising_edge(clk) then
            instr_internal <= instr;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            write_data <= alu_result;
        end if;
    end process;

    

    -- sign extend immediate 4-bit to 16-bit
    se_block: sign_extend4to16
        port map (
            input_4bit => instr_internal(3 downto 0),
            output_16bit => immediate_extended
        );

    -- Fill upper 8 bits with zeros
    --immediate_extended(15 downto 8) <= (others => '0');

    -- controller
    control_unit: controller
        port map (
            op            => instr_internal(7 downto 6),
            control       => instr_internal(3),
            ALU_result    => alu_result,
            --clk           => clk,
            alu_op        => alu_op,
            a_mux         => a_mux_sel,
            b_mux         => b_mux_sel,
            print_control => print_en,
            skip_control  => skip,
            write_control => we
        );

    -- Register File
    reg_file: reg_component
        port map (
            Rs => instr_internal(5 downto 4),
            Rt => instr_internal(3 downto 2),
            Rd => instr_internal(1 downto 0),
            write_data => alu_result,
            write_en => we,
            clk => clk,
            Rd1_out => rd1,
            Rd2_out => rd2
        );

    -- MUX for ALU input
    mux_output <= rd1 when a_mux_sel = '1' else immediate_extended;

    -- ALU
    alu: main_alu
        port map (
            A => mux_output,
            B => rd2,
            clk => clk,
            control => alu_op,
            result => alu_result
        );

    -- PC
    program_counter: pc
        port map (
            clk => clk,
            reset => reset,
            skip => skip,
            pc_out => pc_value
        );

    -- print mod
    printer: print_module
        port map (
            data_in => alu_result,
            print_enable => print_en,
            digits_out => digits_out
        );

end Behavioral;
