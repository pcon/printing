include <../lib/BOSL2/std.scad>
include <../lib/gridfinity.scad>

HANDLE_WIDTH = 19.624 * 2;
HANDLE_LENGTH = 150;

SHAFT_SMALL_DIAMETER = 7.5;
SHAFT_LARGE_DIAMETER = 10.25;
SHAFT_LENGTH = 87.5;
SHAFT_HEAD_LENGTH = 27;
BIT_LENGTH = 16.25;
BIT_DIAMETER = 7.5;

shaft_total_length = SHAFT_LENGTH + SHAFT_HEAD_LENGTH + BIT_LENGTH;

module shaft() {
    fwd(shaft_total_length / 2)
    ycyl(
        l = BIT_LENGTH,
        d = BIT_DIAMETER,
        anchor = FRONT
    ) {
        attach(BACK, FRONT)
        ycyl(
            l = SHAFT_HEAD_LENGTH,
            d = SHAFT_LARGE_DIAMETER,
            anchor = FRONT
        ) {
            attach(BACK, FRONT)
            ycyl(
                l = SHAFT_LENGTH,
                d = SHAFT_SMALL_DIAMETER,
                anchor = FRONT
            );
        }
    }
}

module holder() {
    difference() {
        diff("remove")
        gridfinity_bin(
            2,
            4,
            4,
            lip = "none",
            middle = "solid"
         ) {
             tag("remove")
             attach(TOP, BOT)
             left(25)
             down(SHAFT_LARGE_DIAMETER / 2)
             up(7 * 4 - 2)
             shaft();
             
             tag("remove")
             up(7 * 4)
             xcyl(
                l = 75,
                d = 30,
                rounding = 10
             );
         }
         translate([(HANDLE_WIDTH / 2) - 10, HANDLE_LENGTH / 2, (HANDLE_WIDTH / 2) + 9])
         rotate([90, 0, 0])
         rotate_extrude($fn = 100)
         import("milwaukee_screwdriver.svg", convexity = 5);
    }
}

holder();