include <../lib/statics.scad>
use <../lib/common.scad>
include <../lib/BOSL2/std.scad>

MAGNET_WIDTH = 10;
MAGNET_LENGTH = 59.5;
MAGNET_HEIGHT = 3;

magnet_dimensions = [
    MAGNET_WIDTH,
    MAGNET_LENGTH,
    MAGNET_HEIGHT
];

WALL_THICKNESS = 1.5;
BOTTOM_THICKNESS = 1;
TOP_THICKNESS = 1;

MATERIAL_THICKNESS = 3;  
CORNER_OVERLAP = 5;

function add_walls(width, count = 2) = width + WALL_THICKNESS * count;

holder_width = add_walls(MAGNET_WIDTH);
holder_length = add_walls(MAGNET_LENGTH);
holder_height = BOTTOM_THICKNESS + MAGNET_HEIGHT + TOP_THICKNESS;
holder_dimensions = [
    holder_width,
    holder_length,
    holder_height
];

corner_height = holder_height - MATERIAL_THICKNESS;

module magnet_holder(anchor, spin = 0) {
    cuboid(
        holder_dimensions,
        anchor = anchor,
        spin = spin
    );
}

module magnet_holder_corner() {
    cuboid(
        [
            holder_width,
            holder_width,
            holder_height
        ],
        anchor = BOT + RIGHT + FWD
    ) {
        diff("hole")
        attach(FWD, BACK)
        cuboid(
            holder_dimensions,
            anchor = BOT + RIGHT + BACK
        )
        tag("hole")
        cuboid(
            magnet_dimensions
        );
        
        diff("hole")
        attach(RIGHT, BACK)
        cuboid(
            holder_dimensions,
            anchor = BOT + LEFT + BACK
        )
        tag("hole")
        cuboid(
            magnet_dimensions
        );
    }
    
    up(corner_height / 2)
    prismoid(
        size1 = [
            CORNER_OVERLAP,
            corner_height
        ],
        size2 = [
            0,
            corner_height
        ],
        shift = [
            -CORNER_OVERLAP / 2,
            0
        ],
        h = CORNER_OVERLAP,
        orient = FWD,
        anchor = BOT + LEFT
    );
}

module magnet_holder_side() {
    diff("hole")
    cuboid(
        holder_dimensions,
        anchor = BOT + RIGHT + BACK
    )
    tag("hole")
    cuboid(
        magnet_dimensions
    );
    
    cuboid(
        [
            CORNER_OVERLAP,
            holder_length,
            corner_height
        ],
        anchor = BOT + LEFT + BACK
    );
}

magnet_holder_side();