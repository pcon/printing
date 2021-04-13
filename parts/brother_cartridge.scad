// Brother P-Touch Cartridge Holder version 1.0
// Design by Patrick Connelly (patrick@deadlypenguin.com)

// preview[view:south east, tilt:top diagonal]

/* [Cartridge] */
number_of_cartridges = 5; //[2:15]

/* [Hidden] */
cart_width = 89;
cart_depth = 16;
cart_height = 20;

cart_gap = 2;

bottom_height = 2;

base_width = cart_width + cart_gap * 2;
base_depth = (cart_depth + cart_gap) * number_of_cartridges + cart_gap;
base_height = cart_height + bottom_height;

module base() {
	cube([base_width, base_depth, base_height]);
}

module pockets() {
    union() {
		for (i = [0:number_of_cartridges - 1]) {
            current_y = cart_gap + ((cart_depth + cart_gap) * i);
			translate([cart_gap, current_y, base_height - cart_height + 1])
			cube([cart_width, cart_depth, cart_height + 1]);
        }
    }
}

difference() {
    base();
    pockets();
}