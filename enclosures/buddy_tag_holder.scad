include <../lib/statics.scad>
include <../lib/BOSL2/std.scad>

TAG_DIAMETER = 39;
TAG_HEIGHT = 1.7;
tag_radius = TAG_DIAMETER / 2;

TAG_COUNT = 28;

WALL_WIDTH = 3;

total_width = WALL_WIDTH * 2 + TAG_HEIGHT * TAG_COUNT;
total_depth = WALL_WIDTH * 2 + TAG_DIAMETER;
total_height = WALL_WIDTH + tag_radius;

diff("remove")
cuboid(
    [
        total_width,
        total_depth,
        total_height
    ],
    anchor = BOT,
    chamfer = WALL_WIDTH / 2
) {
    tag("remove")
    up(WALL_WIDTH)
    align(BOT, CENTER, inside = true)
    xcyl(
        l = TAG_HEIGHT * TAG_COUNT,
        d = TAG_DIAMETER
    );
    
    tag("remove")
    up(WALL_WIDTH + tag_radius / 2)
    align(BOT, CENTER, inside = true)
    xcyl(
        l = total_width + render_helper,
        d = tag_radius
    );
}