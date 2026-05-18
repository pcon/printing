include <../lib/statics.scad>
use <../lib/common.scad>
include <../lib/BOSL2/std.scad>

PIPE_DIAMETER = 18.2;
WALL_WIDTH = 2;
CAP_LENGTH = 30;
CAP_END = 5;
cap_total_diameter = PIPE_DIAMETER + WALL_WIDTH * 2;
cap_total_radius = cap_total_diameter / 2;
cap_total_length = CAP_LENGTH + CAP_END;
cap_side_length =  cap_total_length + cap_total_radius;


$fn = 50;

module pipe_cap_x3() {
    diff("hole")
    zcyl(
        l = cap_total_length,
        d = cap_total_diameter,
        anchor = BOT
    ) {
        left(cap_total_radius)
        attach(RIGHT, RIGHT, align = BOT)
        cuboid(
            [
                cap_side_length,
                cap_total_diameter,
                cap_total_radius
            ],
            anchor = BOT
        )
        align(BOT, inside = true)
        xcyl(
            l = cap_total_length + cap_total_diameter / 2,
            d = cap_total_diameter,
            anchor = BOT
        )
        tag("hole")
        attach(LEFT, LEFT, inside = true, shiftout = .1)
        xcyl(
            l = CAP_LENGTH,
            d = PIPE_DIAMETER
        );
        
        back(cap_total_diameter / 2)
        attach(FWD, FWD, align = BOT)
        cuboid(
            [
                cap_total_diameter,
                cap_side_length,
                cap_total_radius
            ],
            anchor = BOT + BACK
        )
        align(BOT, inside = true)
        ycyl(
            l = cap_side_length,
            d = cap_total_diameter,
            anchor = BOT
        )
        tag("hole")
        attach(BACK, BACK, inside = true, shiftout = .1)
        ycyl(
            l = CAP_LENGTH,
            d = PIPE_DIAMETER
        );
        
        tag("hole")
        attach(TOP, TOP, inside = true, shiftout = .1)
        zcyl(
            l = CAP_LENGTH,
            d = PIPE_DIAMETER
        );
    }
}

pipe_cap_x3();