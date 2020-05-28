library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_ndim_shift_register_types.all;

entity convolution_top is
  generic (IMAGE_SIZE: integer; WINDOW_SIZE: integer);
  port (
    -- Inputs
    i_CLK             : in std_logic;
    i_RST             : in std_logic;
    i_START           : in std_logic;
    i_NEW_DATA        : in std_logic_vector(7 downto 0);

    -- Outputs
    o_CURRENT_WINDOW  : out t_SHIFT_REGISTER(WINDOW_SIZE*WINDOW_SIZE-1 downto 0);
    o_VALID_WINDOW    : out std_logic
  );
end;

architecture rtl of convolution_top is


  signal w_FIRST_RUN_CTR_LD      : std_logic;
  signal w_FIRST_RUN_CTR_CLR     : std_logic;
  signal w_LINE_RUN_CTR_LD       : std_logic;
  signal w_LINE_RUN_CTR_CLR      : std_logic;
  signal w_FIRST_RUN_CTR_EQ_MAX  : std_logic;
  signal w_LINE_RUN_CTR_EQ_MAX   : std_logic;
  signal w_NEW_LINE_CTR_EQ_MAX   : std_logic;

begin

  u_CONVOLUTION_CONTROL : entity work.convolution_control
    port map (
      i_CLK                   => i_CLK,
      i_RST                   => i_RST,
      i_START                 => i_START,
      i_FIRST_RUN_CTR_EQ_MAX  => w_FIRST_RUN_CTR_EQ_MAX,
      i_LINE_RUN_CTR_EQ_MAX   => w_LINE_RUN_CTR_EQ_MAX,
      -- i_NO_MORE_LINES         => w_NO_MORE_LINES,
      i_NEW_LINE_CTR_EQ_MAX   => w_NEW_LINE_CTR_EQ_MAX,
      o_VALID_WINDOW          => o_VALID_WINDOW,
      o_FIRST_RUN_CTR_LD      => w_FIRST_RUN_CTR_LD,
      o_FIRST_RUN_CTR_CLR     => w_FIRST_RUN_CTR_CLR,
      o_LINE_RUN_CTR_LD       => w_LINE_RUN_CTR_LD,
      o_LINE_RUN_CTR_CLR      => w_LINE_RUN_CTR_CLR
    );
  
  u_CONVOLUTION_DATAPATH : entity work.convolution_datapath
    generic map (WINDOW_SIZE => WINDOW_SIZE, IMAGE_SIZE => IMAGE_SIZE)
    port map (
      i_CLK                   => i_CLK,
      i_FIRST_RUN_CTR_LD      => w_FIRST_RUN_CTR_LD,
      i_FIRST_RUN_CTR_CLR     => w_FIRST_RUN_CTR_CLR,
      i_LINE_RUN_CTR_LD       => w_LINE_RUN_CTR_LD,
      i_LINE_RUN_CTR_CLR      => w_LINE_RUN_CTR_CLR,
      i_NEW_DATA              => i_NEW_DATA,
      o_CURRENT_WINDOW	      => o_CURRENT_WINDOW,
      o_FIRST_RUN_CTR_EQ_MAX  => w_FIRST_RUN_CTR_EQ_MAX,
      o_LINE_RUN_CTR_EQ_MAX   => w_LINE_RUN_CTR_EQ_MAX,
      o_NEW_LINE_CTR_EQ_MAX   => w_NEW_LINE_CTR_EQ_MAX
    );

  
    
end rtl;