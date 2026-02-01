BASE_WIDTH = 40;
BASE_DEPTH = 24;
BASE_HEIGHT = 10;

POST_WIDTH = 6;
POST_DEPTH = 6.5;
POST_HEIGHT = 13;

HOLE_DIAMETER = 3.5;
WALL_WIDTH = 1.5;

module post() {
    offset_x = BASE_WIDTH / 2 - POST_WIDTH / 2;
    offset_y = BASE_DEPTH / 2 - POST_DEPTH / 2;
    offset_z = BASE_HEIGHT;
    translate([offset_x, offset_y, offset_z])
    cube([POST_WIDTH, POST_DEPTH, POST_HEIGHT]);
}

module hole() {
    offset_x = BASE_WIDTH / 2;
    offset_y = BASE_DEPTH / 2;
    offset_z = BASE_HEIGHT + POST_HEIGHT - WALL_WIDTH * 2;
    
    translate([offset_x, offset_y, offset_z])
    rotate([-90, 0, 90])
    cylinder(h = POST_WIDTH + 2, d = HOLE_DIAMETER, center = true);
}

module base() {
    cube([BASE_WIDTH, BASE_DEPTH, BASE_HEIGHT]);
}

union() {
    base();
    
    difference() {
        post();
        hole();
    }
}