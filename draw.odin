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

draw_triangle_lines :: proc(x0, y0, x1, y1, x2, y2: int, color: u32) {
	draw_line_ddr(x0, y0, x1, y1, color)
	draw_line_ddr(x1, y1, x2, y2, color)
	draw_line_ddr(x2, y2, x0, y0, color)
}

fill_flat_top_triangle :: proc(x0, y0, x1, y1, x2, y2: int, color: u32) {
	inv_slope_a := f32(x2 - x0) / f32(y2 - y0)
	inv_slope_b := f32(x2 - x1) / f32(y2 - y1)

	x_start := f32(x2)
	x_end := f32(x2)

	for y := y2; y >= y0; y -= 1 {
		draw_line_ddr(int(math.round(x_start)), y, int(x_end), y, color)
		x_start -= inv_slope_a
		x_end -= inv_slope_b
	}
}

fill_flat_bottom_triangle :: proc(x0, y0, x1, y1, x2, y2: int, color: u32) {
	inv_slope_a := f32(x1 - x0) / f32(y1 - y0)
	inv_slope_b := f32(x2 - x0) / f32(y2 - y0)

	x_start := f32(x0)
	x_end := f32(x0)

	// loop all the scan lines from top to bottom:
	for y := y0; y <= y2; y += 1 {
		draw_line_ddr(int(math.round(x_start)), y, int(x_end), y, color)
		x_start += inv_slope_a
		x_end += inv_slope_b
	}
}

draw_triangle_fill :: proc(x0, y0, x1, y1, x2, y2: int, fill_color: u32) {

	// shadow variables
	x0, x1, x2 := x0, x1, x2
	y0, y1, y2 := y0, y1, y2
	// sort points of the triangle on Y axis
	if (y0 > y1) {
		swap(&y0, &y1)
		swap(&x0, &x1)
	}
	if (y1 > y2) {
		swap(&y1, &y2)
		swap(&x1, &x2)
	}
	if (y0 > y1) {
		swap(&y0, &y1)
		swap(&x0, &x1)
	}

	if y1 == y2 {
		fill_flat_bottom_triangle(x0, y0, x1, y1, x2, y2, fill_color)
	} else if y0 == y1 {
		fill_flat_top_triangle(x0, y0, x1, y1, x2, y2, fill_color)
	} else {
		// find Triangle midpoint. 
		my := y1
		mx := f32((x2 - x0) * (y1 - y0)) / f32(y2 - y0) + f32(x0)
		// fill triangle
		fill_flat_bottom_triangle(x0, y0, x1, y1, int(math.round(mx)), my, fill_color)
		fill_flat_top_triangle(x1, y1, int(math.round(mx)), my, x2, y2, fill_color)
	}


}
