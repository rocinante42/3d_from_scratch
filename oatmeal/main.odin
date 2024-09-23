package oatmeal 
import "core:fmt"

main :: proc() {
    m1 := Mat3 {  {5, -3, 6}, {1, -2, 4}, {0, 7, 2} }
    m2 := Mat3 { {-1, 8, 3},  {6, 5, 9},  {0, 1, -3}}

    result := mat3_multiply(m1, m2)
    fmt.printfln("Result is: %v", result)

}