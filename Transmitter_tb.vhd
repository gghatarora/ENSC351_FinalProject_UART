library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

entity Transmitter_tb is
end Transmitter_tb;

architecture test of Transmitter_tb is

	component Transmitter
		 port(tx_en	: in std_logic;  -- key 0
				tx_data : in std_logic_vector(7 downto 0);  -- connect to switches
				baud_pulse : in std_logic;
				resetn : in std_logic;
				clk : in std_logic;
				cts : in std_logic;
				rts : out std_logic;
				tx_busy : out std_logic;
				tx : out std_logic);
	end component;

	signal clk :  std_logic := '1';
	signal resetn :  std_logic := '0';
	signal tx_en :  std_logic := '1'; 
	signal tx_data : std_logic_vector(7 downto 0) := (others => '0'); 
	signal tx :  std_logic := '1';  
	signal tx_busy :  std_logic := '0';
	signal baud_pulse : std_logic;
	signal cts : std_logic;
	signal rts : std_logic := '1';

begin

	dut : Transmitter
		 port map( clk=>clk, resetn=>resetn, tx_data=>tx_data, tx_en=>tx_en, tx=>tx, tx_busy=>tx_busy, baud_pulse=>baud_pulse, cts => cts, rts => rts);

	process
	begin
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
	end process;	 
		 
	process is
	begin
		
		baud_pulse <= '1';
		cts <= '0';
		tx_en <= '1'; 
		tx_data <= "01100001";
		wait for 20 ns;
		
		cts <= '0';
		tx_en <= '1';
		tx_data <= "01100001";
		wait for 20 ns;
		
		cts <= '1';
		tx_en <= '0';
		tx_data <= "01100001";
		wait for 20 ns;
		
		cts <= '1';
		tx_en <= '1';
		tx_data <= "01100001";
		wait for 20 ns;
		
		cts <= '1';
		tx_en <= '1';
		tx_data <= "01100001";
		wait for 20 ns;
		
		cts <= '1';
		tx_en <= '0';
		wait for 10 ns;
		tx_en <= '1';
		tx_data <= "01100001";
		wait for 250 ns;
		
		wait for 10 ns;
		
		cts <= '1';
		tx_en <= '0';
		wait for 10 ns;
		tx_en <= '1';
		tx_data <= "01100001";
		wait for 20 ns;
		
		cts <= '0';
		tx_en <= '1';
		resetn <= '1';
		wait for 20 ns;
		
		resetn <= '0';
		wait for 20 ns;
		wait;
	
	end process; 
end test;
