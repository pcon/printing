include <./statics.scad>
use <./common.scad>
include <./BOSL2/std.scad>
include <./BOSL2/joiners.scad>
include <./BOSL2/vectors.scad>

PLATE_SIDE_CLEARANCE = 5;
PLATE_WALL_WIDTH = 2.5;
PLATE_HEIGHT_MAX = 120;

SWITCH_TYPE_SWITCH = "SWITCH";
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

SWITCH_TYPE_ROCKER = "ROCKER";
PLATE_ROCKER_WIDTH = 33.5;
PLATE_ROCKER_HEIGHT = 67;
PLATE_ROCKER_DEPTH = 5;
PLATE_HOLE_DISTANCE_ROCKER_Y = 97;
PLATE_HOLE_DISTANCE_ROCKER_X = 46;
function plate_rocker_size() = [
    PLATE_ROCKER_WIDTH,
    PLATE_ROCKER_HEIGHT,
    PLATE_ROCKER_DEPTH
];

PLATE_HOLE_DIAMETER = 4;
PLATE_HOLE_HEAD_DIAMETER = 7;
PLATE_HOLE_BASE_HEIGHT = 1;
PLATE_HOLE_HEAD_HEIGHT = 3;

PLATE_RADIUS = 2;
PLATE_WIDTH = 70;
PLATE_HEIGHT = PLATE_HOLE_BASE_HEIGHT + PLATE_HOLE_HEAD_HEIGHT;

PLATE_HOLDER_OFFSET = 2;
PLATE_HOLDER_REMOTE = "REMOTE";
PLATE_HOLDER_CIRCLE = "CIRCLE";

PLATE_HOLDER_REMOTE_LIP = 4;

$fn = 32;

function isSwitch(type) = type == SWITCH_TYPE_SWITCH;

function getSwitchSize(type) = isSwitch(type) ?
    PLATE_SWITCH_SIZE :
    plate_rocker_size();

function switch_min_width(
    count,
    radius = PLATE_RADIUS,
    type = SWITCH_TYPE_SWITCH,
    cover_wall_width = PLATE_WALL_WIDTH,
    distance_x = PLATE_HOLE_DISTANCE_X
 ) = let(switch_size = getSwitchSize(type)) (switch_size[0] + (cover_wall_width + radius) * 2) * count + (distance_x - switch_size[0] - cover_wall_width * 2) * (count - 1);

module switchplate_base(
    count = 1,
    width = -1,
    depth = PLATE_HEIGHT,
    height = PLATE_HEIGHT_MAX,
    full_height = false,
    override_max_height = false,
    radius = PLATE_RADIUS,
    type = SWITCH_TYPE_SWITCH,
    cover_wall_width = PLATE_WALL_WIDTH,
    distance_x = PLATE_HOLE_DISTANCE_X,
    edges = TOP,
    remote_size = undef
) {
    switch_size = getSwitchSize(type);
    switch_min_width = switch_min_width(
        count,
        radius = radius,
        type = type,
        cover_wall_width = cover_wall_width,
        distance_x = distance_x
    );
    
    base_width = 
        width == -1
            ?
            is_undef(remote_size)
                ? switch_min_width
                : max(
                    switch_min_width,
                    remote_size[0] +
                    (cover_wall_width + radius) * 2
                )
            : width;
    
    base_height = override_max_height ?
        height :
        full_height ?
            PLATE_HEIGHT_MAX :
            min(PLATE_HEIGHT_MAX, height);
    
    cuboid(
        [
            base_width,
            base_height,
            depth
        ],
        rounding = radius,
        edges = edges,
        anchor = BOT
    )
    children();
}

module plate_screw_hole(
    depth = PLATE_HEIGHT,
    hole_d = PLATE_HOLE_DIAMETER,
    h = PLATE_HOLE_BASE_HEIGHT,
    head_d = PLATE_HOLE_HEAD_DIAMETER,
    head_h = PLATE_HOLE_HEAD_HEIGHT,
    through_all = true
) {
    top_height = through_all ? depth - h + render_helper : head_h + render_helper;

    union() {
        cyl(h + render_helper * 2, hole_d / 2, anchor = BOT);
        
        up(h + render_helper)
        cyl(top_height, head_d / 2, anchor = BOT);
    }
}

module plate_screw_pair(
    depth = PLATE_HEIGHT,
    hole_d = PLATE_HOLE_DIAMETER,
    h = PLATE_HOLE_BASE_HEIGHT,
    head_d = PLATE_HOLE_HEAD_DIAMETER,
    head_h = PLATE_HOLE_HEAD_HEIGHT,
    type = SWITCH_TYPE_SWITCH
) {
    distance_y = isSwitch(type) ?
        PLATE_HOLE_DISTANCE_Y :
        PLATE_HOLE_DISTANCE_ROCKER_Y;
    offset_y = distance_y / 2;
    
    tag("remove")
    union() {
        fwd(offset_y)
        plate_screw_hole(depth, hole_d, h, head_d, head_h);
        
        back(offset_y)
        plate_screw_hole(depth, hole_d, h, head_d, head_h);
    }        
}

module switchplate_switchhole(
    type = SWITCH_TYPE_SWITCH,
    depth = PLATE_HEIGHT
) {
    switch_size = getSwitchSize(type);
    hole_size = [
        switch_size[0],
        switch_size[1],
        max(switch_size[2], depth) + render_helper * 2
    ];
    
    tag("remove")
    cuboid(hole_size);
}

module switchplate_switchcover(
    type = SWITCH_TYPE_SWITCH,
    cover_wall_width = PLATE_WALL_WIDTH,
    radius = PLATE_RADIUS
) {
    switch_size = getSwitchSize(type);
    
    cover_size = add_scalar(
        switch_size,
        cover_wall_width * 2
    ) - [0, 0, cover_wall_width];
    
    cuboid(
        cover_size,
        anchor = BOT,
        rounding = radius,
        edges = "ALL",
        except = BOT
    )
    attach(BOT, BOT, inside = true, shiftout = render_helper)
    tag("remove")
    cuboid(
        switch_size + [0, 0, render_helper],
        rounding = radius,
        edges = "ALL",
        except = BOT
    )
    children();
}

module switchplate_remoteholder(
    remote_size = undef,
    switch_type = SWITCH_TYPE_SWITCH,
    cover_wall_width = PLATE_WALL_WIDTH,
    lip_size = PLATE_HOLDER_REMOTE_LIP,
    radius = PLATE_RADIUS
) {
    switch_size = getSwitchSize(switch_type);
    assert(is_vector(remote_size), "remote_size must be a vector");
    
    shell_dimensions = add_scalar(remote_size, PLATE_WALL_WIDTH) + [PLATE_WALL_WIDTH, 0, 0];
    
    diff("holder_remove")
    cuboid(
        shell_dimensions,
        anchor = BOT,
        rounding = PLATE_RADIUS,
        edges = "ALL",
        except = BOT
    ) {
        back(PLATE_WALL_WIDTH / 2 + render_helper)
        attach(BOT, BOT, inside = true, shiftout = render_helper)
        tag("holder_remove")
        cuboid(
            remote_size + [0, render_helper, render_helper],
            rounding = PLATE_RADIUS,
            edges = [ FWD, TOP ],
            except = [BOT, TOP + BACK]
        );
        
        tag("holder_remove")
        back(lip_size / 2 + cover_wall_width / 2)
        down(cover_wall_width + render_helper)
        attach(TOP, TOP)
        cuboid(
            [
                remote_size[0] - lip_size * 2,
                remote_size[1] - lip_size + render_helper,
                cover_wall_width + render_helper * 2
            ],
            rounding = radius,
            edges = [
                FRONT + LEFT,
                FRONT + RIGHT
            ]
        );
    }
}

module switchplate(
    type = SWITCH_TYPE_SWITCH,
    include_cover = true,
    include_hole = true,
    remote_size = undef,
    depth = PLATE_HEIGHT
) {
    diff("remove")
    switchplate_base(
        type = type,
        remote_size = remote_size,
        depth = depth
    ){
        if (include_hole) {
            attach(BOT, BOT, inside = true, shiftout = render_helper)
            switchplate_switchhole(
                type = type,
                depth = depth
            );
        }
        
        attach(BOT, BOT, inside = true, shiftout = render_helper)
        plate_screw_pair(
            type = type,
            depth = depth
        );
    
        if (include_cover) {
            down(PLATE_HEIGHT)
            attach(TOP, BOT)
            switchplate_switchcover(
                type = type
            );
        }
        
        attach(TOP, BOT)
        children();
    }
}

REMOTE_DEPTH = 68.5;
REMOTE_WIDTH = 45.5;
REMOTE_HEIGHT = 22.5;

REMOTE_DIMENSIONS = [
    REMOTE_WIDTH,
    REMOTE_DEPTH,
    REMOTE_HEIGHT
];