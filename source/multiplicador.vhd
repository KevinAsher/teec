library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplicador is
  generic (g_SIZE: integer := 8);
  port (
  	i_A 	: in std_logic_vector(g_SIZE-1 downto 0);
    i_B   	: in std_logic_vector(g_SIZE-1 downto 0);
    o_M  	: out std_logic_vector(2*g_SIZE-1 downto 0)
  );
end entity;


architecture arch of multiplicador is
	-- used for multiplication carry outs
	signal w_C: std_logic_vector((g_SIZE+1)*(g_SIZE)-1 downto 0);
	
    -- used for multiplications results
    signal w_M: std_logic_vector((g_SIZE)*(g_SIZE-1)-1 downto 0);
begin

	ROWS: for row in 0 to g_SIZE generate
    	FIRST_ROW: if row=0 generate
        	COLUMN_LOOP: for col in 0 to g_SIZE-1 generate
 
                FIRST_COLUMN: if col=0 generate
                  MC: entity work.mult_cell 
                          port map (
                              i_A => i_A(row),
                              i_B => i_B(col),
                              i_M => '0',
                              i_C => '0',
                              o_C => w_C(g_SIZE*(row) + col),
                              o_M => o_M(row)
                          );
                  end generate;
                
                INTERMEDIATE_COLUMN: if col<g_SIZE-1 and col>0 generate
              		MC: entity work.mult_cell 
                		port map (
                    		i_A => i_A(row),
                    		i_B => i_B(col),
                    		i_M => '0',
                        i_C => '0',
                    		o_C => w_C(g_SIZE*(row) + col),
                  			o_M => w_M((g_SIZE-1)*(row) + col-1)
                		);
                end generate;
                
                LAST_COLUMN: if col=g_SIZE-1 generate
              		MC: entity work.mult_cell_inv 
                		port map (
                    		i_A => i_A(row),
                    		i_B => i_B(col),
                    		i_M => '0',
                        i_C => '0',
                    		o_C => w_C(g_SIZE*(row) + col),
                  			o_M => w_M((g_SIZE-1)*(row) + col-1)
                		);
                end generate;
                
        	end generate;
    	end generate;
        
        INTERMEDIATE_ROW: if row>0 and row <g_SIZE-1 generate
        	COLUMN_LOOP: for col in 0 to g_SIZE-1 generate
 
                FIRST_COLUMN: if col=0 generate
                  MC: entity work.mult_cell 
                          port map (
                              i_A => i_A(row),
                              i_B => i_B(col),
                              i_M => w_M((g_SIZE-1)*(row-1) + col),
                              i_C => w_C(g_SIZE*(row-1) + col),
                              o_C => w_C(g_SIZE*(row) + col),
                              o_M => o_M(row)
                          );
                  end generate;
                
                INTERMEDIATE_COLUMN: if col<g_SIZE-1 and col>0 generate
              		MC: entity work.mult_cell 
                          port map (
                              i_A => i_A(row),
                              i_B => i_B(col),
                              i_M => w_M((g_SIZE-1)*(row-1) + col),
                              i_C => w_C(g_SIZE*(row-1) + col),
                              o_C => w_C(g_SIZE*(row) + col),
                              o_M => w_M((g_SIZE-1)*(row) + col-1)
                          );
                end generate;
                
                LAST_COLUMN_SECOND_ROW: if col=g_SIZE-1 and row=1 generate
              		MC: entity work.mult_cell_inv
                		port map (
                    		i_A => i_A(row),
                    		i_B => i_B(col),
                    		i_M => '1',
                        i_C => w_C(g_SIZE*(row-1) + col),
                    		o_C => w_C(g_SIZE*(row) + col),
                  			o_M => w_M((g_SIZE-1)*(row) + col-1)
                		);
                end generate;

                LAST_COLUMN: if col=g_SIZE-1 and row>1 generate
                  MC: entity work.mult_cell_inv
                		port map (
                    		i_A => i_A(row),
                    		i_B => i_B(col),
                    		i_M => '0',
                        i_C => w_C(g_SIZE*(row-1) + col),
                    		o_C => w_C(g_SIZE*(row) + col),
                  			o_M => w_M((g_SIZE-1)*(row) + col-1)
                		);
                end generate;

                
        	end generate;
    	end generate;
        
      SECOND_LAST_ROW: if row = g_SIZE-1 generate
        COLUMN_LOOP: for col in 0 to g_SIZE-1 generate
 
                FIRST_COLUMN: if col=0 generate
                  MC: entity work.mult_cell_inv 
                          port map (
                              i_A => i_A(row),
                              i_B => i_B(col),
                              i_M => w_M((g_SIZE-1)*(row-1) + col),
                              i_C => w_C(g_SIZE*(row-1) + col),
                              o_C => w_C(g_SIZE*(row) + col),
                              o_M => o_M(row)
                          );
                  end generate;
                
                INTERMEDIATE_COLUMN: if col<g_SIZE-1 and col>0 generate
              		MC: entity work.mult_cell_inv 
                          port map (
                              i_A => i_A(row),
                              i_B => i_B(col),
                              i_M => w_M((g_SIZE-1)*(row-1) + col),
                              i_C => w_C(g_SIZE*(row-1) + col),
                              o_C => w_C(g_SIZE*(row) + col),
                              o_M => w_M((g_SIZE-1)*(row) + col-1)
                          );
                end generate;

                LAST_COLUMN: if col=g_SIZE-1 and row>1 generate
                  MC: entity work.mult_cell
                		port map (
                    		i_A => i_A(row),
                    		i_B => i_B(col),
                    		i_M => '0',
                        i_C => w_C(g_SIZE*(row-1) + col),
                    		o_C => w_C(g_SIZE*(row) + col),
                  			o_M => w_M((g_SIZE-1)*(row) + col-1)
                		);
                end generate;

                
        	end generate;
    	end generate;
      

      LAST_ROW: if row = g_SIZE generate
        COLUMN_LOOP: for col in 0 to g_SIZE-1 generate

              FIRST_COLUMN: if col=0 generate
                MC: entity work.mult_cell
                  port map (
                      i_A => w_M((g_SIZE-1)*(row-1) + col),
                      i_B => w_M((g_SIZE-1)*(row-1) + col),
                      i_M => w_C(g_SIZE*(row-1) + col),
                      i_C => '0',
                      o_C => w_C(g_SIZE*(row) + col),
                      o_M => o_M(row+col)
                  );
              end generate;
              
              INTERMEDIATE_COLUMN: if col<g_SIZE-1 and col>0 generate
                MC: entity work.mult_cell 
                  port map (
                      i_A => w_M((g_SIZE-1)*(row-1) + col),
                      i_B => w_M((g_SIZE-1)*(row-1) + col),
                      i_M => w_C(g_SIZE*(row-1) + col),
                      i_C => w_C(g_SIZE*(row) + col-1),
                      o_C => w_C(g_SIZE*(row) + col),
                      o_M => o_M(row+col)
                  );
              end generate;
              
              LAST_COLUMN: if col=g_SIZE-1 generate
                MC: entity work.mult_cell 
                        port map (
                            i_A => '1',
                            i_B => '1',
                            i_M => w_C(g_SIZE*(row-1) + col),
                            i_C => w_C(g_SIZE*(row) + col-1),
                            o_C => w_C(g_SIZE*(row) + col),
                            o_M => o_M(row+col)
                        );
              end generate;
                
        	end generate;
    	end generate;
        
        
        
   	end generate;

end architecture;