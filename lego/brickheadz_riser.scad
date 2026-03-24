include <../lib/statics.scad>
include <../lib/BOSL2/std.scad>

BASE_SIDE = 64;
BASE_HEIGHT = 4;
WALL_WIDTH = 2;

module base() {
    diff("base_cutout")
    cuboid(
        [
            BASE_SIDE,
            BASE_SIDE,
            BASE_HEIGHT
        ],
        anchor = BOT
    )
    
    attach(TOP, BOT)
    cuboid([10, 10, 10])
    
    tag("base_cutout")
    attach(BOT, BOT)
    down(render_helper)
    cuboid(
        [
            BASE_SIDE - WALL_WIDTH * 2,
            BASE_SIDE - WALL_WIDTH * 2,
            BASE_HEIGHT + render_helper * 2
        ]
    );
    
}

module riser() {
    attach(TOP, BOT)
    cuboid([10, 10, 10]);
}

base() {
    riser();
}