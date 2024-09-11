package game

Triangle :: struct {
	points: [3]Vec2,
}

swap :: proc{
    swap_int,
    swap_float
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

