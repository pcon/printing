MEDAL_WIDTH = 152;
MEDAL_HEIGHT = 64;
MEDAL_TOP = 4.5;
SCREW_HEAD_DEPTH = 2;
SCREW_HEAD_DIAMETER = 7.5;
SCREW_DIAMETER = 4;
BACK_DEPTH = 1.5;
PIN_DIAMETER = 8;
PIN_DEPTH = 6;
pin_voffset = MEDAL_TOP + PIN_DIAMETER / 2;

skim = .5;

plate_depth = BACK_DEPTH + SCREW_HEAD_DEPTH;

module back_plate() {
    cube([MEDAL_WIDTH, MEDAL_HEIGHT, plate_depth], center = true);
}

module pin() {
    y_offset = pin_voffset -(MEDAL_HEIGHT / 2);
    translate([0, y_offset, plate_depth / 2])
    cylinder(h = PIN_DEPTH, d = PIN_DIAMETER, $fn = 180);
}

module pins() {
    x_offset = MEDAL_WIDTH / 3;
    pin();
    
    translate([-x_offset, 0, 0])
    pin();
    
    translate([x_offset, 0, 0])
    pin();
}

module hole() {
    head_hole_height = SCREW_HEAD_DEPTH + skim;
    translate([0, 0, (head_hole_height / 2)])
    cylinder(h = head_hole_height, d = SCREW_HEAD_DIAMETER, center = true, $fn = 180);
    cylinder(h = plate_depth + skim *2, d = SCREW_DIAMETER, center = true, $fn = 180);
}

module holes() {
    x_offset = MEDAL_WIDTH / 3;
    
    translate([-x_offset, 0, 0])
    hole();
    
    translate([x_offset, 0, 0])
    hole();
}

difference() {
    union() {
        back_plate();
        pins();
    }
    holes();
}