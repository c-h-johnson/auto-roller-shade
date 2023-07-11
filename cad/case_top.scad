include <MCAD/boxes.scad>;

include <common.scad>;

module case_top() {
	_size_z_separator_join = size_z_case-size_z_motor-(thickness_z_case*2);
	_radius_separator_fillet = size_x_separator-thickness_xy_case_compartment_1;
	_position_x_power_plug_screw = ((size_x_case-diameter_head_power_plug)/2)-size_x_power_plug;
	difference() {
		union() {
			case_half(size_z_case_top);
			case_screws() {
				translate([0, 0, size_z_case_top/2]) {
					cylinder(h=size_z_case_top, d=diameter_case_screw_support, center=true);
				}
			}
			// separator join
			translate([position_x_separator, 0, _size_z_separator_join/2]) {
				cube([size_x_separator, size_y2_case-(thickness_xy_case_compartment_2*2), _size_z_separator_join], center=true);
			}
			// power plug holder
			if (bool_power_plug) {
				translate([0, -position_y_power_plug, size_z_case_top/2]) {
					translate([(size_x_case-size_x_power_plug-thickness_xy_case_compartment_1)/2, 0, 0]) {
						cube([size_x_power_plug+thickness_xy_case_compartment_1, size_y_power_plug+(thickness_xy_case_compartment_1*2), size_z_case_top], center=true);
					}
					translate([_position_x_power_plug_screw, 0, 0]) {
						cylinder(h=size_z_case_top, d=diameter_head_power_plug, center=true);
					}
				}
			}
		}
		case_screws() {
			// head
			translate([0, 0, size_z_screw_head_case/2]) {
				cylinder(h=size_z_screw_head_case+epsilon, d=diameter_head_case, center=true);
			}
			// body
			translate([0, 0, size_z_case_top/2]) {
				cylinder(h=size_z_case_top+epsilon, d=diameter_hole_case, center=true);
			}
		}
		// chain cutout
		translate([position_x_separator-((size_x_case+size_x_separator)/2), 0, size_z_case_top/2]) {
			cube([size_x_case, size_y2_case+epsilon, size_z_case_top+epsilon], center=true);
		}
		// limit switch wire hole
		translate([position_x_pcbs, 0, thickness_z_case/2]) {
			cylinder(h=thickness_z_case+epsilon, d=10, center=true);
		}
		// separator fillet
		mirror_copy([0, 1, 0]) {
			translate([position_x_separator+((_radius_separator_fillet-size_x_separator)/2), (size_y2_case-_radius_separator_fillet)/2, size_z_case_top/2]) {
				difference() {
					cube([_radius_separator_fillet+epsilon, _radius_separator_fillet+epsilon, size_z_case_top+epsilon], center=true);
					translate([_radius_separator_fillet/2, _radius_separator_fillet/-2, 0]) {
						cylinder(h=size_z_case_top+epsilon, r=_radius_separator_fillet, center=true);
					}
				}
			}
		}
		// power plug holder
		if (bool_power_plug) {
			translate([0, -position_y_power_plug, 0]) {
				translate([(size_x_case-size_x_power_plug)/2, 0, thickness_z_case+(size_z_power_plug/2)]) {
					cube([size_x_power_plug+epsilon, size_y_power_plug, size_z_power_plug], center=true);
				}
				translate([_position_x_power_plug_screw, 0, size_z_case_top/2]) {
					cylinder(h=size_z_case_top+epsilon, d=diameter_thread_power_plug, center=true);
				}
			}
		}
	}
}

case_top();
