--  32b Brent Kung adder test bench
--  Done By: Tejaswee Sulekh, 20D070082
library ieee ;
use ieee.std_logic_1164.all ;

library work;
use work.all;

-- Test Bench Entity
entity adder_32b_tb is
end entity adder_32b_tb;

architecture test of adder_32b_tb is

    -- Component under test
    component adder_32b is
        port (
            a, b : in STD_LOGIC_VECTOR(31 downto 0);
            c_in : in std_logic;
            s : out STD_LOGIC_VECTOR(31 downto 0);
            c_out : out std_logic);
      end component adder_32b;
    
      --  Specifies which entity is bound with the component.
      for adder_32b_0: adder_32b use entity work.adder_32b(structural);
      signal a, b, s : std_logic_vector(31 downto 0);
      signal c_in, c_out : std_logic;
    begin
      --  Component instantiation.
      adder_32b_0: adder_32b
      port map (a => a, b => b, c_in => c_in, s => s, c_out => c_out);
    
      --  This process does the real job.
      process
        type pattern_type is record
          --  The inputs of the adder.
          a, b : std_logic_vector(31 downto 0);
          c_in : std_logic;
        end record;
        --  The patterns to apply.
        type pattern_array is array (natural range <>) of pattern_type;
        constant patterns : pattern_array :=
          (("01010101010101010101010101010101", "00011010101010101010101010101010", '1'), -- B + A 
           ("00000000000000000000000000000000", "00000000000000000000000000001001", '1'),
           ("00000000000000000000000000000001", "00000000000000000000000000001111", '0'),
           ("00110000111100001111000011110000", "00111100001111000011110000111100", '0'));
      begin
        --  Check each pattern.
        for i in patterns'range loop
          --  Set the inputs.
          a <= patterns(i).a;
          b <= patterns(i).b;
          c_in <= patterns(i).c_in;
          --  Wait for the results.
          wait for 15 ns;
        end loop;
        wait;
      end process;
end architecture test;