VENT_WIDTH = 125;
VENT_LENGTH = 320;

PART_HEIGHT = 1.5;
PART_COUNT = 2;

part_length = VENT_LENGTH / PART_COUNT;

LENGTH_SEGMENTS = 10;
WIDTH_SEGMENTS = 5;
SEGMENT_SEPERATOR_SIZE = 3;

module segments() {
    segment_length = (part_length - ((LENGTH_SEGMENTS + 1) * SEGMENT_SEPERATOR_SIZE)) / LENGTH_SEGMENTS;
    segment_width = (VENT_WIDTH - ((WIDTH_SEGMENTS + 1) * SEGMENT_SEPERATOR_SIZE)) / WIDTH_SEGMENTS;
    segment_height = PART_HEIGHT + 2;
    
    for (i = [1 : LENGTH_SEGMENTS]) {
        for (j = [1 : WIDTH_SEGMENTS]) {
            x_offset = SEGMENT_SEPERATOR_SIZE * i + (segment_width * (i - 1));
            y_offset = SEGMENT_SEPERATOR_SIZE * j + (segment_length * (j - 1));
            
            translate([x_offset, y_offset, 1])
            cube([
                segment_width,
                segment_length,
                segment_height
            ]);
        }
    }
}

difference() {
    cube([
        part_length,
        VENT_WIDTH,
        PART_HEIGHT
    ]);
    segments();
}