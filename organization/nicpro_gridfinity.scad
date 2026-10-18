include <../lib/BOSL2/std.scad>
include <../lib/gridfinity.scad>

$fn = 32;

RULER_LENGTH = 200;
RULER_WIDTH = 36;
RULER_DEPTH = 5;

SCREEN_WIDTH = 29;
SCREEN_LENGTH = 50;
SCREEN_DEPTH = 11;

KNOB_DIAMETER = RULER_WIDTH;
KNOB_DEPTH = 9;

knob_radius = KNOB_DIAMETER / 2;
screen_body_length = SCREEN_LENGTH + knob_radius;

total_depth = RULER_DEPTH + SCREEN_DEPTH + KNOB_DEPTH;

module eraser(anchor, spin, orient) {
    attachable(
        size=[
            1,
            1,
            1
        ],
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        cuboid(
            [
                1,
                1,
                1
            ],
            anchor = BOT
        ) {
        }
        children();
    }
}

module refills(anchor, spin, orient) {
    attachable(
        size=[
            1,
            1,
            1
        ],
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        cuboid(
            [
                1,
                1,
                1
            ],
            anchor = BOT
        ) {
        }
        children();
    }
}

module pencil(anchor, spin, orient) {
    attachable(
        size=[
            1,
            1,
            1
        ],
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        cuboid(
            [
                1,
                1,
                1
            ],
            anchor = BOT
        ) {
        }
        children();
    }
}

module sharpener(anchor, spin, orient) {
    attachable(
        size=[
            1,
            1,
            1
        ],
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        cuboid(
            [
                1,
                1,
                1
            ],
            anchor = BOT
        ) {
        }
        children();
    }
}

module holder() {
    diff("remove")
    gridfinity_bin(
        1,
        5,
        3,
        lip = "none",
        middle = "solid"
     ) {
         
     }
}

holder();