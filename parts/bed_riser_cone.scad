include <../lib/BOSL2/std.scad>

CONE_HEIGHT = 20;
CONE_TOP_DIAMETER = 20;
CONE_BOTTOM_DIAMETER = 25;
CONE_ROUNDING = 1.5;

cyl(
    l = CONE_HEIGHT,
    d1 = CONE_BOTTOM_DIAMETER,
    d2 = CONE_TOP_DIAMETER,
    rounding = CONE_ROUNDING,
    $fa = 1,
    $fs = 1,
    center = false
);