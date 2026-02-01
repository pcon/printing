LOWER_DIAMETER = 28;
LOWER_HEIGHT = 15;

UPPER_DIAMETER = 30;
UPPER_HEIGHT = 8;

$fn = 100;

union() {
    cylinder(h = LOWER_HEIGHT, d = LOWER_DIAMETER);
    
    translate([0, 0, LOWER_HEIGHT])
    cylinder(h = UPPER_HEIGHT, d = UPPER_DIAMETER);
}