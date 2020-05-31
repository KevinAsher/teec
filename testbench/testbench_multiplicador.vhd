-- Testbench for OR gate
library IEEE;
use IEEE.std_logic_1164.all;
 
entity testbench_multiplicador is
-- empty
end testbench_multiplicador; 

architecture tb of testbench_multiplicador is

	signal w_A: std_logic_vector(3 downto 0) := (others => '0');
	signal w_B: std_logic_vector(3 downto 0) := (others => '0');
	signal w_M: std_logic_vector(7 downto 0) := (others => '0');
    
    
    
    signal w_A_8: std_logic_vector(7 downto 0) := (others => '0');
	signal w_B_8: std_logic_vector(7 downto 0) := (others => '0');
	signal w_M_16: std_logic_vector(15 downto 0) := (others => '0');
begin

  -- Connect DUT
  DUT_4_bits: entity work.multiplicador
  generic map (g_SIZE => 4)
  port map (
  	i_A => w_A,
    i_B => w_B,
    o_M => w_M
   );
   
  DUT_8_bits: entity work.multiplicador
  generic map (g_SIZE => 8)
  port map (
  	i_A => w_A_8,
    i_B => w_B_8,
    o_M => w_M_16
   );

  process
  begin
    -- w_A <= X"04"; w_B <= X"08";
    -- wait for 1 ns;
    -- assert(w_M=X"20") report "Fail 04/08" & " got " & to_hstring(w_M) 		severity error;
    
    -- *******************************
    -- * Tests for 4 bit multiplier
    -- *
    -- *******************************
    
    -- w_A <= X"3"; w_B <= X"3";
    -- wait for 1 ns;
    -- assert(w_M=X"09") report "Fail 3/3" & " got " & to_hstring(w_M) 		severity error;
    
    -- w_A <= X"2"; w_B <= X"2";
    -- wait for 1 ns;
    -- assert(w_M=X"04") report "Fail 2/2" & " got " & to_hstring(w_M) 		severity error;
    
    -- w_A <= X"9"; w_B <= X"9";
    -- wait for 1 ns;
    -- assert(w_M=X"51") report "Fail 9/9" & " got " & to_hstring(w_M) 		severity error;
    
    -- (1 * -1) = -1
    w_A <= X"1"; w_B <= X"F";
    wait for 1 ns;
    assert(w_M=X"FF") report "Fail 1/-1" & " got " & to_hstring(w_M) 		severity error;

    -- (-4 * 3) = -12
    w_A <= X"C"; w_B <= X"3";
    wait for 1 ns;
    assert(w_M=X"F4") report "Fail -4/3" & " got " & to_hstring(w_M) 		severity error;
    
    -- *******************************
    -- * Tests for 8 bit multiplier
    -- *
    -- *******************************
    
    -- (-1 * 1) = -1
    w_A_8 <= X"FF"; w_B_8 <= X"01";
    wait for 1 ns;
    assert(w_M_16=X"FFFF") report "Fail -1/1" & " got " & to_hstring(w_M_16) 		severity error;
    
    -- (-4 * 3) = -12
    w_A_8 <= B"1111_1100"; w_B_8 <= X"03";
    wait for 1 ns;
    assert(w_M_16=B"1111_1111_1111_0100") report "Fail -4/3" & " got " & to_hstring(w_M_16) 		severity error;
    
    assert false report "Test done." severity note;
    wait;
  end process;
end tb;
