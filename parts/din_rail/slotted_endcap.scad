use <din_utilities.scad>

WALL_WIDTH = 2;

din_block_depth = din_width() + WALL_WIDTH * 2;
block_depth = 6;
block_length = din_length() + WALL_WIDTH * 2;

SLOT_DEPTH = 15;
HOLE_DIAMETER = 6.5;
HOLE_LENGTH = 25;
hole_width = din_length() - HOLE_DIAMETER;

hole_radius = HOLE_DIAMETER / 2;

block_height = SLOT_DEPTH + WALL_WIDTH * 2 + HOLE_LENGTH + HOLE_DIAMETER * 2;


module slot() {
    linear_extrude(block_depth)
    hull() {
        scale([1/10, 1/10, 1/10])
        circle(d = HOLE_DIAMETER * 10);
        
        translate([0, HOLE_LENGTH + hole_radius, 0])
        scale([1/10, 1/10, 1/10])
        circle(d = HOLE_DIAMETER * 10);
    }
}

module holes() {
    center_offset = WALL_WIDTH * 2 + hole_radius;
    min_z_offset = hole_radius + SLOT_DEPTH + WALL_WIDTH * 2;
    
    translate([center_offset, din_block_depth, min_z_offset])
    rotate([90, 0, 0])
    slot();
    
    translate([block_length - center_offset, din_block_depth, min_z_offset])
    rotate([90, 0, 0])
    slot();
}

module block() {
    union() {
        translate([0, din_block_depth - block_depth, 0])
        cube([block_length, block_depth, block_height]);
        
        cube([block_length, din_block_depth, SLOT_DEPTH + WALL_WIDTH]);
    }
}

difference() {
    block();
    holes();

    translate([WALL_WIDTH, WALL_WIDTH, 0])
    linear_extrude(SLOT_DEPTH)
        din_modified_slot();
}