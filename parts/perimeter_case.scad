include <../lib/roundedcube.scad>

HOLE_DIAMETER = 11.25;
FLOOR_WIDTH = 1;
WALL_WIDTH = 1.5;
CASE_WIDTH = 28;
CASE_DEPTH = 20;
CASE_HEIGHT = 65;
ROUND = 1;
SKIM = 1;

full_height = CASE_HEIGHT + FLOOR_WIDTH;

difference() {
    translate([0, 0, full_height / 2])
    roundedcube(
        [
            CASE_WIDTH + WALL_WIDTH * 2,
            CASE_DEPTH + WALL_WIDTH * 2,
            full_height
        ],
        true, ROUND, "z"
    );
    
    translate([0, 0, full_height / 2 + FLOOR_WIDTH])
    roundedcube(
        [
            CASE_WIDTH,
            CASE_DEPTH,
            full_height
        ],
        true, ROUND, "z"
    );
    
    cylinder(h = FLOOR_WIDTH + SKIM, d = HOLE_DIAMETER, center = true);
}