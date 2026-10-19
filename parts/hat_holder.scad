include <../lib/BOSL2/std.scad>
include <../lib/statics.scad>

$fn = $preview ? 32 : 260;

BASE_DIAMETER = 190;
BASE_HEIGHT = 10;
TAB_WIDTH = 5;
TAB_LENGTH = 52;
LED_WIDTH = 10;

diff("remove_tab")
zcyl(
    d = BASE_DIAMETER,
    h = BASE_HEIGHT
) {
    tag("remove_tab")
    ycopies(spacing = LED_WIDTH + TAB_WIDTH, n = 2)
    attach(TOP, TOP, inside = true, shiftout = render_helper)
    cuboid(
        [
            TAB_LENGTH,
            TAB_WIDTH,
            BASE_HEIGHT + render_helper * 2
        ]
    );
}