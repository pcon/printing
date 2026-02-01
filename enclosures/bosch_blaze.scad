include <../lib/roundedcube.scad>

INSIDE_HEIGHT = 64;
INSIDE_WIDTH = 43.35;
INSIDE_DEPTH = 24;

WALL_WIDTH = 2;
CORNER_RADIUS = 1;

render_helper = 1;

total_height = INSIDE_HEIGHT + WALL_WIDTH;
total_width = INSIDE_WIDTH + WALL_WIDTH * 2;
total_depth = INSIDE_DEPTH + WALL_WIDTH * 2;

translate([0, 0, total_height / 2])
difference() {    
    roundedcube(
        [
            total_width,
            total_depth,
            total_height,
        ],
        center = true,
        radius = CORNER_RADIUS,
        apply_to = "zmin"
    );
    
    translate([
        0,
        0,
        WALL_WIDTH
    ])
    cube(
        [
            INSIDE_WIDTH,
            INSIDE_DEPTH,
            INSIDE_HEIGHT + render_helper
        ],
        center = true
    );
}