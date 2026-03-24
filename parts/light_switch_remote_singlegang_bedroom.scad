include <../lib/switchplate.scad>

REMOTE_DEPTH = 114;
REMOTE_WIDTH = 47.5;
REMOTE_HEIGHT = 13.5;

REMOTE_DIMENSIONS = [
    REMOTE_WIDTH,
    REMOTE_DEPTH,
    REMOTE_HEIGHT
];

switchplate(
    type = SWITCH_TYPE_ROCKER,
    remote_size = REMOTE_DIMENSIONS,
    include_cover = false
)
switchplate_remoteholder(
    switch_type = SWITCH_TYPE_ROCKER,
    remote_size = REMOTE_DIMENSIONS
);