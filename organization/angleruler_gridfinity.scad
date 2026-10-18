include <../lib/BOSL2/std.scad>
include <../lib/gridfinity.scad>
include <../lib/BOSL2/math.scad>

$fn = $preview ? 16 : 128;

RULER_LENGTH = 220;
RULER_WIDTH = 36;
RULER_DEPTH = 5;

SCREEN_WIDTH = 29;
SCREEN_LENGTH = 50;
SCREEN_DEPTH = 11.5;

KNOB_DIAMETER = RULER_WIDTH;
KNOB_DEPTH = 9;

PENCIL_DIAMETER_MIN = 6.5;
PENCIL_DIAMETER_MIN_SEC = 9.5;
PENCIL_DIAMETER_SEC = 13.5;
PENCIL_DIAMETER_MAX = 15.5;
PENCIL_LENGTH_MIN = 43;
PENCIL_LENGTH_MIN_SEC_TRANSITION = 7;
PENCIL_LENGTH_SEC = 77.5;
PENCIL_LENGTH_SEC_MAX_TRANSITION = 5;
PENCIL_LENGTH_MAX = 19.5;

pencil_lengths = [
    PENCIL_LENGTH_MIN,
    PENCIL_LENGTH_MIN_SEC_TRANSITION,
    PENCIL_LENGTH_SEC,
    PENCIL_LENGTH_SEC_MAX_TRANSITION,
    PENCIL_LENGTH_MAX
];

total_pencil_length = sum(pencil_lengths);

knob_radius = KNOB_DIAMETER / 2;
screen_body_length = SCREEN_LENGTH + knob_radius;

total_depth = RULER_DEPTH + SCREEN_DEPTH + KNOB_DEPTH;

module pencil(anchor, spin, orient) {
    attachable(
        size = [
            PENCIL_DIAMETER_MAX,
            total_pencil_length,
            PENCIL_DIAMETER_MAX
        ],
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        fwd(total_pencil_length / 2)
        ycyl(
            d = PENCIL_DIAMETER_MIN,
            h = PENCIL_LENGTH_MIN,
            anchor = FWD
        ) {
            position(BACK)
            ycyl(
                d1 = PENCIL_DIAMETER_MIN_SEC,
                d2 = PENCIL_DIAMETER_SEC,
                h = PENCIL_LENGTH_MIN_SEC_TRANSITION,
                anchor = FWD
            ) {
                position(BACK)
                ycyl(
                    d = PENCIL_DIAMETER_SEC,
                    h = PENCIL_LENGTH_SEC,
                    anchor = FWD
                ) {
                    position(BACK)
                    ycyl(
                        d1 = PENCIL_DIAMETER_SEC,
                        d2 = PENCIL_DIAMETER_MAX,
                        h = PENCIL_LENGTH_SEC_MAX_TRANSITION,
                        anchor = FWD
                    ) {
                        position(BACK)
                        ycyl(
                            d = PENCIL_DIAMETER_MAX,
                            h = PENCIL_LENGTH_MAX,
                            anchor = FWD
                        );
                    }
                }
            }
        }
        children();
    }
}

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
        6,
        3,
        lip = "none",
        middle = "solid",
        anchor = BOT
     ) {
         tag("remove")
         up(5)
         left(total_depth / 2)
         ruler(anchor = RIGHT, orient = RIGHT);
         
         tag("remove")
         attach(TOP, CENTER)
         back(40)
         right(9)
         pencil();
     }
}

holder();