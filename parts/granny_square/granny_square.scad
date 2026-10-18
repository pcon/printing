include <../../lib/statics.scad>
include <../../lib/BOSL2/std.scad>
include <../../lib/magnets.scad>
include <../../lib/screw_container.scad>

PART_PLATE = "plate";
PART_BASE = "base";
PART_HOLDER = "holder";
PART_PIN_CASE = "pincase";
PART_ALL = "all";

PARTS = [
    PART_PLATE,
    PART_BASE,
    PART_HOLDER,
    PART_PIN_CASE,
    PART_ALL
];

CURRENT_PART = PART_PIN_CASE;

assert(in_list(CURRENT_PART, PARTS), str("Part '", CURRENT_PART, "' unknown"));

PLATE_HEIGHT = 5;

PIN_COUNT_X = 6;
PIN_COUNT_Y = 6;
PIN_SPACING = 25.4;

PIN_GROUP = [2, 2];
PIN_CASE_SPACING = 3;

NAIL_DIAMETER = 2.2;
NAIL_HEAD_DIAMETER = 5;
NAIL_HEAD_HEIGHT = 1.5;
NAIL_HEIGHT = 16;

PIN_HEIGHT = PLATE_HEIGHT + NAIL_HEIGHT;

LAYER_HEIGHT = .2;

// END OF CONFIGURATION

assert(PIN_COUNT_X > 1, "X pin count must be >= 2");
assert(PIN_COUNT_Y > 1, "Y pin count must be >= 2");
assert(PIN_COUNT_X % 2 == 0, "X pin count must be even for magnet spacing");
assert(PIN_COUNT_Y % 2 == 0, "Y pin count must be even for magnet spacing");
assert(NAIL_HEAD_HEIGHT < PLATE_HEIGHT, "Nail head taller than plate height");
assert(PLATE_HEIGHT % LAYER_HEIGHT, "Plate height must be a multiple of layer height");

$slop = .2;
$fn = $preview ? 32 : 128;

pin_base_width = NAIL_HEAD_DIAMETER * 2;
plate_edge_width = PIN_SPACING / 2;
pin_group_diameter = (sqrt(2) * (NAIL_HEAD_DIAMETER / 2 + 2) + NAIL_HEAD_DIAMETER / 2 + 2) * 2;

total_width = (PIN_COUNT_X - 1) * PIN_SPACING + plate_edge_width * 2;
total_depth = (PIN_COUNT_Y - 1) * PIN_SPACING + plate_edge_width * 2;

magnet_count_x = PIN_COUNT_X / 2;
magnet_count_y = PIN_COUNT_Y / 2;
magnet_top_layer = LAYER_HEIGHT * 2;

assert(pin_base_width / 2 > NAIL_DIAMETER, "Nail head to diameter ratio too low for pin generation");

module magnet_holes(label = "") {
    grid_copies(
        spacing = [
            PIN_SPACING * 2,
            PIN_SPACING * 2
        ],
        n = [
            magnet_count_x,
            magnet_count_y
        ]
    )
    magnet_hole(label);
}

module nail_holder(hole = false) {
    diff("remove2")
    zcyl(
        d = pin_base_width,
        h = PLATE_HEIGHT / 2 + render_helper,
        anchor = BOT
    ) {
        attach(BOT, BOT, inside = true)
        zcyl(
            d = pin_base_width / 2,
            h = PLATE_HEIGHT + render_helper * 2,
            anchor = BOT
        );
        
        if (hole) {
            tag("remove2")
            attach(BOT, BOT, inside = true, shiftout = render_helper)
            zcyl(
                d = NAIL_HEAD_DIAMETER,
                h = NAIL_HEAD_HEIGHT + render_helper
            ) {
                attach(TOP, BOT, shiftout = -render_helper)
                zcyl(
                    d = NAIL_DIAMETER,
                    h = PLATE_HEIGHT - NAIL_HEAD_HEIGHT + render_helper * 4
                );
            }
        }
    }
}

module nail_holes() {
    down(render_helper)
    grid_copies(
        spacing = [
            PIN_SPACING,
            PIN_SPACING
        ],
        n = [
            PIN_COUNT_X,
            PIN_COUNT_Y
        ]
    )
    nail_holder();
}

module base_plate(
    anchor = BOT,
    spin = 0,
    orient = UP,
    magnet_label = ""
) {
    diff("remove")
    cuboid(
        [
            total_width,
            total_depth,
            PLATE_HEIGHT
        ],
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        tag("remove")
        attach(BOT, BOT, inside = true, overlap = -magnet_top_layer)
        magnet_holes(label = magnet_label);
        
        children();
    }
}

module pin_plate(magnet_label = "", anchor, spin, orient) {
    base_plate(
        magnet_label = magnet_label,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        tag("remove")
        attach(BOT, BOT, inside = true)
        nail_holes();
    }
}

module pin_case(anchor, spin, orient) {
    diff("remove_pincase")
    container_bottom(
        h = PIN_HEIGHT,
        id = 38,
        outside_percentage = .25,
        inside_percentage = .9,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        tag("remove_pincase")
        grid_copies(n = PIN_GROUP, spacing = pin_base_width + PIN_CASE_SPACING)
        attach(BOT, BOT, inside = true, shiftout = -2)
        scale(1.04)
        cyl(
            d = pin_base_width + $slop,
            h = PIN_HEIGHT
        );
    }
    
    right(50)
    container_lid(
        h = PIN_HEIGHT,
        od = 38,
        outside_percentage = .75,
        inside_percentage = .1,
        anchor = anchor,
        spin = spin,
        orient = orient
    );
}

if (CURRENT_PART == PART_ALL || CURRENT_PART == PART_HOLDER) {
    scale(.96)
    nail_holder(hole = true);
}

if (CURRENT_PART == PART_ALL || CURRENT_PART == PART_PLATE) {
    pin_plate(orient = $preview ? UP : DOWN, magnet_label = MAGNET_LABEL_B);
}

if (CURRENT_PART == PART_ALL || CURRENT_PART == PART_BASE) {
    base_plate(orient = DOWN, magnet_label = MAGNET_LABEL_A);
}

if (CURRENT_PART == PART_PIN_CASE) {
    pin_case(anchor = BOT);
}