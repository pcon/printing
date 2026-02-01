use <lib/roundedcube.scad>

FRONT_DEPTH = 25;
REAR_DEPTH = 225;
DRAWER_DEPTH = REAR_DEPTH + FRONT_DEPTH;
DRAWER_WIDTH = 203;
NUBBIN_WIDTH = 19;
FRONT_WIDTH = DRAWER_WIDTH - NUBBIN_WIDTH * 2;

CORNER_RADIUS = 3;
WALL_WIDTH = 2;

DRAWER_HEIGHT = 45;
bottom_height = DRAWER_HEIGHT / 2;
tray_height = DRAWER_HEIGHT / 2;
tray_depth = REAR_DEPTH / 2;

render_helper = 1;

module rc(size) {
    roundedcube(size, radius = CORNER_RADIUS, apply_to = "z");
}

module bottom_base() {
    union() {
        translate([0, FRONT_DEPTH, 0])
        rc([DRAWER_WIDTH, REAR_DEPTH, bottom_height]);
        
        translate([NUBBIN_WIDTH, 0, 0])
        rc([FRONT_WIDTH, FRONT_DEPTH + CORNER_RADIUS, bottom_height]);
    }
}

module bottom_cutout() {
    union() {
        translate([WALL_WIDTH, FRONT_DEPTH + WALL_WIDTH, WALL_WIDTH])
        rc(
            [
                DRAWER_WIDTH - WALL_WIDTH * 2,
                REAR_DEPTH - WALL_WIDTH * 2,
                bottom_height - WALL_WIDTH + render_helper
            ]
        );
        
        translate([NUBBIN_WIDTH + WALL_WIDTH, WALL_WIDTH, WALL_WIDTH])
        rc(
            [
                FRONT_WIDTH - WALL_WIDTH * 2,
                FRONT_DEPTH + CORNER_RADIUS,
                bottom_height
            ]
        );
    }
}

module bottom_walls() {
    front_wall = 70;
    middle_wall = (DRAWER_DEPTH - WALL_WIDTH) / 2;
    
    // Front wall
    translate([0, front_wall, 0])
    cube([DRAWER_WIDTH, WALL_WIDTH, bottom_height]);
    
    // Middle wall
    translate([0, middle_wall, 0])
    cube([DRAWER_WIDTH, WALL_WIDTH, bottom_height]);
    
    // Middle divider
    translate([(DRAWER_WIDTH - WALL_WIDTH) / 2, front_wall, 0])
    cube([WALL_WIDTH, middle_wall - front_wall, bottom_height]);
}

module bottom_tray() {
    union() {
        difference() {
            bottom_base();
            bottom_cutout();
        }
        bottom_walls();
    }
}

module tray_base() {
    rc([DRAWER_WIDTH, tray_depth, tray_height]);
}

module tray_cutout() {
    translate([WALL_WIDTH, WALL_WIDTH, WALL_WIDTH])
    rc([
        DRAWER_WIDTH - WALL_WIDTH * 2,
        tray_depth - WALL_WIDTH * 2,
        tray_depth - WALL_WIDTH + render_helper
    ]);
}

module tray_walls() {
    drawer_third = DRAWER_WIDTH / 3;
    
    // Left wall
    translate([drawer_third - WALL_WIDTH / 2, 0, 0])
    cube([WALL_WIDTH, tray_depth, tray_height]);
    
    // Middle wall
    translate([drawer_third, (tray_depth + WALL_WIDTH) / 2, 0])
    cube([drawer_third * 2, WALL_WIDTH, tray_height]);
}

module top_tray() {
    union() {
        difference() {
            tray_base();
            tray_cutout();
        }
        tray_walls();
    }
}

bottom_tray();
/*
translate([0, FRONT_DEPTH, bottom_height])
top_tray();*/