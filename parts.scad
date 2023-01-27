module ota_adapter(height, diameter, sides, offset, text = "", font_size = 8)
{
    translate([ 0, 0, offset ])
    {
        difference()
        {
            outer_radius = diameter * 0.64;
            ngon3d(sides, height, outer_radius);

            union()
            {
                // Inner cutout - fits over tube
                translate([ 0, 0, -height / 2 ]) cylinder(h = height * 2, r = diameter / 2);

                // Inset text
                width = outer_radius - (diameter / 2);
                translate([ 0, outer_radius + font_size - (width * 1.15), height - 2 ]) rotate([ 180, 180 ])
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
                iso_trapazoid(cable_width_short + thickness * 2, cable_width_long + thickness * 2, cable_length,
                              cable_height + thickness);
                translate([ 0, -1, -thickness ]) iso_trapazoid(cable_width_short, cable_width_long,
                                                               cable_length + thickness, cable_height + thickness);
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
                iso_trapazoid(cable_width_short + thickness * 2, cable_width_long + thickness * 2, cable_length, 2);
        }

        if (quarter != "")
            quarter_slice(diameter, height, quarter);
    }
}

// Utility Modules

// Used with intersect to slice a part into quarters
module quarter_slice(width, height, quarter = "")
{
    if (quarter == "0")
        translate([ 0, 0, 0 ]) cube([ width, width, height + 1 ]);
    if (quarter == "1")
        translate([ 0, -width, 0 ]) cube([ width, width, height + 1 ]);
    if (quarter == "2")
        translate([ -width, -width, 0 ]) cube([ width, width, height + 1 ]);
    if (quarter == "3")
        translate([ -width, 0, 0 ]) cube([ width, width, height + 1 ]);
}

// Text Label for OTA Adapter
module label(string, size, height, font = "Liberation Sans", halign = "center", valign = "center")
{
    linear_extrude(height)
    {
        text(text = string, size = size, font = font, halign = halign, valign = valign, $fn = 64);
    }
}

// Posts or holes to aid in aligning parts for gluing
module posts(x, z, h = 2, d = 2)
{
    stub_x = x / 2 + d * 2;
    for (x1 = [ -stub_x, stub_x ])
        translate([ x1, 0, z ]) cylinder(h = h, r = d);
}

// N - sided 3d polygon
module ngon3d(n, h, r)
{
    linear_extrude(height = h) circle(r = r, $fn = n);
}

// A thin ring
module ring(width, height, diameter)
{
    difference()
    {
        cylinder(h = height, d = diameter);
        cylinder(h = height + width + 1, d = diameter - width * 2, center = true);
    }
}

// 3D Isosceles Trapazoid
module iso_trapazoid(short, long, length, height, center = true)
{
    linear_extrude(height) translate([ center ? -long / 2 : 0, 0, 0 ])
        polygon(points = [ [ 0, 0 ], [ long / 2 - short / 2, length ], [ long / 2 + short / 2, length ], [ long, 0 ] ]);
}