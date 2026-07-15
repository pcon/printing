include <../lib/statics.scad>
include <../lib/BOSL2/std.scad>

// Newer badges seem to be larger than older designed ones
// Older badges are 38mm
BADGE_DIAMETER = 40;
BADGE_COUNT_X = 3;
BADGE_COUNT_Y = 1;
SASH_WIDTH = 125;
HOLDER_HEIGHT = 2;
HOLDER_LIP_WIDTH = 2;
HOLDER_LIP_HEIGHT = 2;

function badge_distribution(d, count, space) = d * (count - 1) + space * (count - 1);

extra_space = SASH_WIDTH - (BADGE_COUNT_X * BADGE_DIAMETER);
assert(extra_space > 0, "Not enough space for all badges");

badge_spacing = extra_space / BADGE_COUNT_X;
holder_width = SASH_WIDTH + HOLDER_LIP_WIDTH * 2;
holder_depth = (BADGE_DIAMETER + badge_spacing) * BADGE_COUNT_Y;

badge_cutout_diameter = BADGE_DIAMETER;
badge_cutout_height = HOLDER_HEIGHT + render_helper * 2;
badge_distribution_length = badge_distribution(BADGE_DIAMETER, BADGE_COUNT_X, badge_spacing);
badge_distribution_depth = badge_distribution(BADGE_DIAMETER, BADGE_COUNT_Y, badge_spacing);

diff("remove")
cuboid(
    [
        holder_width,
        holder_depth,
        HOLDER_HEIGHT
    ],
    anchor = BOT
) {
    align(TOP, [LEFT, RIGHT])
    cuboid(
        [
            HOLDER_LIP_WIDTH,
            holder_depth,
            HOLDER_LIP_HEIGHT
        ],
        anchor = BOT
    );
    
    tag("remove")
    ycopies(
        n = BADGE_COUNT_Y,
        l = badge_distribution_depth
    )
    xcopies(
        n = BADGE_COUNT_X,
        l = badge_distribution_length
    )
    cyl(
        h = badge_cutout_height,
        d = badge_cutout_diameter
    );
}