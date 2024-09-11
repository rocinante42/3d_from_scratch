package game
import "core:fmt"
import "core:log"
import sdl "vendor:sdl2"

FPS :: 60
FRAME_TARGET_TIME :: 1000 / FPS
previous_frame_time: u32 = 0

RenderOptionsState :: struct {
	show_wireframe, show_vertex_dot, show_fill_color, enable_backface_culling: bool,
}


fov_factor: f32 = 128 * 4
camera_position := Vec3{0, 0, 0}
cube_rotation := Vec3{}
render_options_state := RenderOptionsState {
	show_wireframe = true,
}


triangles_to_render := make([dynamic]Triangle)


setup :: proc() {
	// set the pixel at the column 10 and row 20 as green
	// fmt.printfln("type of color_buufer: ", type_of(color_buffer))
	// color_buffer[WINDOW_WIDTH * 20 + 10] = 0x00ff00
	// mesh_load_cube(&mesh)
	// load array of vectors
	// starting from -1 to 1 with lenght 2 for the cube
	//

	obj_load_from_path("cube.obj", &mesh)
}

ProjectionType :: enum {
	ORTHO,
	PERSPECTIVE,
}

//////////////// Function that receives a 3d Vector and returns a  projected 2d point
project :: proc(point: Vec3, projection: ProjectionType) -> Vec2 {
	projected_point: Vec2

	switch projection {
	case .ORTHO:
		fov_divider: f32 = 4
		projected_point = Vec2 {
			(point.x * (fov_factor / fov_divider)),
			(point.y * (fov_factor / fov_divider)),
		}
		break
	case .PERSPECTIVE:
		projected_point = Vec2{(point.x * fov_factor) / point.z, (point.y * fov_factor) / point.z}
		break
	}

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
		#partial switch event.key.keysym.sym {
		case .ESCAPE:
			is_window_running = false
			break
		case .NUM1:
			render_options_state = RenderOptionsState {
				show_vertex_dot = true,
				show_wireframe  = true,
			}
			break
		case .NUM2:
			render_options_state = RenderOptionsState {
				show_wireframe = true,
			}
			break
		case .NUM3:
			render_options_state = RenderOptionsState {
				show_fill_color = true,
			}
			break
		case .NUM4:
			render_options_state = RenderOptionsState {
				show_fill_color = true,
				show_wireframe  = true,
			}
			break
		case .C:
			render_options_state.enable_backface_culling = true
			break
		case .D:
			render_options_state.enable_backface_culling = false
			break
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

	mesh.rotation.x += 0.01
	mesh.rotation.y += 0.01
	mesh.rotation.z += 0.01

	for face, index in mesh.faces {
		face_vertex: [3]Vec3

		face_vertex[0] = mesh.vertices[face.a - 1]
		face_vertex[1] = mesh.vertices[face.b - 1]
		face_vertex[2] = mesh.vertices[face.c - 1]
		transformed_point: [3]Vec3
		projected_triangle: Triangle

		for j in 0 ..= 2 {
			transformed_point[j] = face_vertex[j]
			transformed_point[j] = vec3_rotate_x(transformed_point[j], mesh.rotation.x)
			transformed_point[j] = vec3_rotate_y(transformed_point[j], mesh.rotation.y)
			transformed_point[j] = vec3_rotate_z(transformed_point[j], mesh.rotation.z)

			// zoom out from camera
			transformed_point[j].z += 5
		}

		// check backface culling 
		if render_options_state.enable_backface_culling {
			// get the vectors AC and AB from the triangle
			// order matters so we should do indexes 1, 2, 3 in clockwise orientation
			vec_a := transformed_point[0] //    A
			vec_b := transformed_point[1] //  /  \
			vec_c := transformed_point[2] // C---B

			// get the vectors segments from the triangle
			vec_ab := vec3_substract(vec_b, vec_a)
			vec3_normalize(&vec_ab)
			vec_ac := vec3_substract(vec_c, vec_a)
			vec3_normalize(&vec_ac)
			// find the normal-cross product
			normal := vec3_cross(vec_ab, vec_ac)
			vec3_normalize(&normal)
			camera_ray := vec3_substract(camera_position, vec_a)

			// dot product between camera ray and normal
			dot_product := vec3_dot(normal, camera_ray)
			if dot_product < 0 {continue}
		}


		for j in 0 ..= 2 {

			// project the 3d point into 2d space
			projected_point := project(transformed_point[j], .PERSPECTIVE)

			// scale and translate

			projected_point.x += WINDOW_WIDTH / 2
			projected_point.y += WINDOW_HEIGHT / 2

			projected_triangle.points[j] = projected_point

		}
		append(&triangles_to_render, projected_triangle)


	}


}

render :: proc() {

	clear_color_buffer(0)

	// Loop all projected points and render them

	// render_draw_grid()

	for triangle, index in triangles_to_render {

		

		if render_options_state.show_fill_color {
			draw_triangle_fill(
				int(triangle.points[0].x),
				int(triangle.points[0].y),
				int(triangle.points[1].x),
				int(triangle.points[1].y),
				int(triangle.points[2].x),
				int(triangle.points[2].y),
				0xffffffff,
			)
		}

		if render_options_state.show_wireframe == true {
			draw_triangle_lines(
				int(triangle.points[0].x),
				int(triangle.points[0].y),
				int(triangle.points[1].x),
				int(triangle.points[1].y),
				int(triangle.points[2].x),
				int(triangle.points[2].y),
				0xFF00FF00,
			)
		}

        if render_options_state.show_vertex_dot {
			for point, point_index in triangle.points {
				render_draw_rectangle(int(point.x), int(point.y), 3, 3, 0xFFFFFF00)
			}
		}

	}
	// draw_triangle_lines(300, 100, 50, 400, 500, 700, 0xffff0000)
	// draw_triangle_fill(300, 100, 50, 400, 500, 700, 0xffff0000)

	// test the drawing line algorithm
	// draw_line_ddr(100, 80, 100, 200, 0xFF00FF00)

	render_color_buffer()
	clear(&triangles_to_render)

	sdl.RenderPresent(renderer)
}

free_resources :: proc() {
	delete(triangles_to_render)
	mesh_delete_mesh(&mesh)
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
	free_resources()
	destroy_window()
}
