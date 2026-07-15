include <../lib/BOSL2/std.scad>

SHELF_TOTAL_HEIGHT = 310;
SHELF_COUNT = 2;
RISER_COUNT = 3;

shelf_height = SHELF_TOTAL_HEIGHT / (SHELF_COUNT + 1);

PLEXI_WIDTH = 3.5;
WALL_WIDTH = 2.5;
SPACER_HEIGHT = 10;
TAPE_WIDTH = 28;

/* Only used for visualization */
SHELF_WIDTH = 275;
SHELF_DEPTH = 255;

plexi_depth = SHELF_DEPTH / 3;
plexi_width = SHELF_WIDTH - WALL_WIDTH * 2;

riser_spacing = SHELF_DEPTH / 10;

function holderHeight(sections) = shelf_height * sections;

module bracket() {
    zcopies(
        spacing = PLEXI_WIDTH + WALL_WIDTH,
        n = 2,
        sp = [0, 0, -(PLEXI_WIDTH + WALL_WIDTH * 1.5)]
    )
    cuboid(
        [
            SPACER_HEIGHT,
            TAPE_WIDTH,
            WALL_WIDTH
        ],
        anchor = LEFT
    );
}

module shelf_holder(sections = SHELF_COUNT) {
    holder_height = holderHeight(sections);
    
    cuboid(
        [
            WALL_WIDTH,
            TAPE_WIDTH,
            holder_height
        ],
        anchor = BOT + RIGHT
    );
    zcopies(spacing = shelf_height, n = sections, sp=[0, 0, shelf_height])
    bracket();
}

module display() {
right(WALL_WIDTH)
back(TAPE_WIDTH / 2 + plexi_depth)
shelf_holder(1);
    
right(SHELF_WIDTH - WALL_WIDTH)
back(TAPE_WIDTH / 2 + plexi_depth)
zrot(180)
shelf_holder(1);

back(-(TAPE_WIDTH / 2) + SHELF_DEPTH)
shelf_holder(2);

right(SHELF_WIDTH - WALL_WIDTH)  
back(-(TAPE_WIDTH / 2) + SHELF_DEPTH)
zrot(180)
shelf_holder(2);
    
back((TAPE_WIDTH / 2) + SHELF_DEPTH - plexi_depth)
shelf_holder(2);

right(SHELF_WIDTH - WALL_WIDTH)  
back((TAPE_WIDTH / 2) + SHELF_DEPTH - plexi_depth)
zrot(180)
shelf_holder(2);

back(SHELF_DEPTH)
up(shelf_height - WALL_WIDTH - PLEXI_WIDTH)
%cuboid([plexi_width, plexi_depth * 2, PLEXI_WIDTH], anchor = BOT + LEFT + BACK);
    
back(SHELF_DEPTH)
up(shelf_height * 2 - WALL_WIDTH - PLEXI_WIDTH)
%cuboid([plexi_width, plexi_depth, PLEXI_WIDTH], anchor = BOT + LEFT + BACK);

cuboid([SHELF_WIDTH, SHELF_DEPTH, 10], anchor = TOP + FRONT + LEFT);
}

display();