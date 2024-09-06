package game
import "core:fmt"
import "core:math"
import sdl "vendor:sdl2"


color_buffer := [WINDOW_HEIGHT * WINDOW_WIDTH]u32 {
	0 ..< (WINDOW_HEIGHT * WINDOW_WIDTH) = 0xFFFFFF,
}


clear_color_buffer :: proc(clear_color: u32) {

	for color, index in color_buffer {
		color_buffer[index] = clear_color
	}


}

render_color_buffer :: proc() {
	sdl.UpdateTexture(color_buffer_texture, nil, &color_buffer, WINDOW_WIDTH * size_of(u32))
	sdl.RenderCopy(renderer, color_buffer_texture, nil, nil)
}


render_draw_rectangle :: proc(x, y, w, h: int, color: u32) {
	if x >= 0 &&
	   x <= WINDOW_WIDTH &&
	   w <= WINDOW_WIDTH &&
	   y >= 0 &&
	   y <= WINDOW_HEIGHT &&
	   h <= WINDOW_HEIGHT {
		for i := 0; i < h; i += 1 {
			for j := 0; j < w; j += 1 {
				// get the current index in the buffer based on x:
				starting_index := (y + i) * WINDOW_WIDTH + x + j
				color_buffer[starting_index] = color
			}
		}

	}

}

render_draw_grid :: proc() {
	for color, index in color_buffer {
		// get column and row coordinates
		row := index / WINDOW_WIDTH
		col := index % WINDOW_WIDTH

		if row % 10 == 0 || col % 10 == 0 {
			color_buffer[index] = 0xDDDDDDDD
		}
	}
}

draw_pixel :: proc(x, y: int, color: u32) {
	if x >= 0 && x < WINDOW_WIDTH && y >= 0 && y < WINDOW_HEIGHT {
		color_buffer[y * WINDOW_WIDTH + x] = color
	}
}

// Draw a line from point to point using Digital Diferential Analizer (DDR)
// algorithm
draw_line_ddr :: proc(x0, y0, x1, y1: int, color: u32) {
	delta_x := x1 - x0
	delta_y := y1 - y0

	longest_side: int
	if math.abs(delta_x) >= math.abs(delta_y) {
		longest_side = math.abs(delta_x)
	} else {
		longest_side = math.abs(delta_y)
	}

	x_increment := f32(delta_x) / f32(longest_side)
	y_increment := f32(delta_y) / f32(longest_side)

	current_x := f32(x0)
	current_y := f32(y0)


	for i in 0 ..= longest_side {
		draw_pixel(int(math.round_f32(current_x)), int(math.round_f32(current_y)), color)
		current_x += x_increment
		current_y += y_increment
	}

}
