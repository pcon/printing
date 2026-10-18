include <../lib/BOSL2/std.scad>
include <../lib/BOSL2/threading.scad>
include <../lib/statics.scad>
include <../lib/BOSL2/screws.scad>
include <../lib/screw_container.scad>

$fn = $preview ? 16 : 128;

CLEARANCE = 0.5;
SCALLOP_DIAMETER = 1.5;

WALL_WIDTH = 2;
MINI_DIAMETER = 35;
MINI_HEIGHT = 41;

TOTAL_HEIGHT = WALL_WIDTH * 2 + MINI_HEIGHT + CLEARANCE * 2;

INSIDE_WALL_DIAMETER = MINI_DIAMETER + WALL_WIDTH;

THREAD_PITCH = 3;
THREAD_HEIGHT = 3;
THREAD_OUTER_DIAMETER = INSIDE_WALL_DIAMETER + WALL_WIDTH * 2 + 1.7;
THREAD_OUTER_HEIGHT = 7;

BASE_DIAMETER = THREAD_OUTER_DIAMETER + WALL_WIDTH * 2;
BASE_HEIGHT = TOTAL_HEIGHT / 2;
LID_HEIGHT = TOTAL_HEIGHT / 2;

module bottom() {
    diff("bot_rem")
    container_bottom(
        h = TOTAL_HEIGHT,
        wall_width = WALL_WIDTH,
        thread_od = THREAD_OUTER_DIAMETER,
        thread_h = THREAD_OUTER_HEIGHT,
        pitch = THREAD_PITCH,
        clearance = CLEARANCE,
        anchor = BOT
    ) {
        tag("bot_rem")
        attach(TOP, TOP, inside = true, shiftout = render_helper)
        cyl(
            d = MINI_DIAMETER,
            h = TOTAL_HEIGHT - WALL_WIDTH * 2 + render_helper
       );
    }
}

DISPLAY_OFFSET = BASE_DIAMETER / 2 + WALL_WIDTH;

translate([-DISPLAY_OFFSET, 0, 0])
bottom();

translate([DISPLAY_OFFSET, 0, 0])
container_lid(
    h = TOTAL_HEIGHT,
    wall_width = WALL_WIDTH,
    thread_od = THREAD_OUTER_DIAMETER,
    thread_h = THREAD_OUTER_HEIGHT,
    pitch = THREAD_PITCH,
    clearance = CLEARANCE,
    anchor = BOT
);