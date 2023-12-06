LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.STD_LOGIC_ARITH.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY mode_translator IS
 PORT(
  clk  : IN STD_LOGIC;
  huruf : IN STD_LOGIC_VECTOR ( 7 DOWNTO 0);
  mode : OUT STD_LOGIC_VECTOR ( 2 DOWNTO 0)
 );
END mode_translator;

ARCHITECTURE behavioral OF mode_translator IS 

SIGNAL clk_25MHz : STD_LOGIC;

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
 IF (huruf = "01110011") or (huruf = "01010011") THEN
  mode <= "001"; --s
 ELSIF (huruf = "01100011") or (huruf = "01000011") THEN
  mode <= "010"; --c
 ELSIF (huruf = "01110100") or (huruf = "01010100") THEN
  mode <= "011"; --t
 ELSIF (huruf = "01100001") or (huruf = "01000001") THEN
  mode <= "100"; --a
 ELSIF (huruf = "01100010") or (huruf = "01000010") THEN
  mode <= "101"; --b
 END IF;
END PROCESS;

END behavioral;