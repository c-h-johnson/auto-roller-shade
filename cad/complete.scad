include <MCAD/multiply.scad>
include <MCAD/regular_shapes.scad>
include <nopscadlib/core.scad> // VERY IMPORTANT
include <nopscadlib/vitamins/pcbs.scad>
include <nopscadlib/vitamins/screws.scad>

include <common.scad>

use <attachment_mount_motor_bottom.scad>
use <attachment_power_plug.scad>
use <case_bottom.scad>
use <case_top.scad>
use <drive.scad>
use <mount_driver.scad>
use <mount_mcu.scad>
use <mount_motor.scad>

offset_case_top = max(size_y1_case, size_y2_case)+10;
// offset_case_top = 0;

cutaway_x = 0;
// cutaway_x = -100+position_x_stepper;
// cutaway_y = -100;
cutaway_y = 300;
// cutaway_y = 0;
cutaway_z = 0;

_size_x_chain = 100;

module _chain() {
	difference() {
		union() {
			torus2(r1=diameter_sprocket/2, r2=diameter_chain_rope/2);
			spin(teeth_sprocket) {
				translate([diameter_sprocket/2,0,0]){
					sphere(d=diameter_chain_bead);
				}
			}
		}
		translate([0, diameter_sprocket/-2, 0]) {
			cube([diameter_sprocket+(diameter_chain_rope*2), diameter_sprocket, diameter_chain_bead], center=true);
		}
	}
	mirror_copy([1, 0, 0]) {
		translate([diameter_sprocket/2, _size_x_chain/-2, 0]) {
			rotate([90, 0, 0]) {
				cylinder(h=_size_x_chain, d=diameter_chain_rope, center=true);
			}
		}
	}
	linear_multiply(no=_size_x_chain/separation_chain_bead, separation=-separation_chain_bead, axis=[0, 1, 0]) {
		// TODO make the beads go around the chain for animation
		union() {
			translate([diameter_sprocket/2, 0, 0]) {
				sphere(d=diameter_chain_bead);
			}
			translate([diameter_sprocket/-2, 0, 0]) {
				sphere(d=diameter_chain_bead);
			}
		}
	}
}

module _motor() {
	_position_box = (size_x_motor_gearbox/2)-((size_x_motor/2)+offset_x_motor_shaft);
	_diameter_motor_engine = 24.2;

	color("silver") {
		motor_shaft(h=size_z_motor+size_z_motor_shaft_full-epsilon);
		translate([_position_box, 0, size_z_motor_shaft_full/-2]) {
			// TODO replace with `roundedCube` in newer version of MCAD
			roundedBox([size_x_motor_gearbox, size_y_motor, size_z_motor], 1, true);
		}
		translate([_position_box+((size_x_motor_gearbox+size_x_motor_engine)/2), 0, ((size_z_motor_shaft_full+size_z_motor-_diameter_motor_engine)/-2)]) {
			rotate([0, 90, 0]) {
				cylinder(h=size_x_motor_engine, d=_diameter_motor_engine, center=true);
			}
		}
	}
}

module complete() {
	case_bottom();
	translate([0,offset_case_top,size_z_case]) {
		rotate([180,0,0]) {
			case_top();
		}
		case_screws() {
			translate([0, 0, -size_z_screw_head_case]) {
				screw(M3_cap_screw, size_z_case-size_z_screw_head_case);
			}
		}
	}
	
	translate([0, offset_case_top, thickness_z_case+size_z_motor]) {
		mount_motor();
		translate([position_x_drive, 0, size_z_motor_mount]) {
			if (bool_separate_chain_retainer) {
				attachment_mount_motor_bottom();
			}
		}
	}

	translate([position_x_pcbs, size_y1_case/2, thickness_z_case+(size_z_case_internal/2)]) {
		rotate([90, 0, 0]) {
			mount_mcu();
			translate([0, 0, standoff_height_mcu+3.6]) {
				rotate([0, 180, 0]) {
					pcb(RPI_Pico);
				}
				mirror_copy([1, 0, 0]) {
					mirror_copy([0, 1, 0]) {
						translate([standoff_separation_x_mcu/2, standoff_separation_y_mcu/2, 0]) {
							screw(M2_cap_screw, standoff_height_mcu);
						}
					}
				}
			}
		}
	}

	translate([position_x_pcbs, size_y1_case/-2, thickness_z_case+(size_z_case_internal/2)]) {
		rotate([-90,0,0]) {
			mount_driver();
			translate([0, 0, standoff_height_driver+2]) {
				pcb(L9110S);
				mirror_copy([1, 0, 0]) {
					mirror_copy([0, 1, 0]) {
						translate([standoff_separation_x_driver/2, standoff_separation_y_driver/2, 1.6]) {
							screw(M3_cap_screw, standoff_height_driver);
						}
					}
				}
			}
		}
	}

	translate([position_x_drive, 0, thickness_z_case+size_z_motor+size_z_motor_shaft_full]) {
		rotate([180, 0, 0]) {
			drive();
		}
		translate([(diameter_motor_shaft/2)+offset_motor_key+size_z_screw_thread_coupling, 0, -(size_z_sprocket+(diameter_head_coupling/2)+margin)]) {
			rotate([0, 90, 0]) {
				screw(M3_cap_screw, size_z_screw_thread_coupling);
			}
		}
		translate([0, 0, size_z_sprocket/-2]) {
			#_chain();
		}
		translate([0, 0, (size_z_motor+size_z_motor_shaft_full)/-2]) {
			_motor();
		}
	}

	if (bool_power_plug) {
		translate([((size_x_case-size_x_power_plug)/2)-thickness_xy_case_compartment_1, position_y_power_plug, size_z_case_bottom-size_z_attachment_power_plug]) {
			rotate([0, 0, 180]) {
				attachment_power_plug();
			}
		}
	}

	wall_screws() {
		translate([0, 0, 2]) {
			screw(M4_dome_screw, 30);
		}
	}
}

difference() {
	// rendering takes too long and is pointless
	if ($preview) {
		complete();
	}
	translate([cutaway_x, cutaway_y, cutaway_z]) {
		cube([200, 200, 200], center = true);
	}
}
