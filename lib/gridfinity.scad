include <BOSL2/std.scad>

GF_TOLERANCE=0.5;
GF_SIZE=42.0;
GF_HUNIT=7.0;

function gridfinity_dimension(i)=i*GF_SIZE-GF_TOLERANCE;

module gridfinity_bin(
    x, //width in units of the bin, non-integers are an extra piece
    y, //depth in units of the bin
    h, //height in units of the bin
    extra_piece_direction=CENTER, //if there are fractional pieces which direction is it put, CENTER==None
    magnets="none", //magnets configuration: "none", "default", "corners"
    lip="default", //how the lip on top works: "none", "default" 
    middle="default", //how the center is, "default", "solid", "label", "label_scoop"
    wall_thickness=0.95, //the thickness of walls
    center, //attachable param
    anchor,
    spin=0,
    orient=UP
) {
    bin_size = [ x*GF_SIZE-GF_TOLERANCE , y*GF_SIZE-GF_TOLERANCE ];
    attachable(anchor=anchor, spin=spin, orient=orient, size=[bin_size[0], bin_size[1], GF_HUNIT]){
        gridfinity_bin_bottom_connects(x,y,anchor=BOTTOM)
        position(TOP)
        gridfinity_bin_bottom_plate(x,y, orient=UP, anchor=BOTTOM)
        position(TOP)
        gridfinity_bin_middle(x,y,h, lip=lip, middle=middle, orient=UP, anchor=BOTTOM)
        position(TOP)
        gridfinity_bin_lip(x,y,h, lip=lip, orient=UP, anchor=BOTTOM);
        children();
    }
};
module gridfinity_bin_bottom_plate(
    x,
    y,
    h=1,
    center,
    anchor,
    spin=0,
    orient=UP
){
    bottom_plate_size = [ x*GF_SIZE-GF_TOLERANCE , y*GF_SIZE-GF_TOLERANCE ];
    bottom_plate_h = h*GF_HUNIT - ( 0.8 + 1.8 + 2.15 );
    attachable(anchor=anchor, spin=spin, orient=orient, size=[bottom_plate_size[0], bottom_plate_size[1], bottom_plate_h]){
        zmove(-bottom_plate_h/2)
        prismoid(bottom_plate_size, bottom_plate_size,  bottom_plate_h, rounding=4, anchor=BOTTOM);
        children();
    };
    
}

module gridfinity_bin_bottom_connects(
    x,
    y,
    magnets_style="none",
    center,
    anchor,
    spin=0,
    orient=UP
){
    bin_size = [ x*GF_SIZE-GF_TOLERANCE , y*GF_SIZE-GF_TOLERANCE ];
    x_frac = x-floor(x);
    y_frac = y-floor(y);
    frac_shift = [x_frac*GF_SIZE - GF_TOLERANCE, y_frac*GF_SIZE - GF_TOLERANCE];
    bottom_connects = 0.8 + 1.8 + 2.15;
    attachable(anchor=anchor, spin=spin, orient=orient, size=[bin_size[0], bin_size[1], bottom_connects]){
        diff() {
            move([-frac_shift[0]/2, -frac_shift[1]/2, -bottom_connects/2])
            grid_copies(spacing=GF_SIZE, n=[floor(x),floor(y)])
            gridfinity_bin_bottom_connect(anchor=BOTTOM);
            if (x_frac>0.01) {
                move([(bin_size[0]-frac_shift[0])/2,-frac_shift[1]/2,-bottom_connects/2])
                ycopies(spacing=GF_SIZE, n=floor(y))
                gridfinity_bin_bottom_connect(xscale=x_frac,anchor=BOTTOM);
            }
            if (y_frac>0.01) {
                move([-frac_shift[0]/2, (bin_size[1]-frac_shift[1])/2,-bottom_connects/2])
                xcopies(spacing=GF_SIZE, n=floor(x))
                gridfinity_bin_bottom_connect(yscale=y_frac,anchor=BOTTOM);
            }
            if ((x_frac>0.01) && (y_frac>0.01)) {
                move([(bin_size[0]-frac_shift[0])/2, (bin_size[1]-frac_shift[1])/2,-bottom_connects/2])
                gridfinity_bin_bottom_connect(xscale=x_frac, yscale=y_frac, anchor=BOTTOM);

            }
        };
        children();
    }
}

module gridfinity_bin_bottom_connect(
    magnets_layout=[false, false, false, false],
    magnets_r=6.0,
    magnets_h=2.0,
    screw_layout=[false, false, false, false],
    screw_r=3.0,
    screw_h=3.0,
    xscale=1,
    yscale=1,
    center,
    anchor,
    spin=0,
    orient=UP
  ){
    size=[xscale*GF_SIZE,yscale*GF_SIZE];
    // size1s = [ 35.6, 37.2, 37.2 ];
    xsize1s = [ size[0]-6.4, size[0]-4.8, size[0]-4.8];
    ysize1s = [ size[1]-6.4, size[1]-4.8, size[1]-4.8];
    // size2s = [ 37.2, 37.2, 41.5 ];
    xsize2s = [ size[0]-4.8, size[0]-4.8, size[0]-0.5];
    ysize2s = [ size[1]-4.8, size[1]-4.8, size[1]-0.5];
    hs = [ 0.8, 1.8, 2.15 ];
    r1s = [ 1.15, 1.85, 1.85 ];
    r2s = [ 1.85, undef, 4.0 ];
    bottom_connect_h = hs[0] + hs[1] + hs[2]; 
    attachable(anchor=anchor, spin=spin, orient=orient, size=[xsize2s[2], ysize2s[2], bottom_connect_h]){
        zmove(-(bottom_connect_h/2))
        prismoid(size1=[xsize1s[0], ysize1s[0]], size2=[xsize2s[0], ysize2s[0]], h=hs[0], rounding1=r1s[0], rounding2=r2s[0])
        position(TOP)
        prismoid(size1=[xsize1s[1], ysize1s[1]], size2=[xsize2s[1], ysize2s[1]], h=hs[1], rounding=r1s[1])
        position(TOP)
        prismoid(size1=[xsize1s[2], ysize1s[2]], size2=[xsize2s[2], ysize2s[2]], h=hs[2], rounding1=r1s[2], rounding2=r2s[2]);
        children();
    };
}

module gridfinity_bin_middle(
    x,
    y,
    h,
    lip="default", //TODO
    middle="default",
    wall_thickness=0.95,
    center,
    anchor,
    spin=0,
    orient=UP
) {
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
