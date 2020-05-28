library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity somador is
  generic (g_SIZE: integer := 8);
  port (
  	i_A 	: in std_logic_vector(g_SIZE-1 downto 0);
    i_B   	: in std_logic_vector(g_SIZE-1 downto 0);
    o_S  	: out std_logic_vector(g_SIZE-1 downto 0);
    o_C		: out std_logic
  );
end entity;


architecture arch of somador is
	signal w_C: std_logic_vector(g_SIZE-1 downto 0) := (others => '0');
	signal w_S: std_logic_vector(g_SIZE-1 downto 0) := (others => '0');
begin


	linked_full_adders: for i in 0 to g_SIZE-2 generate
      full_bit_adder: entity work.full_adder 
        port map (
          i_A => i_A(i),
          i_B => i_B(i),
          i_C => w_C(i),
          o_C => w_C(i+1),
          o_S => o_S(i)
         );
	end generate;
    
    last_full_bit_adder: entity work.full_adder 
      port map (
        i_A => i_A(g_SIZE-1),
        i_B => i_B(g_SIZE-1),
        i_C => w_C(g_SIZE-1),
        o_C => o_C,
        o_S => o_S(g_SIZE-1)
      );

end architecture;
