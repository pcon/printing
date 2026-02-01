HOOK_WIDTH = 34;
HOOK_BASE_DEPTH = 40;
HOOK_TOP_DEPTH = 10;
HOOK_HEIGHT = 34;
WALL_WIDTH = 1.5;
SCREW_HEAD_DEPTH = 4;
SCREW_DIAMETER = 5;
SCREW_HEAD_DIAMETER = 9;
SKIM = .5;

baseHeight = WALL_WIDTH + SCREW_HEAD_DEPTH;
difference() {
    union() {
        cube([HOOK_WIDTH, HOOK_BASE_DEPTH, baseHeight]);

        translate([0, HOOK_BASE_DEPTH, 0])
        cube([HOOK_WIDTH, WALL_WIDTH, HOOK_HEIGHT + WALL_WIDTH + baseHeight]);

        translate([0, HOOK_BASE_DEPTH - HOOK_TOP_DEPTH, baseHeight + HOOK_HEIGHT])
        cube([HOOK_WIDTH, HOOK_TOP_DEPTH, WALL_WIDTH]);
    }

    union() {
        translate([HOOK_WIDTH / 2, HOOK_BASE_DEPTH / 2, -SKIM])
        cylinder(h = baseHeight + SKIM * 2, d = SCREW_DIAMETER, $fn=180);

        translate([HOOK_WIDTH / 2, HOOK_BASE_DEPTH / 2, WALL_WIDTH])
        cylinder(h = SCREW_HEAD_DEPTH + SKIM, d = SCREW_HEAD_DIAMETER, $fn=180);
    }
}