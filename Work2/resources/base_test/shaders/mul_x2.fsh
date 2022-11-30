ps.1.1

tex t0             ; sample color map
mul t0, t0, v0     ; mulitply with color
mul t0, t0, c0     ; multiply with param
add r0, t0, t0     ; make it brighter and store result
