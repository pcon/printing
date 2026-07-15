include <../lib/BOSL2/std.scad>

PLEXI_WIDTH = 3.5;
WALL_WIDTH = 2.5;
WALL_HEIGHT = 10;
TAPE_WIDTH = 28;
PART_LENGTH = 150;

cuboid(
    [
        TAPE_WIDTH,
        PART_LENGTH,
        WALL_WIDTH
    ],
    anchor = BOT
) {
    attach(TOP, BOT)
    xcopies(PLEXI_WIDTH + WALL_WIDTH, 2)
    cuboid(
        [
            WALL_WIDTH,
            PART_LENGTH,
            WALL_HEIGHT
        ]
    );
}