LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.STD_LOGIC_ARITH.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY degree_handler IS
	PORT(
		clk			: IN STD_LOGIC;
		theta_in	: IN STD_LOGIC_VECTOR ( 8 DOWNTO 0 );
		theta_out	: OUT STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
		kuadran		: OUT STD_LOGIC_VECTOR ( 1 DOWNTO 0 )
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
	IF (theta_in >= 0) AND (theta_in <= 90) THEN 
		kuadran <= "00";
	ELSIF (theta_in > 90) AND (theta_in <= 180) THEN
		kuadran <= "01";
	ELSIF (theta_in > 180) AND (theta_in <= 270) THEN
		kuadran <= "11";
	ELSE
		kuadran <= "10";
	END IF;
END PROCESS;

PROCESS
BEGIN
	theta <= theta_in;
	WAIT UNTIL( clk_25MHz'EVENT ) AND ( clk_25MHz = '1' );
	IF (theta > 180) THEN
		theta <= theta - 180;
	ELSIF (theta > 90) THEN
		theta <= 180 - theta;
	ELSE
		theta_out <= theta(7 downto 0) & "000000000000000000000000";
	END IF;
END PROCESS;

END behavioral;