package game
import "core:math"

Vec2 :: struct {
	x: f32,
	y: f32,
}

Vec3 :: struct {
	x, y, z: f32,
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
