
module ota_adapter(height, diameter, sides, outer_diameter, offset, scale = 0.8, text = "")
{
    translate([ 0, 0, offset ])
    {
        difference()
        {
            scale([ scale, scale, 1 ]) ngon3d(sides, height, (outer_diameter / 2));

            union()
            {
                translate([ 0, 0, -height / 2 ]) cylinder(h = height * 2, r = diameter / 2);

                font_size = 8;
                translate([ 0, (outer_diameter / 2) * scale - font_size * 1.1, height - 2 ]) rotate([ 180, 180 ])
                    label(text, font_size, 5);
            }
        }

        // guide stubs for panel cover guide holes
        stubs(x = diameter, z = -2, h = 4);
    }
}

module panel_cover(height, diameter, inner_diameter, thickness, offset, cable_width_short, cable_width_long,
                   cable_length, cable_height)
{
    translate([ 0, 0, offset ]) difference()
    {
        cylinder(h = height, d = diameter);

        union()
        {
            translate([ 0, 0, -thickness ]) cylinder(h = height, d = diameter - thickness * 2);

            // guide hole cutouts
            stubs(x = inner_diameter, z = -thickness + height / 2, h = height + 1, d = 2.2);

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
        translate([ 0, -1, -thickness ])
            iso_trapazoid(cable_width_short, cable_width_long, cable_length + thickness, cable_height + thickness);
    }
}

module panel_base(diameter, height, cable_width_short, cable_width_long, cable_length, thickness = 2)
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

// Utility Modules

// Text Label for OTA Adapter
module label(string, size, height, font = "Liberation Sans", halign = "center", valign = "center")
{
    linear_extrude(height)
    {
        text(text = string, size = size, font = font, halign = halign, valign = valign, $fn = 64);
    }
}

// Posts or holes to aid in aligning parts for gluing
module stubs(x, z, h = 2, d = 2)
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
