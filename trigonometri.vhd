LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.STD_LOGIC_ARITH.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;

entity trigonometri is
    port(
        clk, rst, go_i : in std_logic;
        mode_in : IN STD_LOGIC_VECTOR ( 7 DOWNTO 0);
        sign_in: in std_logic_vector(7 downto 0);
		number_in_sct: in std_logic_vector(8 downto 0);
		number_in_ab: in std_logic_vector(31 downto 0);
        output: out std_logic_vector(31 downto 0)
    );
end trigonometri;

architecture toplevel_arc of trigonometri is

    component mode_translator is
        PORT(
            clk  : IN STD_LOGIC;
            huruf : IN STD_LOGIC_VECTOR ( 7 DOWNTO 0);
            mode : OUT STD_LOGIC_VECTOR ( 2 DOWNTO 0)
        );
    END component;

    component degree_handler IS
	PORT(
		clk		: IN STD_LOGIC;
		theta_in	: IN STD_LOGIC_VECTOR ( 8 DOWNTO 0 );
		theta_out	: OUT STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
		kuadran	: OUT STD_LOGIC_VECTOR ( 1 DOWNTO 0 )
	);
    END component;

    component sign_handler_sct IS
	PORT(
		clk		: IN STD_LOGIC;
        mode  : IN STD_LOGIC_VECTOR ( 2 DOWNTO 0);
        kuadran : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        sign_in : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		sign_out	: OUT STD_LOGIC_VECTOR ( 7 DOWNTO 0 )
	);
    END component;

    component sign_handler_ab IS
	PORT(
		clk		: IN STD_LOGIC;
		theta_in	: IN STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
        mode  : IN STD_LOGIC_VECTOR ( 2 DOWNTO 0);
        sign_in : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		theta_out	: OUT STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
		sign_out	: OUT STD_LOGIC_VECTOR ( 7 DOWNTO 0 )
	);
    END component;

    component tan_lut is
    port (  clk  : IN STD_LOGIC;
        deg_in: in std_logic_vector(31 downto 0);
        tan_out: out std_logic_vector(31 downto 0)
    );
    end component;

    component arcsin is
        port( 
            rst, clk, enable: in std_logic;
            mode: in std_logic_vector(2 downto 0);
            inverse_theta: in std_logic_vector(31 downto 0); -- blm dipake, testing make T init biar gampang
            theta_out: out std_logic_vector(31 downto 0)
        );
    end component;
	
	component sincos is
        port( 
			rst, clk, enable: in std_logic;
			theta: in std_logic_vector(31 downto 0);
			sin_out, cos_out: out std_logic_vector(31 downto 0)
    );
    end component;
	
	component mux is
	port( rst: in std_logic;
		mode_in: in std_logic_vector(2 downto 0);
		sin_in, cos_in, tan_in, inverse_in: in std_logic_vector( 31 downto 0 );
		mux_out: out std_logic_vector( 31 downto 0 )
		);
	end component; 
	
	component regis is
		port( rst, clk: in std_logic;
			input: in std_logic_vector( 31 downto 0 );
			output: out std_logic_vector( 31 downto 0 )
		);
	end component;
	
	signal sincosld, inverseld: std_logic;
	signal hkuadran_out: std_logic_vector(1 downto 0);
	signal trans_out: std_logic_vector(2 downto 0);
	signal sign_out: std_logic_vector(7 downto 0);
	signal htheta_out: std_logic_vector(31 downto 0);
	signal sin_out, cos_out, tan_out, inverse_out, theta_sign_out, mux_out, result: std_logic_vector(31 downto 0);
	signal enable: std_logic := '1';
	
	begin
	MODE_TRANS: mode_translator port map(clk, mode_in, trans_out);
	
	DEG_HANDLER: degree_handler port map(clk, number_in_sct, htheta_out, hkuadran_out);
	 
	X_SINCOS: sincos port map(rst, clk, enable, htheta_out, sin_out, cos_out);
	TAN: tan_lut port map(clk, htheta_out, tan_out);
	INVERSE: arcsin port map(rst, clk, enable, trans_out, number_in_ab, inverse_out);
	
	SINCOS_SIGN_HANDLER: sign_handler_sct port map(clk, trans_out, hkuadran_out, sign_in, sign_out);
	INVERSE_SIGN_HANDLER: sign_handler_ab port map(clk, inverse_out, trans_out, sign_in, theta_sign_out, sign_out);
	
	OUT_MUX: mux port map(rst, trans_out, sin_out, cos_out, tan_out, inverse_out, mux_out);
	SINCOS_OUTREG: regis port map (rst, clk, mux_out, result);
	
	output <= result; 
    end toplevel_arc;

