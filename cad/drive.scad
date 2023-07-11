include <MCAD/multiply.scad>
include <MCAD/regular_shapes.scad>

include <common.scad>

radius_chain_rope = diameter_chain_rope/2;

radius_sprocket_hole_rope_inner = radius_chain_rope*cos(angle_max_slope);

offset_sprocket_hole_rope = radius_chain_rope*sin(angle_max_slope);

// thin part
size_z_sprocket_middle = radius_sprocket_hole_rope_inner*2;
// sloped sections
size_z_sprocket_end = (size_z_sprocket-size_z_sprocket_middle)/2;
length_sprocket_slope = (size_z_sprocket/2)/sin(angle_max_slope);

radius_sprocket_inner = (diameter_sprocket/2)-offset_sprocket_hole_rope;
radius_sprocket_outer = radius_sprocket_inner+(size_z_sprocket_end/tan(angle_max_slope));

radius_coupling = min(
    max(
        radius_sprocket_outer,
        (diameter_motor_shaft/2)+thickness_coupling
    ),
    radius_shaft_cutout-margin
);

// inverted
module _sprocket_hole() {
    difference() {
        union() {
            sphere(d=diameter_chain_bead);
            mirror_copy([0, 0, 1]) {
                rotate([0, 90-angle_max_slope, 0]) {
                    translate([0, 0, length_sprocket_slope/2]) {
                        cylinder(h=length_sprocket_slope, d=diameter_chain_bead, center=true);
                    }
                }
            }
        }
    }
}

module _sprocket() {
    difference() {
        union() {
            cylinder(h=size_z_sprocket_middle, d=diameter_sprocket, center=true);
            mirror_copy([0, 0, 1]) {
                translate([0, 0, (size_z_sprocket_middle+size_z_sprocket_end)/2]) {
                    cylinder(h=size_z_sprocket_end, r1=radius_sprocket_inner, r2=radius_sprocket_outer, center=true);
                }
            }
        }
        spin(teeth_sprocket) {
            translate([diameter_sprocket/2,0,0]){
                _sprocket_hole();
            }
        }
        torus2(r1=diameter_sprocket/2, r2=radius_chain_rope);
    }
}

module _coupling() {
    _length_hole = (diameter_motor_shaft/2)+thickness_coupling;
    difference() {
        cylinder(h=size_z_coupling, r=radius_coupling, center=true);
        translate([(diameter_motor_shaft/2)+offset_motor_key, 0, ((diameter_head_coupling/2)+margin)-(size_z_coupling/2)]) {
            rotate([0, 90, 0]) {
                // cylinder(h=_length_hole, d=diameter_thread_coupling, center=true);
                screw_hole(h=size_z_screw_thread_coupling+size_z_screw_head_coupling, d=diameter_thread_coupling, h_head=size_z_screw_head_coupling, d_head=diameter_head_coupling, clearance=thickness_coupling);
            }
        }
    }
}

module drive() {
    difference() {
        union() {
            translate([0, 0, size_z_sprocket/2]) {
                _sprocket();
            }
            translate([0, 0, size_z_sprocket+(size_z_coupling/2)]) {
                _coupling();
            }
        }
        translate([0, 0, size_z_motor_shaft/2]) {
            motor_shaft(h=size_z_motor_shaft+epsilon);
        }
    }
}

drive();

echo("sprocket diameter:", diameter_sprocket);
