package game

MeshVertices :: Vec3

Face :: struct {
	a, b, c: u32,
}

// ----------------------------CUBES------------------------------------------------ //
CUBE_VERTICES :: 8
CUBE_FACES :: 6 * 2

CubeVertices :: [CUBE_VERTICES]MeshVertices
CubeFaces :: [CUBE_FACES]Face

cube_mesh := mesh_generate_cube_vertices()
cube_faces := mesh_generate_cube_faces()

mesh_generate_cube_vertices :: proc() -> CubeVertices {
	cube_points: CubeVertices = {
		Vec3{x = -1, y = -1, z = -1},
		Vec3{x = -1, y = 1, z = -1},
		Vec3{x = 1, y = 1, z = -1},
		Vec3{x = 1, y = -1, z = -1},
		Vec3{x = 1, y = 1, z = 1},
		Vec3{x = 1, y = -1, z = 1},
		Vec3{x = -1, y = 1, z = 1},
		Vec3{x = -1, y = -1, z = 1},
	}
	return cube_points
}

// Generate faces. 6 faces per cube * two triangles per face
mesh_generate_cube_faces :: proc() -> CubeFaces {
	return CubeFaces {
		// front
		{a = 1, b = 2, c = 3},
		{a = 1, b = 3, c = 4},
		// right
		{a = 4, b = 3, c = 5},
		{a = 4, b = 5, c = 6},
		// back
		{a = 6, b = 5, c = 7},
		{a = 6, b = 7, c = 8},
		// left
		{a = 8, b = 7, c = 2},
		{a = 8, b = 2, c = 1},
		// top
		{a = 2, b = 7, c = 5},
		{a = 2, b = 5, c = 3},
		// bottom
		{a = 6, b = 8, c = 1},
		{a = 6, b = 1, c = 4},
	}
}

// ----------------------------MESHES------------------------------------------------ //
//
Mesh :: struct {
	vertices: [dynamic]MeshVertices,
	faces:    [dynamic]Face,
	rotation: Vec3,
}

mesh_delete_mesh :: proc(mesh: ^Mesh) {
	delete(mesh.vertices)
	delete(mesh.faces)
}

// try to clear the mesh dynamnic arrays and set the length to 0
mesh_free_mesh :: proc(mesh: ^Mesh) {
	clear(&mesh.faces)
	clear(&mesh.vertices)
}

mesh_load_cube :: proc(mesh: ^Mesh) {
	for vertex in cube_mesh {
		append(&mesh.vertices, vertex)
	}
	for face in cube_faces {
		append(&mesh.faces, face)
	}
}

mesh := Mesh {
	vertices = make([dynamic]MeshVertices),
	faces = make([dynamic]Face),
	rotation = Vec3{x = 0, y = 0, z = 0},
}
