include <../lib/statics.scad>
include <../lib/BOSL2/std.scad>

HOLDER_WIDTH = 160;
HOLDER_DEPTH = 100;
HOLDER_HEIGHT = 120;

WALL_WIDTH = 2;

PACKET_HOLE_COUNT = 7;
PACKET_HOLE_WIDTH = 20;
packet_hole_depth = HOLDER_DEPTH - WALL_WIDTH + render_helper;
packet_hole_height = HOLDER_HEIGHT - WALL_WIDTH * 2;
packet_hole_length = HOLDER_WIDTH - PACKET_HOLE_WIDTH - WALL_WIDTH * 2;

echo(packet_hole_depth=packet_hole_depth);
echo(packet_hole_height=packet_hole_height);

diff("remove")
cuboid(
    [
        HOLDER_WIDTH,
        HOLDER_DEPTH,
        HOLDER_HEIGHT
    ],
    chamfer = WALL_WIDTH,
    except = FRONT,
    anchor = BOT + FRONT
) {
    tag("remove")
    
    xcopies(
        n = PACKET_HOLE_COUNT,
        l = packet_hole_length
    )
    attach(FRONT, FRONT, inside = true, shiftout = render_helper)
    cuboid(
        [
            PACKET_HOLE_WIDTH,
            packet_hole_depth,
            packet_hole_height
        ],
        chamfer = WALL_WIDTH,
        except = FRONT
    );
};