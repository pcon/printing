include <../lib/BOSL2/std.scad>
include <../lib/gridfinity.scad>

CARTRIDGE_WIDTH = 16.75;
CARTRIDGE_DEPTH = 68;
CARTRIDGE_HEIGHT = 88;
CARTRIDGE_ROUNDING = 1;
CARTRIDGE_SPACING = CARTRIDGE_WIDTH + 2;
CARTRIDGE_COUNT = 6;

module long_high() {
    diff("remove")
    gridfinity_bin(
        2,
        2,
        4,
        lip = "none",
        middle = "solid"
     ) {
         tag("remove")
         attach(
            BOT,
            TOP,
            inside = true,
            shiftout = -7.7
         )
         xcopies(
            spacing = CARTRIDGE_SPACING,
            n = CARTRIDGE_COUNT
         )
         cuboid(
            [
                CARTRIDGE_WIDTH,
                CARTRIDGE_DEPTH,
                CARTRIDGE_HEIGHT
            ],
            rounding = CARTRIDGE_ROUNDING
        );
    }
}

module long_wide() {
    diff("remove")
    gridfinity_bin(
        3,
        3,
        4,
        lip = "none",
        middle = "solid"
     ) {
         free_y_spacing = gridfinity_dimension(3) - CARTRIDGE_HEIGHT;
         
         tag("remove")
         fwd(free_y_spacing / 2 - 3)
         attach(
            BOT,
            TOP,
            inside = true,
            shiftout = -9
         )
         xcopies(
            spacing = CARTRIDGE_SPACING,
            n = CARTRIDGE_COUNT
         )
         cuboid(
            [
                CARTRIDGE_WIDTH,
                CARTRIDGE_HEIGHT,
                CARTRIDGE_DEPTH
                
            ],
            rounding = CARTRIDGE_ROUNDING
        );
        
        back(gridfinity_dimension(1.5) - 18)
        attach(
            BOT,
            TOP,
            inside = true,
            shiftout = -9
         )
        cuboid(
            [
                CARTRIDGE_HEIGHT,
                CARTRIDGE_WIDTH,
                CARTRIDGE_DEPTH
                
            ],
            rounding = CARTRIDGE_ROUNDING
        );
    }
}

long_wide();