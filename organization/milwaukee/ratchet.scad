include <../../lib/BOSL2/std.scad>
include <../../lib/statics.scad>
include <./packout.scad>

$fn = $preview ? 32 : 260;

TOOL_SPACE_MIN = 3;
SOCKET_HEIGHT = 27;
SOCKET_STICKOUT = .5;
TEXT_HEIGHT = 4;

BOX_WIDTH = packout_size(2, lip = false);

METRIC_LABELS = [
    "8",
    "10",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17"
];

SAE_LABELS = [
    "1/4",
    "5/16",
    "3/8",
    "7/16",
    "1/2",
    "9/16",
    "5/8",
    "11/16"
];

METRIC_SIZES = [
     17,
     17,
     17,
     18,
     20,
     22,
     22,
     24
 ];
 
 SAE_SIZES = [
     17,
     17,
     17,
     17,
     18,
     20,
     22,
     24
];

MAX_DIAMETER = max([max(METRIC_SIZES), max(SAE_SIZES)]);

assert(len(METRIC_LABELS) == len(METRIC_SIZES), "There should be the same number of metric labels as sizes");
assert(len(SAE_LABELS) == len(SAE_SIZES), "There should be the same number of metric labels as sizes");

function get_offsets(sizes, current_sum = 0, index = 0) = 
    index >= len(sizes) ? [] :
    concat([current_sum], get_offsets(sizes, current_sum + sizes[index], index + 1));

module socket_holder(
    diameter,
    label,
    height = SOCKET_HEIGHT,
    stickout = SOCKET_STICKOUT,
    wall_width = TOOL_SPACE_MIN,
    max_diameter = MAX_DIAMETER,
    text_height = TEXT_HEIGHT,
    show_socket = $preview,
    anchor,
    spin,
    orient
 ) {        
     holder_dimensions = [
        diameter + wall_width * 2,
        max_diameter + wall_width * 2 + text_height,
        height * stickout
    ];

    attachable(
        size = holder_dimensions,
        anchor = anchor,
        spin = spin,
        orient = orient
     ) {
        diff("remove_socket")
        cuboid(
            holder_dimensions
        ) {
            socket_offset = (holder_dimensions[1] / 2) - (diameter / 2) - wall_width;
            
            tag("remove_socket")
            back(socket_offset)
            attach(BOT, BOT, inside = true, shiftout = render_helper)
            zcyl(
                d = diameter,
                h = height + render_helper
            );
            
            color("black")
            back(1)
            align(TOP, FWD)
            text3d(
                label,
                h = 1,
                size = 5,
                center = true
            );
            
            if ($preview) {
                color("grey")
                back_half()
                back(socket_offset)
                attach(BOT, BOT, inside = true)
                zcyl(
                    d = diameter + render_helper,
                    h = height + render_helper
                );
            }
        }
        children();
    }
}

module sockets(
    sizes,
    labels,
    height = SOCKET_HEIGHT,
    stickout = SOCKET_STICKOUT,
    wall_width = TOOL_SPACE_MIN,
    max_diameter = MAX_DIAMETER,
    text_height = TEXT_HEIGHT,
    anchor,
    spin,
    orient
) {
    socket_block_widths = add_scalar(sizes, wall_width);
    socket_spacing = get_offsets(socket_block_widths);
    socket_size = [
        sum(socket_block_widths),
        max_diameter + text_height + wall_width * 2,
        height * stickout
    ];
    
    attachable(
        size = socket_size,
        anchor = anchor,
        spin = spin, 
        orient = orient
    ) {
        left(socket_size[0] / 2)
        right(socket_block_widths[0] / 2)
        xcopies(
            n = len(sizes),
            spacing = socket_spacing
        )
        socket_holder(
            diameter = sizes[$idx],
            label = labels[$idx],
            height = height,
            stickout = stickout,
            wall_width = wall_width,
            max_diameter = max_diameter,
            text_height = text_height
        );
        children();
    }
}

sockets(METRIC_SIZES, METRIC_LABELS)show_anchors();

//packout_bin(width = 2, cutout = false, anchor = BOT);