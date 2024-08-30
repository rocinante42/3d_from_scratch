package game
import "core:fmt"
import "core:log"
import sdl "vendor:sdl2"


setup :: proc() {
	// set the pixel at the column 10 and row 20 as green
	// fmt.printfln("type of color_buufer: ", type_of(color_buffer))
	// color_buffer[WINDOW_WIDTH * 20 + 10] = 0x00ff00
}

process_input :: proc() {
	event: sdl.Event
	sdl.PollEvent(&event)


	#partial switch event.type {
	case .QUIT:
		is_window_running = false
		break
	case .KEYDOWN:
		if event.key.keysym.sym == .ESCAPE {
			is_window_running = false
		}
		break
	case:
		break
	}

}

update :: proc() {

}

render :: proc() {
	sdl.SetRenderDrawColor(renderer, 255, 25, 0, 255)
	sdl.RenderClear(renderer)

	clear_color_buffer(0xFFFFFF)
	render_draw_grid()
	render_draw_rectangle(30, 30, 40, 40, 0x000000FF00)
	render_color_buffer()


	sdl.RenderPresent(renderer)
}


main :: proc() {
	// create a SDL window //
	is_window_running = initialize_window()

	setup()

	for is_window_running {
		process_input()
		update()
		render()
	}

	destroy_window()
}
