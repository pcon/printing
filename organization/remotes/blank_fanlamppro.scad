include <../../lib/BOSL2/std.scad>
use <../../lib/switchplate.scad>

REMOTE_WIDTH = 48;
REMOTE_DEPTH = 15;

plate(
    switch_holes = false,
    switch_covers = false
)
attach(TOP, BOT)
cuboid(10);