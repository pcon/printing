include <BOSL2/std.scad>

GF_TOLERANCE = 0.5;
GF_SIZE = 42.0;
GF_HUNIT = 7.0;
GF_WALL_THICKNESS = 0.95;

// Currently unsupported, leaving for future use
MAGNET_DIAMETER = 12;
MAGNET_HEIGHT = 2;
MAGNETS_NONE = "none";
MAGNETS_DEFAULT = "default";
MAGNETS_CORNERS = "corners";

MAGNET_OPTIONS = [
    MAGNETS_NONE,
    MAGNETS_DEFAULT,
    MAGNETS_CORNERS
];

// Currently unsupported, leaving for future use
SCREW_DIAMETER = 6;
SCREW_HEIGHT = 3;

LIP_NONE = "none";
LIP_DEFAULT = "default";

LIP_OPTIONS = [
    LIP_NONE,
    LIP_DEFAULT
];

MIDDLE_DEFAULT = "default";
MIDDLE_SOLID = "solid";
MIDDLE_LABEL = "label";
MIDDLE_LABEL_SCOOP = "label_scoop";

MIDDLE_OPTIONS = [
    MIDDLE_DEFAULT,
    MIDDLE_SOLID,
    MIDDLE_LABEL,
    MIDDLE_LABEL_SCOOP
];

GRIDFINITY_CONNECTOR_HEIGHTS = [
    0.8, // bottom taper
    1.8, // middle taper
    2.15 // top taper
];
GRIDFINITY_CONNECTOR_HEIGHT = sum(GRIDFINITY_CONNECTOR_HEIGHTS);

function gridfinity_dimension(i, size = GF_SIZE, tolerance = GF_TOLERANCE) = i * size - tolerance;
function gridfinity_height(h) = h * GF_HUNIT;
function gridfinity_half_height(h) = gridfinity_height(h) / 2;
function gridfinity_bin_size(x, y, h,  size = GF_SIZE, tolerance = GF_TOLERANCE) = [gridfinity_dimension(x), gridfinity_dimension(y), gridfinity_height(h)];
function is_valid_magnet(magnets) = in_list(magnets, MAGNET_OPTIONS);
function is_valid_lip(lip) = in_list(lip, LIP_OPTIONS);
function is_valid_middle(middle) = in_list(middle, MIDDLE_OPTIONS);

module gridfinity_bin(
    x,
    y,
    h,
    extra_piece_direction = CENTER,
    magnets = MAGNETS_NONE,
    lip = LIP_DEFAULT,
    middle = MIDDLE_DEFAULT,
    wall_thickness = GF_WALL_THICKNESS,
    center,
    anchor,
    spin = 0,
    orient = UP
) {
    assert(is_valid_magnet(magnets), str("Invalid magnet option '", magnets, "'"));
    assert(is_valid_lip(lip), str("Invalid lip option '", lip, "'"));
    assert(is_valid_middle(middle), str("Invalid middle option '", middle, "'"));
    
    attachable(
        anchor = anchor,
        spin = spin,
        orient = orient,
        size = gridfinity_bin_size(x, y, h),
        cp = [0, 0, gridfinity_half_height(h)]
    ) {
        gridfinity_bin_bottom_connects(x, y, magnets = magnets, anchor = BOT)
        position(TOP)
        gridfinity_bin_bottom_plate(x, y, orient = UP, anchor = BOTTOM)
        position(TOP)
        gridfinity_bin_middle(x, y, h, lip = lip, middle = middle, orient = UP, anchor = BOTTOM)
        position(TOP)
        gridfinity_bin_lip(x, y, h, lip = lip, orient = UP, anchor = BOTTOM);
        children();
    }
}

module gridfinity_bin_bottom_plate(
    x,
    y,
    h = 1,
    center,
    anchor,
    spin = 0,
    orient = UP
){
    bottom_plate_size = [
        gridfinity_dimension(x),
        gridfinity_dimension(y),
        h * GF_HUNIT - ( 0.8 + 1.8 + 2.15 )
    ];
    prismoid_size = [
        bottom_plate_size[0],
        bottom_plate_size[1]
    ];
    
    attachable(
        anchor = anchor,
        spin = spin,
        orient = orient,
        size = bottom_plate_size
    ){
        zmove(-bottom_plate_size[2] / 2)
        prismoid(
            size1 = prismoid_size,
            size2 = prismoid_size,
            h = bottom_plate_size[2],
            rounding = 4,
            anchor = BOTTOM
        );
        children();
    };
}

module gridfinity_bin_bottom_connects(
    x,
    y,
    magnets = MAGNETS_NONE,
    center,
    anchor,
    spin = 0,
    orient = UP
){
    assert(is_valid_magnet(magnets), str("Invalid magnet option '", magnets, "'"));

    bin_size = gridfinity_bin_size(x, y, 0);
    base_size = [
        bin_size[0],
        bin_size[1],
        GRIDFINITY_CONNECTOR_HEIGHT
    ];
    
    full_x = floor(x);
    full_y = floor(y);
    partial_size_x = x - full_x;
    partial_size_y = y - full_y;
    partial_size = gridfinity_bin_size(partial_size_x, partial_size_y, 0);
    
    frac_shift = [
        gridfinity_dimension(partial_size_x),
        gridfinity_dimension(partial_size_y)
    ];
    
    attachable(
        anchor = anchor,
        spin = spin,
        orient = orient,
        size = base_size
    ){
        diff() {
            move([-frac_shift[0]/2, -frac_shift[1]/2, -GRIDFINITY_CONNECTOR_HEIGHT/2])
            grid_copies(
                spacing = GF_SIZE,
                n = [full_x, full_y]
            )
            gridfinity_bin_bottom_connect(anchor = BOTTOM);
            
            if (partial_size_x > 0.01) {
                move([
                    (bin_size[0]-frac_shift[0])/2,
                    -frac_shift[1]/2,
                    -GRIDFINITY_CONNECTOR_HEIGHT/2
                ])
                ycopies(spacing = GF_SIZE, n = full_y)
                gridfinity_bin_bottom_connect(x = partial_size_x, anchor = BOTTOM);
            }
            
            if (partial_size_y>0.01) {
                move([-frac_shift[0]/2, (bin_size[1]-frac_shift[1])/2,-GRIDFINITY_CONNECTOR_HEIGHT/2])
                xcopies(spacing=GF_SIZE, n=floor(x))
                gridfinity_bin_bottom_connect(y=partial_size_y,anchor=BOTTOM);
            }
            
            if ((partial_size_x>0.01) && (partial_size_y>0.01)) {
                move([(bin_size[0]-frac_shift[0])/2, (bin_size[1]-frac_shift[1])/2,-GRIDFINITY_CONNECTOR_HEIGHT/2])
                gridfinity_bin_bottom_connect(x=partial_size_x, y=partial_size_y, anchor=BOTTOM);
            }
        }
        children();
    }
}

gridfinity_bin_bottom_connects(1, 4.5);

module gridfinity_bin_bottom_connect(
    x = 1,
    y = 1,
    magnets_layout = [false, false, false, false],
    magnets_d = MAGNET_DIAMETER,
    magnets_h = MAGNET_HEIGHT,
    screw_layout = [false, false, false, false],
    screw_d = SCREW_DIAMETER,
    screw_h = SCREW_HEIGHT,
    center,
    anchor,
    spin = 0,
    orient = UP
){   
    TOP_OFFSET = [
        -6.4,
        -4.8,
        -4.8
    ];
    
    BOTTOM_OFFSET = [
        -4.8,
        -4.8,
        -0.5
    ];
    
    connector_size = gridfinity_bin_size(x, y, 0, tolerance = 0);
    xsize1s = add_scalar(TOP_OFFSET, connector_size[0]);
    ysize1s = add_scalar(TOP_OFFSET, connector_size[1]);
    xsize2s = add_scalar(BOTTOM_OFFSET, connector_size[0]);
    ysize2s = add_scalar(BOTTOM_OFFSET, connector_size[1]);
    
    heights = [ 0.8, 1.8, 2.15 ];
    rounding1 = [ 1.15, 1.85, 1.85 ];
    rounding2 = [ 1.85, undef, 4.0 ];
    
    total_height = sum(heights);
    total_half_height = total_height / 2;
    attachable(
        anchor = anchor,
        spin = spin,
        orient = orient,
        size = [xsize2s[2], ysize2s[2], total_height]
    ) {
        zmove(-total_half_height)
        prismoid(
            size1 = [xsize1s[0], ysize1s[0]],
            size2 = [xsize2s[0], ysize2s[0]],
            h = heights[0],
            rounding1 = rounding1[0],
            rounding2 = rounding2[0]
        )
        position(TOP)
        prismoid(
            size1 = [xsize1s[1], ysize1s[1]],
            size2 = [xsize2s[1], ysize2s[1]],
            h = heights[1],
            rounding1 = rounding1[1],
            rounding2 = rounding2[1]
        )
        position(TOP)
        prismoid(
            size1 = [xsize1s[2], ysize1s[2]],
            size2 = [xsize2s[2], ysize2s[2]],
            h = heights[2],
            rounding1 = rounding1[2],
            rounding2 = rounding2[2]
        );
        children();
    };
}

module gridfinity_bin_middle(
    x,
    y,
    h,
    lip=LIP_DEFAULT, //TODO
    middle=MIDDLE_DEFAULT,
    wall_thickness=0.95,
    center,
    anchor,
    spin=0,
    orient=UP
) {
    assert(is_valid_lip(lip), str("Invalid lip option '", lip, "'"));
    assert(is_valid_middle(middle), str("Invalid middle option '", middle, "'"));
    
    bin_size = [ x*GF_SIZE-GF_TOLERANCE , y*GF_SIZE-GF_TOLERANCE ];
    lip_thick = 5.2/2;
    wtv = [2*wall_thickness, 2*wall_thickness];
    wtvp = [2*lip_thick, 2*lip_thick];
    deltav = [0.001, 0.001];
    middle_h = (h-1)*GF_HUNIT;
    attachable(anchor=anchor, spin=spin, orient=orient, size=[bin_size[0], bin_size[1], middle_h]){
        zmove(-middle_h/2)
        //main walls
        if (middle=="default") {
            rect_tube(size=bin_size, wall=wall_thickness, height = middle_h, rounding=4, anchor=BOTTOM)
            if (lip=="default") {
                position(TOP)
                rect_tube(size1=bin_size-wtv, size2=bin_size-wtv, isize1=bin_size-wtvp, isize2=bin_size-wtv-deltav, h=lip_thick-wall_thickness, rounding=4, irounding2=4, irounding1=1.15, anchor=BOTTOM, orient=DOWN);
            };
        } else if (middle=="solid"){
            prismoid(size1=bin_size, size2=bin_size, height=middle_h, rounding=4, anchor=BOTTOM);
        }
        children();
    }
};

module gridfinity_bin_lip(
    x,
    y,
    h,
    lip="default",
    center,
    anchor,
    spin=0,
    orient=UP
  ){
    bin_size = [ x*GF_SIZE-GF_TOLERANCE , y*GF_SIZE-GF_TOLERANCE ];
    isize1s = [ -5.2, -3.8, -3.8 ];
    isize2s = [ -3.8, undef, -0.01 ];
    hs = [ 0.7, 1.8, 1.9];
    lip_h = 4.4;
    r1s = [ 1.15, 1.85, 1.85 ];
    r2s = [ 1.85, undef, 4.0 ];
    bottom_connect_h = hs[0] + hs[1] + hs[2]; 
    attachable(anchor=anchor, spin=spin, orient=orient, size=[bin_size[0], bin_size[1], lip_h]){
if(lip=="default") {
        zmove(-lip_h/2)
        rect_tube(size1=bin_size, size2=bin_size, isize1=bin_size+[isize1s[0], isize1s[0]], isize2=bin_size+[isize2s[0],isize2s[0]], h=hs[0], rounding=4, irounding1=r1s[0], irounding2=r2s[0], anchor=BOTTOM)
        position(TOP)
        rect_tube(size=bin_size, isize=bin_size+[isize1s[1],isize1s[1]], h=hs[1], rounding=4, irounding=r1s[1], anchor=BOTTOM)
        position(TOP)
        rect_tube(size1=bin_size, size2=bin_size, isize1=bin_size+[isize1s[2], isize1s[2]], isize2=bin_size+[isize2s[2],isize2s[2]], h=hs[2], rounding=4, irounding1=r1s[2], irounding2=r2s[2], anchor=BOTTOM);
}
        children();
    };
  }