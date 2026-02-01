default_hole_d = 6.35;
default_wall_thickness = 5;
default_foot_clearance = 7;
default_bracket_height = 15;

render_helper = 1;

module bracket(
    hole_d = default_hole_d,
    wall_thickness = default_wall_thickness
) {
    $hole_d = hole_d;
    $wall_thickness = wall_thickness;
    
    children(0);
}

module u_bracket(
    width,
    depth,
    height = default_bracket_height,
    foot_clearance = default_foot_clearance
) {
    foot_width = foot_clearance * 2 + $hole_d;
    bracket_outside_width = foot_width * 2 + $wall_thickness * 2 + width;
    bracket_depth = depth + $wall_thickness;

    difference() {
        bracket_body();
        cutout();
        holes();
    }
    
    module bracket_body() {
        union() {
            cube([
                bracket_outside_width,
                $wall_thickness,
                height
            ], center = true);
            
            body_offset_y = bracket_depth / 2 - $wall_thickness / 2;
            translate([0, body_offset_y, 0])
            cube([
                width + $wall_thickness *2,
                bracket_depth,
                height
            ], center = true);
        }
    }
    
    module cutout() {
        hole_offset_y = depth / 2 - $wall_thickness / 2 - render_helper;
        translate([0, hole_offset_y, 0])
        cube([
            width,
            depth + render_helper,
            height + render_helper
        ], center = true);
    }
    module holes() {
        hole_height = $wall_thickness + render_helper;
        offset_x = width / 2 + foot_width / 2 + $wall_thickness;
        for (x = [1, -1]) {
            translate([offset_x * x, hole_height / 2, 0])
            rotate([90, 0, 0])
            cylinder(
                h = hole_height,
                d = $hole_d,
                $fn=12
            );
        }
    }
}