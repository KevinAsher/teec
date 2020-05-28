library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity design is
  port (
    i_VALID : in std_logic;
    i_PIX   : in std_logic_vector(7 downto 0);
    
    i_RSTN  : in std_logic;
    i_CLK   : in std_logic;
    
    o_VALID : out std_logic;
    o_PIX   : out std_logic_vector(7 downto 0)
  );
end entity;


architecture arch of design is
	signal w_inter_result_mult   : std_logic_vector(15 downto 0) := (others => '0');
    signal w_inter_result   : std_logic_vector(15 downto 0) := (others => '0');
    signal w_result    		: std_logic_vector(15 downto 0) := (others => '0');


    
    
    
    signal w_contraste 		: std_logic_vector(6 downto 0) := B"000_0001";
    signal w_brilho  		: std_logic_vector(7 downto 0) := B"0111_1111";
    signal w_T : std_logic_vector(7 downto 0);
    signal w_T2 : std_logic_vector(15 downto 0);
begin

  -- w_T <='0' & w_contraste; -- usar MSB 0 pra evitar 16-bit overflow na hora de somar
	-- u_MULT_CONTRASTE: entity work.multiplicador
  --     generic map (g_SIZE => 8)
  --     port map (
  --       i_A => w_T,
  --       i_B => i_PIX,
  --       o_M => w_inter_result_mult
  --      );
       
  --   w_T2 <= X"00" & w_brilho;
  --   u_SOMA_BRILHO: entity work.somador
  --     generic map (g_SIZE => 16)
  --     port map (
  --       i_A => w_inter_result_mult,
  --       i_B => w_T2,
  --       -- o_C => ,
  --       o_S => w_inter_result
  --      );
       
  --   w_result <= X"00FF" when unsigned(w_inter_result) > 255 else
  --   			X"0000" when unsigned(w_inter_result) < 0 else
  --               w_inter_result;
  
  o_VALID <= i_VALID;
  o_PIX   <= std_logic_vector(w_result(7 downto 0));
end architecture;
