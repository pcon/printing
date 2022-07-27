HOLE_SPACING = 45;
HOLE_RADIUS = 1.5;
BACKING_PADDING = 3;
PEG_DIAMETER = 17;
PEG_DEPTH = 20;

CORNER_RADIUS = 2;
DEPTH = 3.5;

total_width = HOLE_SPACING + HOLE_RADIUS + BACKING_PADDING * 2;

module rounded_square( width, radius_corner ) {
    translate( [ radius_corner, radius_corner, 0 ] )
    minkowski() {
        square( width - 2 * radius_corner );
        circle( radius_corner );
    }
}

module holes() {
    translate([BACKING_PADDING + HOLE_RADIUS / 2, BACKING_PADDING + HOLE_RADIUS / 2, 0])
    union() {
        translate([0, 0, 0])
        circle(HOLE_RADIUS);
        
        translate([HOLE_SPACING, 0, 0])
        circle(HOLE_RADIUS);
        
        translate([0, HOLE_SPACING, 0])
        circle(HOLE_RADIUS);
        
        translate([HOLE_SPACING, HOLE_SPACING, 0])
        circle(HOLE_RADIUS);
    }
}

module peg() {
    total_depth = DEPTH + PEG_DEPTH;
    x = total_width / 2;
    y = total_width - BACKING_PADDING - PEG_DIAMETER / 2;

    linear_extrude(total_depth)
    translate([x, y, 0])
    circle(d=PEG_DIAMETER);
}

union() {
    linear_extrude(DEPTH)
    difference() {
        union() {
            rounded_square(total_width, CORNER_RADIUS);
        }
        holes();
    }
    peg();
}