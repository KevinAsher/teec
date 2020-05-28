library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- library de leitura e escrita de arquivo
use std.textio.all;
use ieee.std_logic_textio.all;
use work.pkg_ndim_shift_register_types.all;

entity testbench_convolution is
end entity;

architecture arch of testbench_convolution is
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
  signal w_RST : std_logic;
  signal w_START : std_logic;
  signal w_VALID_WINDOW : std_logic;
begin

  clk <= not clk after period/2;
  
  
  
  p_INPUT : process
  begin
    wait for period;    
    w_START <= '1';
    wait for period;
    w_RST <= '0';
    w_START <= '0';
    wait for period;
    -- wait for period/2;
    for i in 1 to 30 loop
      w_NEW_DATA <= std_logic_vector(to_unsigned(i, w_NEW_DATA'length));
	    wait for period;
    end loop;
    wait;
  end process;

  design_inst : entity work.convolution_top
  generic map (WINDOW_SIZE => 3, IMAGE_SIZE => 5)
  port map (
    i_CLK   => clk,
    i_RST   => w_RST,
    i_START => w_START,
  	i_NEW_DATA => w_NEW_DATA,
    o_CURRENT_WINDOW	=> w_DATA,
    o_VALID_WINDOW => w_VALID_WINDOW
  );

end architecture;