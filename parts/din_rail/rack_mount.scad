use <din_utilities.scad>

WALL_WIDTH = 2;

din_block_depth = din_width() + WALL_WIDTH * 2;
block_length = din_length() + WALL_WIDTH * 2;

SLOT_DEPTH = 40;
HOLE_WALL = 5;
HOLE_OFFSET = 17;
HOLE_DIAMETER = 6.5;
HOLE_DEPTH = 9;
hole_width = din_length() - HOLE_DIAMETER;
block_depth = HOLE_DIAMETER + HOLE_OFFSET + HOLE_WALL;

hole_radius = HOLE_DIAMETER / 2;


module slot() {
    linear_extrude(HOLE_DEPTH)
    hull() {
        scale([1/10, 1/10, 1/10])
        circle(d = HOLE_DIAMETER * 10);
        
        translate([0, hole_width, 0])
        scale([1/10, 1/10, 1/10])
        circle(d = HOLE_DIAMETER * 10);
    }
}

module block() {
    union() {
        translate([0, din_block_depth, 0])
        cube([block_length, block_depth, HOLE_DEPTH]);
        
        cube([block_length, din_block_depth, SLOT_DEPTH]);
    }
}

difference() {
    block();
    
    rotate([0, 0, -90])
    translate([-din_block_depth - HOLE_OFFSET, WALL_WIDTH + hole_radius, 0])
    slot();

    translate([WALL_WIDTH, WALL_WIDTH, 0])
    linear_extrude(SLOT_DEPTH)
        din_modified_slot();
}