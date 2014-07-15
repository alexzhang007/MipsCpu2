MipsCpu2
========

The second generation of MIPS CPU with pipelined design


July.15.2014
The RTL should be synthesizable, so i have to consider the implementation of integer add, sub, mul, division and
for single floating-point arithmetic. The arithmetic core is generally combinational logic, however, considering 
tapeout technology TSMC28nm and goal running frequency (1GHz). The arithmetic core should be pipelined and have 
2 or more cycles delay in execution stage. SFP arithmetic core needs more cycles (4-6) while Int arithmetic core just 
needs 2 or 3 cycles. It is funny to consider the optimization in SW layer to schedule Int operation while it is 
running the floating-point operation.
The RTL can be implemented at someday, however, how to hook up the OpenGL driver is a bigger question. Furthermore,
3D optimization is also a question. 
