use <./parts.scad>

$fa = 1;
$fs = 0.4;

// All measurements are in millimeters 

// OTA outer diameter
tube_diameter= 105;
tube_height= 40;

// Light Panel 
panel_diameter = 163;
panel_height = 20;

// Wall thickness
thickness = 2;

panel_cover_diameter = panel_diameter + thickness;
panel_cover_height = panel_height + thickness;

// A simple ring to test for fit
// print this first and slide over the front of the OTA
// When complete, disable by prepending '*'
*ring(2,2,tube_diameter);

// Parts should be printed independently and glued
// Remove the '*' to render the part
ota_adapter(tube_height, tube_diameter, panel_cover_diameter, panel_cover_height + thickness);
panel_cover( panel_cover_height, panel_cover_diameter, tube_diameter, thickness, thickness);
panel_base(panel_cover_diameter);
