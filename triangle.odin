package game
import oat "oatmeal"

Triangle :: struct {
	points: [3]oat.Vec2,
	color:  u32,
    avg_z: f32
}

swap :: proc {
	swap_int,
	swap_float,
}

swap_float :: proc(a, b: ^f32) {
	temp_a := a^
	a^ = b^
	b^ = temp_a
}

swap_int :: proc(a, b: ^int) {
	temp_a := a^
	a^ = b^
	b^ = temp_a
}

swap_dynamic_triangle_array_positions :: proc(array: ^[dynamic]Triangle, pos1: int, pos2: int) {
    // copy the temporary triangle
    temp_pos1 := array[pos1]
    array[pos1] = array[pos2]
    array[pos2] = temp_pos1
}
