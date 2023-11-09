library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_tb is

end display_tb;

architecture arch_display_tb of display_tb is

	component counter is
		port(reset:in std_logic;
     		clk: in std_logic;
	--     digit_left:out unsigned(3 downto 0);
	--     digit_right:out unsigned(3 downto 0);
	--     SW : in STD_LOGIC_VECTOR (8 downto 0);
   	        seg: out std_logic_vector(7 downto 0);
      	        AN : out STD_LOGIC_VECTOR (7 downto 0));
	end component counter;


	type seg_array is array (0 to 15) of std_logic_vector (7 downto 0);
 	signal seg_value: seg_array := ("11000000",  -- 0
                                         "11111001",  -- 1
                                         "10100100",  -- 2
                                         "10110000",  -- 3
                                         "10011001",  -- 4
                                         "10010010",  -- 5
                                         "10000010",  -- 6
                                         "11111000",  -- 7
                                         "10000000",  -- 8
                                         "10010000",  -- 9
                                         "10001000",  -- A
                                         "10000011",  -- B
                                         "11000110",  -- C
                                         "10100001",  -- D
                                         "10000110",  -- E
                                         "10001110"); -- F

		
	
   	signal count_time1: unsigned (26 downto 0);
   --	signal count_time2: unsigned (26 downto 0);
   	signal ms_d: unsigned (3 downto 0); --most significant digit
   	signal ls_d: unsigned (3 downto 0); --least significant digit
   	signal d: std_logic_vector(3 downto 0); -- output to the 7- segement display
   	signal en_hz:std_logic; --enable for 200Hz switching
	signal reset:std_logic;
	signal clk:std_logic;
	signal seg: std_logic_vector(7 downto 0);
	signal AN: std_logic_vector(7 downto 0);
	
      BEGIN 
	counter_inst:
		component counter	
			port map(reset => reset,
				 clk => clk,
   				 seg => seg,
				 AN => AN);

	clk_proc: process
    	    begin
    	    wait for 5 ns;
    	    clk <= not(clk);
  	end process clk_proc;


	reset <= '0',
		 '1' after 50 ns;

	test_proc:process
		begin
		wait for 100 ns;
	        for i in 0 to 6 loop
		        for j in 0 to 9 loop
  			        assert (seg = seg_value(j))
			        report "Units place digit is wrong"
          			severity error;
          			assert (AN = "11111110")
          			report "Units digit is not selected"
         			 severity error;
         			 wait for 10 ns;

				
          			assert (seg = seg_value(i))
  			        report "Tens place digit is wrong"
          			severity error;
          			assert (AN = "11111101")
          			report "Tens digit is not selected"
          			severity error;
          			wait for 10000 ns;
        		end loop;
 	     end loop;
  end process test_proc;


end arch_display_tb;
