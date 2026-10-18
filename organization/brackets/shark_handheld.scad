include <../../lib/BOSL2/std.scad>
include <../../lib/common.scad>
include <../../lib/statics.scad>

$fn = $preview ? 16 : 128;

WALL_WIDTH = 6;

HANDLE_DIAMETER = 30;
HANDLE_LENGTH = 30;
HANDLE_HEIGHT = 80;
HANDLE_DEPTH = 52;
HANDLE_WIDTH = 70;
HANDLE_TOP_INSET = 17;

PLATE_DEPTH = default_wall_hanger_depth();
PLATE_HEIGHT = 165;
PLATE_WIDTH = 85;
PLATE_ROUNDING = 3;

CORD_WIDTH = 4.5;

TOP_DIAMETER = 24;

module cordcutout() {
    ycyl(
        d = CORD_WIDTH,
        h = PLATE_HEIGHT + render_helper * 2
    );
}

module wall_plate() {
    diff("plate_remove")
    cuboid(
        [
            PLATE_WIDTH,
            PLATE_HEIGHT,
            PLATE_DEPTH
        ],
        anchor = BOT,
        rounding = PLATE_ROUNDING,
        edges = [TOP + LEFT, BOT + RIGHT, BOT + LEFT, FWD + LEFT, BACK + LEFT, "Z"]
    ) {
        tag("plate_remove")
        wall_hanger_screwholes(
            spacing = PLATE_HEIGHT / 3,
            spin = 90,
            orient = DOWN
        );
        
        tag("plate_remove")
        down(CORD_WIDTH / 2)
        right(PLATE_WIDTH / 4)
        align(BOT, inside = true)
        cordcutout();
        
        children();
    }
}

module side_wall() {
    cuboid(
        [
            WALL_WIDTH,
            PLATE_HEIGHT,
            HANDLE_DEPTH + HANDLE_DIAMETER
        ],
        anchor = BOT,
        rounding = PLATE_ROUNDING,
        edges = ["Z"]
    ) {
        back(PLATE_ROUNDING)
        left(WALL_WIDTH)
        align(BOT + FWD + RIGHT, inside = true)
        cuboid(
            [
                HANDLE_TOP_INSET,
                HANDLE_HEIGHT,
                HANDLE_DEPTH + HANDLE_DIAMETER - HANDLE_DIAMETER / 2
            ]
        );
        
        diff("remove_support")
        back(PLATE_ROUNDING)
        left(WALL_WIDTH + HANDLE_TOP_INSET)
        align(BOT + FWD + RIGHT, inside = true)
        cuboid(
            [
                TOP_DIAMETER / 2,
                HANDLE_HEIGHT,
                TOP_DIAMETER / 2
            ]
        ) {
            tag("remove_support")
            attach(TOP + LEFT, CENTER)
            ycyl(
                d = TOP_DIAMETER,
                h = HANDLE_HEIGHT + render_helper * 2
            );
        }
        children();
    }
}

module handle() {
    back(PLATE_ROUNDING)
    left(WALL_WIDTH)
    align(TOP + FWD + RIGHT, inside = true)
    cuboid(
        [
            HANDLE_WIDTH,
            HANDLE_HEIGHT,
            HANDLE_DIAMETER
        ],
        rounding = HANDLE_DIAMETER / 2,
        edges = "X"
    ) {
        align(LEFT, BACK)
        cuboid(
            [
                10,
                HANDLE_HEIGHT + 8,
                HANDLE_DIAMETER
            ],
            rounding = HANDLE_DIAMETER / 2,
            edges = "X"
        );
    }
}

module mount() {
    wall_plate() {
        up(PLATE_DEPTH)
        align(BOT + RIGHT + FWD, inside = true)
        side_wall()
        handle();
    }
}

mount();