TRAY_WIDTH = 30;
TRAY_DEPTH = 30;
TRAY_HEIGHT = 20;

HANGER_HEIGHT = 30;

WALL_WIDTH = 3;

HOLE_DIAMETER = 8;
hole_radius = HOLE_DIAMETER / 2;

font = "Liberation Sans";
emboss_height = 18;
emboss_depth = WALL_WIDTH / 2;

total_width = WALL_WIDTH * 2 + TRAY_WIDTH;
total_depth = WALL_WIDTH * 2 + TRAY_DEPTH;
total_height = WALL_WIDTH + TRAY_HEIGHT;

module hanger() {
    cube([total_width, WALL_WIDTH, HANGER_HEIGHT + total_height]);
}

module exclaim() {
    offset_x = total_width / 2 - 3.4;
    offset_y = emboss_depth;
    offset_z = total_height + (HANGER_HEIGHT - WALL_WIDTH - HOLE_DIAMETER - emboss_height) / 2;

    translate([offset_x, offset_y, offset_z])
    rotate([90, 0, 0])
    linear_extrude(height = emboss_depth) {
        text(
            "!",
            size = emboss_height,
            font = font,
            halign = "left",
            valign = "baseline",
            spacing = 1.5,
            $fn = 16
        );
    }
}

module mounting_hole() {
    offset_x = total_width / 2;
    offset_y = WALL_WIDTH;
    offset_z = total_height + HANGER_HEIGHT - WALL_WIDTH - hole_radius;

    translate([offset_x, offset_y, offset_z])
    rotate([90, 0, 0])
    cylinder(h = WALL_WIDTH, d = HOLE_DIAMETER);
}

module back_wall() {
    translate([0, total_depth - WALL_WIDTH, 0])
    difference() {
        hanger();
        mounting_hole();
        exclaim();
    }
}

union() {
    difference() {
        cube([total_width, total_depth, total_height]);
        translate([WALL_WIDTH, WALL_WIDTH, WALL_WIDTH])
        cube([TRAY_WIDTH, TRAY_DEPTH, TRAY_HEIGHT]);
    }
    back_wall();
}