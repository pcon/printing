include <../lib/BOSL2/std.scad>
include <../lib/statics.scad>

$fn = $preview ? 16 : 128;

TOP_DIAMETER = 22;
BOTTOM_DIAMETER = 36;
WALL_HEIGHT = 2;
WALL_WIDTH = 4.5;
BASE_HEIGHT = 12;

total_diameter = BOTTOM_DIAMETER + WALL_WIDTH * 2;
total_height = WALL_HEIGHT + BASE_HEIGHT;

diff("remove")
zcyl(
    d = total_diameter,
    h = total_height,
    anchor = BOT
) {
    tag("remove")
    zcyl(
        d = TOP_DIAMETER,
        h = total_height + render_helper * 2
    );
    
    tag("remove")
    attach(TOP, BOT, inside = true, shiftout = render_helper)
    zcyl(
        d = BOTTOM_DIAMETER,
        h = BASE_HEIGHT + render_helper
    );
}