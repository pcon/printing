WALL_WIDTH = 2;
BOTTOM_OD = 146;
TOP_OD = 96;
HEIGHT = 32;
CONE_HEIGHT = 50;

bottom = BOTTOM_OD / 2;
top = TOP_OD / 2;

rotate_extrude($fn=200)
polygon(
    points=[
        [bottom, 0],
        [bottom + WALL_WIDTH, 0],
        [bottom + WALL_WIDTH, HEIGHT],
        [top + WALL_WIDTH, HEIGHT + CONE_HEIGHT],
        [top + WALL_WIDTH, HEIGHT + CONE_HEIGHT + HEIGHT],
        [top, HEIGHT + CONE_HEIGHT + HEIGHT],
        [top, HEIGHT + CONE_HEIGHT],
        [bottom, HEIGHT]
    ]
);