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

// OTA outer diameter, add 1mm for clearance
adapter_diameter= 105;
adapter_height= 40;

// Light Panel 
panel_diameter = 163;
panel_height = 20;

// Wall thickness
thickness = 2;

panel_cover_diameter = panel_diameter + thickness;
panel_cover_height = panel_height + thickness;

// Print this first and slide over the front of the OTA to check for fit
// When complete, disable by prepending '*'
*ring(2, 2, adapter_diameter);

// Parts should be printed independently and glued
// Remove the '*' to render the part
ota_adapter(adapter_height, adapter_diameter, panel_cover_diameter, panel_cover_height + thickness);
panel_cover( panel_cover_height, panel_cover_diameter, adapter_diameter, thickness, thickness);
panel_base(panel_cover_diameter);
