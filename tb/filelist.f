//time scale 
-timescale=1ns/1ps 

// include directories
-incdir ../sv # include directory for sv files
../sv/ptc_pkg.sv # compile  package
../sv/ptc_if.sv # compile  interface

// compile files
//*** add compile files here
../tb/clkgen.sv 
../tb/hw_top_no.sv

tb_top.sv # compile top level module
