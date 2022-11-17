
module ota_adapter(height, diameter, sides, outer_diameter, offset, scale = 0.8) {
    translate([0, 0, offset]) {
        difference() {
            scale([scale, scale, 1])
                ngon3d(sides, height, (outer_diameter / 2)); 
            
            translate([0, 0, -height / 2])
                cylinder(h = height * 2, r = diameter / 2); 
        }
        
        // guide stubs for gluing 
        glue_stubs(x = diameter, z = -1.5, d = 1.5);
    }
}

module panel_cover(height, diameter, inner_diameter, thickness, offset, cable_width, cable_height) {
    translate([0, 0, offset])
        difference() {
            cylinder(h = height, d = diameter);

            union(){           
                // inside cutout
                translate([0, 0, -thickness])
                    cylinder(h = height, d = diameter - thickness);
                
                // guide hole cutouts
                glue_stubs(inner_diameter, height - thickness);
                
                // top cutout
                cylinder(h = height + thickness, d = inner_diameter);
                
                // Cable notch
                translate([0, diameter / 2 - thickness / 2, thickness])
                  cube([cable_width,cable_height,thickness * 2], center = true);
            }
        }
}

module panel_base(diameter, height = 2, cable_width) {
    translate([0, 0, height])
        difference() {
            ring(height, height, diameter - height);
            translate([0, diameter/2, height])
                cube(cable_width, center = true);
        }
    
    cylinder(h = height, d = diameter);
}

// Posts or holes to aid in aligning parts for gluing
module glue_stubs(x, z, d = 2) { 
    stub_x = x / 2 + d * 2;
    for (x1= [-stub_x, stub_x])
        translate([x1, 0, z])
            cylinder(h = d, r = d);
}

// N - sided 3d polygon 
module ngon3d(n, h, r) {
  linear_extrude(height=h)
    circle(r=r, $fn=n);
}

module ring(width, height, diameter) {
    difference() {
        cylinder(h = height, d = diameter);
        cylinder(h = height + width + 1, d = diameter - width * 2, center = true);
    }
}      

module top_rounded_cylinder(h,r,n) {
  rotate_extrude(convexity=1) {
    offset(r=n) offset(delta=-n) square([r,h]);
    square([r/2,h]);
    square([r,h/2]);
  }
}
