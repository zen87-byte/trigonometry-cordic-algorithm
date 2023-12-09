LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.STD_LOGIC_ARITH.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY sign_handler_ab IS
	PORT(
		clk		: IN STD_LOGIC;
		theta_in	: IN STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
        mode  : IN STD_LOGIC_VECTOR ( 2 DOWNTO 0);
        sign_in : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		theta_out	: OUT STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
		sign_out	: OUT STD_LOGIC_VECTOR ( 7 DOWNTO 0 )
	);
END sign_handler_ab;

ARCHITECTURE behavioral OF sign_handler_ab IS

SIGNAL clk_25MHz	: STD_LOGIC;
SIGNAL theta        : STD_LOGIC_VECTOR ( 7 DOWNTO 0 );
SIGNAL sign         : STD_LOGIC_VECTOR ( 7 DOWNTO 0 );

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
    sign <= sign_in;
    theta <= theta_in(31 downto 24);
    IF (mode = "101") THEN
		if (sign = "00101101") then
                theta <= theta + 180;
        end if;
	END IF;
    sign_out <= sign;
    theta_out <= theta & theta_in(23 downto 0);
END PROCESS;

END behavioral;