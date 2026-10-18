include <BOSL2/std.scad>
include <statics.scad>

BASE_TILE_SIZE=20;
BASE_WIDTH=5;
PEAK_HEIGHT=3;

WALL_HANGER_REAR_WALL_MIN = 3;
WALL_HANGER_SCREW_HEAD_DIAMTER = 9;
WALL_HANGER_SCREW_HEAD_HEIGHT = 4;
WALL_HANGER_SCREW_DIAMETER = 5;

function y_up() = [90, 0, 0];
function x_up() = [90, 0, 90];

function min_floor_offset(wall_width) = wall_width + PEAK_HEIGHT;
function tri_mid() = BASE_WIDTH / 2;
function triangle() = [[0, 0],[BASE_WIDTH, 0],[tri_mid(), PEAK_HEIGHT]];
function base_tile_size() = BASE_TILE_SIZE;
function peak_height() = PEAK_HEIGHT;
function default_wall_hanger_depth() = WALL_HANGER_REAR_WALL_MIN + WALL_HANGER_SCREW_HEAD_HEIGHT;

function isX(direction) = (direction == "x");
function v_max(v1, v2, index = 0, vm = []) = (v1 == undef) ? v2 : (v2 == undef) ? v1 : (len(v1) <= index) ? vm : v_max(v1, v2, index + 1, concat(vm, max(v1[index], v2[index])));

module grid(width, depth, direction) {
    length = isX(direction) ? width : depth;
    slot_length = isX(direction) ? depth : width;
    translate_z = isX(direction) ? -slot_length : 0;
    rot = isX(direction) ? y_up() : x_up();

    // This is the total additional slots past the initial one
    total_slots = floor(length / BASE_TILE_SIZE);

    for (i = [0 : total_slots]) {
        offset = -tri_mid() + BASE_TILE_SIZE * i;
        rotate(rot)
        translate([offset, 0, translate_z])
        linear_extrude(height = slot_length)
        polygon(points=triangle());
    }
}

module grid_slots(width, depth) {
    grid(width, depth, "y");
    grid(width, depth, "x");
}

module base_block(width, depth, height, include_grid = true) {
    difference() {
        cube([width, depth, height]);

        if (include_grid) {
            grid_slots(width, depth);
        }
    }
}

module wall_hanger_screwhole(
    head_diameter = WALL_HANGER_SCREW_HEAD_DIAMTER,
    head_height = WALL_HANGER_SCREW_HEAD_HEIGHT,
    body_diameter = WALL_HANGER_SCREW_DIAMETER,
    depth = WALL_HANGER_REAR_WALL_MIN + WALL_HANGER_SCREW_HEAD_HEIGHT,
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    body_height = depth - head_height;
    up(head_height / 2)
    cyl(
        d = body_diameter,
        h = body_height + render_helper,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        up(render_helper)
        attach(BOT, TOP)
        cyl(
            d = head_diameter,
            h = head_height + render_helper * 2
        );
    }
}

module wall_hanger_screwholes(
    count = 2,
    spacing = 20,
    head_diameter = WALL_HANGER_SCREW_HEAD_DIAMTER,
    head_height = WALL_HANGER_SCREW_HEAD_HEIGHT,
    body_diameter = WALL_HANGER_SCREW_DIAMETER,
    depth = WALL_HANGER_REAR_WALL_MIN + WALL_HANGER_SCREW_HEAD_HEIGHT,
    anchor = CENTER,
    spin = 0,
    orient = UP
) {
    attachable(
        anchor,
        spin,
        orient,
        size = [
            spacing + head_diameter,
            head_diameter,
            depth
        ]
    ) {
        xcopies(
            n = count,
            spacing = spacing
        )
        wall_hanger_screwhole(
            head_diameter = head_diameter,
            head_height = head_height,
            body_diameter = body_diameter,
            depth = depth
        );
        children();
    }
}