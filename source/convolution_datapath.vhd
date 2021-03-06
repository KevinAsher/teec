library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_ndim_shift_register_types.all;

entity convolution_datapath is
  generic (IMAGE_SIZE: integer; WINDOW_SIZE: integer);
  port (
    -- Inputs
    i_CLK               : in std_logic;
    i_FIRST_RUN_CTR_LD  : in std_logic;
    i_FIRST_RUN_CTR_CLR : in std_logic;
    i_LINE_RUN_CTR_LD   : in std_logic;
    i_LINE_RUN_CTR_CLR  : in std_logic;

    i_NEW_DATA : in std_logic_vector(7 downto 0);

    -- Outputs
    o_CURRENT_WINDOW 	      : out t_SHIFT_REGISTER(WINDOW_SIZE*WINDOW_SIZE-1 downto 0);
    o_FIRST_RUN_CTR_EQ_MAX  : out std_logic;
    o_LINE_RUN_CTR_EQ_MAX   : out std_logic;
    o_NEW_LINE_CTR_EQ_MAX   : out std_logic
  );
end;

architecture rtl of convolution_datapath is


  -- TODO: size these vector according to required count sizes.
  signal w_FIRST_RUN_CTR : std_logic_vector(31 downto 0);
  signal w_LINE_RUN_CTR : std_logic_vector(31 downto 0);

begin

  p_OPERACIONAL : process (i_CLK, i_FIRST_RUN_CTR_CLR, i_LINE_RUN_CTR_CLR, i_FIRST_RUN_CTR_LD, i_LINE_RUN_CTR_LD)
  begin
  
    if (rising_edge(i_CLK)) then
      
      -- Handle Inputs

      if (i_FIRST_RUN_CTR_CLR = '1') then
        w_FIRST_RUN_CTR <= (others => '0');
      end if;

      if (i_LINE_RUN_CTR_CLR = '1') then
        w_LINE_RUN_CTR <= (others => '0');
      end if;

      if (i_FIRST_RUN_CTR_LD = '1') then
        w_FIRST_RUN_CTR <= std_logic_vector(to_unsigned(to_integer(unsigned( w_FIRST_RUN_CTR )) + 1, w_FIRST_RUN_CTR'length));
      end if;

      if (i_LINE_RUN_CTR_LD = '1') then
        w_LINE_RUN_CTR <= std_logic_vector(to_unsigned(to_integer(unsigned( w_LINE_RUN_CTR )) + 1, w_LINE_RUN_CTR'length));
      end if;

    end if;
  end process;
      
  -- Handle Outputs
  o_FIRST_RUN_CTR_EQ_MAX  <= '1' when unsigned(w_FIRST_RUN_CTR) = (WINDOW_SIZE * WINDOW_SIZE + (WINDOW_SIZE - 1) * (IMAGE_SIZE - WINDOW_SIZE) - 1) else '0';
  o_LINE_RUN_CTR_EQ_MAX   <= '1' when unsigned(w_LINE_RUN_CTR) = (IMAGE_SIZE - WINDOW_SIZE - 1) else '0';
  o_NEW_LINE_CTR_EQ_MAX   <= '1' when unsigned(w_LINE_RUN_CTR) = (WINDOW_SIZE - 3) else '0';
  
  
  u_LINE_BUFFER : entity work.line_buffer
    generic map (WINDOW_SIZE => WINDOW_SIZE, IMAGE_SIZE => IMAGE_SIZE)
    port map (
      i_NEW_DATA => i_NEW_DATA,
      i_CLK   => i_CLK,
      o_CURRENT_WINDOW	=> o_CURRENT_WINDOW
    );
    
end rtl;