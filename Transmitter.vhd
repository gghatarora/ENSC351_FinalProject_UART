library ieee;
use ieee.std_logic_1164.all;

entity Transmitter is
	port( tx_en	: in std_logic;  							  -- key 0
			tx_data : in std_logic_vector(7 downto 0);  -- connect to switches 7 to 0
			baud_pulse : in std_logic;
			resetn : in std_logic;
			clk : in std_logic;
			cts : in std_logic;
			rts : out std_logic;
			tx_busy : out std_logic;
			tx : out std_logic );
end Transmitter;


architecture behavioural of Transmitter is
	type state_type is (Idle, Transmit);
	signal state : state_type := Idle;
	
	--signals just to hold constant values.
	signal baud_rate		: integer := 19200;
	signal data_bits		: integer := 8;
	
	signal parity			: integer := 1; -- set if we want to use parity (1) or not(0).
	signal parity_eo  	: std_logic := '0'; -- '0' even, '1' odd parity
   signal parity_error 	: std_logic := '0'; -- error flag; '0' = no error, '1' = error;
	
   signal tx_parity    	: std_logic_vector(data_bits downto 0) := (others => '0');  -- holds transmit parity 9 bits (1 for even/odd parity bit, 8 for data)
   signal tx_buffer    	: std_logic_vector(parity+data_bits+1 downto 0) := (others => '1'); -- holds bits being transmitted  11 bits (1 bit for parity, 2 bits for start/stop, 8 bits for data). init to all 1's

	
begin



	process (resetn, clk)
			
			variable tbits_count : integer range 0 to parity+data_bits+3 := 0; -- counter to keep track of which bit is being sent from the buffer.
			
			begin 
				if (resetn = '1') then
					tbits_count := 0;               --reset counter
					tx <= '1';                      --default tx to 1
					tx_busy <= '1';                 --while resetting we should not be able to transmit so set busy to 1
					state <= idle;                  --go to idle state
					
				elsif (rising_edge(clk)) then
					
					case state is
						when Idle =>
							if (tx_en = '0' AND cts = '1') then										-- if tx is enabled (key 0 is pressed) and the receiver clears us to send
								tx_buffer(data_bits+1 downto 0) <=  tx_data & '0' & '1';    -- put our data and start and stop bits into the buffer.
								
								if(parity = 1) then                                       	-- if we use parity, add the parity in as well.
								  tx_buffer(parity+data_bits+1) <= tx_parity(data_bits);    -- tx_buffer(10) <= tx_parity(8)
								end if;
								
								--Before we transmit set the following
								tx_busy <= '1';                            -- set busy to 1
								rts <= '0';											 -- set rts to 0, cannot receive while we transmit.
								tbits_count := 0;                          -- make sure the counter is starting from bit 0
								state <= Transmit;                         -- go to transmit state
							 
							 else                                         -- we are not transmitting
								tx_busy <= '0';                            -- busy set to 0
								rts <= '1';											 -- rts to 1, we are ready to receive (in case of full duplex)	
								state <= Idle;                             -- stay in idle state
							 
							 end if;
							 
						when Transmit =>                                          
							 if(baud_pulse = '1') then                                 		-- when we get a baud pulse
								tbits_count := tbits_count + 1;                             -- increment counter to next bit to be sent
								tx_buffer <= '1' & tx_buffer(parity+data_bits+1 downto 1);  -- shift the transmit buffer by one bit to the right, replace msb with 1
							 end if;
							 
							 if(tbits_count < parity+data_bits+3) then                     -- if we have not transmitted all the bits yet 
								state <= Transmit;                                     		-- continue to transmit
								
							 else                                                      		
								state <= Idle;                                         		-- done transmitting; go back to idle.
		
							 end if;
						
					end case;
					
					tx <= tx_buffer(0);	-- set tx to the bit we just sent.
					
				end if;
			end process;
	  
	 
			--Parity checker
			process(tx_data)
			begin
			  tx_parity(0) <= parity_eo;		-- set the  LSB in parity buffer to 0 or 1, in this case 0 for even parity.
			  for i in 0 to data_bits-1 loop 
				 tx_parity(i+1) <= tx_parity(i) XOR tx_data(i); -- while i has not reached the MSB, XOR parity buffer with data to check.
			  end loop;
			end process;
			
			
end behavioural;