package game
import "core:fmt"
import "core:log"
import sdl "vendor:sdl2"

FPS :: 30
FRAME_TARGET_TIME :: 1000 / FPS
previous_frame_time: u32 = 0


N_POINTS :: 8
// N_POINTS :: 9 * 9 * 9
cube_points: [N_POINTS]Vec3
projected_points: [N_POINTS]Vec2

fov_factor: f32 = 128
camera_position := Vec3{0, 0, -3}
cube_rotation := Vec3{}


draw_noisey_cube :: proc() {
	point_count := 0
	for x: f32 = -1.0; x <= 1.0; x += 0.25 {
		for y: f32 = -1.0; y <= 1.0; y += 0.25 {
			for z: f32 = -1.0; z <= 1.0; z += 0.25 {
				new_point := Vec3{x, y, z}
				cube_points[point_count] = new_point
				point_count += 1
			}
		}
	}
}


draw_cube :: proc() {
	cube_points = {
		Vec3{x = -1, y = -1, z = -1},
		Vec3{x = -1, y = 1, z = -1},
		Vec3{x = 1, y = 1, z = -1},
		Vec3{x = 1, y = -1, z = -1},
		Vec3{x = 1, y = 1, z = 1},
		Vec3{x = 1, y = -1, z = 1},
		Vec3{x = -1, y = 1, z = 1},
		Vec3{x = -1, y = -1, z = 1},
	}
}


setup :: proc() {
	// set the pixel at the column 10 and row 20 as green
	// fmt.printfln("type of color_buufer: ", type_of(color_buffer))
	// color_buffer[WINDOW_WIDTH * 20 + 10] = 0x00ff00


	// load array of vectors
	// starting from -1 to 1 with lenght 2 for the cube
	draw_cube()
	projected_points = [N_POINTS]Vec2 {
		0 ..< N_POINTS = Vec2{},
	}

}

//////////////// Function that receives a 3d Vector and returns a  projected 2d point
project :: proc(point: Vec3) -> Vec2 {

	projected_point := Vec2{(point.x * fov_factor) / point.z, (point.y * fov_factor) / point.z}

	return projected_point
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
		if event.key.keysym.sym == .A {
			for point, index in projected_points {
				fmt.printfln("%v", point)
			}
		}
		break
	case:
		break
	}

}

update :: proc() {


	time_to_wait := FRAME_TARGET_TIME - (sdl.GetTicks() - previous_frame_time)

	if time_to_wait > 0 && time_to_wait <= FRAME_TARGET_TIME {
		sdl.Delay(time_to_wait)
	}


	previous_frame_time = sdl.GetTicks()


	cube_rotation.y += 0.01
	cube_rotation.x += 0.01
	cube_rotation.z += 0.01
	for _, index in cube_points {
		point := cube_points[index]

		transformed_point := vec3_rotate_y(point, cube_rotation.y)
		transformed_point = vec3_rotate_z(transformed_point, cube_rotation.z)
		transformed_point = vec3_rotate_x(transformed_point, cube_rotation.x)

		// simulate moving away from the camera
		transformed_point.z -= camera_position.z

		projected_point := project(transformed_point)
		projected_points[index] = projected_point
	}

}

render :: proc() {

	clear_color_buffer(0)

	// Loop all projected points and render them

	for point, index in projected_points {
		color: u32

		color = 0xFFFFFFFF

		render_draw_rectangle(
			int(point.x) + WINDOW_WIDTH / 2,
			int(point.y) + WINDOW_HEIGHT / 2,
			1,
			1,
			color,
		)
	}


	// render_draw_grid()

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
