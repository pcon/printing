include <../lib/BOSL2/std.scad>
include <../lib/gridfinity.scad>

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

module ruler(anchor, spin, orient) {
    attachable(
        size=[
            RULER_WIDTH,
            RULER_LENGTH,
            total_depth
        ],
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        back(knob_radius / 2)
        cuboid(
            [
                RULER_WIDTH,
                RULER_LENGTH - knob_radius,
                RULER_DEPTH
            ],
            anchor = BOT
        ) {
            back(knob_radius)
            align(FWD, BOT)
            cyl(
                d = KNOB_DIAMETER,
                h = total_depth
            );
            
            back(screen_body_length)
            up(RULER_DEPTH)
            align(FWD, BOT)
            cuboid(
                [
                    SCREEN_WIDTH,
                    screen_body_length,
                    SCREEN_DEPTH
                ]
            );
        }
        children();
    }
}

module holder() {
    diff("remove")
    gridfinity_bin(
        1,
        5,
        4,
        lip = "none",
        middle = "solid"
     ) {
         tag("remove")
         up(5)
         left(total_depth / 2)
         ruler(anchor = RIGHT, orient = RIGHT);
     }
}

holder();