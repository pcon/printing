include <../lib/statics.scad>
use <../lib/common.scad>
include <../lib/BOSL2/std.scad>

BASE_DEPTH = 15;
BASE_HEIGHT = 8;

CORD_LENGTH = 135;
CORD_DIAMETER = 2.5;

CUT_LENGTH = 10;
CUT_WIDTH = 1;

total_width = CORD_LENGTH + CUT_LENGTH;

diff("remove")
cuboid(
    [
        total_width,
        BASE_DEPTH,
        BASE_HEIGHT
    ],
    anchor = LEFT + BOT
) {
    tag("remove")
    right(CORD_LENGTH)
    attach(
        TOP,
        TOP,
        inside = true,
        align = LEFT,
        shiftout = render_helper
    )
    cuboid(
        [
            CUT_WIDTH,
            BASE_DEPTH + render_helper * 2,
            CORD_DIAMETER + render_helper
        ]
    );
    
    tag("remove")
    attach(
        TOP,
        TOP,
        inside = true,
        align = LEFT,
        shiftout = render_helper
    )
    cuboid(
        [
            total_width + render_helper * 2,
            CORD_DIAMETER,
            CORD_DIAMETER + render_helper
        ]
    );
    
    tag("remove")
    up(3)
    back(2.5)
    text3d("NEXUS CORD", h=3, size=4);
};