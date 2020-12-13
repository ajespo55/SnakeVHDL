LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity snakepos is
	port (
		clk : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		length_in : in integer range 0 to 50 := 1;
		next_dir : in std_logic_vector(3 downto 0) := "0100";
	    v_sync : IN STD_LOGIC;
		pixel_row : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		pixel_col : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		green : OUT STD_LOGIC;
		head_x : out integer;
		head_y : out integer
	);
end snakepos;

architecture Behavioral of snakepos is
    constant snake_size : integer := 30;
    constant max_length : integer := 300;
    constant grid_size : integer := 40;
    constant boundary : integer := (grid_size-snake_size)/2;
    signal snake_on : std_logic := '0';
    type snake_pieces_array_type is array (0 to max_length, 0 to 2) of integer range 0 to 20; --- array of pieces where each piece contains 1 number for on or off and then the x,y grid coordinate
    signal snake_pieces : snake_pieces_array_type := ((1, 0, 0), others => (0,20,20));
    shared variable head_pos : integer range 0 to max_length := 0;
begin
green <= snake_on;
snake_drawing : process(pixel_row, pixel_col)
        function grid_to_pixel (grid_pos : integer range 0 to 20) return integer is
            variable pixel_coord : integer;
        begin
            pixel_coord := grid_pos*grid_size;
            return pixel_coord;
        end function grid_to_pixel;
    begin
    draw_loop : for i in 0 to length_in loop
        if (snake_pieces(i, 0) = 0)
            and (CONV_INTEGER(pixel_row) > grid_to_pixel(snake_pieces(i, 1)))
            and (CONV_INTEGER(pixel_row) < grid_to_pixel(snake_pieces(i, 1)) + grid_size)
            and (CONV_INTEGER(pixel_col) > grid_to_pixel(snake_pieces(i, 2)))
            and (CONV_INTEGER(pixel_col) < grid_to_pixel(snake_pieces(i, 2)) + grid_size) then
                snake_on <= '1';
        end if;
    end loop draw_loop;
end Process;
snake_positioning : process --- TODO: add collision code some
    variable old_head : integer range 0 to max_length := 0;
begin
    wait until rising_edge(v_sync);
    old_head := head_pos;
    head_pos := (head_pos - 1) mod length_in;
    case next_dir is
        when "1000" => --- left
            snake_pieces(head_pos, 0) <= 1;
            snake_pieces(head_pos, 1) <= snake_pieces(old_head, 1) - 1;
            snake_pieces(head_pos, 2) <= snake_pieces(old_head, 2);
        when "0100" => --- right
            snake_pieces(head_pos, 0) <= 1;
            snake_pieces(head_pos, 1) <= snake_pieces(old_head, 1) + 1;
            snake_pieces(head_pos, 2) <= snake_pieces(old_head, 2);
        when "0010" => --- up
            snake_pieces(head_pos, 0) <= 1;
            snake_pieces(head_pos, 1) <= snake_pieces(old_head, 1);
            snake_pieces(head_pos, 2) <= snake_pieces(old_head, 2) + 1;
        when "0001" => --- down
            snake_pieces(head_pos, 0) <= 1;
            snake_pieces(head_pos, 1) <= snake_pieces(old_head, 1);
            snake_pieces(head_pos, 2) <= snake_pieces(old_head, 2) - 1;
    end case;
    head_x <= snake_pieces(head_pos, 1);
    head_y <= snake_pieces(head_pos, 2);
end process;
length_change : process(length_in)
    variable snake_pieces_copy : snake_pieces_array_type := snake_pieces;
begin
    copy_loop : for i in 0 to length_in loop
        snake_pieces(i, 0) <= 1;
        snake_pieces(i, 1) <= snake_pieces_copy((i+head_pos) mod length_in-1, 1);
        snake_pieces(i, 2) <= snake_pieces_copy((i+head_pos) mod length_in-1, 2);
    end loop;
end process;
end Behavioral;
