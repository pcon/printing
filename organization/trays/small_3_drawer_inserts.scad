include <../../lib/parts.scad>

DRAWER_DEPTH = 203;
DRAWER_WIDTH = 140;
DRAWER_HEIGHT = 39;
DRAWER_FRONT_X_INSET = 25;
DRAWER_FRONT_Y_INSET = 33;

half_depth = DRAWER_DEPTH / 2;
quarter_depth = half_depth / 2;
half_width = DRAWER_WIDTH / 2;
quarter_width = half_width / 2;
half_height = DRAWER_HEIGHT / 2;

NOZZLE_WIDTH = 0.4;

WALL_WIDTH = NOZZLE_WIDTH * 4;
half_wall_width = WALL_WIDTH / 2;
double_wall_width = WALL_WIDTH * 2;
FLOOR_WIDTH = 1.5;

render_helper = 1;

function part_size(size, n)=(size - WALL_WIDTH * (n + 1)) / n;
function renderHelper(size)=size + render_helper;
function doubleRender(size)=size + render_helper * 2;

module drawer_mockup() {
    linear_extrude(DRAWER_HEIGHT)
    polygon([
        [0, DRAWER_FRONT_Y_INSET],
        [0, DRAWER_DEPTH],
        [DRAWER_WIDTH, DRAWER_DEPTH],
        [DRAWER_WIDTH, DRAWER_FRONT_Y_INSET],
        [DRAWER_WIDTH - DRAWER_FRONT_X_INSET, 0],
        [DRAWER_FRONT_X_INSET, 0]
    ]);
}

module front_half(height = half_height) {
    linear_extrude(height)
    polygon([
        [0, DRAWER_FRONT_Y_INSET],
        [0, half_depth],
        [DRAWER_WIDTH, half_depth],
        [DRAWER_WIDTH, DRAWER_FRONT_Y_INSET],
        [DRAWER_WIDTH - DRAWER_FRONT_X_INSET, 0],
        [DRAWER_FRONT_X_INSET, 0]
    ]);
}

module front_half_inset_wall_offset(height = half_height) {
    offset_z = FLOOR_WIDTH;
    
    translate([0, 0, offset_z])
    linear_extrude(height)
    polygon([
        [WALL_WIDTH, DRAWER_FRONT_Y_INSET],
        [WALL_WIDTH, half_depth - WALL_WIDTH],
        [DRAWER_WIDTH - WALL_WIDTH, half_depth - WALL_WIDTH],
        [DRAWER_WIDTH - WALL_WIDTH, DRAWER_FRONT_Y_INSET],
        [DRAWER_WIDTH - DRAWER_FRONT_X_INSET, WALL_WIDTH],
        [DRAWER_FRONT_X_INSET, WALL_WIDTH]
    ]);
}

module front_half_split_2(height = half_height) {
    difference() {
        front_half(height);
        
        difference() {
            front_half_inset_wall_offset(height);
            
            translate([0, quarter_depth - half_wall_width, 0])
            cube([
                DRAWER_WIDTH,
                WALL_WIDTH,
                doubleRender(height)
            ]);
        }
    }
}

module back_half(height = half_height) {
    cube([
        DRAWER_WIDTH,
        half_depth,
        height
    ]);
}

module back_half_inset_wall_offset(height = half_height) {
    translate([WALL_WIDTH, WALL_WIDTH, FLOOR_WIDTH])
    cube([
        DRAWER_WIDTH - double_wall_width,
        half_depth - double_wall_width,
        height
    ]);
}

module back_half_split_4(height = half_height) {
    difference() {
        back_half(height);
        
        difference() {
            back_half_inset_wall_offset(height);
            
            translate([0, quarter_depth - half_wall_width, 0])
            cube([
                DRAWER_WIDTH,
                WALL_WIDTH,
                doubleRender(height)
            ]);
            
            translate([half_width - half_wall_width, 0, 0])
            cube([
                WALL_WIDTH,
                DRAWER_DEPTH,
                doubleRender(height)
            ]);
        }
    }
}

module drawer_inserts_all() {
    front_half_split_2();

    translate([0, 0, half_height])
    front_half_split_2();
    
    translate([0, half_depth, 0])
      back_half_split_4();
    
    translate([0, half_depth, half_height])
    back_half_split_4();
}

module drawer_inserts_spread() {
    part("front_half_split_2.stl") {
        front_half_split_2();
    }
    
    translate([0, half_depth, 0])
    part("back_half_split_4.stl") {
        back_half_split_4();
    }
}

#%drawer_mockup();
drawer_inserts_spread();