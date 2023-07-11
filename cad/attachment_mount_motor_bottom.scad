include <MCAD/utilities.scad>;

include <common.scad>

module attachment_mount_motor_bottom_ends(height) {
  mirror_copy([0, 1, 0]) {
	  translate([0, (diameter_chain_retainer+thickness_xy_case_compartment_2)/2, height/2]) {
		  cylinder(h=height, d=thickness_xy_case_compartment_2, center=true);
		}
	}
}

module attachment_mount_motor_bottom() {
  _size_x_screws_bbox = size_x_motor_gearbox-offset_x1_motor_mount-offset_x2_motor_mount;
  _position_x_screws_center = position_x_motor_farside+offset_x2_motor_mount+(_size_x_screws_bbox/2);
  
  _multiply_offset_y = bool_vertical ? 0 : bool_chain_side ? 1 : -1;
	
	_height = size_z_motor_shaft_full-size_z_motor_mount;
	_height_motor_shaft_cutout = _height-size_z_sprocket;

	difference() {
		union() {
      // chain retainer
      translate([0, 0, _height/2]) {
        cylinder(h=_height, d=diameter_chain_retainer_outer, center=true);
      }
	    // chain guide mount screw hole
			mirror_copy([1, 0, 0]) {
		    translate([offset_xy_screw_guide, 0, _height/2]) {
		      cylinder(h=_height, d=diameter_head_guide, center=true);
		    }
			}
			// join to the main part
      translate([0, 0, _height/2]) {
	      cube([offset_xy_screw_guide*2, diameter_head_guide, _height], center=true);
      }
			attachment_mount_motor_bottom_ends(_height);
		}
    // motor shaft cutout
    translate([0, 0, (_height_motor_shaft_cutout/2)]) {
      cylinder(h=_height_motor_shaft_cutout+epsilon, r=radius_shaft_cutout, center=true);
    }
    // chain retainer
    translate([0, 0, (_height/2)]) {
      cylinder(h=_height+epsilon, d=diameter_chain_retainer, center=true);
    }
    // chain retainer
		difference() {
	    translate([0-(diameter_chain_retainer_outer*0.5), 0, (_height/2)+_height_motor_shaft_cutout]) {
	      cube([diameter_chain_retainer_outer, diameter_chain_retainer_outer, _height+epsilon], center=true);
	    }
			attachment_mount_motor_bottom_ends(_height);
		}
    // chain guide mount screw hole
		mirror_copy([1, 0, 0]) {
	    translate([offset_xy_screw_guide, 0, 0]) {
				screw_hole(_height, diameter_hole_guide, size_z_screw_head_guide, diameter_head_guide);
	    }
		}
	}
}

attachment_mount_motor_bottom();
