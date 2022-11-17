/*
Case and OTA adapter for an Ellumiglow round EL panel: 
https://www.ellumiglow.com/electroluminescence/astrophotography

Render STL using OpenSCAD:
https://openscad.org/
*/

use <./parts.scad>

$fa = 1;
$fs = 0.4;

// All measurements are in millimeters 

// OTA adapter 
adapter_diameter = 105; // add 1mm for clearance
adapter_height = 40;
adapter_sides = 8;

// Wall thickness
thickness = 2;

// Light Panel measurements
panel_diameter = 163;
panel_height = 5;
cable_width = 23;
cable_height = 5;

panel_cover_diameter = panel_diameter + thickness * 2;
panel_cover_height = panel_height + thickness;

// Print this first and slide over the front of the OTA to check for fit
// When complete, disable by prepending '*'
*ring(2, 2, adapter_diameter);

// Parts should be printed independently and glued
// Remove the '*' to render the part
*ota_adapter(adapter_height, adapter_diameter, adapter_sides, panel_cover_diameter, panel_cover_height + thickness);
*panel_cover(height = panel_cover_height, diameter = panel_cover_diameter, inner_diameter = adapter_diameter, thickness = thickness, offset = thickness, cable_width = cable_width, cable_height = cable_height);
*panel_base(panel_cover_diameter, cable_width = 23);
