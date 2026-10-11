include <../../lib/BOSL2/std.scad>
include <../../lib/statics.scad>

PACKOUT_MODULE_BASE_WIDTH = 92;
PACKOUT_MODULE_BASE_HEIGHT = 37;
PACKOUT_MODULE_INSET_DEPTH = 4;
PACKOUT_MODULE_LIP_DEPTH = 4;
PACKOUT_MODULE_LIP_HEIGHT = 8;
PACKOUT_MODULE_WALL = 2;
PACKOUT_MODULE_LIP_WALL = PACKOUT_MODULE_WALL + PACKOUT_MODULE_LIP_DEPTH;
PACKOUT_MODULE_WALLS = [
    PACKOUT_MODULE_LIP_WALL * 2,
    PACKOUT_MODULE_LIP_WALL * 2,
    PACKOUT_MODULE_WALL
];

PACKOUT_MODULE_BOTTOM_CHAMFER = 9;
PACKOUT_MODULE_CORNER_CHAMFER = 12;

function packout_size(units, lip = true) = units * (PACKOUT_MODULE_BASE_WIDTH + PACKOUT_MODULE_LIP_DEPTH * 2 * (lip ? 1 : 0)) + (PACKOUT_MODULE_LIP_DEPTH * 2 * (units - 1)) * (lip ? 0 : 1);
function packout_height(units, lip = true) = units * (PACKOUT_MODULE_BASE_HEIGHT + PACKOUT_MODULE_LIP_HEIGHT * (lip ? 1 : 0));
function packout_sizes(width, depth, height, lip = true) = [packout_size(width, lip), packout_size(depth, lip), packout_height(height, lip)];

module packout_bin_base(
    width = 1,
    depth = 1,
    height = 1,
    cutout = true,
    anchor,
    spin,
    orient
) {
    bin_size = packout_sizes(width, depth, height);
    bottom_size = packout_sizes(width, depth, height, lip = false);
    
    top_size = [
        packout_size(width),
        packout_size(depth),
        PACKOUT_MODULE_LIP_HEIGHT
    ];
    
    attachable(
        size = bin_size,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        down(PACKOUT_MODULE_LIP_HEIGHT / 2)
        cuboid(
            bottom_size,
            chamfer = PACKOUT_MODULE_BOTTOM_CHAMFER,
            except = TOP
        )
        attach(TOP, BOT)
        diff()
        cuboid(
            top_size,
            chamfer = PACKOUT_MODULE_LIP_DEPTH,
            except = TOP
        )
        edge_profile([FWD + LEFT, FWD + RIGHT, BACK + LEFT, BACK + RIGHT])
        mask2d_chamfer(PACKOUT_MODULE_CORNER_CHAMFER);
        
        children();
    }
}

module packout_bin(
    width = 1,
    depth = 1,
    height = 1,
    cutout = true,
    anchor,
    spin,
    orient
) {
    left_half()
    diff("packout_remove")
    packout_bin_base(
        width = width,
        depth = depth,
        height = height,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        cutout_size = packout_sizes(width, depth, height) - PACKOUT_MODULE_WALLS;
        echo(cutout_size=cutout_size);
        tag("packout_remove")
        attach(TOP, TOP, inside = true, shiftout = render_helper)
        cuboid(
            cutout_size,
            chamfer = PACKOUT_MODULE_BOTTOM_CHAMFER,
            except = TOP
        );
    }
}

packout_bin(anchor = BOT);