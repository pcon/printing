include <../lib/pegmixer.scad>

SMALL_DIAMETER = 15;
SMALL_HEIGHT = 15;
LARGE_DIAMETER = 34;
LARGE_HEIGHT = 25;
WALL_WIDTH = 5;

render_helper = 1;

box_depth = LARGE_DIAMETER + WALL_WIDTH * 2;
box_width = box_depth + 8;
box_height = SMALL_HEIGHT + LARGE_HEIGHT;

module base() {
    pegmixer()
    solid([box_width, box_depth, box_height]);
}

module cutout() {
    stack_height = SMALL_HEIGHT + LARGE_HEIGHT;
    
    translate([0, 0, -stack_height / 2])
    union() {
        translate([0, 0, -render_helper])
        cylinder(h = SMALL_HEIGHT + render_helper * 2, d = SMALL_DIAMETER);
        
        translate([0, 0, SMALL_HEIGHT])
        cylinder(h = LARGE_HEIGHT + render_helper, d = LARGE_DIAMETER);
    }
}

module holder() {
    difference() {
        base();
        cutout();
    }
}

holder();