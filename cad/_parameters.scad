// this file is to customize the output
// it should be unique to your specific requirements

// all measurements in millimetres unless otherwise stated
// defaults provided here are for raspberry pi pico w as mcu and a l9110s driver

// minimum distance around components
margin = 1;

// angle to the horizontal plane
// increase to improve print quality, decrease to obviate supports
angle_max_slope = 60;

// false for chain of left side of window, true for right
bool_chain_side = false;
// should the usb port be pointing down?
// ideally should be true but in most cases there is not enough clearance
// make sure there is at least a 20cm gap between the lowest point on the chain and the windowsill/floor before setting to true
bool_vertical = false;

// add attachements to the case bottom to screw to wall
bool_wall_mount = true;

// only takes effect when the motor shaft cutout is larger than the chain retainer i.e. the chain retainer would overhang the base
// if you think you might be adjusting the parameters a lot then set to true
bool_force_separate_chain_retainer = false;

thickness_xy_case_compartment_1 = 2;
thickness_xy_case_compartment_2 = 5;
thickness_z_case = 2;
case_bevel_radius_outer = 5;
case_bevel_radius_inner = 1;
size_z_case_top_stepper_holder = 5;
// internal size of pcb compartment
size_y1_case_internal = 50;

// mount used to attach mcu and driver modules
thickness_base_mount_pcb = 2;
radius_bevel_base_mount_pcb = 5;
// must be larger than `thickness_base_mount_pcb`
// increase for more support but more likely to break
// recommended value: 2*thickness_base_mount_pcb
size_z_mount_pcb_dovetail = 4;

// these 2 values directly correspond to the size of the cutout for the micro usb cable b
// smallest
size_y_usb = 11;
// largest
size_z_usb = 13;

// 12V power
bool_power_plug = false;
// depth
size_x_power_plug = 15;
// profile
size_y_power_plug = 9;
size_z_power_plug = 11;
// for hole in attachment
size_x_power_plug_prongs = 9;
offset_y_power_plug_prongs = 2;
// (M3)
diameter_head_power_plug = 5.5;
diameter_hole_power_plug = 3;
diameter_thread_power_plug = 2.85;

// case screws
// M3 (socket cap)
diameter_head_case = 5.5;
diameter_hole_case = 3;
diameter_thread_case = 2.85;
size_z_screw_head_case = 3;

// wall mount
// M4 (dome cap) (countersink not supported)
diameter_head_wall = 8;
diameter_hole_wall = 4;
// increase strength of wall mount
size_z_mount_wall = 5;

// consider largest length and width (with the x being the largest of the 2)
// nodemcu
// size_x_mcu = 57;
// size_y_mcu = 30.5;
// rpi pico
size_x_mcu = 51;
size_y_mcu = 21;

// L9110S
size_x_driver = 29.2;
size_y_driver = 23;
// L298N
// size_x_driver = 44.1;
// size_y_driver = 44.1 + 10; // extra space for wires

standoff_height_mcu = 4;
standoff_height_driver = 2;

// distance between centers of 2 holes
// nodemcu
// standoff_separation_x_mcu = 51.5;
// standoff_separation_y_mcu = 25;
// rpi pico
standoff_separation_x_mcu = 47;
standoff_separation_y_mcu = 11.4;

// L9110S
standoff_separation_x_driver = 13;
standoff_separation_y_driver = 18.2;
// L298N
// standoff_separation_x_driver = 37.3;
// standoff_separation_y_driver = 36.7;

// diameter of the holes of the standoffs on the mount
// nodemcu (M3)
// diameter_thread_mcu = 2.85;
// rpi pico (M2)
diameter_thread_mcu = 1.95;

// L9110S
// L298N
// (M3)
diameter_thread_driver = 2.85;

// how much the motor can intrude into the pcb compartment
offset_x_motor = 10;
// must be large enough such that the drive slides on easily but small enough that it does not wobble
diameter_motor_shaft = 6.2;
// only the flat part
size_z_motor_shaft = 12.3;
// depth of the flat part compared to the opposing point on the circumference
offset_motor_key = -0.5;
offset_x_motor_shaft = -24.6; // [offset from the side opposite the engine]-(size_x_motor/2)
offset_z_motor_shaft = 1.6; // compared to the highest point on the gearbox
size_x_motor = 78;
size_y_motor = 32;
// not including shaft
size_z_motor = 26;
size_x_motor_gearbox = 46;
separation_y_motor_mount = 18;
// following 2 offsets are from the nearest end of the gearbox
offset_x1_motor_mount = 7.4; // from the engine side
offset_x2_motor_mount = 5.4;
size_z_motor_mount = 5;
// screw mount (M3)
diameter_hole_motor = diameter_hole_case;
diameter_head_motor = diameter_head_case;
size_z_screw_head_motor = size_z_screw_head_case;

thickness_coupling = 5;
diameter_thread_coupling = diameter_thread_case;
diameter_head_coupling = diameter_head_case;
size_z_screw_head_coupling = size_z_screw_head_case;
// should be the shortest screw you have.
// need to be about 1 shorter than the actual screw or it will not be able to go in far enough
size_z_screw_thread_coupling = 3;

// should be the diameter of the bead
size_z_sprocket = 4.5;
// ideally should be diameter_chain_bead/2 but can increase if chain closer to wall
offset_z_sprocket_chain = 2.25;
diameter_chain_bead = 4.5;
diameter_chain_rope = 1.25;
separation_chain_bead = 12.25;
// 3 in considered the minimum, although 2 might be feasible in some circumstances
teeth_sprocket = 4;
// must leave enough clearance to guarantee chain does not hit wall in the worst case
size_cutout_chain = 40;
// increase if beads get stuck, decrease if chain slips
margin_chain_retainer = 0.25;

// M3
diameter_thread_guide = diameter_thread_case;
diameter_hole_guide = diameter_hole_case;
diameter_head_guide = diameter_head_case;
size_z_screw_head_guide = size_z_screw_head_case;

offset_xy_screw_guide = 18;
