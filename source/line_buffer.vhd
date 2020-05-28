library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_ndim_shift_register_types.all;

entity line_buffer is
  generic (IMAGE_SIZE: integer; WINDOW_SIZE: integer);
  port (
    i_NEW_DATA : in std_logic_vector(7 downto 0);
    i_CLK   : in std_logic;
    o_CURRENT_WINDOW 	: out t_SHIFT_REGISTER(WINDOW_SIZE*WINDOW_SIZE-1 downto 0)
  );
end entity;


architecture arch of line_buffer is

  constant  c_SHIFT_REGISTER_SIZE : integer := WINDOW_SIZE*WINDOW_SIZE + (WINDOW_SIZE-1)*(IMAGE_SIZE-WINDOW_SIZE);
	signal    w_FULL_LINE_BUFFER    : t_SHIFT_REGISTER(c_SHIFT_REGISTER_SIZE-1 downto 0);
begin

  u_SHIFT_REGISTER: entity work.ndim_shift_register
  generic map (SIZE => c_SHIFT_REGISTER_SIZE)
  port map (
  	i_NEW_DATA => i_NEW_DATA,
    i_CLK   => i_CLK,
    o_DATA	=> w_FULL_LINE_BUFFER
  );
    
  GEN_WINDOW_PER_LINE: for i in 1 to WINDOW_SIZE generate 
    o_CURRENT_WINDOW(i*WINDOW_SIZE-1 downto (i-1)*WINDOW_SIZE) <= w_FULL_LINE_BUFFER((i*WINDOW_SIZE-1 + (i-1)*(IMAGE_SIZE-WINDOW_SIZE)) downto (i-1)*(IMAGE_SIZE));
  end generate;
end architecture;
