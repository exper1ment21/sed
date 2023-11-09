
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
 
entity counter IS
port(reset:in std_logic;
     clk: in std_logic;
--     digit_left:out unsigned(3 downto 0);
--     digit_right:out unsigned(3 downto 0);
--     SW : in STD_LOGIC_VECTOR (8 downto 0);
     seg: out std_logic_vector(7 downto 0);
     AN : out STD_LOGIC_VECTOR (7 downto 0));
END counter;

Architecture arch_counter of counter IS 

   signal count_time1: unsigned (26 downto 0);
   signal count_time2: unsigned (26 downto 0);
   signal ms_d: unsigned (3 downto 0); --most significant digit
   signal ls_d: unsigned (3 downto 0); --least significant digit
   signal d: std_logic_vector(3 downto 0); -- output to the 7- segement display
   signal en_hz:std_logic; --enable for 200Hz switching
   

BEGIN

   counter:PROCESS(clk ,reset)
   begin
      if(reset = '0') THEN
         ms_d <= (others=>'0');
         ls_d <= (others=>'0');
         count_time1 <= (others=>'0');
         count_time2 <= (others=>'0');
         en_hz <= '0';
      elsif rising_edge(clk) THEN   
	      count_time1 <= count_time1 + 1;  --counter for the clk
	      count_time2 <= count_time2 + 1;
	       if (count_time2 = 500000) then -- counter for the 200hz switching
		  en_hz<='1';
		end if;
	       if(count_time2 = 1000000) then
	          en_hz <= '0';
	          count_time2 <= (others=>'0');
	      end if;
	      
	  if(count_time1 = 100000000) THEN -- counter for 100MHZ frequency
		count_time1 <= (others=>'0');
		 ls_d <= ls_d + 1; --counter for 0-9
		if(ls_d = "1001") then
		    ls_d <= (others=>'0');
		    ms_d<=ms_d+1;  --counter for 0-5
		    if(ms_d="0101") THEN
			ms_d<=(others=>'0');
		    end if;
		end if;
	end if;
       end if;
     end process counter;

     
    disp:   process(clk,en_hz)
    begin
        if rising_edge(clk) then
            if (en_hz='1') then
               AN <= "11111110";  -- to display lsd
                d <= std_logic_vector(ls_d);       
            else
                AN <= "11111101"; -- to display msd
                d <= std_logic_vector(ms_d);
            
            end if;
         end if;
        
        end process disp;
        
     seven_seg_disp: process(d,clk)
     begin
        case d is --
            when "0000" => seg <= "11000000";
            when "0001" => seg <= "11111001";
            when "0010" => seg <= "10100100";
            when "0011" => seg <= "10110000";
            when "0100" => seg <= "10011001";
            when "0101" => seg <= "10010010";
            when "0110" => seg <= "10000010";
            when "0111" => seg <= "11111000";
            when "1000" => seg <= "10000000";
            when "1001" => seg <= "10010000";
            when "1010" => seg <= "10001000";
            when "1011" => seg <= "10000011"; 
            when "1100" => seg <= "11000110";
            when "1101" => seg <= "10100001";
            when "1110" => seg <= "10000110";
            when "1111" => seg <= "10001110";
	    when others => seg <= "00000000";
        end case;
     end process seven_seg_disp;           		
END arch_counter;