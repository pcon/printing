include <./statics.scad>
use <./common.scad>
include <./BOSL2/std.scad>
include <./BOSL2/joiners.scad>
include <./BOSL2/vectors.scad>

PLATE_SIDE_CLEARANCE = 5;
PLATE_WALL_WIDTH = 1.5;
PLATE_HEIGHT_MAX = 120;

PLATE_SWITCH_WIDTH = 11;
PLATE_SWITCH_HEIGHT = 30;
PLATE_SWITCH_DEPTH = 18;
PLATE_HOLE_DISTANCE_X = 46;
PLATE_HOLE_DISTANCE_Y = 60;
PLATE_SWITCH_SIZE = [
    PLATE_SWITCH_WIDTH,
    PLATE_SWITCH_HEIGHT,
    PLATE_SWITCH_DEPTH
];

PLATE_ROCKER_WIDTH = 33.5;
PLATE_ROCKER_HEIGHT = 67;
PLATE_ROCKER_DEPTH = 4;
PLATE_HOLE_DISTANCE_ROCKER_Y = 97;
PLATE_HOLE_DISTANCE_ROCKER_X = 46;
PLATE_ROCKER_SIZE = [
    PLATE_ROCKER_WIDTH,
    PLATE_ROCKER_HEIGHT,
    PLATE_ROCKER_DEPTH
];

PLATE_HOLE_DIAMETER = 4;
PLATE_HOLE_HEAD_DIAMETER = 7;
PLATE_HOLE_BASE_HEIGHT = 1;
PLATE_HOLE_HEAD_HEIGHT = 4;

PLATE_RADIUS = 2;
PLATE_WIDTH = 70;
PLATE_HEIGHT = PLATE_HOLE_BASE_HEIGHT + PLATE_HOLE_HEAD_HEIGHT;

$fn = 32;

function switch_min_width(
    count,
    radius = PLATE_RADIUS,
    switch_size = PLATE_SWITCH_SIZE,
    cover_wall_width = PLATE_WALL_WIDTH,
    distance_x = PLATE_HOLE_DISTANCE_X
 ) = (switch_size[0] + (cover_wall_width + radius) * 2) * count + (distance_x - switch_size[0] - cover_wall_width * 2) * (count - 1);

module plate_base(
    count = 1,
    width = -1,
    depth = PLATE_HEIGHT,
    height = PLATE_HEIGHT_MAX,
    full_height = false,
    override_max_height = false,
    radius = PLATE_RADIUS,
    switch_size = PLATE_SWITCH_SIZE,
    cover_wall_width = PLATE_WALL_WIDTH,
    distance_x = PLATE_HOLE_DISTANCE_X,
    edges = TOP
) {
    base_width = width == -1 ?
        switch_min_width(
            count,
            radius = radius,
            switch_size = switch_size,
            cover_wall_width = cover_wall_width,
            distance_x = distance_x
        ) : width;
    base_height = override_max_height ? height : full_height ? PLATE_HEIGHT_MAX : min(PLATE_HEIGHT_MAX, height);

    cuboid(
        [base_width, base_height, depth],
        rounding = radius,
        edges = edges,
        anchor = BOT
    ) {
        children();
    };
}

module plate_screw_hole(
    depth = PLATE_HEIGHT,
    d = PLATE_HOLE_DIAMETER,
    h = PLATE_HOLE_BASE_HEIGHT,
    head_d = PLATE_HOLE_HEAD_DIAMETER,
    head_h = PLATE_HOLE_HEAD_HEIGHT,
    through_all = true
) {
    top_height = through_all ? depth - h + render_helper : head_h + render_helper;
    
    union() {
        cyl(h + render_helper * 2, d / 2, anchor = BOT);
        
        up(h + render_helper)
        cyl(top_height, head_d / 2, anchor = BOT);
    }
}

module plate_screw_pair(
    depth = PLATE_HEIGHT,
    d = PLATE_HOLE_DIAMETER,
    h = PLATE_HOLE_BASE_HEIGHT,
    head_d = PLATE_HOLE_HEAD_DIAMETER,
    head_h = PLATE_HOLE_HEAD_HEIGHT,
    distance_y = PLATE_HOLE_DISTANCE_Y
) {
    offset_y = distance_y / 2;
    
    union() {
        fwd(offset_y)
        plate_screw_hole(depth, d, h, head_d, head_h);
        
        back(offset_y)
        plate_screw_hole(depth, d, h, head_d, head_h);
    }        
}

module plate_screw_holes(
    count = 1,
    depth = PLATE_HEIGHT,
    d = PLATE_HOLE_DIAMETER,
    h = PLATE_HOLE_BASE_HEIGHT,
    head_d = PLATE_HOLE_HEAD_DIAMETER,
    head_h = PLATE_HOLE_HEAD_HEIGHT,
    distance_y = PLATE_HOLE_DISTANCE_Y,
    distance_x = PLATE_HOLE_DISTANCE_X
) {
    xcopies(distance_x, count)
    plate_screw_pair(
        depth = depth,
        d = d,
        h = h,
        head_d = head_d,
        head_h = head_h,
        distance_y = distance_y
    );
}

module plate_switch_hole(
    size = PLATE_SWITCH_SIZE,
    anchor = BOT,
    extra_depth = render_helper,
    radius = PLATE_RADIUS
) {
    down(extra_depth)
    cuboid(
        size + [0, 0, render_helper],
        anchor = anchor,
        rounding = radius,
        edges = "ALL",
        except = BOT
    );
}

module plate_switch_holes(
    count = 1,
    distance_x = PLATE_HOLE_DISTANCE_X,
    size = PLATE_SWITCH_SIZE,
    anchor = BOT,
    extra_depth = render_helper,
    radius = PLATE_RADIUS
) {
    xcopies(distance_x, count)
    plate_switch_hole(
        size = size,
        anchor = anchor,
        extra_depth = extra_depth,
        radius = radius
    );
}

module plate_switch_cover(
    switch_size = PLATE_SWITCH_SIZE,
    cover_wall_width = PLATE_WALL_WIDTH,
    radius = PLATE_RADIUS,
    anchor = BOT,
    holder_size = undef
) {
    switch_size_for_base = (holder_size == undef) ?
        switch_size :
        v_max(switch_size, holder_size);
    
    cover_size = add_scalar(
        switch_size_for_base,
        cover_wall_width * 2
    ) - [0, 0, cover_wall_width];
    diff("cover_remove")
    cuboid(
        cover_size,
        anchor = anchor,
        rounding = radius,
        edges = "ALL",
        except = BOT
    ) {
        attach(BOT, BOT, inside = true, shiftout = render_helper)
        tag("cover_remove")
        cuboid(
            switch_size + [0, 0, render_helper],
            rounding = radius,
            edges = "ALL",
            except = BOT
        );
    }
}

module plate_switch_covers(
    count = 1,
    switch_size = PLATE_SWITCH_SIZE,
    cover_wall_width = PLATE_WALL_WIDTH,
    distance_x = PLATE_HOLE_DISTANCE_X,
    radius = PLATE_RADIUS,
    anchor = BOT,
    holder_size = holder_size
) {
    xcopies(distance_x, count)
    plate_switch_cover(
        switch_size = switch_size,
        cover_wall_width = cover_wall_width,
        radius = radius,
        anchor = anchor,
        holder_size = holder_size
    );
}

module plate(
    count = 1,
    depth = PLATE_HEIGHT,
    height = PLATE_HEIGHT_MAX,
    hole_d = PLATE_HOLE_DIAMETER,
    hole_h = PLATE_HOLE_BASE_HEIGHT,
    head_d = PLATE_HOLE_HEAD_DIAMETER,
    head_h = PLATE_HOLE_HEAD_HEIGHT,
    distance_y = PLATE_HOLE_DISTANCE_Y,
    distance_x = PLATE_HOLE_DISTANCE_X,
    full_height = false,
    override_max_height = false,
    radius = PLATE_RADIUS,
    switch_holes = true,
    switch_size = PLATE_SWITCH_SIZE,
    switch_covers = true,
    cover_wall_width = PLATE_WALL_WIDTH,
    holder_size = undef
) {
    switch_size_for_base = (holder_size == undef) ?
        switch_size :
        v_max(
            switch_size,
            add_scalar(holder_size, cover_wall_width)
        );
    
    diff("remove")
    tag("base")
    plate_base(
        count = count,
        depth = depth,
        height = height,
        full_height = full_height,
        override_max_height = override_max_height,
        radius = radius,
        switch_size = switch_size_for_base,
        cover_wall_width = cover_wall_width,
        distance_x = distance_x
    ) {
        tag("remove")
        attach(BOT, BOT, inside = true, shiftout = render_helper)
        plate_screw_holes(
            count = count,
            depth = depth,
            d = hole_d,
            h = hole_h,
            head_d = head_d,
            head_h = head_h,
            distance_y = distance_y,
            distance_x = distance_x
        );
        
        if (switch_holes) {
            tag("remove")
            attach(BOT, BOT, inside = true, shiftout = render_helper)
            plate_switch_holes(
                count = count,
                distance_x = distance_x,
                size = switch_size,
                radius = radius
            );
        }
        
        if (switch_covers) {
            attach(TOP)
            plate_switch_covers(
                count = count,
                switch_size = switch_size,
                cover_wall_width = cover_wall_width,
                distance_x = distance_x,
                radius = radius,
                holder_size = holder_size
            );
        }
    }
}


module plate_rocker(
    count = 1,
    switch_holes = true,
    switch_covers = true,
    holder_size = undef
) {
    plate(
        count = count,
        switch_holes = switch_holes,
        switch_covers = switch_covers,
        switch_size = PLATE_ROCKER_SIZE,
        distance_x = PLATE_HOLE_DISTANCE_ROCKER_X,
        distance_y = PLATE_HOLE_DISTANCE_ROCKER_Y,
        holder_size = holder_size
    );
}