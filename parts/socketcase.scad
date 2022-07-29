/*
A socket case insert for the Pittsburgh 3/8 in 40 Pc socket set sold at Harbor Freight

https://www.harborfreight.com/38-in-14-in-drive-sae-metric-socket-set-40-pc-62843.html
*/

BOX_WIDTH = 233;
BOX_LENGTH = 100;
BOX_DEPTH = 24;
LID_DEPTH = 8;

half_length = BOX_LENGTH / 2;
total_depth = BOX_DEPTH + LID_DEPTH;

PADDING = 2;
dpadding = PADDING * 2;

working_width = BOX_WIDTH - PADDING * 2;
working_length = BOX_LENGTH - PADDING * 2;

TALL_SOCKET_HEIGHT = 25;
SHORT_SOCKET_HEIGHT = 21;

short_socket_depth = SHORT_SOCKET_HEIGHT * 0.5;
tall_socket_depth = TALL_SOCKET_HEIGHT - SHORT_SOCKET_HEIGHT + short_socket_depth;
insert_depth = total_depth - TALL_SOCKET_HEIGHT + tall_socket_depth;

ROW_METRIC_DIAMETERS = [
    22,
    20,
    17.5,
    16,
    16,
    14,
    13,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12
];

ROW_METRIC_LABELS = [
    "15",
    "14",
    "13",
    "12",
    "11",
    "10",
    "9",
    "8",
    "7.5",
    "7",
    "6.5",
    "6",
    "5.5",
    "5",
    "4.5"
];

ROW_METRIC_DEPTH = [
    tall_socket_depth,
    tall_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth
];

ROW_SAE_DIAMETERS = [
    24,
    22.25,
    18.25,
    18.75,
    17.25,
    16.25,
    16.25,
    14.25,
    13.25,
    13.25,
    12,
    12,
    12,
    12
];

ROW_SAE_LABELS = [
    "11/16", // .6875
    "5/8", // .625
    "9/16", // .5625
    "17/32", // .53125
    "1/2", // .5
    "15/32", // .46875
    "7/16", // .4375
    "13/32", // .40625
    "11/32", // .34375
    "3/8", // .375
    "5/16", // .3125
    "9/32", //.28125
    "1/4", // .25
    "7/32", // .21875
];

ROW_SAE_DEPTH = [
    tall_socket_depth,
    tall_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth
];

ROW_MIXED_DIAMETERS = [
    16,
    14.25,
    12,
    12,
    12,
    12
];

ROW_MIXED_LABELS = [
    "3/8",
    "5/16",
    "1/4",
    "3/16",
    "5/32",
    "4"
];

ROW_MIXED_DEPTH = [
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth,
    short_socket_depth
];

HANDLE_DIAMETER = 13;
HANDLE_LENGTH = 140;
HANDLE_HEAD_TOP = 3;
HANDLE_HEAD_WIDTH = 33;
HANDLE_HEAD_DEPTH = 18;
HANDLE_HEAD_LENGTH = 42;
HANDLE_HEAD_SHAFT_DEPTH = 12;
HANDLE_HEAD_SHAFT_DIAMETER = 13;
HANDLE_HEAD_SHAFT_OFFSET = 18;
HANDLE_OFFSET = 6;

EXTENDER_DIAMETER = 17;
EXTENDER_LENGTH = 72.5;

ADAPTER_DIAMETER = 16.25;
ADAPTER_DEPTH = tall_socket_depth;

handle_cutout_depth = total_depth - insert_depth;

$fs = 0.01;

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	module build_point(type = "sphere", rotate = [0, 0, 0]) {
		if (type == "sphere") {
			sphere(r = radius);
		} else if (type == "cylinder") {
			rotate(a = rotate)
			cylinder(h = diameter, r = radius, center = true);
		}
	}

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							build_point("sphere");
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							build_point("cylinder", rotate);
						}
					}
				}
			}
		}
	}
}

function subSum(x = 0, i = 0) = x[i] + ((i <= 0) ? 0 : subSum(x = x, i = i - 1));
function sum(x)=subSum(x = x, i = len(x) - 1);
function right(list, count) = [for (i = [len(list) - count:len(list) - 1]) list[i]];

function depth_offset(socket_depth) = insert_depth - socket_depth;
function remaining_sockets(diameters, socket_index) = len(diameters) - socket_index;
function remaining_width(width, diameters) = width - sum(diameters);
function spacing(width, diameters) = remaining_width(width, diameters) / len(diameters);
function column_offset(width, diameters, socket_index) =
    PADDING +
    diameters[socket_index] / 2 +
    spacing(width, diameters) * remaining_sockets(diameters, socket_index) +
    sum(right(diameters, remaining_sockets(diameters, socket_index))) -
    diameters[socket_index];
function label_offset_over(base_offset, max_diameter, socket_diameter) =
    base_offset +
    max_diameter -
    (max_diameter - socket_diameter) / 2 +
    PADDING * 1.5;
function label_offset_under(base_offset, max_diameter, socket_diameter) =
    base_offset +
    (max_diameter - socket_diameter) / 2 -
    PADDING * 1.5;

module print_label(label) {
    text(
        size = 3.25,
        spacing = 1,
        font = "Liberation Mono",
        halign = "center",
        valign = "center",
        text = label
    );
}

module row(width, diameters, depths, labels, offset_x_base, offset_y_base, label_over) {
    count = len(diameters);
    
    for (index = [0 : len(diameters) - 1]) {
        // Generate socket hole
        socket_diameter = diameters[index];
        socket_depth = depths[index];

        max_diameter = max(diameters);
        offset_x = offset_x_base + column_offset(width, diameters, index);
        offset_y = offset_y_base + socket_diameter / 2 +
            (max_diameter - socket_diameter) / 2;
        offset_z = depth_offset(socket_depth);

        translate([offset_x, offset_y, offset_z])
        cylinder(socket_depth + 1, d=socket_diameter);
        
        text_x = offset_x_base + column_offset(width, diameters, index);
        text_y = (label_over) ?
            label_offset_over(offset_y_base, max_diameter, socket_diameter) :
            label_offset_under(offset_y_base, max_diameter, socket_diameter);
        
        text_z = insert_depth - 1;
        
        // Generate label embossing
        translate([text_x, text_y, text_z])
        linear_extrude(2)
        print_label(labels[index]);
        
    }
}

module metric() {
    row_offset_y = PADDING;
    row(working_width, ROW_METRIC_DIAMETERS, ROW_METRIC_DEPTH, ROW_METRIC_LABELS, 0,row_offset_y, true);
}

module sae() {
    row_offset_y = BOX_LENGTH - PADDING - max(ROW_SAE_DIAMETERS);
    row(working_width, ROW_SAE_DIAMETERS, ROW_SAE_DEPTH, ROW_SAE_LABELS, 0, row_offset_y, false);
}

module mixed() {
    row_offset_x = EXTENDER_LENGTH + dpadding + HANDLE_HEAD_LENGTH + PADDING;
    row_offset_y = max(ROW_METRIC_DIAMETERS) + 12;
    width = working_width - row_offset_x;
    row(width, ROW_MIXED_DIAMETERS, ROW_MIXED_DEPTH, ROW_MIXED_LABELS, row_offset_x, row_offset_y, false);
}

module extender_insert() {
    offset_y = half_length - (HANDLE_DIAMETER + dpadding) / 2 -
        EXTENDER_DIAMETER - PADDING + HANDLE_OFFSET;

    translate([
        HANDLE_HEAD_LENGTH + PADDING,
        offset_y,
        0
    ])
    cube([EXTENDER_LENGTH + dpadding, EXTENDER_DIAMETER + dpadding, total_depth]);
}

module extender() {
    offset_y = half_length - (HANDLE_DIAMETER + dpadding) / 2 -
        EXTENDER_DIAMETER + HANDLE_OFFSET;
    offset_z = total_depth - EXTENDER_DIAMETER;
    
    translate([
        HANDLE_HEAD_LENGTH + dpadding,
        offset_y,
        offset_z
    ])
    cube([EXTENDER_LENGTH, EXTENDER_DIAMETER, EXTENDER_DIAMETER]);
}

module extender_cutout() {
    third_length = EXTENDER_LENGTH / 3;
    offset_y = half_length - (HANDLE_DIAMETER + PADDING) / 2 -
        EXTENDER_DIAMETER + HANDLE_OFFSET - dpadding;
    offset_z = total_depth - EXTENDER_DIAMETER;
    
    translate([
        HANDLE_HEAD_LENGTH + dpadding + third_length,
        offset_y,
        offset_z
    ])
    cube([third_length, EXTENDER_DIAMETER + dpadding + PADDING, EXTENDER_DIAMETER]);
}

module handle_insert() {
    head_top = total_depth - HANDLE_HEAD_DEPTH + HANDLE_DIAMETER;
    
    union() {
        // Handle of the driver
        translate([
            HANDLE_HEAD_LENGTH + PADDING,
            half_length - (HANDLE_DIAMETER + dpadding) / 2 + HANDLE_OFFSET,
            0
        ])
        cube([EXTENDER_LENGTH + dpadding, HANDLE_DIAMETER + dpadding, total_depth]);
    }
}

module handle() {    
    union() {
        // Head of the driver
        head_depth = HANDLE_HEAD_TOP + HANDLE_HEAD_DEPTH;
        head_offset = total_depth - head_depth;
        
        translate([
            PADDING,
            half_length - HANDLE_HEAD_WIDTH / 2 + HANDLE_OFFSET,
            head_offset
        ])
        cube([HANDLE_HEAD_LENGTH, HANDLE_HEAD_WIDTH, head_depth]);
        
        // Shaft of the driver
        shaft_offset = total_depth - head_depth - HANDLE_HEAD_SHAFT_DEPTH;
        
        translate([
            PADDING + HANDLE_HEAD_SHAFT_OFFSET,
            half_length + HANDLE_OFFSET,
            shaft_offset + .01
        ])
        cylinder(HANDLE_HEAD_SHAFT_DEPTH, d = HANDLE_HEAD_SHAFT_DIAMETER);
        
        // Handle of the driver
        top_size = HANDLE_DIAMETER + HANDLE_HEAD_TOP;
        translate([
            PADDING + HANDLE_HEAD_LENGTH,
            half_length - (HANDLE_DIAMETER) / 2 + HANDLE_OFFSET,
            total_depth - top_size
        ])
        cube([HANDLE_LENGTH, HANDLE_DIAMETER, top_size]);
    }
}

module adapter() {
    offset_x = BOX_WIDTH - PADDING - ADAPTER_DIAMETER / 2;
    offset_y = 59;
    offset_z = insert_depth - ADAPTER_DEPTH;
    
    translate([offset_x, offset_y, offset_z])
    cylinder(ADAPTER_DEPTH + 1, d = ADAPTER_DIAMETER);
}

module sockets() {
    union() {
        metric();
        sae();
        mixed();
    }
}

module insert() {
    union() {
        handle_insert();
        extender_insert();
        roundedcube([BOX_WIDTH, BOX_LENGTH, insert_depth], false, 4, "z");
    }
}

module base() {
    difference() {
        insert();
        handle();
        extender();
        extender_cutout();
        adapter();
        sockets();
    }
}

base();