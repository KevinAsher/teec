library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult_cell_inv is
  port (
  	-- parametros
    i_A : in std_logic;
    i_B : in std_logic;
    
    -- resultado de mult. anterior
    i_M : in std_logic;
    
    -- carry in
    i_C : in std_logic;
    
    -- resultado de mult. e carry out
    o_M : out std_logic;
    o_C : out std_logic
  );
end entity;


architecture arch of mult_cell_inv is
  signal w_T : std_logic;
begin
    w_T <= not (i_A and i_B);
    full_bit_adder: entity work.full_adder 
      port map (
        i_A => w_T,
        i_B => i_M,
        i_C => i_C,
        o_C => o_C,
        o_S => o_M
      );

end architecture;
