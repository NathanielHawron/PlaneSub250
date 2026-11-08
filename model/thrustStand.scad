include <./parameters.scad>

module stand(diameter, length, width, thickness, shaft, base, offset){
    r = diameter/2;
    union(){
        difference(){
            intersection(){
                cylinder(length+thickness*2,r+thickness,r+thickness,true);
                translate([0,-offset,0]){
                    cube([100,width,length*2],true);
                } 
            }
            cylinder(length,r,r,true);
            translate([0,0,(length+thickness)*0.5]){
                cylinder(thickness*2,shaft/2,shaft/2,true);
            }
        }
        translate([0,0,-(length+thickness)/2]){
            intersection(){
                cylinder(thickness, base, base, true);
                translate([0,base/2-width/4-offset,0]){
                    cube([100,base+width/2,base],true);
                } 
            }
        } 
    }
}

stand(motor_diameter+0.5,motor_length*1.75,6,1,4,10,0.5);