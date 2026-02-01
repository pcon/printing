BOX_WIDTH = 57;
BOX_HEIGHT = 110;

PLATE_DEPTH = 1.5;

SCREW_DIAMETER = 2;
SCREW_DISTANCE = 83.8;
SCREW_OFFSET_Y = SCREW_DISTANCE / 2;

translate([0, 0, PLATE_DEPTH])
import("assets/guition-esp32s3-eu-wall-mount-small.stl");

cube(
    [
        BOX_WIDTH,
        BOX_HEIGHT,
        PLATE_DEPTH
    ],
    center = true
);

translate([0, SCREW_OFFSET_Y, 0])
%cylinder(h = 10, d = SCREW_DIAMETER, center = true);