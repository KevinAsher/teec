library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- library de leitura e escrita de arquivo
use std.textio.all;
use ieee.std_logic_textio.all;
use work.pkg_ndim_shift_register_types.all;

entity testbench_line_buffer is
end entity;

architecture arch of testbench_line_buffer is
  constant period : time := 10 us;
  signal rstn : std_logic := '0';
  signal clk : std_logic := '1';
  
  file fil_in : text;
  file fil_out : text;

  signal valid : std_logic := '0';
  signal pix   : std_logic_vector(7 downto 0);
  
  signal valid_o : std_logic;
  signal w_NEW_DATA : std_logic_vector(7 downto 0);
  constant c_WINDOW_SIZE : integer := 3;
  signal w_DATA : t_SHIFT_REGISTER(c_WINDOW_SIZE*c_WINDOW_SIZE-1 downto 0);
begin

  clk <= not clk after period/2;
  rstn <= '1' after period/2;

  p_INPUT : process
  begin
--    wait for period/2;
    for i in 1 to 30 loop
      w_NEW_DATA <= std_logic_vector(to_unsigned(i, w_NEW_DATA'length));
	    wait for period;
    end loop;
    wait;
  end process;

  design_inst : entity work.line_buffer
  generic map (WINDOW_SIZE => 3, IMAGE_SIZE => 100)
  port map (
  	i_NEW_DATA => w_NEW_DATA,
    i_CLK   => clk,
    o_CURRENT_WINDOW	=> w_DATA
  );

end architecture;