--Authors: 
--Gurnek Ghatarora (301394646)
--Akash Mahli	(301393341)
--Referenced code for all components from DigiKey: https://forum.digikey.com/t/uart-vhdl/12670

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART is
	port(
		KEY : in std_logic_vector(3 downto 0);  -- pushbutton switches
      SW : in std_logic_vector(17 downto 0);  -- slide switches
		CLOCK_50 : in std_logic;
		UART_CTS : in std_logic;
		
      LEDG : out std_logic_vector(7 downto 0); -- green LED's
		LEDR : out std_logic_vector(7 downto 0); -- keeps track of the number of characters printed													 
		
		UART_TXD : out std_logic;
		UART_RTS : out std_logic);  -- used to send instructions or characters
		
end UART;

architecture behavioural of UART is

	component baudGenerator
		port(
		  clk : in std_logic;
		  resetn : in std_logic;
		  baud_pulse_out : out std_logic);
	end component;

	component Transmitter
		port(tx_en	: in std_logic;  						  -- key 0
			tx_data : in std_logic_vector(7 downto 0);  -- connect to switches 7 to 0
			baud_pulse : in std_logic;
			resetn : in std_logic;
			clk : in std_logic;
			cts : in std_logic;
			rts : out std_logic;
			tx_busy : out std_logic;
			tx : out std_logic );
	end component;

	
	signal baud_rate	: integer := 19200;
	signal data_bits	: integer := 8;
	signal baud_pulse_sig : std_logic;

	
begin
	LEDR <= SW(7 downto 0);
	
	trans : Transmitter
	port map(tx_en => KEY(0), tx_data => SW(7 downto 0), baud_pulse => baud_pulse_sig, resetn => SW(15), clk => CLOCK_50, tx_busy => LEDG(0), tx => UART_TXD, cts => UART_CTS, rts => UART_RTS);
	
	baudGen : baudGenerator
	port map(clk => CLOCK_50, resetn => Sw(15), baud_pulse_out => baud_pulse_sig);
	



end behavioural;