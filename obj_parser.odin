package game
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
// loads into mesh a single .obj from path
obj_load_from_path :: proc(path: string, mesh: ^Mesh) -> bool {
	// list first iterate thorugh entire file to get the lines
	data, ok := os.read_entire_file(path, context.allocator)
	if !ok {
		fmt.println("Error reading from file at path: ", path)
		return false
	}
	defer delete(data, context.allocator)

	// clear the mesh so we don't overwrite indexes
	mesh_free_mesh(mesh)

	it := string(data)
	for line in strings.split_lines_iterator(&it) {
		// iterate line
		// get the vertex data if the line starts with v
		if strings.has_prefix(line, "v ") {
			vertex: Vec3

			// break the line for each blank space into a new element
			elements := strings.split(line, " ", context.allocator)
			defer delete(elements, context.allocator)

			// the first element we can ignore since will be the "v " character.
			vertex.x = f32(strconv.atof(elements[1]))
			vertex.y = f32(strconv.atof(elements[2]))
			vertex.z = f32(strconv.atof(elements[3]))

			// append the new vertex to the mesh data
			append(&mesh.vertices, vertex)

			// or perhaps is a face
		} else if strings.has_prefix(line, "f ") {

			face: Face
			elements := strings.split(line, " ", context.allocator)
			defer delete(elements, context.allocator)

			indexes := make([dynamic]int)
			defer delete(indexes)
			counter := 0
			// face.a = u32(strconv.atoi(string(elements[1][0])))
			for element, index in elements {
				if index == 0 {continue}
				values := strings.split(element, "/", context.allocator)
				defer delete(values, context.allocator)

				append(&indexes, strconv.atoi(values[0]))
			}

			// since our faces are hardcoded with 3 indexes, lets just assign them by hand
			face.a = u32(indexes[0])
			face.b = u32(indexes[1])
			face.c = u32(indexes[2])

			append(&mesh.faces, face)
		} else {
			continue
		}
	}
	return true
}
