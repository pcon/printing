use <base.scad>
use <../lib/roundedcube.scad>

WALL_WIDTH = 1.5;
RENDER_HELPER = 1;

SECTION_WIDTH = (boxWidth() - WALL_WIDTH * 3) / 2;
SECTION_DEPTH = (boxDepth() - WALL_WIDTH * 3) / 2;

module left_cutout() {
    width = SECTION_WIDTH;
    depth = boxDepth() - WALL_WIDTH * 2;
    height = boxHeight() - WALL_WIDTH + RENDER_HELPER;
    
    offset_x = WALL_WIDTH;
    offset_y = WALL_WIDTH;
    offset_z = WALL_WIDTH;
    
    translate([offset_x, offset_y, offset_z])
    union() {
        translate([width - boxCorner(), 0, 0])
        cube([boxCorner(), depth, height]);
        
        roundedcube(
            [width, depth, height],
            radius = boxCorner(),
            apply_to = "z"
        );
    }
}

module right_slot() {
    width = SECTION_WIDTH;
    depth = SECTION_DEPTH;
    height = boxHeight() - WALL_WIDTH + RENDER_HELPER;
    
    union() {
        cube([boxCorner(), depth, height]);
        roundedcube(
            [width, depth, height],
            radius = boxCorner(),
            apply_to = "z"
        );
    }
}

module right_bottom() {
    offset_x = WALL_WIDTH * 2 + SECTION_WIDTH;
    offset_y = WALL_WIDTH;
    offset_z = WALL_WIDTH;
    
    translate([offset_x, offset_y, offset_z])
    union() {
        translate([SECTION_WIDTH - boxCorner(), SECTION_DEPTH + WALL_WIDTH, 0])
        cube([boxCorner(), boxCorner(), boxHeight()]);
        
        right_slot();
    }
}

module right_top() {
    offset_x = WALL_WIDTH * 2 + SECTION_WIDTH;
    offset_y = WALL_WIDTH * 2 + SECTION_DEPTH;
    offset_z = WALL_WIDTH;
    
    translate([offset_x, offset_y, offset_z])
    right_slot();
}

module right_cutout() {
    union() {
        right_top();
        right_bottom();
    }
}

difference() {
    base_insert();
    left_cutout();
    right_cutout();
}