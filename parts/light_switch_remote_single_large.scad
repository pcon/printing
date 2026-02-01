use <../lib/roundedcube.scad>

WALL_WIDTH = 1.5;

REMOTE_DEPTH = 19.5;
REMOTE_WIDTH = 45.5;
REMOTE_HEIGHT = 150.5;
REMOTE_LIP = 2;
REMOTE_X_OFFSET = -3.75;

SWITCH_WIDTH = 11;
SWITCH_HEIGHT = 30;
SWITCH_DEPTH = 18;
SWITCH_OFFSET = 45;
SWITCH_OFFSET_X = SWITCH_OFFSET / 2;

HOLE_OFFSET_X = 45;
HOLE_OFFSET_Y = 60;
HOLE_DIAMETER = 4;
HOLE_HEAD_DIAMETER = 7;
HOLE_BASE_DEPTH = 1;
HOLE_HEAD_DEPTH = 4;

PLATE_HEIGHT_MAX = 120;

PLATE_RADIUS = 2;
PLATE_WIDTH = 70;
PLATE_HEIGHT = min(PLATE_HEIGHT_MAX, REMOTE_HEIGHT + WALL_WIDTH + PLATE_RADIUS * 2);
PLATE_DEPTH = HOLE_BASE_DEPTH + HOLE_HEAD_DEPTH;

SKIM = 1;

module remote_cutout() {
    translate([0, WALL_WIDTH, PLATE_DEPTH + (REMOTE_DEPTH / 2)])
    roundedcube(
        [
            REMOTE_WIDTH,
            REMOTE_HEIGHT + SKIM,
            REMOTE_DEPTH
        ],
        true, PLATE_RADIUS, "zmax"
    );
        
}

module switch_cutout_right() {
    translate([SWITCH_OFFSET_X - WALL_WIDTH + 1.5, 0, (SWITCH_DEPTH / 2)])
    roundedcube(
        [
            SWITCH_WIDTH,
            SWITCH_HEIGHT,
            SWITCH_DEPTH
        ],
        true, PLATE_RADIUS, "zmax"
    );
}

module remote_base() {
    translate([0, 0, (REMOTE_DEPTH + WALL_WIDTH + PLATE_DEPTH) / 2])
    roundedcube(
        [
            REMOTE_WIDTH + WALL_WIDTH * 2,
            REMOTE_HEIGHT + WALL_WIDTH,
            REMOTE_DEPTH + WALL_WIDTH + PLATE_DEPTH
        ],
        true, PLATE_RADIUS, "zmax"
    );
}

module remote_top_cutout() {
    translate([0, WALL_WIDTH, PLATE_DEPTH + (REMOTE_DEPTH + WALL_WIDTH + SKIM) / 2])
    roundedcube(
        [
            REMOTE_WIDTH - REMOTE_LIP * 2,
            REMOTE_HEIGHT - REMOTE_LIP + WALL_WIDTH,
            REMOTE_DEPTH + WALL_WIDTH + SKIM
        ],
        true, PLATE_RADIUS, "z"
    );
}

module remote_holder() {
    translate([REMOTE_X_OFFSET, 0, 0])
    difference() {
        remote_base();
        remote_cutout();
        switch_cutout_right();
        remote_top_cutout();
    }
}

module switch_cover() {
    translate([SWITCH_OFFSET_X, 0, (SWITCH_DEPTH / 2) + WALL_WIDTH])
    roundedcube(
        [
            SWITCH_WIDTH + WALL_WIDTH + 3,
            SWITCH_HEIGHT + WALL_WIDTH * 2,
            SWITCH_DEPTH + WALL_WIDTH
        ],
        true, PLATE_RADIUS, "zmax"
    );
}

module switch_covers() {
    difference() {
        union() {
            difference() {
                switch_cover();
                switch_cutout_right();
            }
        }
        
        translate([REMOTE_X_OFFSET, 0, 0])
        remote_cutout();
    }
}

module screw_hole() {
    union() {
        translate([0, 0, -SKIM])
        cylinder(PLATE_DEPTH + SKIM, HOLE_DIAMETER / 2, HOLE_DIAMETER / 2);
        
        translate([0, 0, HOLE_BASE_DEPTH])
        cylinder(PLATE_DEPTH + SKIM, HOLE_HEAD_DIAMETER / 2, HOLE_HEAD_DIAMETER / 2);
    }
}

module screw_holes() {
    offset_x = HOLE_OFFSET_X / 2;
    offset_y = HOLE_OFFSET_Y / 2;
    
    union() {
        translate([offset_x, offset_y, 0])
        screw_hole();
        
        translate([-offset_x, offset_y, 0])
        screw_hole();
        
        translate([-offset_x, -offset_y, 0])
        screw_hole();
        
        translate([offset_x, -offset_y, 0])
        screw_hole();
    }  
}

module switch_hole() {
    translate([-(SWITCH_WIDTH / 2), -(SWITCH_HEIGHT / 2), -SKIM])
    cube([SWITCH_WIDTH, SWITCH_HEIGHT, PLATE_DEPTH + SKIM * 2]);
}

module switch_holes() {
    offset_x = SWITCH_OFFSET / 2;
    
    union() {
        translate([offset_x, 0, 0])
        switch_hole();
    }
}

module plate_base() {
    translate([0, 0, PLATE_DEPTH / 2])
    roundedcube(
        [PLATE_WIDTH, PLATE_HEIGHT, PLATE_DEPTH],
        true, PLATE_RADIUS, "zmax"
    );
}

module plate() {
    difference() {
        union() {
            plate_base();
            switch_covers();
            remote_holder();
        }
        screw_holes();
        switch_holes();
    }
}

plate();