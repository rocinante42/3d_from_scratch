package game
import oat "oatmeal"

MeshVertices :: oat.Vec3
Vec3 :: oat.Vec3
Vec2 :: oat.Vec2

Face :: struct {
	a, b, c: u32,
    color: u32
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
		{a = 1, b = 2, c = 3, color=0xFFFF00FF},
		{a = 1, b = 3, c = 4, color=0xFFFF00FF},
		// right
		{a = 4, b = 3, c = 5, color=0xFF00FF00},
		{a = 4, b = 5, c = 6, color=0xFF00FF00},
		// back
		{a = 6, b = 5, c = 7, color=0xFF0000FF},
		{a = 6, b = 7, c = 8, color=0xFF0000FF},
		// left
		{a = 8, b = 7, c = 2, color=0xFFFF0000},
		{a = 8, b = 2, c = 1, color=0xFFFF0000},
		// top
		{a = 2, b = 7, c = 5, color=0xFF00FFFF},
		{a = 2, b = 5, c = 3, color=0xFF00FFFF},
		// bottom
		{a = 6, b = 8, c = 1, color=0xFFFFF00F},
		{a = 6, b = 1, c = 4, color=0xFFFFF00F},
	}
}

// ----------------------------MESHES------------------------------------------------ //
//
Mesh :: struct {
	vertices: [dynamic]MeshVertices,
	faces:    [dynamic]Face,
	rotation: Vec3,
    scale: Vec3,
    translation: Vec3
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
    scale = Vec3 {1, 1, 1}
}
