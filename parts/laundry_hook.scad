include <../lib/statics.scad>
include <../lib/BOSL2/std.scad>
include <../lib/BOSL2/walls.scad>
include <../lib/BOSL2/joiners.scad>
include <../lib/BOSL2/screws.scad>

WALL_MOUNT_WIDTH = 5;

HOOK_DIAMETER = 10;
HOOK_WIDTH = 8;
HOOK_HEIGHT = 15;
HOOK_BOTTOM_OFFSET = 10;
HOOK_WALL_OFFSET = 94 - WALL_MOUNT_WIDTH;

SCREW_SPEC = "#6-8,1";
SCREW_HEAD = "button";
SCREW_DIAMETER = 4.5;
SCREW_HEAD_DIAMETER = 8.5;
DOVETAIL_PADDING = 6;

MOUNT_WALL_PADDING = 5;
MOUNT_WIDTH = 12;

dovetail_base_width = SCREW_DIAMETER + DOVETAIL_PADDING * 2;
dovetail_width = SCREW_HEAD_DIAMETER + DOVETAIL_PADDING * 2;
dovetail_height = 15;//MOUNT_WIDTH - MOUNT_WALL_PADDING;
dovetail_block_width = dovetail_height + MOUNT_WALL_PADDING;

echo(MOUNT_WIDTH=MOUNT_WIDTH);
echo(dovetail_height=dovetail_height);

OBJ_DEPTH = dovetail_width + MOUNT_WALL_PADDING;

hook_radius = HOOK_DIAMETER / 2;

total_width = HOOK_WIDTH + HOOK_WALL_OFFSET;
hook_total_width = HOOK_WIDTH * 2 + HOOK_DIAMETER;
support_width = total_width - dovetail_block_width - hook_total_width;
total_height = HOOK_BOTTOM_OFFSET + hook_radius + HOOK_HEIGHT;

bottom_rounding = total_height - HOOK_HEIGHT;

module hook() {
    diff("hook_cutout")
    right(
        MOUNT_WIDTH +
        support_width
    )
    cuboid(
        [
            hook_total_width,
            OBJ_DEPTH,
            total_height
        ],
        anchor = BOT + LEFT,
        rounding = bottom_rounding,
        edges = [BOT + RIGHT]
    ) {
        tag("hook_cutout")
        up(HOOK_BOTTOM_OFFSET)
        attach(BOT)
        cuboid(
            [
                HOOK_DIAMETER,
                OBJ_DEPTH + render_helper * 2,
                total_height - HOOK_BOTTOM_OFFSET + render_helper
            ],
            anchor = TOP,
            rounding = hook_radius,
            edges = [
                TOP + RIGHT,
                TOP + LEFT
            ]
        );
    };
}

module mount() {
    diff("dovetail_cutout")
    cuboid(
        [
            dovetail_block_width,
            OBJ_DEPTH,
            total_height
        ],
        anchor = BOT + LEFT
    ) {
        tag("dovetail_cutout")
        down(render_helper)
        attach(LEFT)
        dovetail(
            gender = "female",
            w = dovetail_width,
            h = dovetail_height,
            slide = total_height + render_helper * 2,
            back_width = dovetail_width - 3
        );
    }
}

module support() {
    right(dovetail_block_width)
    cuboid(
        [
            support_width,
            OBJ_DEPTH,
            total_height
        ],
        anchor = BOT + LEFT
    );
    /*
    zrot(90)
    hex_panel(
        shape = [
            total_height,
            support_width,
            OBJ_DEPTH
        ],
        strut = 1.5,
        spacing = 10,
        frame = 3,
        anchor = BACK + RIGHT,
        orient = RIGHT);
    */
}

module hook_assembly() {
    union() {
        hook();
        support();
        mount();
    }
}

module wall_mount() {
    screw_offset = total_height / 4;
    
    diff("screw_cutout")
    cuboid(
        [
            WALL_MOUNT_WIDTH,
            OBJ_DEPTH,
            total_height
        ],
        anchor = BOT + RIGHT
    )
    attach(RIGHT)
    dovetail(
        gender = "male",
        w = dovetail_width,
        h = dovetail_height,
        slide = total_height + render_helper * 2,
        back_width = dovetail_width - 3
    )
    tag("screw_cutout")
    attach(TOP)
    screw_hole(
        spec = SCREW_SPEC,
        head = SCREW_HEAD,
        anchor = TOP,
        hole_oversize = 1,
        head_oversize = 3
    );
}

//back_half()
//up(total_height - $t*total_height)
hook_assembly();
//wall_mount();