BASE_TILE_SIZE=20;
BASE_WIDTH=5;
PEAK_HEIGHT=3;

function y_up() = [90, 0, 0];
function x_up() = [90, 0, 90];

function min_floor_offset(wall_width) = wall_width + PEAK_HEIGHT;
function tri_mid() = BASE_WIDTH / 2;
function triangle() = [[0, 0],[BASE_WIDTH, 0],[tri_mid(), PEAK_HEIGHT]];
function base_tile_size() = BASE_TILE_SIZE;
function peak_height() = PEAK_HEIGHT;

function isX(direction) = (direction == "x");

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