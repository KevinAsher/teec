-- Testbench for OR gate
library IEEE;
use IEEE.std_logic_1164.all;
 
entity testbench_somador is
-- empty
end testbench_somador; 

architecture tb of testbench_somador is

	signal w_A: std_logic_vector(7 downto 0) := (others => '0');
	signal w_B: std_logic_vector(7 downto 0) := (others => '0');
	signal w_S: std_logic_vector(7 downto 0) := (others => '0');
    signal w_C: std_logic := '0';
begin

  -- Connect DUT
  DUT: entity work.somador
  generic map (g_SIZE => 8)
  port map (
  	i_A => w_A,
    i_B => w_B,
    o_C => w_C,
    o_S => w_S
   );

  process
  begin
    w_A <= X"12"; w_B <= X"22";
    wait for 1 ns;
    assert(w_S=X"34" and w_C='0') report "Fail 12/22" & " got " & to_hstring(w_S) 		severity error;
    
	w_A <= X"FE"; w_B <= X"02";
    wait for 1 ns;
    assert(w_S=X"00" and w_C='1') report "Fail FE/02" & " got " & to_hstring(w_S) 		severity error;
    
    
    w_A <= X"FE"; w_B <= X"01";
    wait for 1 ns;
    assert(w_S=X"FF" and w_C='0') report "Fail FE/01" & " got " & to_hstring(w_S) 		severity error;
    
    
    assert false report "Test done." severity note;
    wait;
  end process;
end tb;
