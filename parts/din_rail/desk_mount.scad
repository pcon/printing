use <din_utilities.scad>

DEPTH = 20;

module base() {
    linear_extrude(DEPTH)
    polygon([
        [0, 0],
        [130, 0],
        [130, 10],
        [100, 10],
        [35, 50],
        [10, 90],
        [0, 90]
    ]);
}

module cutout() {
    linear_extrude(DEPTH)
    polygon([
        [33, 3],
        [97, 3],
        [97, 7],
        [33, 47]
    ]);
    
    linear_extrude(DEPTH)
    polygon([
        [3, 3],
        [30, 3],
        [30, 47],
        [3, 47]
    ]);
}

module screw_slot() {
    hole_size = 9;
    
    translate([21, 73, DEPTH / 2])
    rotate([90, 0, -59])
    cylinder(
        h = 10,
        d = hole_size
    );
}

module screw_hole() {
    hole_size = 3.5;

    translate([21, 73, DEPTH / 2])
    rotate([90, 0, -59])
    cylinder(
        h = 22,
        d = hole_size
    );
}

module rail() {
    linear_extrude(DEPTH + 1)
    translate([28, 55, 0])
    rotate([0, 0, 122])
    din_modified_slot();
}

difference() {
    base();
    cutout();
    rail();
    screw_slot();
    screw_hole();
}