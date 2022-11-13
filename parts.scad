module ota_adapter(height, diameter, outer_diameter, offset, scale = 0.8) {
    translate([0, 0, offset]) {
        difference() {
            scale([scale, scale, 1])
                ngon3d(12, height, (outer_diameter / 2)); 
            
            translate([0, 0, -height / 2])
                cylinder(h = height * 2, r = diameter / 2); 
        }
        
        // guide stubs for gluing 
        glue_stubs(diameter, -2);
    }
}


module panel_cover(height, diameter, inner_diameter, thickness, offset) {
    translate([0, 0, offset])
        difference() {
            top_rounded_cylinder(height, diameter/2, 10);

            union(){           
                // inner cutout
                translate([0, 0, -thickness])
                    top_rounded_cylinder(height, diameter/2 - thickness, 10);
                
                // guide hole cutouts
                glue_stubs(inner_diameter, height - thickness);
                
                // top cutout
                cylinder(h = height + thickness, r = inner_diameter/2);
                
                // Cable notch
                translate([0, diameter / 2 - thickness / 2,0])
                  cube(thickness * 5, center = true);
            }
        }
}

module panel_base(diameter, width = 2) {
    translate([0, 0, width])
        ring(width, 20, diameter - 8);
    cylinder(h = width, r = diameter/2);
}

// Posts or holes to aid in aligning parts for gluing
module glue_stubs(x, z, width = 2) { 
    stub_x = x / 2 + width * 2;
    for (x1= [-stub_x, stub_x])
        translate([x1, 0, z])
            cylinder(h = width, r = width);
}

// N - sided polygon 
module ngon3d(n, h, r) {
  linear_extrude(height=h)
    circle(r=r, $fn=n);
    //polygon([for (i=[0:n-1], a=i*360/n) [ r*cos(a), r*sin(a) ]]);
}

module ring(width, height, diameter) {
  rotate_extrude()
    translate([diameter/2,0,0])
      square(width, height);
}    

module rounded_cylinder(h,r,n) {
  rotate_extrude(convexity=1) {
    offset(r=n) offset(delta=-n) square([r,h]);
    square([n,h]);
  }
}

module top_rounded_cylinder(h,r,n) {
  rotate_extrude(convexity=1) {
    offset(r=n) offset(delta=-n) square([r,h]);
    square([r/2,h]);
    square([r,h/2]);
  }
}
