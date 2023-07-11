// this file is not effected by parameters.scad
// all the parameters here are self contained and can only be changed here

include <MCAD/boxes.scad>;
include <MCAD/regular_shapes.scad>

include <constants.scad>
include <utils.scad>

// START PARAMETERS

// should be slightly larger than the actual length so that there is enough clearance
length_lever = 56;

thickness = 5;
// minimum thickness just below the end of the lever
thickness_bottom = 2;

// consider relevant dimensions when switch is laid flat with holes facing upwards
size_switch = [
    20,
    // largest width of the housing not including the pins at the bottom
    10.5,
    6.5
];

// consider the lever going to the right and the pins facing toward you
// positive x is to the right
// positive y is away from you
// offsets from the center of the switch housing
offset_x_lever = -7;
offset_y_lever = (size_switch.y/2)+0.5;

// M2.5
diameter_thread_switch = 2.4;

separation_x_holes = 9.5;
// center of switch to center of holes
offset_y_holes = (size_switch.y/-2)+2.8;

// must be higher than the angle the level makes with the top of the switch in the default position
// ideal values between 20-45
angle_switch = 27;

// END PARAMETERS

separation_y_lever = offset_y_lever-(size_switch.y/2);

size_switch_holder = size_switch+[thickness*2, thickness*2, thickness];

radius_guide_curve = length_lever+thickness;

// does not include thickness_bottom i.e. the top of the bottom
offset_y_bottom = max(
    // this is the prefered factor
    (length_lever*sin(angle_switch))+(separation_y_lever*cos(angle_switch)),
    // this is to stop the switch reaching the bottom in rare circumstances where angle_switch is not high enough
    size_switch.y+(thickness*2)
);
position_y_bottom = -offset_y_bottom-thickness_bottom;
position_x_curve_end = sqrt((radius_guide_curve^2)-(position_y_bottom^2));

size_bottom = [position_x_curve_end+(thickness/2), abs(position_y_bottom)*2, size_switch_holder.z];

module _switch_holder() {
    difference() {
        union() {
            translate([0, 0, size_switch_holder.z/2]) {
                // TODO: replace with `roundedCube` in newer version of MCAD
                roundedBox(size_switch_holder, thickness, true);
                // structual support and stop lever from bending
                translate([offset_x_lever+(length_lever/2), (size_switch.y-thickness)/2, 0]) {
                    cube([length_lever, thickness, size_switch_holder.z], center=true);
                }
            }
        }
        translate([0, 0, size_switch_holder.z/2]) {
            // lever cutout
            // give the lever 1mm extra room
            translate([thickness+((size_switch.x/2)-abs(offset_x_lever))-1, size_switch_holder.y-thickness, 0]) {
                cube(size_switch_holder+[0, 0, epsilon], center=true);
            }
            // screw holes
            mirror_copy([1, 0, 0]) {
                translate([separation_x_holes/2, offset_y_holes, 0]) {
                    cylinder(h=size_switch_holder.z+epsilon, d=diameter_thread_switch, center=true);
                }
            }
        }
        translate([0, 0, thickness+(size_switch.z/2)]) {
            cube(size_switch, center=true);
            translate([0, (size_switch.y+thickness)/-2, 0]) {
                // middle pin
                cube([separation_x_holes-diameter_thread_switch, thickness+epsilon, size_switch.z+epsilon], center=true);
                // side pins
                mirror_copy([1, 0, 0]) {
                    _size_x_pins = (size_switch.x-separation_x_holes-diameter_thread_switch)/2;
                    translate([((size_switch.x-_size_x_pins)/2), 0, 0]) {
                        cube([_size_x_pins, thickness+epsilon, size_switch.z+epsilon], center=true);
                    }
                }
            }
            #if ($preview) {
                translate([(length_lever/2)+offset_x_lever, offset_y_lever, 0]) {
                    cube([length_lever, 0.3, size_switch.z], center=true);
                }
                cube(size_switch+[0, 0, epsilon], center=true);
            }
        }
    }
}

module _guide_curve() {
    difference() {
        // need high $fn because cylinder very large
        cylinder_tube(height=size_switch_holder.z, radius=radius_guide_curve, wall=thickness, center=true, $fn=512);
        // remove top
        translate([0, radius_guide_curve/2, 0]) {
            cube([radius_guide_curve*2, radius_guide_curve, size_switch_holder.z+epsilon], center=true);
        }
        // remove left side
        translate([radius_guide_curve/-2, radius_guide_curve/-2, 0]) {
            cube([radius_guide_curve, radius_guide_curve+epsilon, size_switch_holder.z+epsilon], center=true);
        }
    }
}

module _bottom() {
    difference() {
        // TODO: replace with `roundedCube` in newer version of MCAD
        roundedBox(size_bottom, thickness, true);
        // make L shape
        translate([thickness, thickness, 0]) {
            cube(size_bottom+[0, 0, epsilon], center=true);
        }
        // shorten switch support
        translate([0, abs(position_y_bottom)-((offset_y_lever+((size_switch.y+thickness)/2))/cos(angle_switch)), 0]) {
            cube(size_bottom+[epsilon, 0, epsilon], center=true);
        }
        // reduce height of switch support
        translate([(size_bottom.x/-2), 0, thickness]) {
            cube([size_switch.x, size_bottom.y+epsilon, size_bottom.z], center=true);
        }
        // thin at end of lever
        translate([(thickness/2)+((abs(position_y_bottom)-(separation_y_lever/cos(angle_switch))-thickness)/tan(angle_switch)), thickness_bottom, 0]) {
            cube(size_bottom+[0, 0, epsilon], center=true);
        }
    }
}

module limit_switch() {
    difference() {
        union() {
            translate([0, 0, size_switch_holder.z/2]) {
                _guide_curve();
                translate([(position_x_curve_end-(thickness/2))/2, 0, 0]) {
                    _bottom();
                }
            }
            rotate([0, 0, -angle_switch]) {
                translate([-offset_x_lever, -offset_y_lever, 0]) {
                    _switch_holder();
                }
            }
        }
        translate([0, 0, size_switch_holder.z/2]) {
            // remove below bottom
            translate([0, (radius_guide_curve/-2)+position_y_bottom, 0]) {
                cube([radius_guide_curve*2, radius_guide_curve, size_switch_holder.z+epsilon], center=true);
            }
        }
    }
}

limit_switch();
