use <base.scad>

D4_SIDE = 24;
D4_HEIGHT = 18;
D6_SIDE = 15.5;
D8_SIDE = 11.5;
D8_HEIGHT = 18;
D10_SHORT_SIDE = 8;
D10_LONG_SIDE = 14;
D10_HEIGHT = 18;
D12_SIDE = 7.25;
D12_HEIGHT = 19;
D20_SIDE = 12;
D20_HEIGHT = 19.75;

RENDER_HELPER = 1;

WALL_OFFSET = 2;

d4_depth = D4_SIDE * sqrt(3) / 2;

d8_width = D8_SIDE * sqrt(3);
d8_depth = D8_SIDE * 2;

d10_width = D10_LONG_SIDE * sin(30) * 2;
d10_depth = D10_SHORT_SIDE * sin(30) * 2 + D10_SHORT_SIDE;
d10_slot_width = D10_SHORT_SIDE * cos(30) + D10_LONG_SIDE * cos(30);
d10_slot_depth = D10_SHORT_SIDE * sin(30) * 2 + D10_LONG_SIDE;

d12_depth = (D12_SIDE / (2 * sin(18))) * 2;
d12_width = d12_depth * cos(18);

d20_width = D20_SIDE * sqrt(3);
d20_depth = D20_SIDE * 2;

function sum(v) = [for (p = v) 1] * v;
function partial(list, start, end) = [for (i = [start:end]) list[i]];

top_row_sides = [
    WALL_OFFSET,
    D4_SIDE,
    D6_SIDE,
    d8_width,
    d10_slot_width,
    WALL_OFFSET
];

top_row_depths = [
    d4_depth,
    D6_SIDE,
    d8_depth,
    d10_slot_depth
];

bottom_row_sides = [
    WALL_OFFSET,
    d10_slot_width,
    d12_width,
    d20_width,
    WALL_OFFSET
];

bottom_row_depths = [
    d10_slot_depth,
    d12_depth,
    d20_depth
];

top_row_width = sum(top_row_sides) - WALL_OFFSET * 2;
top_row_offset = (boxWidth() - top_row_width) / (len(top_row_sides) - 1);

bottom_row_width = sum(bottom_row_sides) - WALL_OFFSET * 2;
bottom_row_offset = (boxWidth() - bottom_row_width) / (len(bottom_row_sides) - 1);

function z_offset(h) = boxHeight() - h;
function row_one_y(d) = boxDepth() - WALL_OFFSET - d - (max(top_row_depths) - d) / 2;
function row_one_x(i) = sum(partial(top_row_sides, 0, i - 1)) + top_row_offset * (i - 1);
function row_two_y(d) = WALL_OFFSET + (max(bottom_row_depths) - d) / 2;
function row_two_x(i) = sum(partial(bottom_row_sides, 0, i - 1)) + bottom_row_offset * i;

module d4() {    
    offset_x = row_one_x(1);
    offset_y = row_one_y(d4_depth);
    offset_z = z_offset(D4_HEIGHT);
    
    translate([offset_x, offset_y, offset_z])
    linear_extrude(D4_HEIGHT + RENDER_HELPER)
    polygon([
        [0, 0],
        [D4_SIDE, 0],
        [D4_SIDE / 2, d4_depth]
    ]);
}

module d6() {
    offset_x = row_one_x(2);
    offset_y = row_one_y(D6_SIDE);
    offset_z = z_offset(D6_SIDE);
    
    translate([offset_x, offset_y, offset_z])
    cube([D6_SIDE, D6_SIDE, D6_SIDE + RENDER_HELPER]);
}

module d8() {
    offset_x = row_one_x(3);
    offset_y = row_one_y(D8_SIDE * 2);
    offset_z = z_offset(D8_HEIGHT);
    
    translate([offset_x, offset_y, offset_z])
    translate([d8_width / 2, D8_SIDE, 0])
    rotate([0, 0, 90])
    cylinder(r = D8_SIDE, h = D8_HEIGHT + RENDER_HELPER, $fn = 6);
}

module d10_base() {
    // tri_a == height of short triangle
    // tri_b == base of short triangle
    tri_a = D10_SHORT_SIDE * sin(30);
    tri_b = D10_SHORT_SIDE * cos(30);
    half_side = D10_SHORT_SIDE / 2;
    half_long_side = D10_LONG_SIDE / 2;

    linear_extrude(D10_HEIGHT + RENDER_HELPER)
    polygon([
        [0, D10_LONG_SIDE + tri_a],
        [tri_b, D10_LONG_SIDE + tri_a + tri_a],
        [d10_slot_width, D10_LONG_SIDE + tri_a],
        [d10_slot_width, tri_a],
        [d10_slot_width - tri_b, 0],
        [0, tri_a]
    ]);
}

module d10() {
    offset_x = row_one_x(4);
    offset_y = row_one_y(d10_slot_depth);
    offset_z = z_offset(D10_HEIGHT);
    
    translate([offset_x, offset_y, offset_z])
    d10_base();
}

module top_row() {
    union() {
        d4();
        d6();
        d8();
        d10();
    }
}

module d100() {
    offset_x = row_two_x(1);
    offset_y = row_two_y(d10_slot_depth);
    offset_z = z_offset(D10_HEIGHT);
    
    translate([offset_x, offset_y, offset_z])
    d10_base();
}

module d12() {
    offset_x = row_two_x(2);
    offset_y = row_two_y(d12_depth);
    offset_z = z_offset(D12_HEIGHT);
    
    translate([offset_x, offset_y, offset_z])
    translate([d12_width / 2, d12_depth / 2, 0])
    rotate([0, 0, 18])
    cylinder(r = d12_depth / 2, h = D12_HEIGHT + RENDER_HELPER, $fn = 10);
}

module d20() {
    offset_x = row_two_x(3);
    offset_y = row_two_y(d20_depth);
    offset_z = z_offset(D20_HEIGHT);
    
    translate([offset_x, offset_y, offset_z])
    translate([d20_width / 2, D20_SIDE, 0])
    rotate([0, 0, 90])
    cylinder(r = D20_SIDE, h = D20_HEIGHT + RENDER_HELPER, $fn = 6);
}

module bottom_row() {
    union() {
        d100();
        d12();
        d20();
    }
}

module insert() {
    difference() {
        base_insert();
        top_row();
        bottom_row();
    }
}

insert();