 /*
Light Box for Astrophotography Flats
Case and OTA adapter for an Ellumiglow round panel:
https://www.ellumiglow.com/electroluminescence/astrophotography

Render STL using OpenSCAD:
https://openscad.org/
*/

use <parts.scad>

$fa = 1;
$fs = 0.4;

// All measurements are in millimeters

// OTA adapter - configuration for William Optics GT81
// GT81: 105mm
// AT130: 173mm
adapter_diameter = 172; // Outside diameter of telescope, add 1mm for clearance
adapter_height = 40;
adapter_sides = 12;
adapter_text = "AT130";

// Light Panel - configuration for Ellumiglow 6" AST060
// 6" panel: 164mm
// 8" panel: 209mm
// 10" panel: 263mm
panel_diameter = 209;
panel_height = 5; // Include space for acrylic cover

cable_width_short = 12;
cable_width_long = 22;
cable_length = 26;
cable_height = 5;

// Wall thickness
thickness = 2;

// Panel Cover
panel_cover_diameter = panel_diameter + thickness * 2;
panel_cover_height = panel_height + thickness;

// Parts should be printed independently
// Use '!' to render a specific part, only 1 part at a time can be prepended with '!'

// Print this first and slide over the front of the OTA to check for fit
*ring(2, 2, adapter_diameter);

// Infill: 10%
!color("FireBrick", 1.0) ota_adapter(adapter_height, adapter_diameter, adapter_sides, panel_cover_height + thickness,
                                     text = adapter_text, font_size = 8);

// For sizes larger than the print bed, set quarter to 0 - 3 to print each 1/4 of the panel base and cover
quarter = "";

// Infill: 20%
color("Gray", 1.0) panel_cover(panel_cover_height, panel_cover_diameter, adapter_diameter, thickness, thickness,
                               cable_width_short, cable_width_long, cable_length, cable_height, quarter);

// The base can be press fit against the panel cover
// Infill: 20%
color("White", 1.0)
    panel_base(panel_cover_diameter, thickness, cable_width_short, cable_width_long, cable_length, thickness, quarter);