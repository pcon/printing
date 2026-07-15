include <../lib/statics.scad>
include <../lib/BOSL2/std.scad>
include <../lib/switchplate.scad>

$fn = 100;

WALL_WIDTH = 2;
CHIME_HEIGHT = 48;
CHIME_DIAMETER = 62.3;
DEPTH_STOP_HEIGHT = 20;

plate_width = CHIME_DIAMETER + WALL_WIDTH * 2 + PLATE_RADIUS * 2;
hole_height = PLATE_HEIGHT + render_helper * 2;
hole_diameter = CHIME_DIAMETER - WALL_WIDTH * 2;
tube_height = CHIME_HEIGHT + DEPTH_STOP_HEIGHT + PLATE_HEIGHT;

switchplate(type = SWITCH_TYPE_NONE, width = plate_width, edges_override = TOP) {
    tag("remove")
    //up(render_helper)
    //attach(BOT, BOT)//, inside = true)//, shiftout = render_helper)
    down(hole_height - render_helper)
    cyl(
        l = hole_height,
        d = hole_diameter
    );
    
    tube(
        h = DEPTH_STOP_HEIGHT,
        id = hole_diameter,
        wall = WALL_WIDTH
    );
    
    down(PLATE_HEIGHT)
    tube(
        h = tube_height,
        id = CHIME_DIAMETER,
        wall = WALL_WIDTH
    );
}