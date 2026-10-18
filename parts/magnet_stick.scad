include <../lib/statics.scad>
include <../lib/BOSL2/std.scad>
include <../lib/magnets.scad>

$fn = $preview ? 32 : 128;

NOZZLE_DIAMETER = .4;
WALL_WIDTH = 3;
STICK_LENGTH = 60;
SHELL_HEIGHT = LAYER_HEIGHT * 4;
RING_HEIGHT = LAYER_HEIGHT * 3;
LABEL_HEIGHT = LAYER_HEIGHT * 2;
STICK_WIDTH = MAGNET_DIAMETER + WALL_WIDTH * 2;
STICK_HEIGHT = SHELL_HEIGHT * 2 + LABEL_HEIGHT + MAGNET_HEIGHT;

hole_offset = STICK_LENGTH / 2 - MAGNET_DIAMETER / 2 - WALL_WIDTH;
label_offset = hole_offset - MAGNET_DIAMETER - LAYER_HEIGHT * 8;

labels = [
    MAGNET_LABEL_A,
    MAGNET_LABEL_B
];

module magnet_stick() {
    diff("remove")
    cuboid(
        [
            STICK_LENGTH,
            STICK_WIDTH,
            STICK_HEIGHT
        ],
        rounding = STICK_WIDTH / 2,
        edges = [
            FWD + RIGHT,
            FWD + LEFT,
            BACK + RIGHT,
            BACK + LEFT
        ]
    ) {
        tag("remove")
        right(hole_offset)
        attach(TOP, BOT, inside = true, shiftout = -SHELL_HEIGHT)
        magnet_hole(label = MAGNET_LABEL_A, label_h = LABEL_HEIGHT);
        
        tag("remove")
        right(label_offset)
        attach(TOP, BOT, inside = true, shiftout = render_helper)
        magnet_label(label = MAGNET_LABEL_A, h = LABEL_HEIGHT + render_helper);
        
        tag("remove")
        left(hole_offset)
        attach(TOP, BOT, inside = true, shiftout = -SHELL_HEIGHT)
        magnet_hole(label = MAGNET_LABEL_B, label_h = LABEL_HEIGHT);
        
        tag("remove")
        left(label_offset)
        attach(TOP, BOT, inside = true, shiftout = render_helper)
        magnet_label(label = MAGNET_LABEL_B, h = LABEL_HEIGHT + render_helper);
        
        xcopies(
            n = 2,
            spacing = hole_offset * 2
        )
        attach(TOP, BOT)
        tube(
            id = MAGNET_DIAMETER,
            wall = NOZZLE_DIAMETER * 2,
            h = RING_HEIGHT
        );
    }
}

magnet_stick();