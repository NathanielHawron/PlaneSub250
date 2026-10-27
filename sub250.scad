include <scad/NACA3410.scad>

$fn = 64;

spar_diameter = 6;
subspar_diameter = 2.8;
wing_length = 135;
wing_chord = 115;
wing_twist = 0;
wing_skin = 0.1;
fuselage_width = 75;
fuselage_length = 300;
fuselage_height = 100;
motor_diameter = 7;
motor_length = 22;

clearance = 0.4;

module spar(length,diameter){
    rotate([0,90,0]){
        cylinder(length,diameter/2,diameter/2,true);
    }
};
module fuselage(l,w,h){
    cube([w,l,h],true);
}
module wing(length,chord,off,twist,skin){
    rotate([90,0,-90]){
        difference(){
            linear_extrude(height=length,center=true,twist=twist){
                translate([off,0,0]){
                    polygon(airfoil_profile*chord*(1+skin/chord));
                }
            }
            linear_extrude(height=length+skin,center=true,twist=twist){
                translate([off,0,0]){
                    polygon(airfoil_profile*chord);
                }
            }
        }
    }
}
module rib(width,chord,hole,holeOffset,control,controlOffset){
    rotate([90,0,-90]){
        difference(){
            linear_extrude(height=width,center=true){
                polygon(airfoil_profile*chord);
            }
            translate(holeOffset){
                cylinder(width*2,hole/2,hole/2,true);
            }
            translate(controlOffset){
                cylinder(width*2,control/2,control/2,true);
            }
        }
    }
}
module ribBase(width){
    rib(
        width,wing_chord,
        spar_diameter+clearance,[25,2.5,0],
        subspar_diameter+clearance,[wing_chord*0.7,2.5,0],
    );
}
module rib_servo(width,cutoff,servo,servoOffset,wire,wireOffset){
    difference(){
        ribBase(width);
        rotate([90,0,-90]){
            translate([cutoff,-25,-width]){
                cube([100,50,3*width]);
            }
            translate(servoOffset){
                cube(servo,true);
            }
            translate(wireOffset){
                cylinder(100,wire/2,wire/2,true);
            }
        }
    }
}
module rib_LED(size, offset){
    difference(){
        ribBase(3);
        translate(offset){
            rotate([90,0,-90]){
                cylinder(100,size/2,size/2,true);
            }
        }
    }
}
module rib_internal(width, size, offset){
    difference(){
        ribBase(width);
        translate(offset){
            rotate([0,90,0]){
                translate([0,size[1]/2,0]){
                    cylinder(100,size[2]/2,size[2]/2,true);
                }
                translate([0,-size[1]/2,0]){
                    cylinder(100,size[2]/2,size[2]/2,true);
                }
            }
            cube(size,true);
        }
    }
}
module rib_nacelle(size, wireOffset, length, diameter, offset, holeSide, gap){
    difference(){
        union(){
            rib_internal(diameter+2,size,wireOffset);
            rotate([90,0,0]){
                translate(offset){
                    cylinder(length+1+gap,diameter/2+1,diameter/2+1,true);
                }
            }
        }
        rotate([90,0,0]){
            translate(offset){
                cylinder(length+gap,diameter/2,diameter/2,true);
                translate([-holeSide*diameter/2,0,0]){
                    cube([diameter,diameter-1,length],true);
                }
            }
            translate(offset+[0,0,-(length+gap)/2]){
                cylinder(5,1.5,1.5,true);
            }
        }
    }
}

module ribs(side){
    closest = side*fuselage_width/2;
    farthest = side*wing_length+closest;
    oy = 25;
    oz = -2.5;
    translate([farthest-side*1.5,oy,oz]){
        rib_LED(4.75+clearance,[0,-15,1.5]);
    }
    translate([farthest*0.75+closest*0.25,oy,oz]){
        rib_servo(
            5,wing_chord*0.725,
            [16.77,8.84,100],[43,3.25,0],
            5,[15,1.5,0]
        );
    }
    translate([farthest*0.5+closest*0.5,oy,oz]){
        rib_nacelle(
            [100,12,8],[0,-46,3.25],
            motor_length+2,motor_diameter,
            [0,2,5],
            side,8
        );
    }
    translate([farthest*0.25+closest*0.75,oy,oz]){
        rib_internal(5,[100,12,8],[0,-46,3.25]);
    }
}

module render(){
    color("pink"){
        translate([0,0,0]){
            spar(wing_length*2+fuselage_width,spar_diameter);
        }
        translate([0,-wing_chord*0.7+25,0]){
            spar(wing_length*2+fuselage_width,subspar_diameter);
        }
    }
    color("red"){
        fuselage(fuselage_length,fuselage_width,fuselage_height);
    }
    color("lime",0.5){
        ribs(1);
        ribs(-1);
    }
    /*color("orange",0.5){
        translate([-(fuselage_width/2+wing_length/2),10,-2.5]){
            wing(wing_length,wing_chord,-15,-wing_twist,wing_skin);
        }
        translate([(fuselage_width/2+wing_length/2),10,-2.5]){
            scale([-1,1,1]){
                wing(wing_length,wing_chord,-15,-wing_twist,wing_skin);
            }
        }
    }*/
}
////render();
        rib_servo(
            5,wing_chord*0.725,
            [16.77,8.84,100],[43,3.25,0],
            5,[15,1.5,0]
        );