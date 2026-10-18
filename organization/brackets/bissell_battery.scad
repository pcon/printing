include <../../lib/BOSL2/std.scad>
include <../../lib/wallhanger.scad>
include <../../lib/common.scad>
include <../../lib/statics.scad>

WALL_WIDTH = 2;
PLATE_WIDTH = 7;
BOTTOM_WIDTH = 77.5;
BOTTOM_DEPTH = 32;
TOP_WIDTH = 86;
TOP_DEPTH = 35;
BATTERY_HEIGHT = 160;
BASKET_HEIGHT = 135;
TOTAL_DEPTH = TOP_DEPTH + WALL_WIDTH * 2;
TOTAL_WIDTH = TOP_WIDTH + WALL_WIDTH * 2;
INSET_WIDTH = 14;

diff("remove")
wall_hanger(
    [BATTERY_HEIGHT + WALL_WIDTH, TOTAL_WIDTH, PLATE_WIDTH],
    [BASKET_HEIGHT + WALL_WIDTH, TOTAL_WIDTH, TOP_DEPTH + WALL_WIDTH],
    anchor = BOT + LEFT,
    orient = LEFT
) {
    tag("remove")
    down(WALL_WIDTH)
    right(WALL_WIDTH)
    attach(UP, UP, inside = true, align = LEFT)
    cuboid(
        [
            BASKET_HEIGHT + render_helper,
            TOP_WIDTH,
            TOP_DEPTH
        ]
    );
    
    tag("remove")
    right(WALL_WIDTH)
    attach(UP, UP, inside = true, align = LEFT, shiftout = render_helper)
    cuboid(
        [
            BASKET_HEIGHT + render_helper,
            TOP_WIDTH - INSET_WIDTH * 2,
            WALL_WIDTH + render_helper * 2
        ]
    );
    
    tag("remove")
    attach(DOWN, UP, inside = true)
    wall_hanger_screwholes(spacing = BATTERY_HEIGHT / 3, depth = PLATE_WIDTH);
}