include <common.scad>;

module attachment_power_plug() {
	_size_y_attachment_power_plug = size_y_power_plug+(thickness_xy_case_compartment_1*2);
	_position_x_power_plug_screw = ((size_x_power_plug+diameter_head_power_plug)/2)-thickness_xy_case_compartment_1;
	difference() {
		union() {
			translate([0, 0, size_z_attachment_power_plug/2]) {
				cube([size_x_power_plug, _size_y_attachment_power_plug, size_z_attachment_power_plug], center=true);
				translate([_position_x_power_plug_screw, 0, 0]) {
					cylinder(h=size_z_attachment_power_plug, d=diameter_head_power_plug, center=true);
				}
			}
		}
		translate([0, 0, size_z_attachment_power_plug/2]) {
			translate([-thickness_xy_case_compartment_1, -thickness_xy_case_compartment_1, thickness_z_case]) {
				cube([size_x_power_plug, _size_y_attachment_power_plug, size_z_attachment_power_plug], center=true);
			}
			translate([_position_x_power_plug_screw, 0, 0]) {
				cylinder(h=size_z_attachment_power_plug+epsilon, d=diameter_hole_power_plug, center=true);
			}
		}
		translate([((-size_x_power_plug+size_x_power_plug_prongs)/2)+(thickness_xy_case_compartment_1*2), -thickness_xy_case_compartment_1-offset_y_power_plug_prongs, thickness_z_case/2]) {
			cube([size_x_power_plug_prongs, _size_y_attachment_power_plug, thickness_z_case+epsilon], center=true);
		}
	}
}

attachment_power_plug();
