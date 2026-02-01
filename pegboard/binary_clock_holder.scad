include <../lib/pegmixer.scad>

BOX_WIDTH = 110;
PLATE_HEIGHT = 40;
PLATE_THICKNESS = 6;

INSET_HEIGHT = 5;
INSET_DIAMETER = 4;

render_helper = 1;

module base_plate() {
    pegmixer(wall_thickness = PLATE_THICKNESS) 
    plate([BOX_WIDTH,0,PLATE_HEIGHT]);
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
//drill_template();