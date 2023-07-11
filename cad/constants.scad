// values defined here are not to be customised
// values that do not meet this requirement should go in parameters.scad instead

// number of fragments (used for gear teeth)
$fn = $preview ? 32 : 128;

// When a small distance is needed to overlap shapes for boolean cutting, etc.
epsilon = $preview ? 0.02 : 0;

// minimum printable thickness
thickness_standoff = 0.8;

pi = 3.14159265358979323846264338327950288419716939937510582;
