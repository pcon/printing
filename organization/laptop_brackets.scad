$vpd = 861.88;
$vpt = [ 174.27, 133.18, 67.20 ];
$vpf = 22.50;
$vpr = [ 55.00, 0.00, 25.00 ];

LAPTOP_HEIGHT = 19.5;
WALL_WIDTH = 3;

DESK_HEIGHT = 28;

HOLDER_WIDTH = 75;
HOLDER_DEPTH = 25;
HOLDER_BOTTOM_CUTOUT = 25;

SCREW_HEAD_DIAMETER = 9.5;
SCREW_HEAD_HEIGHT = 3;
SCREW_BODY_DIAMETER = 4;
SCREW_BODY_HEIGHT = 4;
SCREW_DRIVER_DIAMETER = 12;

// These literally do not matter, they're just here to make the final preview look pretty
LAPTOP_WIDTH = 245;
LAPTOP_DEPTH = 355;

total_height = LAPTOP_HEIGHT + WALL_WIDTH + DESK_HEIGHT;
render_helper = 1;

module offset(i) {
    translate([
        (HOLDER_WIDTH / 4) * (i + 1),
        HOLDER_DEPTH / 2,
        0
    ])
    children();
}

module shaft_hole() {
    translate([0, 0, WALL_WIDTH + LAPTOP_HEIGHT - render_helper])
    cylinder(
        h = DESK_HEIGHT + render_helper * 2,
        d = SCREW_BODY_DIAMETER,
        $fn = 20
    );
}

module screwdriver_hole() {
    translate([0, 0, -render_helper])
    cylinder(
        h = total_height - SCREW_BODY_HEIGHT + render_helper,
        d = SCREW_DRIVER_DIAMETER,
        $fn = 20
    );
}

module screw_hole() {
    union() {
        shaft_hole();
        screwdriver_hole();
    }
}

module front_bracket() {
    difference() {
        cube([
            HOLDER_WIDTH,
            HOLDER_DEPTH,
            total_height
        ]);
        
        translate([WALL_WIDTH, -render_helper, WALL_WIDTH])
        cube([
            HOLDER_WIDTH - WALL_WIDTH + render_helper,
            HOLDER_DEPTH + render_helper * 2,
            LAPTOP_HEIGHT
        ]);
        
        translate([
            HOLDER_WIDTH - HOLDER_BOTTOM_CUTOUT,
            -render_helper,
            -render_helper
        ])
        cube([
            HOLDER_BOTTOM_CUTOUT + render_helper,
            HOLDER_DEPTH + render_helper * 2,
            WALL_WIDTH  + render_helper * 2
        ]);
        
        offset(0) {
            screw_hole();
        }
        
        offset(2) {
            screw_hole();
        }
    }
}

module rear_bracket() {
    difference() {
        union() {
            front_bracket();
            
            translate([0, HOLDER_DEPTH, 0])
            cube([HOLDER_WIDTH, WALL_WIDTH, total_height]);
        }
        
        translate([HOLDER_WIDTH - HOLDER_BOTTOM_CUTOUT, HOLDER_DEPTH - render_helper, 0])
        rotate([-90, -90, 0])
        linear_extrude(WALL_WIDTH + render_helper * 2) {
            polygon([
                [0, 0],
                [0, HOLDER_BOTTOM_CUTOUT],
                [total_height - DESK_HEIGHT, HOLDER_BOTTOM_CUTOUT]
            ]);
        }
    }
}


translate([-WALL_WIDTH, 0, 0])
front_bracket();

translate([HOLDER_WIDTH + LAPTOP_WIDTH + WALL_WIDTH, HOLDER_DEPTH, 0])
rotate([0, 0, 180])
front_bracket();

translate([-WALL_WIDTH, LAPTOP_DEPTH, 0])
rear_bracket();

translate([HOLDER_WIDTH + LAPTOP_WIDTH + WALL_WIDTH, LAPTOP_DEPTH, 0])
mirror([1, 0, 0])
rear_bracket();