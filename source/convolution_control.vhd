library ieee;
use ieee.std_logic_1164.all;

entity convolution_control is
  port (
    -- Inputs
    i_CLK                   : in std_logic;
    i_RST                   : in std_logic;
    i_START                 : in std_logic;
    i_FIRST_RUN_CTR_EQ_MAX  : in std_logic;
    i_LINE_RUN_CTR_EQ_MAX   : in std_logic;
    -- i_NO_MORE_LINES         : in std_logic;
    i_NEW_LINE_CTR_EQ_MAX   : in std_logic;

    -- Outputs
    o_VALID_WINDOW          : out std_logic;
    o_FIRST_RUN_CTR_LD      : out std_logic;
    o_FIRST_RUN_CTR_CLR     : out std_logic;
    o_LINE_RUN_CTR_LD       : out std_logic;
    o_LINE_RUN_CTR_CLR      : out std_logic
  ) ;
end;

architecture rtl of convolution_control is

-- Estados da FSM
	type t_ESTADO is ( INIT, SET_FIRST_RUN_CTR_LOOP, FIRST_RUN_CTR_LOOP,  SET_LINE_RUN_CTR_LOOP, LINE_RUN_CTR_LOOP, SET_NEW_LINE_CTR_LOOP, NEW_LINE_CTR_LOOP );
  
  signal w_ESTADO_ATUAL : t_ESTADO;
  signal w_PROXIMO_ESTADO : t_ESTADO;

  

begin

  p_ESTADOS : process (i_CLK, i_RST)
  begin
    if (i_RST = '1') then
      w_ESTADO_ATUAL <= INIT;            -- idle, or first state
    elsif (rising_edge(i_CLK)) then
      w_ESTADO_ATUAL <= w_PROXIMO_ESTADO;
  end if;
  end process;


  -- only state transitions, no outputs setting
  p_next_state : process (w_ESTADO_ATUAL, i_START, i_FIRST_RUN_CTR_EQ_MAX, i_LINE_RUN_CTR_EQ_MAX, i_NEW_LINE_CTR_EQ_MAX)
  begin
    case (w_ESTADO_ATUAL) is
      when INIT =>
        if(i_START = '1') then
          w_PROXIMO_ESTADO <= SET_FIRST_RUN_CTR_LOOP;
        else
          w_PROXIMO_ESTADO <= INIT;
        end if;
      
      -- Counts until the first VALID window
      when SET_FIRST_RUN_CTR_LOOP =>
        w_PROXIMO_ESTADO <= FIRST_RUN_CTR_LOOP;
        
      when FIRST_RUN_CTR_LOOP =>
          
        if (i_FIRST_RUN_CTR_EQ_MAX = '1') then
          w_PROXIMO_ESTADO <= SET_LINE_RUN_CTR_LOOP;
        else
          w_PROXIMO_ESTADO <= FIRST_RUN_CTR_LOOP;
        end if;

      -- Counts until the end of the line of the image
      when SET_LINE_RUN_CTR_LOOP =>
        w_PROXIMO_ESTADO <= LINE_RUN_CTR_LOOP;

      WHEN LINE_RUN_CTR_LOOP =>
        if (i_LINE_RUN_CTR_EQ_MAX = '1') then
          w_PROXIMO_ESTADO <= SET_NEW_LINE_CTR_LOOP;
        else
          w_PROXIMO_ESTADO <= LINE_RUN_CTR_LOOP;
        end if;
      

      -- Starting at a new line, counts until the new line processed WINDOW_WIDTH pixels,
      -- UNLESS, we reached the end of the image 
      WHEN SET_NEW_LINE_CTR_LOOP =>
          -- if (i_NO_MORE_LINES = '1') then
            -- w_PROXIMO_ESTADO <= INIT;
          -- else
            -- w_PROXIMO_ESTADO <= NEW_LINE_CTR_LOOP;
          -- end if;
          
          -- Instead of end flag, the user MUST reset when finished reading image file.
          -- Otherwise, this loop will continue executing
          w_PROXIMO_ESTADO <= NEW_LINE_CTR_LOOP;
          

      WHEN NEW_LINE_CTR_LOOP =>
        if (i_NEW_LINE_CTR_EQ_MAX = '1') then
          w_PROXIMO_ESTADO <= SET_LINE_RUN_CTR_LOOP; -- count the whole line over again
          else
          w_PROXIMO_ESTADO <= NEW_LINE_CTR_LOOP;
        end if;

    end case;
  end process;

    -- Clr and load for first counter
    o_FIRST_RUN_CTR_CLR <= '1' when w_ESTADO_ATUAL = SET_FIRST_RUN_CTR_LOOP else '0';
    o_FIRST_RUN_CTR_LD <= '1' when w_ESTADO_ATUAL = FIRST_RUN_CTR_LOOP else '0';

    -- Clr and load for second counter.
    -- Second counter is reused when there is a new line.
    o_LINE_RUN_CTR_CLR <= '1' when (w_ESTADO_ATUAL = SET_LINE_RUN_CTR_LOOP or w_ESTADO_ATUAL = SET_NEW_LINE_CTR_LOOP) else '0';
    o_LINE_RUN_CTR_LD <= '1' when (w_ESTADO_ATUAL = LINE_RUN_CTR_LOOP or w_ESTADO_ATUAL = NEW_LINE_CTR_LOOP) else '0';

    -- Set valid window while in the line counter
    o_VALID_WINDOW <= '1' when (w_ESTADO_ATUAL = SET_LINE_RUN_CTR_LOOP or w_ESTADO_ATUAL = LINE_RUN_CTR_LOOP) else '0'; 

    
end rtl;