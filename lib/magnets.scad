include <statics.scad>
include <BOSL2/std.scad>

MAGNET_DIAMETER = 6.4;
MAGNET_HEIGHT = 3.2;
MAGNET_LABEL_WIDTH = 2;

MAGNET_LABEL_A = "PLUS";
MAGNET_LABEL_B = "MINUS";

LAYER_HEIGHT = .2;

module magnet_label(label = "", h = LAYER_HEIGHT * 3) {
    assert(
        label != "" ||
        label != MAGNET_LABEL_A ||
        label != MAGNET_LABEL_B,
        "Unknown magnet label"
    );
    
    if (
        label == MAGNET_LABEL_A ||
        label == MAGNET_LABEL_B
    ) {
        cuboid(
            [
                MAGNET_DIAMETER,
                MAGNET_LABEL_WIDTH,
                h
            ],
            rounding = MAGNET_LABEL_WIDTH / 2,
            edges = [
                FWD + RIGHT,
                FWD + LEFT,
                BACK + RIGHT,
                BACK + LEFT
            ]
        ) {
            if (label == MAGNET_LABEL_A) {
                attach(TOP, TOP, inside = true)
                cuboid(
                    [
                        MAGNET_LABEL_WIDTH,
                        MAGNET_DIAMETER,
                        h
                    ],
                    rounding = MAGNET_LABEL_WIDTH / 2,
                    edges = [
                        FWD + RIGHT,
                        FWD + LEFT,
                        BACK + RIGHT,
                        BACK + LEFT
                    ]
                );
            }
        }
    }
}

module magnet_hole(label = "", label_h = 1) {
    zcyl(
        d = MAGNET_DIAMETER,
        h = MAGNET_HEIGHT + render_helper
    ) {
        attach(TOP, BOT, shiftout = -render_helper)
        magnet_label(label = label, h = label_h);
    }
}