library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

entity baudGenerator_tb is
end baudGenerator_tb ;

architecture test of baudGenerator_tb is

	component baudGenerator
		 port(
		  clk : in std_logic;
		  resetn : in std_logic;
		  baud_pulse_out : out std_logic);
	end component;

	signal clk :  std_logic := '1';
	signal resetn : std_logic := '1';
	signal baud_pulse_out : std_logic := '1'; 

begin

	dut : baudGenerator
		 port map( clk=>clk, resetn=>resetn, baud_pulse_out=>baud_pulse_out);

	process
	begin
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
	end process;	 
		 
	process
   begin
       resetn <= '0'; -- Deassert reset
       wait for 10 ns;
       resetn <= '1'; -- Assert reset
		 wait for 10 ns;
		 resetn <= '0';
       wait for 50 ns; -- Wait for system stabilization
		 
		 resetn <= '1';
		 wait for 5 ns;
		 resetn <= '0';
		 wait for 1.042 ms;
       -- You can add more stimulus here if needed
        
       wait;
   end process; 
end test;
