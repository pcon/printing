include <../lib/switchplate.scad>

REMOTE_DEPTH = 114;
REMOTE_WIDTH = 42.5;
REMOTE_HEIGHT = 15.5;

REMOTE_DIMENSIONS = [
    REMOTE_WIDTH,
    REMOTE_DEPTH,
    REMOTE_HEIGHT
];


BUTTON_SIDE = 45.5;
BUTTON_DEPTH = 13.5;
BUTTON_DIAMETER = 25;

BUTTON_DIMENSIONS = [
    BUTTON_SIDE,
    BUTTON_SIDE,
    BUTTON_DEPTH
];

BUTTON_HOLDER_DIMENSIONS =
    BUTTON_DIMENSIONS +
    [
        PLATE_WALL_WIDTH * 2,
        PLATE_WALL_WIDTH,
        PLATE_WALL_WIDTH * 2
    ];

module button_holder() {
    down(
        (REMOTE_HEIGHT + PLATE_WALL_WIDTH) / 2 +
        PLATE_HEIGHT
    )
    position(LEFT)
    diff("button_remove")
    cuboid(
        BUTTON_HOLDER_DIMENSIONS,
        rounding = PLATE_RADIUS,
        except = [BOT, RIGHT],
        anchor = BOT + RIGHT
    ) {
        tag("button_remove")
        attach(BACK, BACK, inside = true, shiftout = render_helper)
        cuboid(
            BUTTON_DIMENSIONS +
            [
                render_helper,
                0,
                0
            ]
        );
        
        tag("button_remove")
        attach(BOT, BOT, inside = true, shiftout = render_helper)
        back(
            PLATE_WALL_WIDTH / 2 +
            PLATE_HOLDER_REMOTE_LIP +
            render_helper
        )
        cuboid(
            BUTTON_DIMENSIONS +
            [
                -PLATE_HOLDER_REMOTE_LIP * 2,
                -PLATE_HOLDER_REMOTE_LIP + render_helper,
                0
            ]
        );
        
        tag("button_remove")
        attach(TOP, TOP, inside = true, shiftout = render_helper)
        back(PLATE_WALL_WIDTH / 2)
        cyl(
            d = BUTTON_DIAMETER,
            h = PLATE_WALL_WIDTH + render_helper * 2
        );
    };
}

switchplate(
    type = SWITCH_TYPE_ROCKER,
    remote_size = REMOTE_DIMENSIONS,
    include_cover = false
)
switchplate_remoteholder(
    switch_type = SWITCH_TYPE_ROCKER,
    remote_size = REMOTE_DIMENSIONS
)
button_holder();