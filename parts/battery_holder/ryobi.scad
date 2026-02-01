BATTERY_DEPTH = 80; // This includes the slide but not the button
BATTERY_HEIGHT = 180; // This should be the same for all batteries but could be reduced to reduce printing amount
BATTERY_WIDTH = 101; // This should be the same for all batteries
WALL_WIDTH = 5;

charger_slot_depth = 6;
charger_slot_outer_width = 58.5;
charger_slot_inner_width = 54;
charger_slot_height = 79;
charger_slot_total_depth = 13;

slide_depth = 18;
slide_width = 75;

total_case_width = BATTERY_WIDTH + WALL_WIDTH * 2;
total_case_depth = BATTERY_DEPTH - slide_depth + WALL_WIDTH * 2;

module outer_case() {
    height = BATTERY_HEIGHT + WALL_WIDTH;
    
    cube([total_case_width, total_case_depth, height]);
}

module battery_hole() {
    cube([BATTERY_WIDTH, BATTERY_DEPTH - slide_depth, BATTERY_HEIGHT]);
}

module slide_hole() {
    translate([(BATTERY_WIDTH - slide_width) / 2, BATTERY_DEPTH - slide_depth, 0])
    cube([slide_width, slide_depth, BATTERY_HEIGHT]);
}

module battery_cutout() {
    translate([WALL_WIDTH, WALL_WIDTH, WALL_WIDTH])
    union() {
        battery_hole();
        slide_hole();
    }
}

module charger_holder() {
    rotate([0, 0, -90])
    translate([-total_case_depth, total_case_width, 0])
    union() {
        translate([(charger_slot_outer_width - charger_slot_inner_width) / 2, 0, 0])
        cube([charger_slot_inner_width, charger_slot_total_depth, charger_slot_height]);
        
        translate([0, charger_slot_total_depth - charger_slot_depth, 0])
        cube([charger_slot_outer_width, charger_slot_depth, charger_slot_height]);
    }
}

union() {
    difference() {
        outer_case();
        battery_cutout();
    }
    charger_holder();
}