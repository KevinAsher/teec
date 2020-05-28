library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_ndim_shift_register_types.all;

entity fir_filter is
  generic (IMAGE_SIZE: integer; WINDOW_SIZE: integer);
  port (
    -- Inputs
    i_CLK             : in std_logic;
    i_RST             : in std_logic;
    i_START           : in std_logic;
    i_NEW_DATA        : in std_logic_vector(7 downto 0);
    i_CURRENT_WINDOW  : in t_SHIFT_REGISTER(WINDOW_SIZE*WINDOW_SIZE-1 downto 0);

    -- Outputs
    o_VALID_PIX    : out std_logic
  );
end;

architecture rtl of fir_filter is

  signal w_CURRENT_WINDOW : t_SHIFT_REGISTER(WINDOW_SIZE*WINDOW_SIZE-1 downto 0);
  signal w_VALID_WINDOW   : std_logic;
begin

  u_CONVOLUTION_TOP : entity work.convolution_top
    generic map (WINDOW_SIZE => 3, IMAGE_SIZE => 5)
    port map (
      i_CLK   => i_CLK,
      i_RST   => w_RST,
      i_START => w_START,
      i_NEW_DATA => w_NEW_DATA,
      o_CURRENT_WINDOW	=> w_CURRENT_WINDOW,
      o_VALID_WINDOW => w_VALID_WINDOW
    );

  
    
end rtl;