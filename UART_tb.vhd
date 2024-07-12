library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

entity UART_tb is
end UART_tb;

architecture test of UART_tb is

	component UART
		 port(
			KEY : in std_logic_vector(3 downto 0);  -- pushbutton switches
			SW : in std_logic_vector(17 downto 0);  -- slide switches
			CLOCK_50 : in std_logic;
			UART_CTS : in std_logic;
			LEDG : out std_logic_vector(7 downto 0); -- green LED's
			LEDR : out std_logic_vector(7 downto 0);													
			UART_TXD : OUT STD_LOGIC;
			UART_RTS : OUT STD_LOGIC); 
	end component;

	signal clk :  std_logic := '1';
	signal KEY :  std_logic_vector(3 downto 0) := "1111";
	signal SW :  std_logic_vector(17 downto 0) := "001000000000000000"; 
	signal UART_RXD : std_logic := '1'; 
	signal UART_CTS : std_logic := '0';
	signal LEDG :  std_logic_vector(7 downto 0) := (others => '0');
	signal LEDR :  std_logic_vector(7 downto 0) := (others => '0');
	signal UART_TXD : std_logic;
	signal UART_RTS : std_logic;

begin

	dut : UART
		 port map( CLOCK_50 => clk, KEY => KEY, SW => SW, UART_CTS => UART_CTS, LEDG => LEDG, LEDR => LEDR, UART_TXD => UART_TXD, UART_RTS => UART_RTS);
		
	process
	begin
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
	end process;	 
		 
	process is
	begin
		
		-- CLK 0
		SW(15) <= '0';
		UART_CTS <= '0';
		KEY(0) <= '1'; 
		SW(7 downto 0) <= "01100001";
		wait for 10 ns;
		SW(15) <= '1';
		wait for 10 ns;
		SW(15) <= '0';
		wait for 50 ns;
		
		
		
		-- CLK 1
		UART_CTS <= '1';
		SW(7 downto 0) <= "01100001";
		SW(15) <= '1';
		wait for 5 ns;
		SW(15) <= '0';
		wait for 1.042 ms;
		
		wait for 0.052 ms;
		
		UART_CTS <= '1';
		wait for 10 ns;
		KEY(0) <= '0';
		wait for 10 ns;
		KEY(0) <= '1';
		SW(7 downto 0) <= "01100001";
		wait for 20 ns;
		
		-- CLK 0
		UART_CTS <= '1';
		KEY(0) <= '1';
		wait for 20 ns;
		
		-- CLK 1
		wait for 20 ns;
		wait;
	
	end process; 
end test;
