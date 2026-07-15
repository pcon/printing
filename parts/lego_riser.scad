include <../lib/statics.scad>
include <../lib/BOSL2/std.scad>

BACK_SHELF_DEPTH = 70;
BACK_SHELF_HEIGHT = 100;
FRONT_SHELF_DEPTH = 85;
FRONT_SHELF_HEIGHT = 50;

RISER_WIDTH = 40;

WALL_WIDTH = 2p.5;

diff("remove")
cuboid(
    [
        RISER_WIDTH,
        FRONT_SHELF_DEPTH,
        FRONT_SHELF_HEIGHT
    ],
    anchor = BOT +  FRONT
) {
    align(TOP)
    attach(BACK, FRONT)
    cuboid(
        [
            RISER_WIDTH,
            BACK_SHELF_DEPTH,
            BACK_SHELF_HEIGHT
        ]
    ) {
        tag("remove")
        attach(CENTER, CENTER)
        cuboid(
            [
                RISER_WIDTH + render_helper,
                BACK_SHELF_DEPTH - WALL_WIDTH * 2,
                BACK_SHELF_HEIGHT - WALL_WIDTH * 2
            ]
        );
    }
    
    tag("remove")
    attach(CENTER, CENTER)
    cuboid(
        [
            RISER_WIDTH + render_helper,
            FRONT_SHELF_DEPTH - WALL_WIDTH * 2,
            FRONT_SHELF_HEIGHT - WALL_WIDTH * 2
        ]
    );
}