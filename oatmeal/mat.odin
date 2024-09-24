package oatmeal 
import "core:math"

Mat3 :: [3][3]f32
Mat4 :: [4][4]f32


mat3_multiply :: proc(a: Mat3, b: Mat3) -> Mat3 {
    result : [3][3]f32
    for vec3, index in a {
        x := vec3.x * b[0].x + vec3.y * b[1].x + vec3.z * b[2].x
        y := vec3.x * b[0].y + vec3.y * b[1].y + vec3.z * b[2].y
        z := vec3.x * b[0].z + vec3.y * b[1].z + vec3.z * b[2].z
        result[index] =  [3]f32{x,y,z}
    }
    return result
}

mat4_multiply :: proc(a: Mat4, b: Mat4) -> Mat4 {
    result: [4][4]f32 
    for row, index in a {
        x := row.x * b[0].x + row.y * b[1].x + row.z * b[2].x + row.w * b[3].x
        y := row.x * b[0].y + row.y * b[1].y + row.z * b[2].y + row.w * b[3].y
        z := row.x * b[0].z + row.y * b[1].z + row.z * b[2].z + row.w * b[3].z
        w := row.x * b[0].w + row.y * b[1].w + row.z * b[2].w + row.w * b[3].w

        result[index] = [4]f32{x, y, z, w}
    }
    return result
}

// Returns an identity matrix of 4x4 with the diagonal of 1s
mat4_identity :: proc() -> Mat4 {
    identity : Mat4
    identity[0][0] = 1
    identity[1][1] = 1
    identity[2][2] = 1
    identity[3][3] = 1
    return identity
}

// Returns a scale transformation matrix 
mat4_make_scale :: proc(sx, sy, sz: f32) -> Mat4 {
    identity := mat4_identity()
    identity[0][0] = sx
    identity[1][1] = sy 
    identity[2][2] = sz 
    return identity
}

mat4_make_translation :: proc(tx, ty, tz: f32) -> Mat4 {
    base := mat4_identity()
    base[0][3] = tx 
    base[1][3] = ty 
    base[2][3] = tz 
    return base
}


mat4_mul_vec4 :: proc(m: Mat4, v: Vec4) -> Vec4 {
    result : Vec4
    result.x = m[0][0] * v.x + m[0][1] * v.y + m[0][2] * v.z + m[0][3] * v.w   
    result.y = m[1][0] * v.x + m[1][1] * v.y + m[1][2] * v.z + m[1][3] * v.w   
    result.z = m[2][0] * v.x + m[2][1] * v.y + m[2][2] * v.z + m[2][3] * v.w   
    result.w = m[3][0] * v.x + m[3][1] * v.y + m[3][2] * v.z + m[3][3] * v.w   
    return result
}

mat4_make_rotation_z :: proc(angle: f32) -> Mat4 {
    // c -s 0 0
    // s c  0 0
    // 0 0  1 0
    // 0 0  0 1

    c := math.cos(angle)
    s := math.sin(angle)
    
    base := mat4_identity()
    base[0][0] = c 
    base[0][1] = -s 
    base[1][0] = s 
    base[1][1] = c 

    return base
}

mat4_make_rotation_x :: proc(angle: f32) -> Mat4 {
    // 1 0  0 0
    // 0 c -s 0
    // 0 s -c 0
    // 0 0  0 1

    c := math.cos(angle)
    s := math.sin(angle)
    
    base := mat4_identity()
    base[1][1] = c 
    base[1][2] = -s 
    base[2][1] = s 
    base[2][2] = c 

    return base
}

mat4_make_rotation_y :: proc(angle: f32) -> Mat4 {
    // c 0 -s 0  x
    // 0 1  0 0  y
    // s 0  c 0  z
    // 0 0  0 1  w

    c := math.cos(angle)
    s := math.sin(angle)
    
    base := mat4_identity()
    base[0][0] = c 
    base[0][2] = -s 
    base[2][0] = s 
    base[2][2] = c 

    return base
}
