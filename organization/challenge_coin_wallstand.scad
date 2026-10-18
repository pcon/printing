include <../lib/BOSL2/std.scad>

// Design and measurements taken from @schutz design on Printables
// https://www.printables.com/model/474287-parametric-challenge-coin-display

$fn = 64;

STAND_WIDTH = 160;
STAND_ROWS = 3;
STAND_ROW_DEPTH = 15;
STAND_ROW_FIRST_HEIGHT = 10;
STAND_ROW_RISE = 8;
STAND_NOTCH_DEPTH = 5;
STAND_NOTCH_WIDTH = 4.5;
STAND_NOTCH_TILT = 5; // Degrees
ROUNDING = 1;

stand_base = STAND_ROW_FIRST_HEIGHT - STAND_ROW_RISE;

KEYHOLE_SCREW_HEAD_DIAMETER = 10;
keyhole_screw_head_radius = KEYHOLE_SCREW_HEAD_DIAMETER / 2;
KEYHOLE_SCREW_SHAFT_DIAMETER = 5;
keyhole_screw_shaft_radius = KEYHOLE_SCREW_SHAFT_DIAMETER / 2;
KEYHOLE_SCREW_HEAD_DEPTH = 5;
KEYHOLE_SCREW_WALL_DEPTH = 2;

function stand_height(n) = stand_base + STAND_ROW_RISE * n;

module keyhole_inside(
    anchor = CENTER,
    spin = 0,
    orient = UP
 ) {
     attachable(anchor, spin, orient, r = [KEYHOLE_SCREW_HEAD_DIAMETER, KEYHOLE_SCREW_HEAD_DIAMETER / 2], l = KEYHOLE_SCREW_HEAD_DEPTH) {
         down(KEYHOLE_SCREW_HEAD_DEPTH / 2)
         linear_extrude(KEYHOLE_SCREW_HEAD_DEPTH)
         glued_circles(
            d = KEYHOLE_SCREW_HEAD_DIAMETER,
            spread = KEYHOLE_SCREW_HEAD_DIAMETER,
            tangent = 0
         );
         children();
    }
}

module keyhole_outside(
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    attachable(anchor, spin, orient, r = [keyhole_screw_shaft_radius, keyhole_screw_head_radius], l = KEYHOLE_SCREW_WALL_DEPTH) {
        back(KEYHOLE_SCREW_HEAD_DIAMETER / 2)
        down(KEYHOLE_SCREW_WALL_DEPTH / 2)
        linear_extrude(KEYHOLE_SCREW_WALL_DEPTH)
        keyhole(
            l = KEYHOLE_SCREW_HEAD_DIAMETER,
            r1 = keyhole_screw_shaft_radius,
            r2 = keyhole_screw_head_radius
        );
        children();
    }
}

module keyhole_cutout(
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    total_height = KEYHOLE_SCREW_HEAD_DEPTH + KEYHOLE_SCREW_WALL_DEPTH;
    attachable(
        anchor = anchor,
        spin = spin,
        orient = orient,
        r = [KEYHOLE_SCREW_HEAD_DIAMETER, KEYHOLE_SCREW_HEAD_DIAMETER / 2], l = total_height
    ) {
        down(total_height / 2)
        keyhole_inside(
            anchor = BOT
        ) {
            attach(TOP, BOT)
            rot(90)
            keyhole_outside();
        }
        children();
    }
}

module coin_holder(
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    attachable(
        anchor,
        spin,
        orient,
        size = [
            STAND_WIDTH,
            STAND_ROW_DEPTH * STAND_ROWS,
            stand_height(STAND_ROWS)
        ]
    ) {
        //down(stand_height(STAND_ROWS) / 2)
        ycopies(
            n = STAND_ROWS,
            spacing = STAND_ROW_DEPTH
        )
        cuboid(
            [
                STAND_WIDTH,
                STAND_ROW_DEPTH,
                stand_height($idx)
            ],
            anchor = BOT
        ) {
            attach(TOP, BOT)
            %cuboid(
                [
                    STAND_WIDTH,
                    STAND_ROW_DEPTH,
                    STAND_ROW_RISE
                ]
            ) {
                tag("remove")
                xrot(-STAND_NOTCH_TILT)
                align(TOP, CENTER, inside = true, shiftout = 1)
                cuboid(
                    [
                        STAND_WIDTH + 2,
                        STAND_NOTCH_WIDTH,
                        STAND_NOTCH_DEPTH + 1
                    ]
                );
            }
        };
        children();
    }
}

diff("remove")
coin_holder(
    anchor = BOT
) {
    /*
    tag("remove")
    xcopies(n = 2, spacing = STAND_WIDTH / 3)
    yrot(-90)
    attach(BACK, TOP, inside = true, shiftout = 1)
    keyhole_cutout();
    */
}
