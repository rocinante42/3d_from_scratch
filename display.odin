package game
import "core:log"
import sdl "vendor:sdl2"


WINDOW_WIDTH :: 640
WINDOW_HEIGHT :: 380

is_window_running := false
window: ^sdl.Window
renderer: ^sdl.Renderer
color_buffer_texture: ^sdl.Texture

initialize_window :: proc() -> (ok: bool) {
	if sdl_init_response := sdl.Init(sdl.INIT_EVERYTHING); sdl_init_response < 0 {
		log.errorf("sdl2.init returned %v.", sdl_init_response)
		return false
	}

	// Use SDL to query what is the fullscreen max width and height of the monitor
	// executing the application

	displayMode: sdl.DisplayMode

	sdl.GetCurrentDisplayMode(0, &displayMode)

	window_width := displayMode.w
	window_height := displayMode.h


	window = sdl.CreateWindow(
		"hello world",
		sdl.WINDOWPOS_CENTERED,
		sdl.WINDOWPOS_CENTERED,
		window_width,
		window_height,
		sdl.WindowFlags{.BORDERLESS, .SKIP_TASKBAR},
	)

	if window == nil {
		log.errorf("Error creating SDL window")
		return false
	}

	// this part is crucial as it determines that the rendering
	// is performed by CPU and not GPU
	renderer = sdl.CreateRenderer(window, -1, {.SOFTWARE})
	if renderer == nil {
		log.errorf("Error creating SDL renderer")
		return false
	}


	// create texture
	color_buffer_texture = sdl.CreateTexture(
		renderer,
		.ARGB8888,
		.STREAMING,
		WINDOW_WIDTH,
		WINDOW_HEIGHT,
	)
	if color_buffer_texture == nil {
		log.errorf("Error creating texture")
		return false
	}


	return true
}

draw_triangle_lines :: proc(x0, y0, x1, y1, x2, y2: int, color: u32) {
	draw_line_ddr(x0, y0, x1, y1, color)
	draw_line_ddr(x1, y1, x2, y2, color)
	draw_line_ddr(x2, y2, x0, y0, color)
}

destroy_window :: proc() {
	sdl.DestroyTexture(color_buffer_texture)
	sdl.DestroyRenderer(renderer)
	sdl.DestroyWindow(window)
	sdl.Quit()
}
