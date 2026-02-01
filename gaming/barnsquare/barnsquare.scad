$vpt = [ 63.22, 24.48, 40.99 ];
$vpr = [ 54.30, 0.00, 340.90 ];
$vpd = 391.08;
$vpf = 22.50;

BASE_WIDTH = 160;
piece_HEIGHT = 4;
WALL_WIDTH = 3;
CHAMFER = 2;
BASE_SLOP = 1.5;

render_helper = 1;

piece_total_height = piece_HEIGHT + CHAMFER * 2;
base_total_width = WALL_WIDTH * 2 + BASE_WIDTH + BASE_SLOP;
base_total_height = WALL_WIDTH + piece_total_height;

half_base = BASE_WIDTH / 2;
long_side = half_base * (sqrt(2) - 1);
square_hyp = sqrt(2 * long_side ^ 2);
half_square_hyp = square_hyp / 2;
half_chamfer = CHAMFER / 2;
top_chamfer_offset = CHAMFER + piece_HEIGHT;

function getColor(colors, index) = len(colors) > index ? colors[index] : colors[0];

module base() {
    difference() {
        cube([
            base_total_width,
            base_total_width,
            base_total_height
        ]);
        
        translate([
            WALL_WIDTH,
            WALL_WIDTH,
            WALL_WIDTH
        ])
        cube([
            BASE_WIDTH + BASE_SLOP,
            BASE_WIDTH + BASE_SLOP,
            piece_total_height + render_helper
        ]);
    }
}

module piece_square() {
    module square2(side = long_side, h = piece_HEIGHT, delta = 0) {    
        linear_extrude(h)
        offset(delta = -delta)
        square(side);
    }
    
    hull() {
        translate([half_chamfer, half_chamfer, 0])
        square2(h = CHAMFER, delta = CHAMFER);
        
        translate([0, 0, CHAMFER])
        square2();
        
        translate([half_chamfer, half_chamfer, top_chamfer_offset])
        square2(h = CHAMFER, delta = CHAMFER);
    }
}

module piece_triangle() {
    module triangle(side = long_side, h = piece_HEIGHT, delta = 0) {
        linear_extrude(h)
        offset(delta = -delta)
        polygon([
            [0, 0],
            [0, side],
            [side, 0]
        ]);
    }
    
    hull() {
        triangle(h = CHAMFER, delta = half_chamfer);
        
        translate([0, 0, CHAMFER])
        triangle();

        translate([0, 0, top_chamfer_offset])
        triangle(h = CHAMFER, delta = half_chamfer);
    }
}

module piece_rhombus() {
    module rhombus(side = long_side,  h = piece_HEIGHT, delta = 0) {
        hyp = sqrt(2 * long_side ^ 2);
        half_hyp = hyp / 2;
        
        bottom_length = side;
        shape_height = half_hyp;

        linear_extrude(h)
        offset(delta = -delta)
        polygon([
            [0, 0],
            [side, 0],
            [side + shape_height, shape_height],
            [shape_height, shape_height]
        ]);
    }

    hull() {
        rhombus(h = CHAMFER, delta = CHAMFER);
        
        translate([0, 0, CHAMFER])
        rhombus();
        
        translate([0, 0, piece_HEIGHT + CHAMFER])
        rhombus(h = CHAMFER, delta = CHAMFER);
    }
}

module sample_pattern_one() {
    module sample_pattern_one_rhombi(colors = ["pink", "purple"]) {
        rhombus_height = long_side + half_square_hyp;
        rhombus_top = BASE_WIDTH - rhombus_height;
         
        color(getColor(colors, 0)) {
            translate([long_side, 0, 0])
            rotate([0, 0, 45])
            piece_rhombus();
            
            translate([long_side + square_hyp + half_square_hyp, rhombus_top, 0])
            rotate([0, 0, 45])
            piece_rhombus();
            
            translate([long_side + square_hyp + half_square_hyp, half_square_hyp, 0])
            rotate([0, 0, 90])
            piece_rhombus();
          
            translate([long_side + square_hyp, rhombus_top - half_square_hyp, 0])
            rotate([0, 0, 90])
            piece_rhombus();
            
            translate([rhombus_height + half_square_hyp, rhombus_height + half_square_hyp, 0])
            rotate([0, 0, 180])
            piece_rhombus();

            translate([rhombus_height * 2 + half_square_hyp, rhombus_height + square_hyp, 0])
            rotate([0, 0, 180])
            piece_rhombus();
            
            translate([rhombus_height, rhombus_top, 0])
            rotate([0, 0, 135])
            piece_rhombus();
            
            translate([BASE_WIDTH, long_side, 0])
            rotate([0, 0, 135])
            piece_rhombus();
        }
        color(getColor(colors, 1)) {
            translate([long_side + half_square_hyp, half_square_hyp, 0])
            rotate([0, 0, 45])
            piece_rhombus();
            
            translate([long_side + square_hyp, long_side + square_hyp, 0])
            rotate([0, 0, 45])
            piece_rhombus();
            
            translate([long_side + square_hyp * 2, 0, 0])
            rotate([0, 0, 90])
            piece_rhombus();
            
            translate([long_side + half_square_hyp, rhombus_top, 0])
            rotate([0, 0, 90])
            piece_rhombus();
            
            translate([rhombus_height, rhombus_height, 0])
            rotate([0, 0, 180])
            piece_rhombus();
            
            translate([BASE_WIDTH, BASE_WIDTH - long_side, 0])
            rotate([0, 0, 180])
            piece_rhombus();
            
            translate([rhombus_height + half_square_hyp, rhombus_top - half_square_hyp, 0])
            rotate([0, 0, 135])
            piece_rhombus();
            
            translate([rhombus_height * 2 + half_square_hyp, rhombus_top - square_hyp, 0])
            rotate([0, 0, 135])
            piece_rhombus();
        }
    }

    module sample_pattern_one_triangles(colors = ["darkgreen"]) {
        color(getColor(colors, 0)) {
            translate([long_side + half_square_hyp, half_square_hyp, 0])
            rotate([0, 0, -135])
            piece_triangle();
            
            translate([long_side + half_square_hyp + square_hyp, half_square_hyp, 0])
            rotate([0, 0, -135])
            piece_triangle();
            
            translate([long_side + half_square_hyp, BASE_WIDTH - half_square_hyp, 0])
            rotate([0, 0, 45])
            piece_triangle();
            
            translate([long_side + half_square_hyp + square_hyp, BASE_WIDTH - half_square_hyp, 0])
            rotate([0, 0, 45])
            piece_triangle();
            
            translate([half_square_hyp, long_side + half_square_hyp, 0])
            rotate([0, 0, 135])
            piece_triangle();
            
            translate([half_square_hyp, long_side + half_square_hyp + square_hyp, 0])
            rotate([0, 0, 135])
            piece_triangle();
            
            translate([BASE_WIDTH - half_square_hyp, long_side + half_square_hyp, 0])
            rotate([0, 0, -45])
            piece_triangle();
            
            translate([BASE_WIDTH - half_square_hyp, long_side + half_square_hyp + square_hyp, 0])
            rotate([0, 0, -45])
            piece_triangle();
        }
     }
     
    module sample_pattern_one_squares(colors = ["yellow", "seagreen"]) {
        square_offset = long_side + square_hyp * 2;
        
        color(getColor(colors, 0)) {
            translate([square_offset, square_offset, 0])
            piece_square();
            
            piece_square();
            
            translate([half_square_hyp, half_base - half_square_hyp, 0])
            rotate([0, 0, 45])
            piece_square();
            
            translate([BASE_WIDTH - half_square_hyp, half_base - half_square_hyp, 0])
            rotate([0, 0, 45])
            piece_square();
        }
        
        color(getColor(colors, 1)) {
            translate([0, square_offset, 0])
            piece_square();
            
            translate([square_offset, 0, 0])
            piece_square();
            
            translate([half_base, 0, 0])
            rotate([0, 0, 45])
            piece_square();
            
            translate([half_base, BASE_WIDTH - square_hyp, 0])
            rotate([0, 0, 45])
            piece_square();
        }
     }

    sample_pattern_one_squares();
    sample_pattern_one_triangles();
    sample_pattern_one_rhombi();
}

module barnsquare(colors = ["brown"]) {
    color(getColor(colors, 0))
    base();
    
    translate([WALL_WIDTH + BASE_SLOP / 2, WALL_WIDTH + BASE_SLOP / 2, WALL_WIDTH])
    sample_pattern_one();
}

barnsquare();