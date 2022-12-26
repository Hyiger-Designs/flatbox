
module ota_adapter(height, diameter, sides, outer_diameter, offset, scale = .8, text = "") {
    translate([0, 0, offset]) {
        difference() {
            scale([scale, scale, 1])
                ngon3d(sides, height, (outer_diameter / 2)); 
            
            union() {
                translate([0, 0, -height / 2])
                    cylinder(h = height * 2, r = diameter / 2); 
                
                font_size = 8;
                translate([0,(outer_diameter / 2) * scale - font_size * 1.25, height - 2])
                    rotate([180,180.0])
                        label(text, font_size, 5);
            }
        }
        
        // guide stubs for gluing 
        glue_stubs(x = diameter, z = -2, h = 4);
        

    }
}
 
module panel_cover(height, diameter, inner_diameter, thickness, offset, cable_width, cable_height) {
    translate([0, 0, offset])
        difference() {
            cylinder(h = height, d = diameter);

            union(){           
                translate([0, 0, -thickness])
                    cylinder(h = height, d = diameter - thickness * 2);
                
                // guide hole cutouts
                glue_stubs(x = inner_diameter, z = - thickness + height/2, h = height + 1, d = 2.2);
                
                // top cutout
                cylinder(h = height + thickness, d = inner_diameter - thickness);
                
                // cable notch
                translate([0, (diameter - thickness) / 2, thickness /2])
                  cube([cable_width, thickness * 2, cable_height], center = true);
            }
        }
}

module panel_base(diameter, height, cable_width) {
    translate([0, 0, height])
        difference() {
            ring(height, height/2, diameter - height * 2);
            translate([0, diameter/2, height])
                cube(cable_width, center = true);
        }
    
    cylinder(h = height, d = diameter);
}

// Utility Functions

module label(string, size, height, font = "Liberation Sans", halign = "center", valign = "center") {
    linear_extrude(height) {
        text(text=string, size=size, font=font, halign = halign, valign = valign, $fn = 64);
    }
}

// Posts or holes to aid in aligning parts for gluing
module glue_stubs(x, z, h = 2, d = 2) { 
    stub_x = x / 2 + d * 2;
    for (x1= [-stub_x, stub_x])
        translate([x1, 0, z])
            cylinder(h = h, r = d);
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
