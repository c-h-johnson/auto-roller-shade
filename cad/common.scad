include <MCAD/boxes.scad>;
include <MCAD/utilities.scad>;

include <constants.scad>;
include <parameters.scad>;
use <utils.scad>;

// which side is the USB port on
bool_usb_right = !(bool_chain_side != bool_vertical);

diameter_case_screw_support = thickness_xy_case_compartment_2;

size_x_motor_engine = size_x_motor-size_x_motor_gearbox;
size_z_motor_shaft_full = offset_z_motor_shaft+size_z_motor_shaft;

size_x_separator = max(thickness_xy_case_compartment_1, thickness_xy_case_compartment_2);

size_x_pcb_max = max(size_x_mcu, size_x_driver);
margin_x1_pcb = max(
    case_bevel_radius_inner+margin,
    (case_bevel_radius_outer-thickness_xy_case_compartment_1)
);
size_x_compartment_pcb = margin_x1_pcb+size_x_pcb_max+margin;
size_x_compartment_motor = size_x_motor+margin-offset_x_motor;
size_x_case_internal = size_x_compartment_pcb+size_x_compartment_motor;

size_y2_case_internal = size_y_motor+(margin*2);

size_z_case_internal = max(
    // margins above and below pcbs
    size_y_mcu+(margin*2),
    size_y_driver+(margin*2),
    size_z_motor
);

size_x_case = size_x_case_internal+thickness_xy_case_compartment_1+thickness_xy_case_compartment_2;
size_y1_case = size_y1_case_internal+(thickness_xy_case_compartment_1*2);
size_y2_case = size_y2_case_internal+(thickness_xy_case_compartment_2*2);
size_z_case = size_z_case_internal+(thickness_z_case*2);

echo("DIMENSIONS:", size_x_case, max(size_y1_case, size_y2_case), size_z_case);

size_z_case_top = max(radius_bevel_base_mount_pcb, thickness_z_case);
size_z_case_bottom = size_z_case-size_z_case_top;

size_y_separator = min(size_y1_case_internal, size_y2_case_internal);

// miscellaneous values that must be derived
// all positions are measured from the center point of the bounding box of the object to the origin

position_x_pcbs = ((size_x_case-size_x_pcb_max)/2)-thickness_xy_case_compartment_1-margin_x1_pcb;
position_x_separator = (size_x_case/2)-thickness_xy_case_compartment_1-size_x_compartment_pcb-(size_x_separator/2);
position_x_motor_farside = (size_x_case/-2)+thickness_xy_case_compartment_2+margin;
position_x_motor = position_x_motor_farside+(size_x_motor/2);
position_x_drive = position_x_motor+offset_x_motor_shaft;

diameter_sprocket = (separation_chain_bead*teeth_sprocket)/pi;

size_z_coupling = size_z_motor_shaft-size_z_sprocket;

_offset_farside_shaft = abs(position_x_motor_farside-position_x_drive);
_separation_shaft_holes = length2([_offset_farside_shaft-offset_x2_motor_mount, separation_y_motor_mount/2]);
radius_shaft_cutout = _separation_shaft_holes-(diameter_head_motor/2);
echo("radius shaft cutout", radius_shaft_cutout);

diameter_chain_retainer = diameter_sprocket+diameter_chain_bead+(margin_chain_retainer*2);
diameter_chain_retainer_outer = diameter_chain_retainer+(thickness_xy_case_compartment_2*2);
  
bool_separate_chain_retainer = radius_shaft_cutout > (diameter_chain_retainer/2) ? true : bool_force_separate_chain_retainer;

position_y_power_plug = ((diameter_head_case/2) + thickness_xy_case_compartment_1 + (size_y_power_plug / 2)) * (bool_usb_right ? -1 : 1);

size_z_attachment_power_plug = size_z_power_plug-size_z_case_top+(thickness_z_case*2);

module mount_pcb_standoffs(x, y, height) {
    mirror_copy([1,0,0]) {
        mirror_copy([0,1,0]) {
            translate([x/2, y/2, height/2]) {
                children();
            }
        }
    }
}

module _dovetail(size, angle) {
    _size_x_base = size.x-((size.z/tan(angle))*2);
    linear_extrude(height=size.z, center=true, scale=[size.x/_size_x_base,1]) {
        square([_size_x_base, size.y], center=true);
    }
}

module dovetail(size, angle, round=false) {
    _radius_fillet = 0.5;
    _offset_x_fillet = _radius_fillet/tan(angle/2);
    _offset_z_fillet_end = _radius_fillet+(_radius_fillet*cos(angle));

    intersection() {
        _dovetail(size, angle);
        if (round) {
            union() {
                cube(size-[_offset_x_fillet*2, 0, 0], center=true);
                translate([0, 0, _offset_z_fillet_end/-2]) {
                    cube(size-[0, 0, _offset_z_fillet_end], center=true);
                }
                mirror_copy([1, 0, 0]) {
                    translate([(size.x/2)-_offset_x_fillet, 0, (size.z/2)-_radius_fillet]) {
                        rotate([90, 0, 0]) {
                            cylinder(h=size.y, r=_radius_fillet, center=true);
                        }
                    }
                }
            }
        }
    }
}

module mount_pcb(x, y, height, diameter, round=false) {
    diameter_standoff = diameter+(thickness_standoff*2);
    _total_height = thickness_base_mount_pcb+height;

    difference() {
        union() {
            translate([0, 0, thickness_base_mount_pcb]) {
                mount_pcb_standoffs(x=x, y=y, height=height) {
                    cylinder(h=height, d=diameter_standoff, center=true);
                }
            }
            translate([0, 0, thickness_base_mount_pcb/2]) {
                // TODO: replace with `roundedCube` in newer version of MCAD
                roundedBox([size_x_pcb_max, size_z_case+epsilon, thickness_base_mount_pcb+epsilon], radius_bevel_base_mount_pcb, true);
            }
            mirror_copy([0, 1, 0]) {
                translate([0, (size_z_case-thickness_xy_case_compartment_1)/2, size_z_mount_pcb_dovetail/2]) {
                    dovetail([size_x_pcb_max-(radius_bevel_base_mount_pcb*2), thickness_xy_case_compartment_1+epsilon, size_z_mount_pcb_dovetail], angle_max_slope, round=round);
                }
            }
        }
        mount_pcb_standoffs(x=x, y=y, height=_total_height) {
            cylinder(h=_total_height+epsilon, d=diameter, center=true);
        }
    }
}

// glorified difference and in addition halfing it
module _case_compartment_half(size) {
    difference() {
        children(0);
        translate([0, 0, thickness_z_case]) {
            children(1);
        }
        if ($children > 2) {
            children([2:$children-1]);
        }
        // cut in half
        translate([size.x/-2, 0, 0]) {
            cube([size.x+epsilon, size.y+epsilon, size.z+epsilon], center=true);
        }
    }
}

module _case_compartment_round(size, thickness_xy, remove_separator=false, bevel_inner=true) {
    _case_compartment_half(size) {
        // TODO replace with `roundedCube` in newer version of MCAD
        roundedBox([size.x,size.y,size.z], case_bevel_radius_outer, true);
        roundedBox([size.x-(thickness_xy*2),size.y-(thickness_xy*2),size.z], case_bevel_radius_inner, true);

        // remove the wall where the separator is
        if (remove_separator) {
            translate([((size.x-thickness_xy)/2), 0, thickness_z_case]) {
                cube([thickness_xy+epsilon, min(size_y1_case_internal, size_y2_case_internal), size.z], center=true);
            }
        }
        // remove inner bevel next to the separator
        if (!bevel_inner) {
            translate([((size.x-case_bevel_radius_inner)/2)-thickness_xy, 0, thickness_z_case]) {
                cube([case_bevel_radius_inner, size.y-(thickness_xy*2), size.z], center=true);
            }
        }
    }
}

module _case_compartment_flat(size, thickness_xy) {
    _case_compartment_half(size) {
        cube([size.x,size.y,size.z], center=true);
        cube([size.x+epsilon,size.y-(thickness_xy*2),size.z], center=true);
    }
}

// inside wall at x=0 (and removed)
module _case_compartment(size, thickness_xy, flat=false) {
    translate([(size.x/2)-thickness_xy, 0, size.z/2]) {
        _case_compartment_round(size, thickness_xy);
        rotate([0, 0, 180]) {
            if (flat) {
                _case_compartment_flat(size, thickness_xy);
            } else {
                _case_compartment_round(size, thickness_xy, remove_separator=true);
            }
        }
    }
}

// don't touch it, it works!
module case_half(height) {
    _is_smallest_compartment_1 = size_y1_case <= size_y2_case;
    _is_smallest_compartment_2 = size_y2_case <= size_y1_case;
    // drive compartment
    translate([position_x_separator-(size_x_separator/2), 0, 0]) {
        rotate([0, 0, 180]) {
            _case_compartment(
                [(size_x_case/2)+position_x_separator+(thickness_xy_case_compartment_2-(size_x_separator/2)), size_y2_case, height],
                thickness_xy_case_compartment_2,
                flat=_is_smallest_compartment_2
            );
        }
    }
    // pcb compartment
    translate([position_x_separator+(size_x_separator/2), 0, 0]) {
        difference() {
            union() {
                _size_x_case_compartment = (size_x_case/2)-position_x_separator+(thickness_xy_case_compartment_1-(size_x_separator/2));
                _case_compartment(
                    [_size_x_case_compartment, size_y1_case, height],
                    thickness_xy_case_compartment_1,
                    flat=_is_smallest_compartment_1
                );
            }
            // pcb mount slot
            mirror_copy([0, 1, 0]) {
                translate([margin+(size_x_pcb_max/2), (size_y1_case)/2, (size_z_case/2)]) {
                    rotate([90, 0, 0]) {
                        mount_pcb(0, 0, 0, 0);
                    }
                }
            }
            _size_y_hole_usb = (size_y_usb/2)+standoff_height_mcu+thickness_base_mount_pcb;
            // usb cutout
            mirror([0, bool_usb_right ? 0 : 1, 0]) {
                translate([size_x_compartment_pcb-((margin_x1_pcb+thickness_xy_case_compartment_1)/2)+thickness_xy_case_compartment_1, ((size_y1_case-_size_y_hole_usb)/2), (size_z_case+size_z_case_bottom)/2]) {
                    cube([margin_x1_pcb+thickness_xy_case_compartment_1+epsilon, _size_y_hole_usb, size_z_usb+size_z_case_bottom], center=true);
                }
            }
        }
    }
    // smooth join between the walls of the 2 compartments
    _outer = min(size_y1_case, size_y2_case);
    _inner = min(size_y1_case_internal, size_y2_case_internal);
    _thickness = (_outer-_inner)/2;
    mirror_copy([0, 1, 0]) {
        translate([position_x_separator, (_inner+_thickness)/2, height/2]) {
            cube([size_x_separator, _thickness, height], center=true);
        }
    }
}

position_y_case_screw = (size_y_separator+size_x_separator)/2;
position_y_motor_mount_screw = (size_y2_case-thickness_xy_case_compartment_2)/2;

module case_screws() {
    mirror_copy([0, 1, 0]) {
        translate([position_x_separator, position_y_case_screw, 0]) {
            children();
        }
    }
    // keep the pcb compartment together
    translate([(size_x_case-diameter_head_case)/2, 0, 0]) {
        children();
    }
}

module motor_mount_screws() {
    mirror_copy([0, 1, 0]) {
        translate([0, position_y_motor_mount_screw, 0]) {
            translate([position_x_motor_farside+size_x_motor_gearbox-offset_x1_motor_mount, 0, 0]) {
                children();
            }
            translate([position_x_motor_farside+offset_x2_motor_mount, 0, 0]) {
                children();
            }
        }
    }
}

module motor_screws() {
    motor_mount_screws() {
        translate([0, (separation_y_motor_mount/2)-position_y_motor_mount_screw, 0]) {
            children();
        }
    }
}

offset_screw_wall = (diameter_head_case+diameter_head_wall)/2;

module wall_screws() {
    translate([0, 0, size_z_mount_wall/2]) {
        motor_mount_screws() {
            translate([0, offset_screw_wall, 0]) {
                children();
            }
        }
    }
}

module motor_shaft(h) {
    intersection() {
        cylinder(h=h, d=diameter_motor_shaft, center=true);
        translate([offset_motor_key, 0, 0]) {
            cube([diameter_motor_shaft, diameter_motor_shaft, h], center=true);
        }
    }
}

// inverted
module screw_hole(h, d, h_head=0, d_head=0, head_top=true, clearance=0) {
    _position_z_head = head_top ? h-((h_head-clearance)/2) : (h_head+clearance)/2;

    translate([0, 0, h/2]) {
        cylinder(h=h+epsilon, d=d, center=true);
    }
    translate([0, 0, _position_z_head]) {
        cylinder(h=h_head+clearance+epsilon, d=d_head, center=true);
    }
}
