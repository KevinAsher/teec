library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_adder is
  port (
    i_A : in std_logic;
    i_B : in std_logic;
    i_C : in std_logic;
    
    o_S : out std_logic;
    o_C : out std_logic
    
  );
end entity;


architecture arch of full_adder is
begin
    o_C <= (i_A and i_B) or (i_A and i_C) or (i_B and i_C);
    o_S <= i_A xor i_B xor i_C;
end architecture;
