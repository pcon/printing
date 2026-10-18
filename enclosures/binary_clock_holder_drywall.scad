include <../lib/BOSL2/std.scad>
include <../lib/statics.scad>

$fn = 32;

BOX_WIDTH = 110;
PLATE_HEIGHT = 40;
PLATE_THICKNESS = 6;

INSET_HEIGHT = 5;
INSET_DIAMETER = 4;

SCREW_DIAMETER = 4.5;
SCREW_HEAD_DIAMETER = 8.5;
SCREW_HEAD_DEPTH = 3.5;

render_helper = 1;

module base_plate() {
    cuboid([
        BOX_WIDTH,
        PLATE_THICKNESS,
        PLATE_HEIGHT
    ]);
}

module heat_insets(width) {
    union() {
        for (x = [1, -1]) {
            for (z = [1, -1]) {
                translate([((width / 2) - INSET_HEIGHT) * x, 0, (PLATE_HEIGHT / 3) * z])
                rotate([0, 90 * x, 0])
                cylinder(h = INSET_HEIGHT + render_helper, d = INSET_DIAMETER, $fn=15);
            }
        }
    }
}

module holder() {
    difference() {
        base_plate();
        heat_insets(width=BOX_WIDTH);
        mounting_screw_holes();
    }
}

module mounting_screw_holes() {
    fwd(PLATE_THICKNESS / 2)
    xcopies(
        n = 2,
        l = BOX_WIDTH / 2
    )
    fwd(render_helper)
    ycyl(
        h = SCREW_HEAD_DEPTH + render_helper,
        d = SCREW_HEAD_DIAMETER,
        anchor = FWD
    ) {
        ycyl(
            h = PLATE_THICKNESS + render_helper,
            d = SCREW_DIAMETER,
            anchor = FWD
        );
    }
}

module drill_template() {
    template_width = INSET_HEIGHT - render_helper;
    
    difference() {
        cube([template_width, PLATE_THICKNESS, PLATE_HEIGHT], center = true);
        heat_insets(template_width);
    }
}

holder();
//mounting_screw_holes();
//drill_template();