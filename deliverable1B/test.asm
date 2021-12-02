declare w, integer
declare x, integer
declare y, integer
declare t, real
declare &tempr1, real
itor w, &tempr1
declare &tempi2, real
rsub &tempr1, t, &tempi2
declare &tempr3, real
itor x, &tempr3
declare &tempi4, real
rmod &tempr3, &tempi2, &tempi4
declare &tempi5, integer
rtoi &tempi4, &tempi5
store &tempi5, y
halt
