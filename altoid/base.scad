use <../lib/roundedcube.scad>

CORNER_RADIUS = 10;
WIDTH = 91;
DEPTH = 56;
HEIGHT = 21;

function boxCorner() = CORNER_RADIUS;
function boxWidth() = WIDTH;
function boxDepth() = DEPTH;
function boxHeight() = HEIGHT;

module base_insert() {
    roundedcube(
        [boxWidth(), boxDepth(), boxHeight()],
        radius = boxCorner(),
        apply_to = "z"
    );
}

base_insert();