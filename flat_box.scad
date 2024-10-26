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
// RC71: 104mm
// GT81: 105mm
// AT130: 173mm
adapter_diameter = 121; // Outside diameter of telescope, add 1mm for clearance
adapter_height = 30;
adapter_sides = 12;
adapter_text = "GT81 WIFD";
font_size = 5;

// Light Panel - configuration for Ellumiglow 6" AST060
// 5" panel: 141mm
// 6" panel: 164mm
// 8" panel: 209mm
// 10" panel: 263mm
panel_diameter = 164;
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
color("FireBrick", 1.0) ota_adapter(adapter_height, adapter_diameter, adapter_sides, panel_cover_height + thickness,
                                    text = adapter_text, font_size = font_size);

// For sizes larger than the print bed, set quarter to 0 - 3 to print each 1/4 of the panel base and cover
quarter = "";

// Infill: 20%
color("Gray", 1.0) panel_cover(panel_cover_height, panel_cover_diameter, adapter_diameter, thickness, thickness,
                               cable_width_short, cable_width_long, cable_length, cable_height, quarter);

// The base can be press fit against the panel cover
// Infill: 20%
color("White", 1.0)
    panel_base(panel_cover_diameter, thickness, cable_width_short, cable_width_long, cable_length, thickness, quarter);

module ota_adapter(height, diameter, sides, offset, text = "", font_size = 8)
{
    translate([ 0, 0, offset ])
    {
        difference()
        {
            outer_radius = (diameter / 2) * 1.2;
            ngon3d(sides, height, outer_radius);

            union()
            {
                // Inner cutout - fits over tube
                translate([ 0, 0, -height / 2 ]) cylinder(h = height * 2, r = diameter / 2);

                // Inset text
                width = outer_radius - (diameter / 2);
                translate([ 0, outer_radius + font_size - width - 1, height - 2 ]) rotate([ 180, 180 ])
                    label(text, font_size, 5);
            }
        }

        // guide stubs for panel cover guide holes
        posts(x = diameter, z = -2, h = 4);
    }
}

module panel_cover(height, diameter, inner_diameter, thickness, offset, cable_width_short, cable_width_long,
                   cable_length, cable_height, quarter = "")
{
    intersection()
    {
        union()
        {
            translate([ 0, 0, offset ]) difference()
            {
                cylinder(h = height, d = diameter);

                union()
                {
                    // central cutout
                    translate([ 0, 0, -thickness ]) cylinder(h = height, d = diameter - thickness * 2);

                    // guide hole cutouts
                    posts(x = inner_diameter, z = -thickness + height / 2, h = height + 1, d = 2.2);

                    // top cutout
                    cylinder(h = height + thickness, d = inner_diameter - thickness);

                    // cable cutout
                    translate([ 0, (diameter - thickness) / 2, thickness / 2 + 1.5 ])
                        cube([ cable_width_long, thickness * 2, cable_height ], center = true);
                }
            }

            // top cable cover
            translate([ 0, diameter / 2 - thickness - 0.5, thickness ]) difference()
            {
                iso_trapazoid(cable_width_short + thickness * 2, cable_width_long + thickness * 2,
                              cable_height + thickness, cable_length);
                translate([ 0, -1, -thickness ]) iso_trapazoid(cable_width_short, cable_width_long,
                                                               cable_height + thickness, cable_length + thickness);
            }
        }

        if (quarter != "")
            quarter_slice(diameter, height, quarter);
    }
}

module panel_base(diameter, height, cable_width_short, cable_width_long, cable_length, thickness = 2, quarter = "")
{
    intersection()
    {
        union()
        {
            translate([ 0, 0, height ]) difference()
            {
                ring(height, height / 2, diameter - height * 2);
                translate([ 0, diameter / 2, height ]) cube(cable_width_long, center = true);
            }

            cylinder(h = height, d = diameter);

            // bottom cable cover
            translate([ 0, diameter / 2 - (thickness + 0.5), 0 ])
                iso_trapazoid(cable_width_short + thickness * 2, cable_width_long + thickness * 2, 2, cable_length);
        }

        if (quarter != "")
            quarter_slice(diameter, height, quarter);
    }
}