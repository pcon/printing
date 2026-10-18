include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <statics.scad>
include <BOSL2/screws.scad>

$fn = $preview ? 16 : 128;

module container_bottom(
    od,
    id,
    h,
    thread_od,
    thread_h = 7,
    pitch = 3,
    outside_percentage = 0.5, // Default to half height
    inside_percentage = 1, // Default to all in base
    wall_width = 2,
    rounding = 2,
    clearance = 0.5,
    anchor,
    spin,
    orient
) {
    assert(is_def(od) || is_def(thread_od) || is_def(id), "Either od, id or thread_od must be provided");
    
    d = is_def(od) ? od : is_def(thread_od) ? thread_od + wall_width * 2 : id + (5/4) * pitch * cos(30);
    thread_d = is_def(thread_od) ? thread_od : d - wall_width * 2;
    bottom_h = (h - clearance - wall_width) * inside_percentage;
    inside_d = is_def(id) ? id : thread_d - (5/4) * pitch * cos(30);
 
    attachable(
        h = bottom_h,
        d = d,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        down(bottom_h / 2)
        cyl(
            d = d,
            h = h * outside_percentage,
            rounding1 = rounding,
            anchor = BOT
        ) {
            attach(TOP, BOT)
            threaded_rod(
                d = thread_d,
                h = thread_h,
                pitch = pitch,
                anchor = BOT
            );
            
            attach(BOT, BOT, inside = true)
            cyl(
                d = thread_d - thread_h / 2,
                h = bottom_h
            );
        }
 
        children();
    }
}

module container_lid(
    od,
    h,
    thread_od,
    thread_h = 7,
    pitch = 3,
    outside_percentage = 0.5, // Default to half height
    inside_percentage = 0, // Default to all in base
    wall_width = 2,
    rounding = 2,
    clearance = 0.5,
    scalloped = true,
    scallop_count = 20,
    scallop_d = 1.5,
    anchor,
    spin,
    orient
) {
    d = is_def(od) ? od : thread_od + wall_width * 2;
    thread_d = is_def(thread_od) ? thread_od : od - wall_width * 2;
    top_h = h * outside_percentage;
    inside_h = (h - clearance - wall_width) * inside_percentage + wall_width;

    attachable(
        h = top_h,
        d = d,
        anchor = anchor,
        spin = spin,
        orient = orient
    ) {
        down(top_h / 2)
        diff("remove_lid")
        cyl(
            d = d,
            h = top_h,
            anchor = BOT,
            rounding1 = wall_width * 2
        ) {
            tag("remove_lid")
            attach(BOT, BOT, inside = true, shiftout = -inside_h - render_helper)
            cyl(
                d = d - wall_width * 2 + clearance,
                h = top_h - thread_h - inside_h + render_helper//,
                //rounding1 = wall_width * 2
            );
            
            tag("remove_lid")
            attach(TOP, TOP, inside = true, shiftout = render_helper)
            threaded_rod(
                d = thread_d - clearance,
                h = thread_h,
                pitch = pitch,
                anchor = BOT,
                internal = true
            );
            
            if (scalloped) {
                tag("remove_lid")
                arc_copies(
                    d = d,
                    n = scallop_count
                )
                attach(BOT, BOT, inside = true, shiftout = render_helper)
                cyl(
                    d = scallop_d,
                    h = top_h + render_helper * 2,
                    anchor = BOT
                );
            }
        }
        children();
    }
}