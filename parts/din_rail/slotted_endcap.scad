use <../../lib/common.scad>
include <../../lib/BOSL2/std.scad>
use <din_utilities.scad>

$fn = 32;

RACK_HOLE_SPACE = 15.9022;
ROUNDING = 3;
WALL_WIDTH = 4;
SLOT_DEPTH = 15;
HOLE_LENGTH = 20;

HOLE_DIAMETER = 6.5;
hole_radius = HOLE_DIAMETER / 2;

din_block_depth = din_width() + WALL_WIDTH * 2;
din_block_height = SLOT_DEPTH + WALL_WIDTH;

block_depth = 6;
block_height = din_block_height + WALL_WIDTH * 2 + HOLE_LENGTH + HOLE_DIAMETER;
block_width = RACK_HOLE_SPACE * 2 + HOLE_DIAMETER + WALL_WIDTH * 2;

top_height = HOLE_DIAMETER / 2 + WALL_WIDTH;

render_helper = 0.1;

module slot() {
    cuboid(
        [
            HOLE_DIAMETER,
            block_depth + render_helper * 2,
            HOLE_LENGTH + HOLE_DIAMETER
        ],
        rounding = HOLE_DIAMETER / 2,
        edges = [
            TOP,
            BOT
        ],
        except = [
            FRONT,
            BACK
        ]
    );
}

module bolt_slots() {
    tag("slots")
    down(HOLE_LENGTH / 2)
    xcopies(RACK_HOLE_SPACE, n = 3)
    attach(TOP)
    slot();
}

module din_slot() {
    tag("slots")
    fwd(block_depth + WALL_WIDTH)
    down(render_helper)
    attach(BOT, TOP, inside = true, align = BACK)
    linear_sweep(din_path(), height = SLOT_DEPTH + render_helper);
}

module block() {    
        cuboid(
            [
                block_width,
                block_depth,
                block_height - top_height
            ],
            anchor = BOT + BACK
        ) {
            attach(TOP, BOT)
            cuboid(
                [
                    block_width,
                    block_depth,
                    top_height
                ],
                rounding = top_height,
                edges = [
                    TOP
                ],
                except = [
                    FRONT,
                    BACK
                ]
            );
            
            attach(FRONT, BACK, align = BOT)
            cuboid(
                [
                    block_width,
                    din_block_depth,
                    din_block_height
                ],
                rounding = ROUNDING,
                edges = [
                    TOP,
                    FRONT
                ],
                except = [
                    BACK,
                    BOT
                ]
            );
            children();
        }
}

module slotted_encap() {
    diff("slots")
    block() {
        bolt_slots();
        din_slot();
    }
}

slotted_encap();