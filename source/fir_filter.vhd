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
    i_KERNEL          : in t_SHIFT_REGISTER(WINDOW_SIZE*WINDOW_SIZE-1 downto 0);
    i_DIV_FACTOR      : in unsigned(15 downto 0); -- TODO: qual tamnnho colocar aqui pra ficar genêrico?
    -- Outputs
    o_VALID_PIX       : out std_logic;
    o_PIX             : out std_logic_vector(7 downto 0)
  );
end;

architecture rtl of fir_filter is

  signal w_CURRENT_WINDOW : t_SHIFT_REGISTER(WINDOW_SIZE*WINDOW_SIZE-1 downto 0);

  -- TODO: ver o tamanho realmente necessário para a soma acumulada e divisão.
  constant c_ACC_SIZE : integer := 8 + WINDOW_SIZE*WINDOW_SIZE;
  
  type t_SHIFT_REGISTER_MULT_RESULT is array (natural range <>) of std_logic_vector(15 downto 0);
  type t_SHIFT_REGISTER_ADDERS_RESULT is array (natural range <>) of std_logic_vector(c_ACC_SIZE-1 downto 0);
  
  
  signal w_MULT_RESULT    : t_SHIFT_REGISTER_MULT_RESULT(WINDOW_SIZE*WINDOW_SIZE-1 downto 0);


  signal w_ACC_RESULT   : t_SHIFT_REGISTER_ADDERS_RESULT(WINDOW_SIZE*WINDOW_SIZE-1 downto 0);
  signal w_ACC_SUM_PART : std_logic_vector(16 downto 0);
  signal w_DIV_RESULT   : unsigned(c_ACC_SIZE-1 downto 0);
  signal w_PIX_TEMP     : unsigned(7 downto 0);
  signal w_VALID_WINDOW : std_logic;

begin

  u_CONVOLUTION_TOP : entity work.convolution_top
    generic map (WINDOW_SIZE => WINDOW_SIZE, IMAGE_SIZE => IMAGE_SIZE)
    port map (
      i_CLK   => i_CLK,
      i_RST   => i_RST,
      i_START => i_START,
      i_NEW_DATA => i_NEW_DATA,
      o_CURRENT_WINDOW	=> w_CURRENT_WINDOW,
      o_VALID_WINDOW => w_VALID_WINDOW
    );
    
    GEN_MULT: for i in 0 to WINDOW_SIZE*WINDOW_SIZE-1 generate
      u_MULT_8_bits: entity work.multiplicador
        generic map (g_SIZE => 8)
        port map (
          i_A => i_KERNEL(i),
          i_B => w_CURRENT_WINDOW(WINDOW_SIZE*WINDOW_SIZE-1 - i), -- since the window is inverted, we need to read it backwords
          o_M => w_MULT_RESULT(i)
        );
    end generate;

    GEN_SOMA: for i in 0 to WINDOW_SIZE*WINDOW_SIZE-1 generate
      GEN_FIRST_SOMA: if i = 0 generate
        signal w_EXTENDED_MULT_RESULT : std_logic_vector(c_ACC_SIZE-2 downto 0);
        signal w_VALID_MULT_RESULT : std_logic_vector(c_ACC_SIZE-2 downto 0);
      begin
        w_EXTENDED_MULT_RESULT <= std_logic_vector(resize(unsigned(w_MULT_RESULT(0)), w_EXTENDED_MULT_RESULT'length));
        w_VALID_MULT_RESULT <= w_EXTENDED_MULT_RESULT when w_VALID_WINDOW='1' else (others => '0');
        u_SOMA_8_bits: entity work.somador
          generic map (g_SIZE => c_ACC_SIZE-1)
          port map (
            i_A => w_VALID_MULT_RESULT,
            i_B => (others => '0'),
            o_S => w_ACC_RESULT(0)(w_ACC_RESULT(0)'high-1 downto 0),
            o_C => w_ACC_RESULT(0)(w_ACC_RESULT(0)'high)
          );

      end generate;

      GEN_REST_SOMA: if i > 0 generate
        signal w_EXTENDED_MULT_RESULT : std_logic_vector(c_ACC_SIZE-2 downto 0);
        signal w_VALID_MULT_RESULT : std_logic_vector(c_ACC_SIZE-2 downto 0);
      begin
        w_EXTENDED_MULT_RESULT <= std_logic_vector(resize(unsigned(w_MULT_RESULT(i)), w_EXTENDED_MULT_RESULT'length));
        w_VALID_MULT_RESULT <= w_EXTENDED_MULT_RESULT when w_VALID_WINDOW='1' else (others => '0');
        u_SOMA_8_bits: entity work.somador
          generic map (g_SIZE => c_ACC_SIZE-1)
          port map (
            i_A => w_VALID_MULT_RESULT,
            i_B => w_ACC_RESULT(i-1)(w_ACC_RESULT(i-1)'high-1 downto 0),
            o_S => w_ACC_RESULT(i)(w_ACC_RESULT(i)'high-1 downto 0),
            o_C => w_ACC_RESULT(i)(w_ACC_RESULT(i)'high)
          );
          -- port map (
          --   i_A => (w_ACC_SUM'high-1 downto 0 => '0') or w_MULT_RESULT(i),
          --   i_B => w_ACC_SUM(w_ACC_SUM'high-1 downto 0),
          --   o_S => w_ACC_SUM(w_ACC_SUM'high-1 downto 0),
          --   o_C => w_ACC_SUM(w_ACC_SUM'high)
          -- );
      end generate;
    end generate;

    o_VALID_PIX <= w_VALID_WINDOW;
    
    w_DIV_RESULT <= unsigned(w_ACC_RESULT(w_ACC_RESULT'high)) / i_DIV_FACTOR;
    
    w_PIX_TEMP <= X"FF" when unsigned(w_DIV_RESULT) > 255 else
    			        X"00" when unsigned(w_DIV_RESULT) < 0 else
                  w_DIV_RESULT(7 downto 0);

    o_PIX <= std_logic_vector(w_PIX_TEMP);
    
end rtl;