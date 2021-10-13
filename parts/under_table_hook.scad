function in_to_mm(in) = in * 25.4;

HOOK_BODY_LENGTH = in_to_mm(6.5);
HOOK_THROAT_LENGTH = in_to_mm(1);
HOOK_CATCH_LENGTH = in_to_mm(3.5);
HOOK_MOUNT_LENGTH = in_to_mm(3);
HOOK_DEPTH = 25;

WALL_WIDTH = 3;

SCREW_DIAMETER = 3;

screw_count = 3;

module hook() {
    hook_points = [
        [0, 0],
        [0, HOOK_BODY_LENGTH],
        [HOOK_THROAT_LENGTH + WALL_WIDTH * 2, HOOK_BODY_LENGTH],
        [HOOK_THROAT_LENGTH + WALL_WIDTH * 2, HOOK_BODY_LENGTH - HOOK_CATCH_LENGTH],
        [HOOK_THROAT_LENGTH + WALL_WIDTH, HOOK_BODY_LENGTH - HOOK_CATCH_LENGTH],
        [HOOK_THROAT_LENGTH + WALL_WIDTH, HOOK_BODY_LENGTH - WALL_WIDTH],
        [WALL_WIDTH, HOOK_BODY_LENGTH - WALL_WIDTH],
        [WALL_WIDTH, -WALL_WIDTH],
        [-HOOK_MOUNT_LENGTH, -WALL_WIDTH],
        [-HOOK_MOUNT_LENGTH, 0]
    ];

    linear_extrude(HOOK_DEPTH)
    polygon(hook_points);
}

module mount_holes() {
    screw_offset = HOOK_MOUNT_LENGTH / (screw_count + 1);
    for (i = [1: screw_count]) {
        echo(i=i);
        translate([-screw_offset * i, 0, HOOK_DEPTH / 2])
        rotate([90, 0, 0])
        linear_extrude(WALL_WIDTH)
        circle(d=SCREW_DIAMETER);
    }
}

difference() {
    hook();
    mount_holes();
}