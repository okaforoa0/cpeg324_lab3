library ieee;
use ieee.std_logic_1164.all;

--declare entity
entity addsub4bit is

	port(	a: in std_logic_vector(3 downto 0);
		b: in std_logic_vector(3 downto 0);
		sub: in std_logic;
		s: out std_logic_vector(3 downto 0);
		over: out std_logic;
		under: out std_logic
	);

end entity addsub4bit;

--behavioral architecture
architecture behav of addsub4bit is

	--declare full adder comp
	component full_adder

		port(	a: in std_logic;
			b: in std_logic;
			cin: in std_logic;
			sum: out std_logic;
			cout: out std_logic
		);

	end component;

	--internal signals used
	signal newb0, newb1, newb2, newb3, c1, c2, c3, c4, sig_bit: std_logic;

	begin
	--xor the bits of 'b' with 'sub' signal to see if subtraction is needed
	newb0 <= b(0) xor sub;
	newb1 <= b(1) xor sub;
	newb2 <= b(2) xor sub;
	newb3 <= b(3) xor sub;

	--instantiate 4 full adders to perform addition or subtraction

	--first bit
	fa0: full_adder port map(	a => a(0),
					b => newb0,
					cin => sub,
					sum => s(0),
					cout => c1);
	--second bit
	fa1: full_adder port map(	a => a(1),
					b => newb1,
					cin => c1,
					sum => s(1),
					cout => c2);
	--third bit
	fa2: full_adder port map(	a => a(2),
					b => newb2,
					cin => c2,
					sum => s(2),
					cout => c3);
	--fourth bit
	fa3: full_adder port map(	a => a(3),
					b => newb3,
					cin => c3,
					sum => sig_bit,
					cout => c4);

	--underflow detection
	under <= (not sig_bit and c4 and a(3) and newb3);
	--overflow detection
	over <= (not a(3) and not b(3)) and sig_bit;
	--most sig bit of the result is assigned from the signal 'sig_bit'
	s(3) <= sig_bit; 

end behav;