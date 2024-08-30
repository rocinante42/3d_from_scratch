package game
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
	assert(x >= 0 && x <= WINDOW_WIDTH && w <= WINDOW_WIDTH)
	assert(y >= 0 && y <= WINDOW_HEIGHT && h <= WINDOW_HEIGHT)

	for i := 0; i < h; i += 1 {
		for j := 0; j < w; j += 1 {
			// get the current index in the buffer based on x:
			starting_index := (y + i) * WINDOW_WIDTH + x + j
			color_buffer[starting_index] = color
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
	assert(x >= 0 && x <= WINDOW_WIDTH)
	assert(y >= 0 && y <= WINDOW_HEIGHT)

	color_buffer[y * WINDOW_WIDTH + x] = color
}
