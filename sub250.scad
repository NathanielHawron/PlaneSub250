include <scad/NACA3415.scad>

$fn = 64;

spar_diameter = 6;
subspar_diameter = 2.8;
wing_length = 225;
wing_chord = 90;
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
module rib_truncate(width,cutoff,wire,wireOffset){
    difference(){
        ribBase(width);
        rotate([90,0,-90]){
            translate([cutoff,-25,-width]){
                cube([100,50,3*width]);
            }
            translate(wireOffset){
                cylinder(100,wire/2,wire/2,true);
            }
        }
    }
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
module rib_nacelle(width, size, wireOffset, length, diameter, offset, holeSide, gap){
    difference(){
        union(){
            rib_internal(width,size,wireOffset);
            rotate([90,0,0]){
                translate(offset){
                    intersection(){
                        cylinder(length+1+gap,diameter/2+1,diameter/2+1,true);
                        cube([width,diameter+2,length*2],true);
                    }
                }
            }
        }
        rotate([90,0,0]){
            translate(offset){
                cylinder(length+gap,diameter/2,diameter/2,true);
                translate([-holeSide*diameter/2,0,0]){
                    cube([diameter,diameter-3*clearance,length],true);
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
    dt = 1/6;
    translate([farthest-side*1.5,oy,oz]){
        rib_LED(4.75+clearance,[0,-15,1.5]);
    }
    translate([farthest*(5*dt)+closest*(dt),oy,oz]){
        rib_truncate(
            5,wing_chord*0.725,
            5,[15,1.5,0]
        );
    }
    translate([farthest*(4*dt)+closest*(2*dt),oy,oz]){
        rib_servo(
            5,wing_chord*0.725,
            [16.77,8.84,100],[43,2.5,0],
            5,[15,1.5,0]
        );
    }
    translate([farthest*(3*dt)+closest*(3*dt),oy,oz]){
        rib_nacelle(
            7,
            [100,10,6],[0,-50,2],
            motor_length+motor_diameter,motor_diameter+clearance,
            [0,2,0],
            side,8
        );
    }
    translate([farthest*(2*dt)+closest*(4*dt),oy,oz]){
        rib_internal(5,[100,10,7],[0,-50,2]);
    }
    translate([farthest*(dt)+closest*(5*dt),oy,oz]){
        rib_internal(5,[100,10,7],[0,-50,2]);
    }
}
module aileron(width,chord,control,controlOffset,cutoff,gap0,gap0Diameter,gap0Offset,gap1,gap1Diameter,gap1Offset){
    rotate([90,0,-90]){
        union(){
            difference(){
                linear_extrude(height=width,center=true){
                    polygon([
                        [chord,-0.2],
                        [chord,0.2],
                        [cutoff,6],
                        [cutoff,-2]
                    ]);
                }
                translate(controlOffset){
                    cylinder(width*2,control/2,control/2,true);
                }
                cube([cutoff*2,1000,1000],true);
                translate(controlOffset+[0,0,gap0Offset]){
                    cylinder(gap0+2*clearance,gap0Diameter/2,gap0Diameter/2,true);
                }
                translate(controlOffset+[0,0,gap1Offset]){
                    cylinder(gap1+2*clearance,gap1Diameter/2,gap1Diameter/2,true);
                }
            }
            translate([cutoff+10,-6,13.5-6]){
                difference(){
                    union(){
                        cylinder(5,control/2+1,control/2+1,true);
                        translate([0,3,0]){
                            cube([control+2,control+2,5],true);

                        }
                    }
                    cylinder(11,control/2,control/2,true);
                }
            }
        }
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
    color("blue"){
        closest = fuselage_width/2;
        farthest = wing_length+closest;
        dt = 1/6;
        translate([farthest*4.5*dt+closest*1.5*dt+0.25,25,-2.5]){
            aileron(
                (farthest*6*dt+closest*0*dt)-(farthest*3*dt+closest*3*dt)-6.5-4*clearance,wing_chord,
                subspar_diameter+clearance,[wing_chord*0.7,2.5,0],
                wing_chord*0.66,
                5,14,19,
                5,14,-18.5,
            );
        }
        translate([-(farthest*4.5*dt+closest*1.5*dt+0.25),25,-2.5]){
            scale([-1,1,1]){
                aileron(
                    (farthest*6*dt+closest*0*dt)-(farthest*3*dt+closest*3*dt)-6.5-4*clearance,wing_chord,
                    subspar_diameter+clearance,[wing_chord*0.7,2.5,0],
                    wing_chord*0.66,
                    5,14,19,
                    5,14,-18.5,
                );
            }
        }
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
render();
