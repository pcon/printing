include <../lib/statics.scad>
include <../lib/BOSL2/std.scad>
include <../lib/BOSL2/walls.scad>

$fn = 64;

WALL_WIDTH = 130;
WALL_DEPTH = 70;
WALL_HEIGHT = 5;

FRAME_WIDTH = 5;
STRUT_WIDTH = 1.5;
SPACING = 10;

MOUNT_DEPTH = 10;
MOUNT_WIDTH = 15;
MOUNT_HEIGHT = 10;

mount_side_width = MOUNT_WIDTH - FRAME_WIDTH;

module wall() {
    hex_panel(
        shape = [
            WALL_WIDTH - mount_side_width * 2,
            WALL_DEPTH,
            WALL_HEIGHT
        ],
        frame = FRAME_WIDTH,
        strut = STRUT_WIDTH,
        spacing = SPACING,
        anchor = BOT
    ) {
        attach(RIGHT, LEFT)
        cuboid(
            [
                mount_side_width,
                WALL_DEPTH,
                WALL_HEIGHT
            ]
        );
           
       attach(LEFT, RIGHT)
       cuboid(
            [
                mount_side_width,
                WALL_DEPTH,
                WALL_HEIGHT
            ]
        )
        right((MOUNT_WIDTH - mount_side_width) / 2)
        back(MOUNT_WIDTH / 2)
        position(FWD)
        attach(TOP, BOT)
        mounts(BOT); 
    }
}

module mounts(anchor) {
    cuboid(
        [
            MOUNT_WIDTH,
            MOUNT_DEPTH,
            MOUNT_HEIGHT
        ],
        anchor = anchor
    );
}

wall();