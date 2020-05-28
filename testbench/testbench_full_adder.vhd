library IEEE;
use IEEE.std_logic_1164.all;
 
entity testbench_full_adder is
-- empty
end testbench_full_adder; 

architecture tb of testbench_full_adder is

	signal w_A, w_B, w_C_IN, w_S, w_C_OUT: std_logic;

begin

  -- Connect DUT
  DUT: entity work.full_adder 
  port map (
  	i_A => w_A,
    i_B => w_B,
    i_C => w_C_IN,
    o_C => w_C_OUT,
    o_S => w_S
   );

  process
  begin
    w_A <= '0'; w_B <= '0'; w_C_IN <= '0';
    wait for 1 ns;
    assert(w_S='0' and w_C_OUT='0') report "Fail 0/0/0" severity error;
    
    w_A <= '0'; w_B <= '0'; w_C_IN <= '1';
    wait for 1 ns;
    assert(w_S='1' and w_C_OUT='0') report "Fail 0/0/1" severity error;
  
  	w_A <= '0'; w_B <= '1'; w_C_IN <= '0';
    wait for 1 ns;
    assert(w_S='1' and w_C_OUT='0') report "Fail 0/1/0" severity error;
  
  	w_A <= '0'; w_B <= '1'; w_C_IN <= '1';
    wait for 1 ns;
    assert(w_S='0' and w_C_OUT='1') report "Fail 0/1/1" severity error;
  
  	w_A <= '1'; w_B <= '0'; w_C_IN <= '0';
    wait for 1 ns;
    assert(w_S='1' and w_C_OUT='0') report "Fail 1/0/0" severity error;
  
  	w_A <= '1'; w_B <= '0'; w_C_IN <= '1';
    wait for 1 ns;
    assert(w_S='0' and w_C_OUT='1') report "Fail 1/0/1" severity error;
  
  	w_A <= '1'; w_B <= '1'; w_C_IN <= '0';
    wait for 1 ns;
    assert(w_S='0' and w_C_OUT='1') report "Fail 1/1/0" severity error;
  
  	w_A <= '1'; w_B <= '1'; w_C_IN <= '1';
    wait for 1 ns;
    assert(w_S='1' and w_C_OUT='1') report "Fail 1/1/1" severity error;

    assert false report "Test done." severity note;
    wait;
  end process;
end tb;
