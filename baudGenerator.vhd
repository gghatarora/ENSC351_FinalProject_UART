library ieee;
use ieee.std_logic_1164.all;

entity baudGenerator is
	port(
		  clk : in std_logic;
		  resetn : in std_logic;
		  baud_pulse_out : out std_logic);
end baudGenerator;

architecture behavioural of baudGenerator is

	signal baud_rate	: integer := 19200;
	signal baud_pulse : std_logic := '0'; -- will pulse every baud period 




begin
	process(resetn, clk)
	
		variable baud_period		: integer range 0 to 50000000/baud_rate-1 := 0; 
		
		begin
			if (resetn = '1') then
				baud_pulse <= '0';                                					-- set baud pulse to 0
				baud_period := 0;                                 					-- reset baud period counter
			
			elsif (rising_edge(clk)) then
										
								if (baud_period < 50000000/baud_rate-1) then       -- while counter is less than baud period, means we're still within a period.
								  baud_period := baud_period + 1;                  -- increment counter
								  baud_pulse <= '0';                               -- make sure pulse is 0 still
								  baud_pulse_out <= baud_pulse;							-- link to output signal
								  
								else                                               -- we hit baud period
								  baud_period := 0;                                -- reset counter
								  baud_pulse <= '1';                               -- send a pulse
								  baud_pulse_out <= baud_pulse;							-- link to output signal
								end if;
			  end if;
	end process;



end behavioural;