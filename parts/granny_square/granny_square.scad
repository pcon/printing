include <../../lib/BOSL2/std.scad>
include <../../lib/BOSL2/joiners.scad>

PLATE_HEIGHT = 5;
DOVETAIL_WIDTH = 10;
DOVETAIL_HEIGHT = 5;
DOVETAIL_CHAMFER = .5;

total_width = 80;
total_depth = 40;

$slop = .1;

module dove(type) {
    dovetail(
        type,
        slide = PLATE_HEIGHT,
        width = DOVETAIL_WIDTH,
        height = DOVETAIL_HEIGHT,
        slope = 4
        //chamfer = DOVETAIL_CHAMFER
    );
}

diff("remove") cube([total_width, total_depth, PLATE_HEIGHT], anchor = BOT) {
    attach(RIGHT) dove("male");
    attach([FRONT, BACK]) left(20) dove("male");
    tag("remove") attach(LEFT) dove("female");
    tag("remove") attach([FRONT, BACK]) right(20) dove("female");
    
    tag("keep") zrot(15) cube([70, 5, PLATE_HEIGHT], anchor = CENTER);
    tag("keep") zrot(-15) cube([70, 5, PLATE_HEIGHT], anchor = CENTER);
    tag("remove") attach(CENTER) cube([60, 20, PLATE_HEIGHT + 2], anchor = CENTER);
}