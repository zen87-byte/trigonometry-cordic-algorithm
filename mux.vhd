library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity mux is
	port( rst: in std_logic;
		mode_in: in std_logic_vector(2 downto 0);
		sin_in, cos_in, tan_in, inverse_in: in std_logic_vector( 31 downto 0 );
		mux_out: out std_logic_vector( 31 downto 0 )
		);
	end mux; 
	
architecture mux_arc of mux is
	begin
	process( rst, mode_in )
	begin
	if( rst = '1' ) then
		mux_out <= "00000000000000000000000000000000"; -- do nothing
	else
		if (mode_in = "001") then
			mux_out <= sin_in;
		elsif (mode_in = "010") then
			mux_out <= cos_in;
		elsif (mode_in = "011") then 
			mux_out <= tan_in;
		else 
			mux_out <= inverse_in;
		end if;
	end if;
	end process;
end mux_arc; 