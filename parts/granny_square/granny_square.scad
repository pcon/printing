include <../../lib/statics.scad>
include <../../lib/BOSL2/std.scad>
include <../../lib/BOSL2/joiners.scad>

PLATE_HEIGHT = 5;

PIN_COUNT_X = 6;
PIN_COUNT_Y = 6;
PIN_SPACING = 25.4;
PIN_DIAMETER = 3;

$slop = .2;

pin_base_width = PIN_SPACING / 2;
plate_edge_width = PIN_SPACING / 8;

DOVETAIL_WIDTH = 10;
DOVETAIL_HEIGHT = 5;
DOVETAIL_CHAMFER = .5;

total_width = PIN_COUNT_X * PIN_SPACING + plate_edge_width * 2;
total_depth = PIN_COUNT_Y * PIN_SPACING + plate_edge_width * 2;
dovetail_offset_x = total_width / 4;

module dove(type) {
    dovetail(
        type,
        slide = PLATE_HEIGHT,
        width = DOVETAIL_WIDTH,
        height = DOVETAIL_HEIGHT,
        slope = 4,
        chamfer = DOVETAIL_CHAMFER
    );
}

module pin() {
    zcyl(
        h = PLATE_HEIGHT * 2,
        r = PIN_DIAMETER / 2,
        anchor = BOT
    );
}

module pin_holder() {
    down(render_helper)
    cuboid(
        [
            pin_base_width,
            pin_base_width,
            PLATE_HEIGHT / 2 + render_helper
        ],
        anchor = BOT
    )
    
    attach(TOP, BOT)
    cuboid(
        [
            pin_base_width / 2,
            pin_base_width / 2,
            PLATE_HEIGHT / 2 + render_helper
        ],
        anchor = BOT
    );
}

module pin_holes() {
    grid_copies(
        spacing = [
            PIN_SPACING,
            PIN_SPACING
        ],
        n = [
            PIN_COUNT_X,
            PIN_COUNT_Y
        ]
    )
    pin_holder();
}

module plate() {
    diff("remove")
    cuboid(
        [
            total_width,
            total_depth,
            PLATE_HEIGHT
        ],
        anchor = BOT
    ) {
        tag("remove")
        attach(BOT, BOT, inside = true)
        pin_holes();
    }
}

module testpart() {
    diff("remove")
    cube([total_width, total_depth, PLATE_HEIGHT], anchor = BOT) {
        attach(RIGHT) dove("male");
        
       attach([FRONT, BACK])
        left(dovetail_offset_x)
        dove("male");
        
        tag("remove") attach(LEFT)
        dove("female");
        
        tag("remove") attach([FRONT, BACK])
        right(dovetail_offset_x)
        dove("female");
        
        tag("keep") zrot(15) cube([70, 5, PLATE_HEIGHT], anchor = CENTER);
        tag("keep") zrot(-15) cube([70, 5, PLATE_HEIGHT], anchor = CENTER);
        tag("remove") attach(CENTER) cube([60, 20, PLATE_HEIGHT + 2], anchor = CENTER);
    }
}

plate();