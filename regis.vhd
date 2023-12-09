library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity regis is
	port( rst, clk: in std_logic;
	input: in std_logic_vector( 31 downto 0 );
	output: out std_logic_vector( 31 downto 0 )
);
end regis;

architecture regis_arc of regis is
	begin
		process( rst, clk, input )
	begin
		if( rst = '1' ) then
			output <= (others => '0');
		elsif( clk'event and clk = '1') then
				output <= input;
		end if;
	end process;
end regis_arc; 