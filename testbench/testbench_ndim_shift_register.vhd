library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- library de leitura e escrita de arquivo
use std.textio.all;
use ieee.std_logic_textio.all;
use work.pkg_ndim_shift_register_types.all;

entity testbench_ndim_shift_register is
end entity;

architecture arch of testbench_ndim_shift_register is
  constant period : time := 10 us;
  signal rstn : std_logic := '0';
  signal clk : std_logic := '1';
  
  file fil_in : text;
  file fil_out : text;

  signal valid : std_logic := '0';
  signal pix   : std_logic_vector(7 downto 0);
  
  signal valid_o : std_logic;
  signal w_NEW_DATA : std_logic_vector(7 downto 0);
  signal w_DATA : t_SHIFT_REGISTER(2 downto 0);
begin

  clk <= not clk after period/2;
  rstn <= '1' after period/2;

  p_INPUT : process
  begin
--    wait for period/2;
	w_NEW_DATA <= X"01";
	wait for period;
    
	w_NEW_DATA <= X"02";
	wait for period;
    
    
	w_NEW_DATA <= X"03";
	wait for period;
    
    
	w_NEW_DATA <= X"04";
	wait for period;

    wait;
  end process;

  design_inst : entity work.ndim_shift_register
  -- generic map (SIZE => 3)
  port map (
  	i_NEW_DATA => w_NEW_DATA,
    i_CLK   => clk,
    o_DATA	=> w_DATA
  );

end architecture;