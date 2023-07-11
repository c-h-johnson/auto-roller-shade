include <MCAD/multiply.scad>

include <common.scad>

module _case_top() {
  _size_x_case_top = size_x_compartment_motor+thickness_xy_case_compartment_2-size_x_separator;

  translate([((size_x_case-_size_x_case_top)/-2), 0, thickness_z_case/2]) {
    // TODO: replace with `roundedCube` in newer version of MCAD
    roundedBox([_size_x_case_top, size_y2_case, thickness_z_case], case_bevel_radius_outer, true);
  }
}

module mount_motor() {
  _size_x_screws_bbox = size_x_motor_gearbox-offset_x1_motor_mount-offset_x2_motor_mount;
  _position_x_screws_center = position_x_motor_farside+offset_x2_motor_mount+(_size_x_screws_bbox/2);
  
  _multiply_offset_y = bool_vertical || bool_separate_chain_retainer ? 0 : bool_chain_side ? 1 : -1;

	difference() {
		union() {
			_case_top();
        translate([_position_x_screws_center, 0, size_z_motor_mount/2]) {
          cube([_size_x_screws_bbox+(thickness_xy_case_compartment_2*2), size_y2_case, size_z_motor_mount], center=true);
        }
        // motor shaft cutout support
        translate([position_x_drive, 0, size_z_motor_mount/2]) {
          cylinder(h=size_z_motor_mount, r=_offset_farside_shaft+margin+thickness_xy_case_compartment_2, center=true);
        }
        // chain retainer
        if (!bool_separate_chain_retainer) {
          translate([position_x_drive, 0, size_z_motor_shaft_full/2]) {
            cylinder(h=size_z_motor_shaft_full, d=diameter_chain_retainer_outer, center=true);
          }
        }
		}
		case_screws() {
      screw_hole(h=size_z_motor_mount, d=diameter_hole_case);
		}
		motor_mount_screws() {
      screw_hole(h=size_z_motor_mount, d=diameter_hole_case, h_head=size_z_screw_head_case, d_head=diameter_head_case, clearance=size_z_motor_shaft_full);
		}
    difference() {
  		motor_screws() {
        screw_hole(h=size_z_motor_mount, d=diameter_hole_motor, h_head=size_z_screw_head_motor, d_head=diameter_head_motor, clearance=size_z_motor_shaft_full);
  		}
      // remove hole in retainer (beads can get stuck in there and block the sprocket from turning)
      translate([position_x_motor_farside+offset_x2_motor_mount, (separation_y_motor_mount/-2)*_multiply_offset_y, size_z_motor_shaft_full/2]) {
        cube([diameter_head_motor, diameter_head_motor, size_z_motor_shaft_full], center=true);
      }
    }
    // motor shaft cutout
    translate([position_x_drive, 0, size_z_motor_mount/2]) {
      cylinder(h=size_z_motor_mount+epsilon, r=radius_shaft_cutout, center=true);
    }
    // chain retainer
    translate([position_x_drive, 0, (size_z_motor_shaft_full/2)+size_z_motor_mount]) {
      cylinder(h=size_z_motor_shaft_full, d=diameter_chain_retainer, center=true);
    }
    // rotate the following objects to match the orientation of the chain
    translate([position_x_drive, 0, 0]) {
      rotate([0, 0, bool_vertical ? 0 : bool_chain_side ? -90 : 90]) {
        // chain retainer
        translate([0-(diameter_chain_retainer_outer*0.5), 0, (size_z_motor_shaft_full/2)+size_z_motor_mount]) {
          cube([diameter_chain_retainer_outer, diameter_chain_retainer_outer, size_z_motor_shaft_full], center=true);
        }
        // sprocket coupling screw cutout
        translate([0-(size_y2_case*0.25), 0, offset_z_motor_shaft+(size_z_coupling-((diameter_head_coupling/2)+margin))]) {
          rotate([90, 0, 90]) {
            cylinder(h=(size_y2_case/2)+epsilon, d=diameter_head_coupling, center=true);
          }
        }
        // chain guide mount screw hole(s)
        spin(bool_separate_chain_retainer ? 4 : 1) {
          translate([-offset_xy_screw_guide, 0, size_z_motor_mount/2]) {
            cylinder(h=size_z_motor_mount+epsilon, d=diameter_thread_guide, center=true);
          }
        }
      }
    }
	}
}

mount_motor();
