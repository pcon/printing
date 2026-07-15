include <../lib/yapp/YAPPgenerator_v3.scad>

myPcb = "refs/esp32-c3.stl";

pcbLength     = 21;
pcbWidth      = 18;
pcbThickness  =  2;
wallThickness = 1.5;

YAPPgenerate();

translate([12,18,4.6]) 
rotate([-90,0,0])
color("darkgray") import(myPcb);