include <../../lib/statics.scad>
include <../../lib/BOSL2/std.scad>

back(5)
up(5)
rotate([0, -90, 0])
linear_extrude(2, center = true)
import("thread_card.svg");

right(15)
back(5)
up(5)
rotate([0, -90, 0])
linear_extrude(2, center = true)
import("thread_card.svg");

right(30)
back(5)
up(5)
rotate([0, -90, 0])
linear_extrude(2, center = true)
import("thread_card.svg");

left(15)
back(5)
up(5)
rotate([0, -90, 0])
linear_extrude(2, center = true)
import("thread_card.svg");

left(30)
back(5)
up(5)
rotate([0, -90, 0])
linear_extrude(2, center = true)
import("thread_card.svg");

difference() {
    left(45)
    cube([90, 110, 50]);
back(5)
up(5)
rotate([0, -90, 0])
linear_extrude(85, center = true)
offset(delta = 2)
import("thread_card.svg");
}