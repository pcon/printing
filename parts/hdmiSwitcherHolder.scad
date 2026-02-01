INSIDE_WIDTH = 121;
SIDE_SPACER = 8;
INSIDE_HEIGHT = 80;
SIDE_HEIGHT = 35;
INSIDE_DEPTH = 18.5;
WALL_WIDTH = 1.5;
SKIM = .5;

totalWidth = INSIDE_WIDTH + WALL_WIDTH * 2;
totalHeight = INSIDE_HEIGHT + WALL_WIDTH;
totalDepth = INSIDE_DEPTH + WALL_WIDTH * 2;

difference() {
    translate([0, 0, totalHeight / 2])
    difference() {
        cube([totalWidth, totalDepth, totalHeight], center = true);
        translate([0, 0, WALL_WIDTH / 2])
        cube([INSIDE_WIDTH, INSIDE_DEPTH, INSIDE_HEIGHT + SKIM], center = true);
    }
    
    cutout_width = INSIDE_WIDTH - SIDE_SPACER * 2;
    translate([-cutout_width / 2, -INSIDE_DEPTH / 2, -SKIM])
    cube([cutout_width, INSIDE_DEPTH, WALL_WIDTH + SKIM * 2]);

    topDepth = INSIDE_DEPTH + WALL_WIDTH + SKIM;
    translate([-totalWidth / 2 - SKIM, (-topDepth / 2) + WALL_WIDTH / 2 + SKIM / 2, SIDE_HEIGHT + WALL_WIDTH])
    cube([totalWidth + SKIM * 2, topDepth, totalHeight - SIDE_HEIGHT + SKIM]);
}