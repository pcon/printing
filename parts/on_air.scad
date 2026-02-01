use <../lib/parts.scad>
use <../lib/roundedcube.scad>

BOX_WIDTH = 150;
BOX_HEIGHT = 60;
BOX_DEPTH = 40;
WALL_WIDTH = 5;
FRONT_DEPTH = 2;

SKIM = .5;

module sign_case() {
    difference() {
        roundedcube([BOX_WIDTH, BOX_HEIGHT, BOX_DEPTH], false, 4, "z");
        translate([WALL_WIDTH, WALL_WIDTH, FRONT_DEPTH])
        roundedcube([
            BOX_WIDTH - WALL_WIDTH * 2,
            BOX_HEIGHT - WALL_WIDTH * 2,
            BOX_DEPTH - FRONT_DEPTH + SKIM
        ], false, 4, "z");
        
    }
}

module sign_lettering() {
    translate([BOX_WIDTH / 2, BOX_HEIGHT / 2, -SKIM])
    linear_extrude(FRONT_DEPTH + SKIM * 2)
    mirror([1, 0, 0])
    text(
        text = "ON AIR",
        font = "Gunplay:style=Regular",
        size = 26,
        valign = "center",
        halign = "center"
    );
}

module sign_front() {
    difference() {
        sign_case();
        sign_lettering();
    }
}

part("sign.stl", c = "red") {
    sign_front();
}