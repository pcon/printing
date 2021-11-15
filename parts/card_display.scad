BOX_INNER_WIDTH = 157;
BOX_WALL_HEIGHT = 15;
BOX_WALL_WIDTH = 2;
BOX_FLOOR_WIDTH = 3;
BOX_RIM_WIDTH = 30;

box_width = BOX_INNER_WIDTH + BOX_WALL_WIDTH * 2;
box_height = BOX_WALL_HEIGHT + BOX_FLOOR_WIDTH;

hole_width = BOX_INNER_WIDTH - BOX_RIM_WIDTH;
inner_offset = (box_width - hole_width) / 2;

emboss_depth = BOX_WALL_WIDTH / 2;
emboss_height = 18;
emboss_half_height = emboss_height / 2;
emboss_offset = 10;

font = "Liberation Sans";

module letter(l) {
	// Use linear_extrude() to make the letters 3D objects as they
	// are only 2D shapes when only using text()
	linear_extrude(height = emboss_depth) {
		text(
            l,
            size = emboss_height,
            font = font,
            halign = "left",
            valign = "baseline",
            spacing = 1.5,
            $fn = 16
        );
	}
}

module suits() {
    translate([0, emboss_depth, 1.25])
    rotate([90, 0, 0])
    letter("\u2665\u2660\u2666\u2663\u2665\u2660\u2666\u2663\u2665\u2660\u2666\u2663");
}

module design_emboss() {
    // Front
    suits();
    
    // Left Side
    translate([0, box_width + 83.5, 0])
    rotate([0, 0, -90])
    suits();
    
    // Right side
    translate([box_width, .5, 0])
    rotate([0, 0, 90])
    suits();
    
    // Back
    translate([box_width + 83.5, box_width, 0])
    rotate([0, 0, 180])
    suits();
}

module card_holder() {
    difference() {
        cube([box_width, box_width, box_height]);
        
        design_emboss();
        
        translate([BOX_WALL_WIDTH, BOX_WALL_WIDTH, BOX_FLOOR_WIDTH])
        cube([BOX_INNER_WIDTH, BOX_INNER_WIDTH, BOX_WALL_HEIGHT]);
        
        translate([inner_offset, inner_offset, 0])
        cube([hole_width, hole_width, BOX_FLOOR_WIDTH]);
    }
}

card_holder();