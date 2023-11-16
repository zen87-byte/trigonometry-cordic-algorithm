LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.STD_LOGIC_ARITH.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY selektor IS
	PORT(
		clk		: IN STD_LOGIC;
		mode	: IN STD_LOGIC_VECTOR ( 3 DOWNTO 0 );
		s		: OUT STD_LOGIC;
		c		: OUT STD_LOGIC;
		t		: OUT STD_LOGIC;
		a		: OUT STD_LOGIC;
		b		: OUT STD_LOGIC
	);
END selektor;

ARCHITECTURE behavioral OF selektor IS

SIGNAL clk_25MHz	: STD_LOGIC;

BEGIN

PROCESS (clk)
BEGIN
	IF clk'EVENT AND clk='1'THEN
		IF (clk_25MHz = '0') THEN
			clk_25MHz <= '1';
		ELSE
			clk_25MHz <= '0';
		END IF;
	END IF;
END PROCESS;

PROCESS
BEGIN
	WAIT UNTIL( clk_25MHz'EVENT ) AND ( clk_25MHz = '1' );
	IF (mode = "001") THEN
		s <= '1';
	ELSIF (mode = "010") THEN
		c <= '1';
		s <= '0';
	ELSIF (mode = "011") THEN
		t <= '1';
		s <= '0';
	ELSIF (mode = "100") THEN
		a <= '1';
		s <= '0';
	ELSIF (mode = "101") THEN
		b <= '1';
		s <= '0';
	END IF;
END PROCESS;

END behavioral;