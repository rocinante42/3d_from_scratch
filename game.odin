package game
import "core:fmt"
import "core:log"
import sdl "vendor:sdl2"

FPS :: 60
FRAME_TARGET_TIME :: 1000 / FPS
previous_frame_time: u32 = 0


fov_factor: f32 = 128
camera_position := Vec3{0, 0, -3}
cube_rotation := Vec3{}
cube_faces := mesh_generate_cube_faces()


triangles_to_render: [CUBE_FACES]Triangle


setup :: proc() {
	// set the pixel at the column 10 and row 20 as green
	// fmt.printfln("type of color_buufer: ", type_of(color_buffer))
	// color_buffer[WINDOW_WIDTH * 20 + 10] = 0x00ff00


	// load array of vectors
	// starting from -1 to 1 with lenght 2 for the cube
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
			fmt.println("hello world")
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


	cube_rotation.x += 0.01
	cube_rotation.y += 0.01
	cube_rotation.z += 0.01

	for face, index in cube_faces {
		face_vertex: [3]Vec3

		face_vertex[0] = cube_mesh[face.a - 1]
		face_vertex[1] = cube_mesh[face.b - 1]
		face_vertex[2] = cube_mesh[face.c - 1]

		projected_triangle: Triangle

		for j in 0 ..= 2 {
			transformed_point := face_vertex[j]
			transformed_point = vec3_rotate_x(transformed_point, cube_rotation.x)
			transformed_point = vec3_rotate_y(transformed_point, cube_rotation.y)
			transformed_point = vec3_rotate_z(transformed_point, cube_rotation.z)

			// zoom out from camera
			transformed_point.z -= camera_position.z

			// project the 3d point into 2d space
			projected_point := project(transformed_point)

			// scale and translate

			projected_point.x += WINDOW_WIDTH / 2
			projected_point.y += WINDOW_HEIGHT / 2

			projected_triangle.points[j] = projected_point
		}


		triangles_to_render[index] = projected_triangle
	}


}

render :: proc() {

	clear_color_buffer(0)

	// Loop all projected points and render them

	// render_draw_grid()

	for triangle, index in triangles_to_render {

		for point, point_index in triangle.points {
			render_draw_rectangle(int(point.x), int(point.y), 1, 1, 0xFFFFFFFF)
		}

		// draw;lines;between;points
		// from;a;to;be:
		// draw_line_ddr(
		// 	int(triangle.points[0].x),
		// 	int(triangle.points[0].y),
		// 	int(triangle.points[1].x),
		// 	int(triangle.points[1].y),
		// 	0xFF00FF00,
		// )
		// // from b to C:
		draw_line_ddr(
			int(triangle.points[1].x),
			int(triangle.points[1].y),
			int(triangle.points[2].x),
			int(triangle.points[2].y),
			0xFF00FF00,
		)
		// // from c to a:
		draw_line_ddr(
			int(triangle.points[2].x),
			int(triangle.points[2].y),
			int(triangle.points[0].x),
			int(triangle.points[0].y),
			0xFF00FF00,
		)

	}

	// test the drawing line algorithm
	// draw_line_ddr(100, 80, 100, 200, 0xFF00FF00)

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
