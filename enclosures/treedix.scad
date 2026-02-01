include <../lib/roundedcube.scad>

DEVICE_WIDTH = 76.5;
DEVICE_DEPTH = 65.5;
DEVICE_HEIGHT = 14.75;

SWITCH_DEPTH = 1.5;
SWITCH_HEIGHT = 10;

CUTOUT_WIDTH = 45;
CUTOUT_DEPTH = 11;
CUTOUT_RADIUS = 3;

WALL_WIDTH = 1.5;
case_radius = WALL_WIDTH;

FONT_DEPTH = 1;

case_width = DEVICE_WIDTH + SWITCH_DEPTH * 2 + WALL_WIDTH * 2;
case_depth = DEVICE_DEPTH + WALL_WIDTH;
case_height = DEVICE_HEIGHT + WALL_WIDTH * 2;

render_helper = 1;

module base_sleeve() {
    roundedcube(
        [
            case_width,
            case_depth,
            case_height
        ],
        radius = case_radius,
        apply_to = "z"
    );
}

module thumb_cutout() {
    offset_x = (case_width - CUTOUT_WIDTH) / 2;
    offset_y = case_depth - CUTOUT_DEPTH;
    offset_z = -render_helper;
    translate([offset_x, offset_y, offset_z])
    roundedcube(
        [
            CUTOUT_WIDTH,
            CUTOUT_DEPTH + CUTOUT_RADIUS + render_helper,
            case_height + render_helper * 2
        ],
        radius = CUTOUT_RADIUS,
        apply_to = "z"
    );
    
    offset_pretty_y = case_depth - CUTOUT_RADIUS;
    translate([offset_x, offset_pretty_y, offset_z])
    union() {
        translate([-CUTOUT_RADIUS, 0, 0])
        cube([
            CUTOUT_RADIUS + render_helper,
            CUTOUT_RADIUS + render_helper,
            case_height + render_helper * 2
        ]);
        
        translate([CUTOUT_WIDTH - render_helper, 0, 0])
        cube([
            CUTOUT_RADIUS + render_helper,
            CUTOUT_RADIUS + render_helper,
            case_height + render_helper * 2
        ]);
    }
}

module thumb_pretty() {
    offset_x = (case_width - CUTOUT_WIDTH) / 2;
    offset_y = case_depth - CUTOUT_RADIUS;
    offset_z = 0;
    translate([offset_x, offset_y, offset_z])
    union() {
        translate([-CUTOUT_RADIUS, 0, 0])
        cylinder(r = CUTOUT_RADIUS, h = case_height);
        
        translate([CUTOUT_WIDTH + CUTOUT_RADIUS, 0, 0])
        cylinder(r = CUTOUT_RADIUS, h = case_height);
    }
}

module device_cutout() {
    offset_x = (case_width - DEVICE_WIDTH) / 2;
    offset_y = case_depth - DEVICE_DEPTH;
    offset_z = (case_height - DEVICE_HEIGHT) / 2;
    translate([offset_x, offset_y, offset_z])
    union() {
        cube(
            [
                DEVICE_WIDTH,
                DEVICE_DEPTH + render_helper,
                DEVICE_HEIGHT
            ]
        );
        
        offset_switch_z = (DEVICE_HEIGHT - SWITCH_HEIGHT) / 2;
        translate([-SWITCH_DEPTH, 0, offset_switch_z])
        cube([
            SWITCH_DEPTH,
            DEVICE_DEPTH + render_helper,
            SWITCH_HEIGHT
        ]);
        
        translate([DEVICE_WIDTH, 0, offset_switch_z])
        cube([
            SWITCH_DEPTH,
            DEVICE_DEPTH + render_helper,
            SWITCH_HEIGHT
        ]);
    }
}

module case() {
    difference() {
        union() {
            difference() {
                base_sleeve();
                thumb_cutout();
            }
            thumb_pretty();
        }
        device_cutout();
    }
}

if ($preview) {
    case();
} else {
    rotate([90, 0, 0])
    case();
}