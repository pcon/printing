BOARD_DEPTH = 11.5;
BOARD_HEIGHT = 14;
BOARD_WIDTH = 29;

INSERT_HEAD_HEIGHT = 2.5;
INSERT_HEAD_DIAMETER = 5;
INSERT_DIAMETER = 2.7;
INSERT_HEIGHT = 7;

USB_Y_OFFSET = 2;
USB_WIDTH = 9;

USB_FRONT_BLOCK_HEIGHT = 6.25;

CABLE_HEIGHT = 1;
CABLE_WIDTH = 10;
CABLE_STICKOUT = 10;
CABLE_Y_OFFSET = 5.75;

CABLE_REAR_BLOCK_HEIGHT = 5.25;

cable_strap_width = CABLE_WIDTH + INSERT_HEAD_DIAMETER * 2 + 2;
cable_strap_hole_offset_y = CABLE_WIDTH / 2 + INSERT_HEAD_DIAMETER / 2;

WALL_WIDTH = 1.6;
FLOOR_HEIGHT = .6;

render_helper = 1;

total_height = FLOOR_HEIGHT + BOARD_HEIGHT;
total_width = WALL_WIDTH * 2 + BOARD_WIDTH + CABLE_STICKOUT;
total_depth = WALL_WIDTH * 2 + BOARD_DEPTH + INSERT_HEAD_DIAMETER * 2;

module base() {
    translate([0, -total_depth / 2, 0])
    cube([
        total_width,
        total_depth,
        total_height
    ]);
}

module board_cutout() {
    translate([
        WALL_WIDTH,
        -BOARD_DEPTH / 2,
        FLOOR_HEIGHT
    ])
    cube([
        BOARD_WIDTH,
        BOARD_DEPTH,
        BOARD_HEIGHT + render_helper
    ]);
}

module usb_cutout() {
    translate([
        -render_helper,
        -USB_WIDTH / 2,
        USB_Y_OFFSET + FLOOR_HEIGHT
    ])
    cube([
        WALL_WIDTH + render_helper * 2,
        USB_WIDTH,
        BOARD_HEIGHT
    ]);
}

module cable_cutout() {
    union() {
        translate([
            WALL_WIDTH + BOARD_WIDTH - render_helper,
            -CABLE_WIDTH / 2,
            CABLE_Y_OFFSET + FLOOR_HEIGHT
        ])
        cube([
            CABLE_STICKOUT + WALL_WIDTH + render_helper * 2,
            CABLE_WIDTH,
            total_height
        ]);
 
        translate([
            WALL_WIDTH + BOARD_WIDTH,
            0,
            CABLE_Y_OFFSET + CABLE_HEIGHT + FLOOR_HEIGHT
        ])
        union() {
            translate([
                0,
                -cable_strap_width / 2,
                0
            ])
            cube([
                CABLE_STICKOUT,
                cable_strap_width,
                total_height
            ]);
            
            translate([
                CABLE_STICKOUT / 2,
                cable_strap_hole_offset_y,
                -INSERT_HEIGHT
            ])
            cylinder(d = INSERT_DIAMETER, h = INSERT_HEIGHT + render_helper, $fn = 32);
            
            translate([
                CABLE_STICKOUT / 2,
                -cable_strap_hole_offset_y,
                -INSERT_HEIGHT
            ])
            cylinder(d = INSERT_DIAMETER, h = INSERT_HEIGHT + render_helper, $fn = 32);
        }
    }
}

module case_bottom() {
    difference() {
        base();
        usb_cutout();
        board_cutout();
        cable_cutout();
    }
}

module case_top() {
    translate([0, -total_depth / 2, 0])
    cube([total_width, total_depth, FLOOR_HEIGHT + INSERT_HEAD_HEIGHT]);
}

case_bottom();

translate([0, 0, total_height])
case_top();