include <../lib/roundedcube.scad>

LED_WALL_WIDTH = 2;
LED_DIAMETER = 12;
LED_CLEARANCE = 4;

LED_SIDE_DEPTH = LED_DIAMETER * 2 + LED_CLEARANCE * 3;
LED_SIDE_WIDTH = 35;
LED_SIDE_HEIGHT = 25;

BOARD_WIDTH = 20;
OVERLAP = 10;
BOARD_SIDE_WIDTH = 40 + OVERLAP;
SLOT_OFFSET = 6;

CABLE_SLOT_DEPTH = 14;
CABLE_SLOT_HEIGHT = 8;
CABLE_SLOT_OFFSET = 18;

WALL_WIDTH = 2.5;

render_helper = 1;

led_side_outside_width = LED_SIDE_WIDTH + LED_WALL_WIDTH;
led_side_outside_depth = LED_SIDE_DEPTH + WALL_WIDTH * 2;
led_side_outside_height = LED_SIDE_HEIGHT + WALL_WIDTH * 2;

board_side_depth = led_side_outside_depth;
board_side_height = led_side_outside_height;

board_side_outside_width = BOARD_SIDE_WIDTH + WALL_WIDTH;
board_side_outside_depth = board_side_depth + WALL_WIDTH * 2;
board_side_outside_height = board_side_height + WALL_WIDTH * 2;

module led_body() {
    roundedcube([
        led_side_outside_width,
        led_side_outside_depth,
        led_side_outside_height
    ], radius = 1);
}

module led_cutout() {
    translate([LED_WALL_WIDTH, WALL_WIDTH, WALL_WIDTH])
    cube([
        LED_SIDE_WIDTH + render_helper,
        LED_SIDE_DEPTH,
        LED_SIDE_HEIGHT
    ]);
}

module led_holes() {
    union() {
        for (x = [1, -1]) {
            translate([
                -led_side_outside_width + LED_WALL_WIDTH + render_helper,
                (LED_DIAMETER / 2 + LED_CLEARANCE) * x,
                0
            ])
            rotate([0, -90, 0])
            cylinder(
                h = LED_WALL_WIDTH + render_helper * 2,
                d = LED_DIAMETER,
                $fn = 20
            );
        }
    }
}

module led_side() {
    difference() {
        translate([
            -led_side_outside_width,
            -led_side_outside_depth / 2,
            -led_side_outside_height / 2
        ])
        difference() {
            led_body();
            led_cutout();
        };
        led_holes();
    }
}

module board_body() {
    roundedcube([
        board_side_outside_width,
        board_side_outside_depth,
        board_side_outside_height
    ], radius = 1);
}

module board_cutout() {
    union() {
        translate([
            -render_helper,
            -(BOARD_WIDTH / 2) + board_side_outside_depth / 2,
            WALL_WIDTH
        ])
        cube([
            BOARD_SIDE_WIDTH + render_helper,
            BOARD_WIDTH,
            board_side_height
        ]);
        
        translate([-render_helper, WALL_WIDTH, WALL_WIDTH])
        cube([
            BOARD_SIDE_WIDTH + render_helper,
            board_side_depth,
            SLOT_OFFSET
        ]);
        
        translate([-render_helper, WALL_WIDTH, WALL_WIDTH])
        cube([
            OVERLAP + render_helper,
            board_side_depth,
            board_side_height
        ]);
    }
}


module cable_cutout() {
    translate([
        BOARD_SIDE_WIDTH - render_helper,
        -(CABLE_SLOT_DEPTH / 2) + board_side_outside_depth / 2,
        CABLE_SLOT_OFFSET + WALL_WIDTH
    ])
    roundedcube([
        WALL_WIDTH + render_helper * 2,
        CABLE_SLOT_DEPTH,
        CABLE_SLOT_HEIGHT
    ], radius = 2, apply_to = "x");
}

module board_side() {
    translate([
        -OVERLAP,
        -board_side_outside_depth / 2,
        -board_side_outside_height / 2
    ])
    union() {
        difference() {
            board_body();
            board_cutout();
            cable_cutout();
        };
    }
}

led_side();
//board_side();