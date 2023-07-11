include <MCAD/boxes.scad>;

include <common.scad>;

module case_bottom() {
	difference() {
		union() {
			case_half(size_z_case_bottom);
			case_screws() {
				translate([0, 0, size_z_case_bottom/2]) {
					cylinder(h=size_z_case_bottom, d=diameter_case_screw_support, center=true);
				}
			}
			if (bool_wall_mount) {
				wall_screws() {
					_width_mount = max(diameter_head_wall, diameter_case_screw_support);
					cylinder(h=size_z_mount_wall, d=_width_mount, center=true);
					rotate([0, 0, -90]) {
						translate([offset_screw_wall/2, 0, 0]) {
							cube([offset_screw_wall, _width_mount, size_z_mount_wall], center=true);
						}
					}
				}
			}
		}
		// motor cutout
		translate([position_x_motor+((size_x_motor_engine-size_x_motor)/-2), 0, 0]) {
			cube([size_x_motor_engine, size_y_motor, size_z_case], center=true);
		}
		// motor mount cutout
		translate([position_x_separator-((size_x_case+size_x_separator)/2), 0, (size_z_case_bottom/2)+thickness_z_case+size_z_motor]) {
			cube([size_x_case, size_y2_case+epsilon, size_z_case_bottom], center=true);
		}
		case_screws() {
			translate([0, 0, size_z_case_bottom/2]) {
				cylinder(h=size_z_case_bottom+epsilon, d=diameter_thread_case, center=true);
			}
		}
		motor_mount_screws() {
			translate([0, 0, size_z_case_bottom/2]) {
				cylinder(h=size_z_case_bottom+epsilon, d=diameter_thread_case, center=true);
			}
		}
		wall_screws() {
			cylinder(h=size_z_mount_wall+epsilon, d=diameter_hole_wall, center=true);
		}
		// power plug holder
		if (bool_power_plug) {
			translate([(size_x_case-thickness_xy_case_compartment_1)/2, position_y_power_plug, size_z_case-thickness_z_case-(size_z_power_plug/2)]) {
				cube([thickness_xy_case_compartment_1+epsilon, size_y_power_plug, size_z_power_plug], center=true);
			}
		}
	}
}

case_bottom();
