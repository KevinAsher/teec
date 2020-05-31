library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_ndim_shift_register_types.all;

-- library de leitura e escrita de arquivo
use std.textio.all;
use ieee.std_logic_textio.all;

entity testbench_fir_filter is
end entity;



architecture arch of testbench_fir_filter is
  constant period : time := 10 us;
  signal clk : std_logic := '1';
  
  file f_FILE_IN : text;
  file f_FILE_OUT : text;

  signal w_PIX_IN   : std_logic_vector(7 downto 0);
  signal w_PIX_OUT   : std_logic_vector(7 downto 0);
  
  signal w_VALID_PIX: std_logic;
  constant c_WINDOW_SIZE : integer := 3;
  signal w_KERNEL : t_SHIFT_REGISTER(c_WINDOW_SIZE*c_WINDOW_SIZE-1 downto 0) := (
    -- Box Blur
    -- X"01", X"01", X"01",
    -- X"01", X"01", X"01",
    -- X"01", X"01", X"01"

    -- Edge Dectection
    X"FF", X"FF", X"FF",
    X"FF", X"08", X"FF",
    X"FF", X"FF", X"FF"
  );

  signal w_DIV_FACTOR : unsigned (15 downto 0) := X"0009";

  signal w_START : std_logic;
  signal w_CLK : std_logic := '1';
  signal w_RST : std_logic;
begin

  w_CLK <= not w_CLK after period/2;
  w_RST <= '1' after period/2;

  
   p_INPUT : process
    begin
      wait for period;    
      w_START <= '1';
      wait for period;
      w_RST <= '0';
      w_START <= '0';
      wait for period;
      for i in 1 to 30 loop
        w_PIX_IN <= std_logic_vector(to_unsigned(i, w_PIX_IN'length));
        wait for period;
      end loop;
      wait;
    end process;

  -- p_INPUT : process
  --   variable v_LINE : line;
  --   variable v_DATA : std_logic_vector(7 downto 0);
  -- begin
  --   wait for period;    
  --   w_START <= '1';
  --   wait for period;
  --   w_RST <= '0';
  --   w_START <= '0';
  --   wait for period;
  --   file_open(f_FILE_IN, "img.dat", READ_MODE);
  --   while not endfile(f_FILE_IN) loop
  --     readline(f_FILE_IN, v_LINE);
  --     read(v_LINE, v_DATA);
  --     w_PIX_IN <= v_DATA;
  --     wait for period;
  --   end loop;
  --   wait for period;
  --   w_RST <= '1';
  --   wait;
  -- end process;

  -- p_RESULT : process
  --   variable v_LINE : line;
  -- begin
  --   file_open(f_FILE_OUT, "img_out.dat", WRITE_MODE);
    
  --   while true loop
  --     wait until rising_edge(w_CLK);
  --     if w_VALID_PIX = '1' then
  --       write(v_LINE, w_PIX_OUT);
  --       writeline(f_FILE_OUT, v_LINE);
  --     end if;
  --   end loop;
  --   wait;
  -- end process;

  design_inst : entity work.fir_filter
  generic map (WINDOW_SIZE => 3, IMAGE_SIZE => 100)
  port map (
    i_CLK   => w_CLK,
    i_RST  => w_RST,
    i_START     => w_START,
    i_NEW_DATA  => w_PIX_IN,
    i_KERNEL    => w_KERNEL,
    i_DIV_FACTOR => w_DIV_FACTOR,
    o_VALID_PIX => w_VALID_PIX,
    o_PIX       => w_PIX_OUT
  );

end architecture;