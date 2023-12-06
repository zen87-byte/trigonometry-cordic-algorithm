library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;

entity arcsin is
    port( 
        rst, clk, enable: in std_logic;
        mode: in std_logic_vector(2 downto 0);
        inverse_theta: in std_logic_vector(31 downto 0);
		theta_out: out std_logic_vector(31 downto 0)
    );
end arcsin;

architecture behavioral of arcsin is
	function arctan(iteration: integer) return std_logic_vector is
		variable tan_out: std_logic_vector(31 downto 0);
		begin
		case iteration is
		-- tan_out <= 8 bit integer & 24 bit fractional
		when 0 => tan_out := "00101101000000000000000000000000";
		when 1 => tan_out := "00011010100100001010001111010000";
		when 2 => tan_out := "00001110000010010011011101010000";
		when 3 => tan_out := "00000111001000000000000000000000";
		when 4 => tan_out := "00000011100100110111010011000000";
		when 5 => tan_out := "00000001110010100011110101110000";
		when 6 => tan_out := "00000000111001010001111011000000";
		when 7 => tan_out := "00000000011100101011000000100000";
		when 8 => tan_out := "00000000001110010101100000010000";
		when 9 => tan_out := "00000000000111001010110000010000";
		when 10 => tan_out := "00000000000011100101011000000000";
		when 11 => tan_out := "00000000000001110010101100000000";
		when 12 => tan_out := "00000000000000111001010110000000";
		when 13 => tan_out := "00000000000000011100101011000000";
		when 14 => tan_out := "00000000000000001110010101100000";
		when others => tan_out := (others => '0');
		end case;
	return tan_out;
	end function;
	
	-- 1 bit shifter
	function shift(n: integer; shift_in: std_logic_vector(31 downto 0)) return std_logic_vector is
        variable fshift_out: std_logic_vector(31 downto 0) := (others => '0');
    begin
        for i in 0 to 31 loop
            if i + n < 32 then
                fshift_out(i) := shift_in(i + n);
            end if;
        end loop;
        return fshift_out;
    end function;

	-- 2 bit shifter
	function Tshift(n: integer; shift_in: std_logic_vector(31 downto 0)) return std_logic_vector is
        variable fshift_out: std_logic_vector(31 downto 0) := (others => '0');
        variable tn: integer := n + n + 1;
    begin
        for i in 0 to 31 loop
            if i + tn < 32 then
                fshift_out(i) := shift_in(i + tn);
            end if;
        end loop;
        return fshift_out;
    end function;

	
-- Signal Temporary shifter
signal xshift_temp: std_logic_vector(31 downto 0) := (Others => '0');
signal yshift_temp: std_logic_vector(31 downto 0) := (Others => '0');
signal zshift_temp: std_logic_vector(31 downto 0) := (Others => '0');
signal Tshift_temp: std_logic_vector(31 downto 0) := (Others => '0');

-- Signal temporary addder
signal xadd_temp: std_logic_vector(31 downto 0) := (Others => '0');
signal yadd_temp: std_logic_vector(31 downto 0) := (Others => '0');
signal zadd_temp: std_logic_vector(31 downto 0) := (Others => '0');
signal Tadd_temp: std_logic_vector(31 downto 0) := (Others => '0');

-- Initial value
constant xinit: std_logic_vector(31 downto 0) := "00000001000100010110100001110000"; -- 1.06799983978271484375
constant yinit: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
constant zinit: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

-- Signal left and right side comparation
signal ls_comp, rs_comp: std_logic_vector(31 downto 0);

-- Declare fsm
TYPE POSSIBLE_STATES IS (waiting, shifting, adding, subtracting, comparing, change_comp);
signal state : POSSIBLE_STATES;

begin
    process(rst, clk)
        variable count: integer := 0;
	begin
    if(rst = '1') then
      xshift_temp <= (others => '0');  
      yshift_temp <= (others => '0');   
      zshift_temp <= (others => '0');    
      state <= waiting;
      count := 0;
	elsif(clk'event and clk='1') then
        case state is
            when waiting =>
                count := 0;
                
                xadd_temp <= xinit;
                yadd_temp <= yinit;
                zadd_temp <= zinit;
                Tadd_temp <= inverse_theta;
                
                xshift_temp <= (others => '0');  
				yshift_temp <= (others => '0');   
				zshift_temp <= (others => '0');   
				Tshift_temp <= (others => '0');   
				
                if(enable = '1') then
                    state <= change_comp;
                else
                    state <= waiting;
                end if;
            when change_comp =>
				if (mode = "100") then -- arcsin
					if (count = 0) then 
						ls_comp <= yinit;
						rs_comp <= Tadd_temp;
						state <= shifting;
					else
						ls_comp <= yadd_temp;
						rs_comp <= Tadd_temp;
						state <= shifting;
					end if;
				elsif (mode = "101") then -- arccos
					if (count = 0) then 
						ls_comp <= Tadd_temp;
						rs_comp <= xinit;
						state <= shifting;
					else
						ls_comp <= Tadd_temp;
						rs_comp <= xadd_temp;
						state <= shifting;
					end if;
				end if;
            when shifting =>
                xshift_temp <= shift(count, xadd_temp);
                yshift_temp <= shift(count, yadd_temp);
                Tshift_temp <= Tshift(count, Tadd_temp);
                state <= comparing;
             when comparing =>
				if (ls_comp < rs_comp) then -- d = 1
					state <= adding;
				else -- d = -1
					state <= subtracting;
				end if;
             when adding => -- counter clockwise
                xadd_temp <= xadd_temp - yshift_temp;
                yadd_temp <= yadd_temp + xshift_temp;
                zadd_temp <= zadd_temp + arctan(count);
                Tadd_temp <= Tadd_temp + Tshift_temp;
				if (count >= 13) then
                    theta_out <= zadd_temp;
                    state <= waiting;
                else
                    count := count + 1;
                    theta_out <= zadd_temp;
                    state <= change_comp;
                end if;
             when subtracting => -- clockwise
                xadd_temp <= xadd_temp + yshift_temp;
                yadd_temp <= yadd_temp - xshift_temp;
                zadd_temp <= zadd_temp - arctan(count);
                Tadd_temp <= Tadd_temp + Tshift_temp;
				if (count >= 13) then
                    theta_out <= zadd_temp;
                    state <= waiting;
                else
                    count := count + 1;
                    state <= change_comp;
                end if; 
        end case;
    end if;
    end process;
end behavioral;
