include <./statics.scad>
use <./common.scad>
include <./BOSL2/std.scad>
include <./BOSL2/walls.scad>

MOUNTING_HEX = "HEX";
MOUNTING_SOLID = "SOLID";

function is_hex(type) = type == MOUNTING_HEX;
function is_solid(type) = type == MOUNTING_SOLID;

MOUNTING_DEFAULT_SHELL_WIDTH = 5;

MOUNTING_SCREW_HOLE_DIAMETER = 6.35;
MOUNTING_DEFAULT_FOOT_CLEARANCE = 7;

function mounting_foot_length(hole_diameter, foot_clearance) = foot_clearance * 2 + hole_diameter;

module mounting_foot(
    dimensions,
    shell_width = MOUNTING_DEFAULT_SHELL_WIDTH,
    foot_clearance = MOUNTING_DEFAULT_FOOT_CLEARANCE,
    hole_diameter = MOUNTING_SCREW_HOLE_DIAMETER,
    hole_count = 1
) {
    obj_width = dimensions[0];
    obj_depth = dimensions[1];
    obj_height = dimensions[2];
    
    foot_length = mounting_foot_length(
        hole_diameter,
        foot_clearance
    ); 

    diff("screw_holes")
    cuboid(
        [
            shell_width,
            foot_length,
            obj_depth
        ],
        anchor = FWD + LEFT
    ) {
        tag("screw_holes")
        zcopies(
            l = obj_depth - foot_clearance * 2,
            n = hole_count
        )
        xcyl(
            l = shell_width + render_helper * 2,
            d = hole_diameter
        );
    };
}

module mounting_bracket(
    dimensions,
    shell_width = MOUNTING_DEFAULT_SHELL_WIDTH,
    foot_clearance = MOUNTING_DEFAULT_FOOT_CLEARANCE,
    hole_diameter = MOUNTING_SCREW_HOLE_DIAMETER,
    hole_count = 1,
    type = MOUNTING_HEX
) {
    obj_width = dimensions[0];
    obj_depth = dimensions[1];
    obj_height = dimensions[2];
    
    if (is_hex(type)) {
        hex_panel(
            shape = [
                obj_depth,
                obj_width + shell_width * 2,
                shell_width
            ],
            strut = 1.5,
            spacing = 10,
            frame = shell_width,
            anchor = BOT,
            orient = RIGHT,
            bevel = [FWD, BACK]
        );
    }
    
    if (is_solid(type)) {
        cuboid(
            [
                shell_width,
                obj_width + shell_width * 2,
                obj_depth,
            ],
            anchor = LEFT,
            chamfer = shell_width,
            edges = [
                FWD + RIGHT,
                BACK + RIGHT
            ]
        );
    }
    ycopies(obj_width + shell_width)
    cuboid(
        [
            obj_height,
            shell_width,           
            obj_depth
        ],
        anchor = RIGHT
    );
    
    back(obj_width / 2 + shell_width)
    left(obj_height)
    mounting_foot(
        dimensions,
        shell_width,
        foot_clearance,
        hole_diameter,
        hole_count
    );
    
    fwd(
        obj_width / 2 +
        shell_width +
        mounting_foot_length(
            hole_diameter,
            foot_clearance
        )
    )
    left(obj_height)
    mounting_foot(
        dimensions,
        shell_width,
        foot_clearance,
        hole_diameter,
        hole_count
    );
}