LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity snakeFood is
	port (
		clk : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		count : OUT STD_LOGIC;
	    v_sync : IN STD_LOGIC;
		pixel_row : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		pixel_col : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		red : OUT STD_LOGIC	
	);

END snakeFood;


architecture Behavioral of snakeFood is
	CONSTANT food_size : INTEGER := 16;
	SIGNAL food_on : STD_LOGIC;
	SIGNAL food_x : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50,10);
    	SIGNAL food_y : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50,10);

BEGIN
	red <= food_on;

food_drawing : PROCESS (food_x, food_y, pixel_row, pixel_col)
	   
BEGIN  
	IF((CONV_INTEGER(Pixel_col)-CONV_INTEGER(food_x))*
	(CONV_INTEGER(Pixel_col)-CONV_INTEGER(food_x))+
	(CONV_INTEGER(Pixel_row)-CONV_INTEGER(food_y))*
	(CONV_INTEGER(Pixel_row)-CONV_INTEGER(food_y)))<=
	CONV_INTEGER(food_size)*CONV_INTEGER(food_size)then
		
		      food_on <= '1';

		ELSE
			food_on <= '0';

		END IF;

		END PROCESS;

food_generation : PROCESS

BEGIN
	IF (head_x >= food_x - 15 AND head_x <= food_x + 15) AND (head_y >= food_y - 15 AND head_y <= food_y + 15) THEN
		      IF (food_x = CONV_STD_LOGIC_VECTOR(50, 10) AND food_y = CONV_STD_LOGIC_VECTOR(50,10)) THEN
		          food_x <= CONV_STD_LOGIC_VECTOR(100,10);
		          food_y <= CONV_STD_LOGIC_VECTOR(250,10);
		          
		END IF;
		      
		      IF (food_x = CONV_STD_LOGIC_VECTOR(100, 10) AND food_y = CONV_STD_LOGIC_VECTOR(250,10)) THEN
		          food_x <= CONV_STD_LOGIC_VECTOR(300,10);
		          food_y <= CONV_STD_LOGIC_VECTOR(75,10);
		         		          		          
		END IF;
		      
		      IF (food_x = CONV_STD_LOGIC_VECTOR(300, 10) AND food_y = CONV_STD_LOGIC_VECTOR(75,10)) THEN
		          food_x <= CONV_STD_LOGIC_VECTOR(200,10);
		          food_y <= CONV_STD_LOGIC_VECTOR(20,10);
		          
		END IF;
		      
		      IF (food_x = CONV_STD_LOGIC_VECTOR(200, 10) AND food_y = CONV_STD_LOGIC_VECTOR(20,10)) THEN
		          food_x <= CONV_STD_LOGIC_VECTOR(175,10);
		          food_y <= CONV_STD_LOGIC_VECTOR(70,10);
		          
		          
		END IF;
		      
		      IF (food_x = CONV_STD_LOGIC_VECTOR(175, 10) AND food_y = CONV_STD_LOGIC_VECTOR(70,10)) THEN
		          food_x <= CONV_STD_LOGIC_VECTOR(50,10);
		          food_y <= CONV_STD_LOGIC_VECTOR(50,10);

		END IF;
    end if;
END process;
END architecture;
