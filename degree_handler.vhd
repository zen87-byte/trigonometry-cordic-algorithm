LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.STD_LOGIC_ARITH.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY degree_handler IS
	PORT(
		clk		: IN STD_LOGIC;
		theta_1	: IN STD_LOGIC_VECTOR ( 8 DOWNTO 0 );
		theta_2	: OUT STD_LOGIC_VECTOR ( 8 DOWNTO 0 );
		kuadran	: OUT STD_LOGIC_VECTOR ( 2 DOWNTO 0 )
	);
END degree_handler;

ARCHITECTURE behavioral OF degree_handler IS

SIGNAL clk_25MHz	: STD_LOGIC;
SIGNAL theta		: STD_LOGIC_VECTOR ( 8 DOWNTO 0 );


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
	IF (theta_1 >= 0) AND (theta_1 <= 90) THEN 
		kuadran <= "001";
	ELSIF (theta_1 > 90) AND (theta_1 <= 180) THEN
		kuadran <= "010";
	ELSIF (theta_1 > 180) AND (theta_1 <= 270) THEN
		kuadran <= "011";
	ELSE
		kuadran <= "100";
	END IF;
END PROCESS;

PROCESS
BEGIN
	theta <= theta_1;
	WAIT UNTIL( clk_25MHz'EVENT ) AND ( clk_25MHz = '1' );
	IF (theta > 180) THEN
		theta <= theta - 180;
	ELSIF (theta > 90) THEN
		theta <= 180 - theta;
	ELSE
		theta_2 <= theta;
	END IF;
END PROCESS;

END behavioral;