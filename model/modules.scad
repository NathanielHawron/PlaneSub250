include <parameters.scad>
include <../scad/NACA3415.scad>

module spar(length,radius){
    rotate([90,0,0]){
        cylinder(length,radius,radius,true);
    }
};
module rib(width,chord,type,params,side){
    rotate([90,0,0]){
        difference() {
            union(){
                linear_extrude(height=width,center=true){
                    polygon(airfoil_profile*chord);
                }
                // Additive component of rib
                for(i=[0:len(type)]){
                    t = type[i];
                    p = params[i];
                    if(t=="TRUNCATE"){
                    }else if(t=="LED"){
                    }else if(t=="NACELLE"){
                        translate(p[0]){
                            rotate([-p[1],90,0]){
                                intersection(){
                                    cylinder(p[2]+2*p[4],p[3]/2+p[4],p[3]/2+p[4],true);
                                    cube([width,100,100],true);
                                }
                            }
                        }
                    }
                }
            }
            // Subtractive component of rib
            for(i=[0:len(type)]){
                t = type[i];
                p = params[i];
                if(t=="TRUNCATE"){
                    translate([chord/2+p[0],0,0]){
                        cube([chord,chord,width*2],true);
                    }
                }else if(t=="LED"){
                    translate(p[0]){
                        cylinder(width*2,p[1]/2,p[1]/2,true);
                    } 
                }else if(t=="NACELLE"){
                    translate(p[0]){
                        rotate([-p[1],90,0]){
                            cylinder(p[2],p[3]/2,p[3]/2,true);
                            translate([0,0,-p[2]/2-p[4]/2]){
                                cylinder(p[4]*2,p[5]/2,p[5]/2,true);
                            }
                            translate([-side*width/2,0,0]){
                                cube([p[6][0],width,p[6][1]],true);
                            }
                        }
                    }
                }else if(t=="SERVO"){
                    
                }
            }
        }
    }
}