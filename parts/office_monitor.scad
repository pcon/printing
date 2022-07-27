BUFFER = 1;
BOARD_LENGTH = 70;
BOARD_DEPTH = 30.5;
HOLE_DIAMETER = 1.5;
HOLE_OFFSET_BOTTOM = 2;
HOLE_OFFSET_LEFT = 1.5;
HOLE_LENGTH = 66;
HOLE_DEPTH = 25.5;
WALL_WIDTH = 2;
DISPLAY_LENGTH = 25;
DISPLAY_DEPTH = 10;

wall_width_2x = WALL_WIDTH * 2;
box_length = BOARD_LENGTH + BUFFER * 2 + wall_width_2x;
box_depth = BOARD_DEPTH + BUFFER * 2 + wall_width_2x;
box_height = 15;

module case() {
    difference() {
        cube([box_length, box_depth, box_height]);

        translate([WALL_WIDTH, WALL_WIDTH, WALL_WIDTH])
        cube([box_length - wall_width_2x, box_depth - wall_width_2x, box_height - WALL_WIDTH]);
    }
}

module display() {
    x_offset = (box_length - DISPLAY_LENGTH) / 2;
    y_offset = (box_depth - DISPLAY_DEPTH) / 2;
    translate([x_offset, y_offset, 0])
    cube([DISPLAY_LENGTH, DISPLAY_DEPTH, WALL_WIDTH]);
}

module pins() {
    hole_left = WALL_WIDTH + BUFFER + HOLE_OFFSET_LEFT;
    hole_bottom = WALL_WIDTH + BUFFER + HOLE_OFFSET_BOTTOM;
    pin_height = box_height - WALL_WIDTH;
    
    translate([hole_left, hole_bottom, WALL_WIDTH])
    cylinder(pin_height, d=HOLE_DIAMETER);
    
    translate([hole_left + HOLE_LENGTH, hole_bottom, WALL_WIDTH])
    cylinder(pin_height, d=HOLE_DIAMETER);
    
    translate([hole_left, hole_bottom + HOLE_DEPTH, WALL_WIDTH])
    cylinder(pin_height, d=HOLE_DIAMETER);
    
    translate([hole_left + HOLE_LENGTH, hole_bottom + HOLE_DEPTH, WALL_WIDTH])
    cylinder(pin_height, d=HOLE_DIAMETER);
}

difference() {
    union() {
        pins();
        case();
    }
    
    display();
}