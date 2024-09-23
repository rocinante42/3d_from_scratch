package oatmeal
import "core:math"
////////////////////////////// VEC2 /////////////////////////////// 
Vec2 :: struct {
	x: f32,
	y: f32,
}

Vec4 :: struct {
    x, y, z, w: f32
}

// Returns the maginute of a Vec2
vec2_len :: proc(v: Vec2) -> f32 {
	return math.sqrt(math.pow(v.x, 2) + math.pow(v.y, 2))
}

vec2_add :: proc(a: Vec2, b: Vec2) -> Vec2 {
	return Vec2{x = a.x + b.x, y = a.y + b.y}
}

vec2_substract :: proc(a, b: Vec2) -> Vec2 {
	return Vec2{x = a.x - b.x, y = a.y - b.y}
}

vec2_mul :: proc(v: Vec2, factor: f32) -> Vec2 {
	return Vec2{x = v.x * factor, y = v.y * factor}
}

vec2_div :: proc(v: Vec2, factor: f32) -> Vec2 {
	return Vec2{x = v.x / factor, y = v.y / factor}
}

vec2_dot :: proc(a: Vec2, b: Vec2) -> f32 {
	return a.x * b.x + a.y * b.y
}

vec2_normalize :: proc(v: ^Vec2) {
	vector_length := vec2_len(v^)
	v.x /= vector_length
	v.y /= vector_length
}

///////////////////////////////////////////////////////////////////
//
////////////////////////////// VEC3 /////////////////////////////// 
Vec3 :: struct {
	x, y, z: f32,
}

vec3_add :: proc(a, b: Vec3) -> Vec3 {
	return Vec3{x = a.x + b.x, y = a.y + b.y, z = a.z + b.z}
}

vec3_substract :: proc(a, b: Vec3) -> Vec3 {
	return Vec3{x = a.x - b.x, y = a.y - b.y, z = a.z - b.z}
}

vec3_mul :: proc(v: Vec3, factor: f32) -> Vec3 {
	return Vec3{x = v.x * factor, y = v.y * factor, z = v.z * factor}
}

vec3_div :: proc(v: Vec3, factor: f32) -> Vec3 {
	return Vec3{x = v.x / factor, y = v.y / factor, z = v.z / factor}
}

vec3_cross :: proc(a: Vec3, b: Vec3) -> Vec3 {
	return Vec3{x = a.y * b.z - a.z * b.y, y = a.z * b.x - a.x * b.z, z = a.x * b.y - a.y * b.x}
}

vec3_dot :: proc(a: Vec3, b: Vec3) -> f32 {
	return a.x * b.x + a.y * b.y + a.z * b.z
}

vec3_len :: proc(v: Vec3) -> f32 {
	return math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
}

vec3_normalize :: proc(v: ^Vec3) {
	vector_length := vec3_len(v^)
	v.x /= vector_length
	v.y /= vector_length
	v.z /= vector_length
}

vec3_rotate_x :: proc(v: Vec3, angle: f32) -> Vec3 {
	return Vec3 {
		x = v.x,
		y = v.y * math.cos(angle) - v.z * math.sin(angle),
		z = v.y * math.sin(angle) + v.z * math.cos(angle),
	}
}
vec3_rotate_y :: proc(v: Vec3, angle: f32) -> Vec3 {
	return Vec3 {
		x = v.x * math.cos(angle) - v.z * math.sin(angle),
		y = v.y,
		z = v.x * math.sin(angle) + v.z * math.cos(angle),
	}

}
vec3_rotate_z :: proc(v: Vec3, angle: f32) -> Vec3 {
	return Vec3 {
		x = v.x * math.cos(angle) - v.y * math.sin(angle),
		y = v.x * math.sin(angle) + v.y * math.cos(angle),
		z = v.z,
	}
}
vec3_from_vec4 :: proc(v: Vec4) -> Vec3 {
    return Vec3 {v.x, v.y, v.z}
}

vec4_from_vec3 :: proc(v: Vec3) -> Vec4 {
    return Vec4 {v.x, v.y, v.z, 1}
}

