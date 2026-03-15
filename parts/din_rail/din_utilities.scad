DIN_LENGTH = 36;
DIN_INNER_LENGTH = 24.5;
DIN_WIDTH = 8;
DIN_NUBBIN_WIDTH = 2.5;
DIN_NUBBIN_LENGTH = 3;
DIN_RAIL_WIDTH = 2;

function din_length() = DIN_LENGTH;
function din_width() = DIN_WIDTH;

din_wing_length = (DIN_LENGTH - DIN_INNER_LENGTH) / 2;
din_inner_width = DIN_WIDTH - DIN_RAIL_WIDTH;
din_path = [
    [0, 0],
    [0, DIN_RAIL_WIDTH],
    [din_wing_length - DIN_RAIL_WIDTH, DIN_RAIL_WIDTH],
    [din_wing_length - DIN_RAIL_WIDTH, DIN_WIDTH - DIN_NUBBIN_WIDTH],
    [din_wing_length - DIN_RAIL_WIDTH - DIN_NUBBIN_LENGTH, DIN_WIDTH - DIN_NUBBIN_WIDTH],
    [din_wing_length - DIN_RAIL_WIDTH - DIN_NUBBIN_LENGTH, DIN_WIDTH],
    [DIN_LENGTH - din_wing_length + DIN_RAIL_WIDTH + DIN_NUBBIN_LENGTH, DIN_WIDTH],
    [DIN_LENGTH - din_wing_length + DIN_RAIL_WIDTH + DIN_NUBBIN_LENGTH, DIN_WIDTH - DIN_NUBBIN_WIDTH],
    [DIN_LENGTH - din_wing_length + DIN_RAIL_WIDTH, DIN_WIDTH - DIN_NUBBIN_WIDTH],
    [DIN_LENGTH - din_wing_length + DIN_RAIL_WIDTH, DIN_RAIL_WIDTH],
    [DIN_LENGTH, DIN_RAIL_WIDTH],
    [DIN_LENGTH, 0],
    [DIN_LENGTH - din_wing_length, 0],
    [DIN_LENGTH - din_wing_length, din_inner_width],
    [din_wing_length, din_inner_width],
    [din_wing_length, 0]
];

function din_path() = din_path;

module din_modified_slot() {
    polygon(din_path());
}
/*
difference() {
    cube([40, 12 ,4]);
    
    translate([2, 2, -.01])
    linear_extrude(4 + .02)
    din_modified_slot();
}*/
din_modified_slot();