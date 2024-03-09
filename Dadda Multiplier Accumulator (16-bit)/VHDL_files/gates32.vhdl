--  Creating basic gates --
--  Done By: Tejaswee Sulekh, 20D070082 --

-- simple gates with trivial architectures --
library IEEE;
use IEEE.std_logic_1164.all;

entity andgate is
    port (A, B: in std_ulogic;
    prod: out std_ulogic);
end entity andgate;

architecture trivial of andgate is
    begin
    prod <= A AND B AFTER 382 ps;
end architecture trivial;

library IEEE;
use IEEE.std_logic_1164.all;

entity xorgate is
    port (A, B: in std_ulogic;
    uneq: out std_ulogic);
end entity xorgate;

architecture trivial of xorgate is
    begin
    uneq <= A XOR B AFTER 764 ps;
end architecture trivial;

library IEEE;
use IEEE.std_logic_1164.all;

entity abcgate is
    port (A, B, C: in std_ulogic;
    abc: out std_ulogic);
end entity abcgate;

architecture trivial of abcgate is
    begin
    abc <= A OR (B AND C) AFTER 482 ps;
end architecture trivial;
-- A + C.(A+B) with a trivial architecture --

library IEEE;
use IEEE.std_logic_1164.all;

entity Cin_map_G is
    port(A, B, Cin: in std_ulogic;
    Bit0_G: out std_ulogic);
end entity Cin_map_G;

architecture trivial of Cin_map_G is
    begin
    Bit0_G <= (A AND B) OR (Cin AND (A OR B)) AFTER 764 ps;
end architecture trivial;

library ieee ;
use ieee.std_logic_1164.all ;
-- Calculation of Gn and Pn from Gn-1 and Pn-1 --
entity pg_calculation is 
  port (
    g_in, p_in, g_in_1, p_in_1 : in std_logic; --Defining inputs --
    g_out, p_out : out std_logic --Defining outputs --
    );
end entity pg_calculation;

architecture behavioral of pg_calculation is
	signal A, B, prod : std_logic;
	
	component andgate is 
            port(
                    A, B : in std_logic;
                    prod : out std_logic
                );
        end component andgate;
		
	component abcgate is
			port(
					A, B, C : in std_logic;
					abc : out std_logic
				);
		end component abcgate;
	
    begin
	A <= p_in_1;
	B <= p_in;
	
	pout: andgate port map(A => p_in_1, B => p_in, prod => p_out);
	gout: abcgate port map(A => g_in, B => g_in_1, C => p_in, abc => g_out);
--        g_out <= g_in or (g_in_1 and p_in) after 381 ps; --
--        p_out <= p_in and p_in_1 after 150 ps; --
end architecture behavioral;

library ieee ;
use ieee.std_logic_1164.all ;
-- Calculation of cout from cin, g_in and p_in --
entity carry_calculation is
    port (
      c_i, p_in, g_in : in std_logic;
      c_o : out std_logic
      );
  end entity carry_calculation;
  
  architecture behavioral of carry_calculation is
--	signal ;
	component abcgate is 
	  port(
				A, B, C : in std_logic;
				abc : out std_logic
			);
		end component abcgate;
      begin
	co: abcgate port map(A => g_in, B => c_i, C => p_in, abc => c_o);
 
 --         c_o <= g_in or (c_i and p_in) after 381 ps;          
  end architecture behavioral;

  library ieee ;
  use ieee.std_logic_1164.all ;
  -- Calculation of sum from a, b and c
  entity sum_calculation is
      port (
        a_in, b_in, cin : in STD_LOGIC_VECTOR(31 downto 0);
        s_out : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end entity sum_calculation;
    
    architecture behavioral of sum_calculation is
        begin
            s_out <= a_in xor b_in xor cin after 764 ps;          
    end architecture behavioral;
