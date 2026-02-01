// https://gist.githubusercontent.com/groovenectar/92174cb1c98c1089347e/raw/c3024ba34f58831a2cf02952212d1ae236238de2/roundedcube.scad
include <../lib/roundedcube.scad>

WALL_WIDTH = 2;
BOX_RADIUS = 1;
SKIM = .5;
FINGER_PULL_OFFSET = 7;
LIP_OFFSET = 3;

TILE_HEIGHT = 38;
TILE_WIDTH = 41;
TILE_DEPTH = 3.75;

TILE_COUNT = 20;

DIVIDER_DEPTH = 1;
DIVIDER_HEIGHT_OFFSET = 3;

LID_HEIGHT = FINGER_PULL_OFFSET + LIP_OFFSET + WALL_WIDTH;

LOWER_BOX_HEIGHT = WALL_WIDTH + TILE_HEIGHT - FINGER_PULL_OFFSET - DIVIDER_HEIGHT_OFFSET;
LOWER_BOX_WIDTH = TILE_WIDTH + WALL_WIDTH * 2;
LOWER_BOX_DEPTH = (TILE_DEPTH + DIVIDER_DEPTH) * TILE_COUNT - DIVIDER_DEPTH + WALL_WIDTH * 2;

DIVIDER_HEIGHT = LOWER_BOX_HEIGHT - WALL_WIDTH - DIVIDER_HEIGHT_OFFSET;
DIVIDER_WIDTH = 3;

module lid_text_emboss() {
    translate([0, 0, LID_HEIGHT - WALL_WIDTH / 2])
    linear_extrude(WALL_WIDTH / 2)
    union() {
        translate([0, 3, 0])
        text("INFILL", size = 5, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
        translate([0, -3, 0])
        text("SWATCHES", size = 5, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
    }
}

module lid_body() {
    difference() {
        translate([0, 0, LID_HEIGHT / 2])
        roundedcube(
            [
                LOWER_BOX_WIDTH,
                LOWER_BOX_DEPTH,
                LID_HEIGHT
            ],
            true, BOX_RADIUS, "zmax"
        );
        
        inside_height = LID_HEIGHT - WALL_WIDTH + SKIM;
        translate([0, 0, inside_height / 2 - SKIM])
        roundedcube(
            [
                LOWER_BOX_WIDTH - WALL_WIDTH * 2,
                LOWER_BOX_DEPTH - WALL_WIDTH * 2,
                inside_height
            ],
            true, BOX_RADIUS, "z"
        );
        
        lip_height = LIP_OFFSET + SKIM;
        translate([0, 0, lip_height / 2 - SKIM])
        roundedcube(
            [
                LOWER_BOX_WIDTH - WALL_WIDTH,
                LOWER_BOX_DEPTH - WALL_WIDTH,
                lip_height
            ],
            true, BOX_RADIUS, "z"
        );
    }
}

module lid() {
    difference() {
        lid_body();
        lid_text_emboss();
    }
}

module divider_wall() {
    cube([DIVIDER_WIDTH, DIVIDER_DEPTH, LOWER_BOX_HEIGHT + LIP_OFFSET - DIVIDER_HEIGHT_OFFSET]);
}

module divider_row() {
    translate([0, -((LOWER_BOX_DEPTH - WALL_WIDTH) / 2) + TILE_DEPTH + DIVIDER_DEPTH, 0])
    union() {
        for (i = [0 : TILE_COUNT - 2]) {
            translate([0, (DIVIDER_DEPTH + TILE_DEPTH) * i, 0])
            divider_wall();
        }
    }
}

module dividers() {
    union() {
        translate([LOWER_BOX_WIDTH / 2 - WALL_WIDTH - DIVIDER_WIDTH, 0, 0])
        divider_row();
        
        translate([-LOWER_BOX_WIDTH / 2 + WALL_WIDTH, 0, 0])
        divider_row();
    }
}

module lower_box_body() {
    difference() {
        union() {
            translate([0, 0, LOWER_BOX_HEIGHT / 2])
            roundedcube(
                [
                    LOWER_BOX_WIDTH,
                    LOWER_BOX_DEPTH,
                    LOWER_BOX_HEIGHT
                ],
                true, BOX_RADIUS, "z"
            );

            translate([0, 0, (LOWER_BOX_HEIGHT + LIP_OFFSET) / 2])
            roundedcube(
                [
                    LOWER_BOX_WIDTH - WALL_WIDTH,
                    LOWER_BOX_DEPTH - WALL_WIDTH,
                    LOWER_BOX_HEIGHT + LIP_OFFSET
                ],
                true, BOX_RADIUS, "z"
            );
        }
 
        translate([0, 0, (LOWER_BOX_HEIGHT + LIP_OFFSET) / 2 + WALL_WIDTH])
        roundedcube(
            [
                LOWER_BOX_WIDTH - WALL_WIDTH * 2,
                LOWER_BOX_DEPTH - WALL_WIDTH * 2,
                LOWER_BOX_HEIGHT - WALL_WIDTH + LIP_OFFSET + SKIM
            ],
            true, BOX_RADIUS, "z"
        );
    }
}

module lower_box() {
    union() {
        lower_box_body();
        dividers();
    }
}

//lower_box();

color("blue")
//translate([0, 0, LOWER_BOX_HEIGHT])
lid();