include <BOSL2/std.scad>
include <statics.scad>
include <common.scad>

$fn = $preview ? 32 : 128;

module wall_hanger(
    rear_panel,
    basket,
    anchor = BOT + LEFT,
    spin = 0,
    orient = LEFT
) {
    total_size = [
        max(rear_panel[0], basket[0]),
        rear_panel[1] + basket[1],
        rear_panel[2] + basket[2]
    ];
    
    attachable(
        anchor,
        spin,
        orient,
        size = total_size
    ) {
        down(total_size[2] / 2)
        cuboid(
            rear_panel,
            anchor = BOT
        ) {
            attach(TOP, BOT, align = LEFT)
            cuboid(basket);
        };
        children();
    }
}