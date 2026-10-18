include <../../lib/BOSL2/std.scad>
include <../../lib/statics.scad>

TRAY_CORNER_CHAMFER = 14;
TRAY_BOTTOM_CHAMFER_RUN = 14;
TRAY_BOTTOM_CHAMFER_RISE = 10;
TRAY_HEIGHT = 83;
TRAY_LENGTH = 332;
TRAY_WIDTH = 71;
TRAY_HANDLE_CHAMFER = 14;
TRAY_HANDLE_LENGTH = 133;

module handle_cutout(
    anchor,
    spin,
    orient
) {
    handle_size = [
        TRAY_HANDLE_LENGTH,
        TRAY_HANDLE_CHAMFER + render_helper,
        TRAY_HEIGHT
    ];
    
    part_size = [
        handle_size[0] + TRAY_BOTTOM_CHAMFER_RUN,
        handle_size[1],
        handle_size[2]
    ];
    
    attachable(
        size = part_size,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        diff("handle_remove")
        cuboid(
            handle_size,
            chamfer = TRAY_HANDLE_CHAMFER,
            edges = [BACK + LEFT, BACK + RIGHT]
        ) {
            up(TRAY_BOTTOM_CHAMFER_RISE)
            align(BACK + BOT)
            diff()
            cuboid(
                [
                    TRAY_HANDLE_LENGTH - TRAY_HANDLE_CHAMFER * 2,
                    TRAY_BOTTOM_CHAMFER_RUN,
                    TRAY_BOTTOM_CHAMFER_RISE
                ]
            )
            edge_profile([TOP + BACK])
            mask2d_chamfer(
                x = TRAY_BOTTOM_CHAMFER_RUN,
                y = TRAY_BOTTOM_CHAMFER_RISE
            );
            
            up(TRAY_BOTTOM_CHAMFER_RISE)
            right(17.55)
            back(17.6)
            align(LEFT + BOT)
            rot(45)
            diff()
            cuboid(
                [
                    40,
                    TRAY_BOTTOM_CHAMFER_RUN - 4,
                    TRAY_BOTTOM_CHAMFER_RISE
                ],
                chamfer = 10,
                edges = [FWD + RIGHT]
            )
            edge_profile([TOP + BACK])
            mask2d_chamfer(
                x = TRAY_BOTTOM_CHAMFER_RUN - 4,
                y = TRAY_BOTTOM_CHAMFER_RISE
            );
            
            up(TRAY_BOTTOM_CHAMFER_RISE)
            left(17.55)
            back(17.6)
            align(RIGHT + BOT)
            rot(-45)
            diff()
            cuboid(
                [
                    40,
                    TRAY_BOTTOM_CHAMFER_RUN - 4,
                    TRAY_BOTTOM_CHAMFER_RISE
                ],
                chamfer = 10,
                edges = [FWD + LEFT]
            )
            edge_profile([TOP + BACK])
            mask2d_chamfer(
                x = TRAY_BOTTOM_CHAMFER_RUN - 4,
                y = TRAY_BOTTOM_CHAMFER_RISE
            );
            
            tag("handle_remove")
            align(FRONT)
            cuboid(
                [200,20,100]
            );
        }
        children();
    }
}

module tray_base(
    anchor,
    spin,
    orient
) {
    base_size = [
        TRAY_WIDTH,
        TRAY_LENGTH,
        TRAY_HEIGHT
    ];
    
    attachable(
        size = base_size,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        diff("handle")
        cuboid(
            base_size,
            chamfer = TRAY_CORNER_CHAMFER,
            edges = "Z"
        );/*
        edge_profile([BOT])
        mask2d_chamfer(
            x = TRAY_BOTTOM_CHAMFER_RUN,
            y = TRAY_BOTTOM_CHAMFER_RISE
        );*/
        children();
    }
}

tray_base();