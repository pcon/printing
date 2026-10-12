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

PACKOUT_MODULE_BOTTOM_CHAMFER_RISE = 9;
PACKOUT_MODULE_BOTTOM_CHAMFER_RUN = 6;
PACKOUT_MODULE_CORNER_CHAMFER = 12;
PACKOUT_MODULE_CORNER_CHAMFER_INSIDE = (PACKOUT_MODULE_CORNER_CHAMFER - PACKOUT_MODULE_LIP_WALL * tan(22.5)) / 2;

function packout_size(units, lip = true) = units * (PACKOUT_MODULE_BASE_WIDTH + PACKOUT_MODULE_LIP_DEPTH * 2 * (lip ? 1 : 0)) + (PACKOUT_MODULE_LIP_DEPTH * 2 * (units - 1)) * (lip ? 0 : 1);
function packout_height(units, lip = true) = units * (PACKOUT_MODULE_BASE_HEIGHT + PACKOUT_MODULE_LIP_HEIGHT * (lip ? 1 : 0));
function packout_sizes(width, depth, height, lip = true) = [packout_size(width, lip), packout_size(depth, lip), packout_height(height, lip)];

module packout_bin_bottom(
    width = 1,
    depth = 1,
    anchor,
    spin,
    orient
) {
    bin_size = packout_sizes(width, depth, 0, lip = false);
    base_size = [
        bin_size[0],
        bin_size[1],
        PACKOUT_MODULE_BOTTOM_CHAMFER_RISE
    ];

    attachable(
        size = base_size,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        diff()
        cuboid(
            base_size,
            chamfer = PACKOUT_MODULE_CORNER_CHAMFER,
            edges = "Z"
        )
        edge_profile([BOT])
        mask2d_chamfer(
            x = PACKOUT_MODULE_BOTTOM_CHAMFER_RUN,
            y = PACKOUT_MODULE_BOTTOM_CHAMFER_RISE
        );
        children();
    }
}

module packout_bin_mid(
    width = 1,
    depth = 1,
    height = 1,
    anchor,
    spin,
    orient
) {
    mid_size = packout_sizes(width, depth, height, lip = false) -
        [0, 0, PACKOUT_MODULE_BOTTOM_CHAMFER_RISE];

    attachable(
        size = mid_size,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        cuboid(
            mid_size,
            chamfer = PACKOUT_MODULE_CORNER_CHAMFER,
            edges = "Z"
        );
        children();
    }
}

module packout_bin_top(
    width = 1,
    depth = 1,
    anchor,
    spin,
    orient
) {
    top_size = [
        packout_size(width),
        packout_size(depth),
        PACKOUT_MODULE_LIP_HEIGHT
    ];

    attachable(
        size = top_size,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
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

    attachable(
        size = bin_size,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        down(bin_size[2] / 2 - PACKOUT_MODULE_LIP_HEIGHT / 2)
        packout_bin_bottom(width = width, depth= depth)
        attach(TOP, BOT)
        packout_bin_mid(width = width, depth= depth, height = height) {
            align(
                [
                    LEFT,
                    RIGHT
                ],
                [
                    TOP + FWD,
                    TOP + BACK
                ],
                inside = true
            )
            cuboid(
                [
                    PACKOUT_MODULE_CORNER_CHAMFER,
                    PACKOUT_MODULE_CORNER_CHAMFER,
                    PACKOUT_MODULE_CORNER_CHAMFER / 2
                ],
                chamfer = PACKOUT_MODULE_CORNER_CHAMFER / 2,
                edges = BOT
            );
            attach(TOP, BOT)
            packout_bin_top(width = width, depth= depth);
        }
        children();
    }
}

module packout_cutout(
    width = 1,
    depth = 1,
    height = 1,
    anchor,
    spin,
    orient
) {
    cutout_size = packout_sizes(width, depth, height) - PACKOUT_MODULE_WALLS;

    diff("edge")
    cuboid(
        cutout_size,
        chamfer = PACKOUT_MODULE_CORNER_CHAMFER_INSIDE * 2,
        edges = "Z"
    )
    tag("edge")
    edge_profile([BOT])
    mask2d_chamfer(
        x = PACKOUT_MODULE_BOTTOM_CHAMFER_RUN,
        y = PACKOUT_MODULE_BOTTOM_CHAMFER_RISE
    );
}

module packout_cutout_top(
    width = 1,
    depth = 1,
    anchor,
    spin,
    orient
) {
    cutout_size = [
        packout_size(width) - PACKOUT_MODULE_WALLS[0],
        packout_size(depth) - PACKOUT_MODULE_WALLS[1],
        PACKOUT_MODULE_INSET_DEPTH
    ];

    cuboid(
        cutout_size,
        chamfer = PACKOUT_MODULE_CORNER_CHAMFER_INSIDE,
        edges = "Z"
    );
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
    diff("packout_remove")
    packout_bin_base(
        width = width,
        depth = depth,
        height = height,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        tag("packout_remove")
        attach(TOP, TOP, inside = true, shiftout = render_helper)
        packout_cutout_top(width = width, depth = depth);

        if (cutout) {
            tag("packout_remove")
            attach(TOP, TOP, inside = true, shiftout = render_helper)
            packout_cutout(width = width, depth= depth, height = height);
        }
    }
}