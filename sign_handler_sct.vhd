LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.STD_LOGIC_ARITH.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY sign_handler_sct IS
	PORT(
		clk		: IN STD_LOGIC;
        mode  : IN STD_LOGIC_VECTOR ( 2 DOWNTO 0);
        kuadran : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        sign_in : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		sign_out	: OUT STD_LOGIC_VECTOR ( 7 DOWNTO 0 )
	);
END sign_handler_sct;

ARCHITECTURE behavioral OF sign_handler_sct IS

SIGNAL clk_25MHz	: STD_LOGIC;
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
	IF (mode = "001") THEN
		IF (kuadran = "10") or (kuadran = "11") then
            IF (sign = "00101011") then
                sign_out <= "00101101";
            ELSIF (sign = "00101101") then
                sign_out <= "00101011";
            end if;
        end if;
	ELSIF (mode = "010") THEN
		if (kuadran = "01") or (kuadran ="10") then
            sign_out <= "00101101";
        else
            sign_out <= "00101011";
        end if;
	ELSIF (mode = "011") THEN
		if (kuadran = "01") or (kuadran = "11") then
            if (sign = "00101011") then
                sign_out <= "00101101";
            else
                sign_out <= "00101011";
            end if;
        end if;
	END IF;
END PROCESS;

END behavioral;