declare a, integer
declare b, integer
declare c, integer
declare &tempi1, integer
rtoi 5.4, &tempi1
store &tempi1, c
declare f, real
store 1.1, f
declare e, real
declare g, real
declare &tempr2, real
itor 2, &tempr2
store &tempr2, g
declare n, char
declare h, char
store 'f', h
declare d, char
store h, d
declare x, boolean
store 1, x
declare y, boolean
store 0, y
declare w, boolean
store y, w
read b, integer
read e, real
read n, char
read w, boolean
declare &tempr3, real
itor a, &tempr3
declare &tempr4, real
rmult e, &tempr3, &tempr4
declare &tempr5, real
itor b, &tempr5
declare &tempr6, real
radd &tempr5, &tempr4, &tempr6
declare &tempi7, integer
rtoi &tempr6, &tempi7
store &tempi7, c
store w, b
write g, real
write d, char
declare &tempr8, real
itor a, &tempr8
declare &tempr9, real
rmult f, &tempr8, &tempr9
write &tempr9, real
halt
