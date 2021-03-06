library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

package pkg_ndim_shift_register_types is
  type t_SHIFT_REGISTER is array (natural range <>) of std_logic_vector(7 downto 0);
end package;

library IEEE;
use IEEE.std_logic_1164.all;
use work.pkg_ndim_shift_register_types.all;

entity ndim_shift_register is
  generic (SIZE: integer := 3);
  port (
    i_NEW_DATA : in std_logic_vector(7 downto 0);
    i_CLK   : in std_logic;
    o_DATA 	: out t_SHIFT_REGISTER(SIZE-1 downto 0)
  );
end entity;


architecture arch of ndim_shift_register is
 signal w_SHIFT_REGISTER : t_SHIFT_REGISTER(SIZE-1 downto 0);
begin
  p_SHIFT : process(i_CLK)
  begin
	if (rising_edge(i_CLK)) then
		w_SHIFT_REGISTER <= w_SHIFT_REGISTER(w_SHIFT_REGISTER'high-1 downto 0) & i_NEW_DATA;
	end if;
      
  end process;
  
  o_DATA <= w_SHIFT_REGISTER;
    
end architecture;
