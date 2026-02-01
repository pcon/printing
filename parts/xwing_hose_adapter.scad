HOSE_DIAMETER = 14.75;
HOSE_HEIGHT = 25;
HOSE_HEIGHT_BELT = 15;

HEATSET_DIAMETER = 5.5;
HEATSET_DEPTH = 8;

FLANGE_DIAMETER = 32;
FLANGE_DIAMETER_BELT = 25;
FLANGE_HEIGHT = 1.5;

SCREW_DIAMETER = 4.5;

HOLE_DIAMETER = 23.5;
HOLE_DIAMETER_BELT = (FLANGE_DIAMETER_BELT - HOSE_DIAMETER) / 3;
HOLE_FILLER_HEIGHT = 2;

CROSS_BAR_HEIGHT = 3;
CROSS_BAR_DEPTH = 10;
CROSS_BAR_WIDTH = 32;

render_helper = 1;

$fn = 60;

module outside() {
    difference() {
        union() {
            cylinder(h = FLANGE_HEIGHT, d = FLANGE_DIAMETER);
            
            translate([0, 0, FLANGE_HEIGHT])
            cylinder(h = HOSE_HEIGHT, d = HOSE_DIAMETER);
        }
 
        cylinder(h = HEATSET_DEPTH, d = HEATSET_DIAMETER);
    }
}

module inside() {
    difference() {
        union() {
            cylinder(h = HOLE_FILLER_HEIGHT + CROSS_BAR_HEIGHT, d = HOLE_DIAMETER);
            
            translate([0, CROSS_BAR_DEPTH / 2, CROSS_BAR_HEIGHT / 2])
            cube([CROSS_BAR_WIDTH, CROSS_BAR_DEPTH, CROSS_BAR_HEIGHT], center = true);
        }
        cylinder(h = HOLE_FILLER_HEIGHT + CROSS_BAR_HEIGHT, d = SCREW_DIAMETER);
    }
}

module belt() {
    difference() {
        union() {
            cylinder(h = FLANGE_HEIGHT, d = FLANGE_DIAMETER_BELT);
            
            translate([0, 0, FLANGE_HEIGHT])
            cylinder(h = HOSE_HEIGHT_BELT, d = HOSE_DIAMETER);
        }
        
        for (i = [0 : 3]) {
            rotate([0, 0, 90 * i])
            translate([
                0,
                (FLANGE_DIAMETER_BELT) / 2 - (FLANGE_DIAMETER_BELT - HOSE_DIAMETER) / 4,
                -render_helper
            ])
            cylinder(h = FLANGE_HEIGHT + render_helper * 2, d = HOLE_DIAMETER_BELT);
        }
    }
}

belt();