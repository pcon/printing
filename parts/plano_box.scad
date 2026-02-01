include <../lib/roundedcube.scad>

WALL_WIDTH = 1;
HEIGHT = 19;
DEPTH = 36;
LEFT_WIDTH = 45.5;
GAP_WIDTH = 7.5;
GAP_DEPTH = 2.5;
RIGHT_WIDTH = 17;
CORNER_RADIUS = 12;

skim = .5;
half_height = HEIGHT / 2;


union() {
    cylinder(HEIGHT, r = CORNER_RADIUS);

    left_depth = DEPTH - CORNER_RADIUS;
    translate([left_depth / 2, (LEFT_WIDTH / 2) - CORNER_RADIUS, half_height])
    cube([left_depth, LEFT_WIDTH, HEIGHT], center = true);

    translate([-CORNER_RADIUS / 2, (LEFT_WIDTH - CORNER_RADIUS) / 2, half_height])
    cube([CORNER_RADIUS, LEFT_WIDTH - CORNER_RADIUS, HEIGHT], center = true);
}