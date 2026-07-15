include <../lib/BOSL2/std.scad>
include <../lib/gridfinity.scad>

CASE_DEPTH = 170;
CASE_ROUNDING = 13.5;
CASE_HEIGHT = 79;
CASE_WIDTH = 27;

total_depth = CASE_DEPTH + CASE_ROUNDING / 2;

diff("remove")
gridfinity_bin(
    1,
    4,
    4,
    lip = "none",
    middle = "solid"
 ) {
     tag("remove")
     attach(BOT, TOP, inside = true, shiftout=-9)
     cuboid(
        [
            CASE_WIDTH,
            total_depth,
            CASE_HEIGHT
        ],
        rounding = CASE_ROUNDING
    );
 }
