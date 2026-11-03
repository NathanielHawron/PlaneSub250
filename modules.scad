module spar(length,diameter){
    rotate([0,90,0]){
        cylinder(length,diameter/2,diameter/2,true);
    }
};
module crossBracket(d0,h0,d1,h1,dist,t,c0,c1){
    r0 = d0/2+c0;
    r1 = d1/2+c1;
    delta = r0+r1+dist;
    difference(){
        union(){
            cylinder(h0,r0+t,r0+t,true);
            translate([0,delta,0]){
                rotate([0,90,0]){
                    cylinder(h1,r1+t,r1+t,true);
                }
            }
            translate([0,delta/2,0]){
                cube([(r0+t)*2,delta,(r1+t)*2],true);
            }
        }
        cylinder(h0+1,r0,r0,true);
        translate([0,delta,0]){
            rotate([0,90,0]){
                cylinder(h1+1,r1,r1,true);
            }
        }
    }
}
module crossBracket2(d0,h0,d1,h1,theta,dist,t,c0,c1){
    r0 = d0/2+c0;
    r1 = d1/2+c1;
    delta = r0+r1+dist;
    difference(){
        union(){
            cylinder(h0,r0+t,r0+t,true);
            translate([0,delta,0]){
                rotate([0,90+theta,0]){
                    translate([0,0,h1/4]){
                        cylinder(h1/2,r1+t,r1+t,true);
                    }
                }
                rotate([0,90-theta,0]){
                    translate([0,0,-h1/4]){
                        cylinder(h1/2,r1+t,r1+t,true);
                    }
                }
            }
            translate([0,delta/2,0]){
                rotate([90,0,0]){
                    cylinder(delta,r1+t,r0+t,true);
                }
            }
            translate([0,delta,0]){
                sphere(r1+t);
            }
        }
        cylinder(h0+1,r0,r0,true);
        translate([0,delta,0]){
            rotate([0,90+theta,0]){
                translate([0,0,h1/4+0.5]){
                    cylinder(h1/2+1,r1,r1,true);
                }
            }
            rotate([0,90-theta,0]){
                translate([0,0,-h1/4-0.5]){
                    cylinder(h1/2+1,r1,r1,true);
                }
            }
        }
    }
}
module crossBracket3(d0,h0,d1,h1,d2,h2,dist0,dist1,t,c0,c1,c2,o0,o1,o2){
    r0 = d0/2+c0;
    r1 = d1/2+c1;
    r2 = d2/2+c2;
    delta0 = r0+r1+dist0;
    delta1 = delta0+r1+r2+dist1;
    difference(){
        union(){
            cylinder(h0,r0+t,r0+t,true);
            translate([0,delta0/2,0]){
                cube([(r0+t)*2,delta0,(r1+t)*2],true);
            }
            translate([o0,0,0]){
                translate([0,delta0,o1]){
                    rotate([0,90,0]){
                        cylinder(h1,r1+t,r1+t,true);
                    }
                }
                translate([o2,delta1,0]){
                    cylinder(h2,r2+t,r2+t,true);
                }
                translate([o2,(delta1-delta0)/2+delta0,0]){
                    cube([(r2+t)*2,delta1-delta0,(r1+t)*2],true);
                }
            }
        }
        cylinder(h0+1,r0,r0,true);
        translate([o0,0,0]){
            translate([0,delta0,o1]){
                rotate([0,90,0]){
                    cylinder(h1+100,r1,r1,true);
                }
            }
            translate([o2,delta1,0]){
                cylinder(h2+100,r2,r2,true);
            }
        }
    }
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
            translate(servoOffset+[servo[0]/2,0,0]){
                cylinder(width*2,1.75,1.75,true);
            }
            translate(servoOffset-[servo[0]/2,0,0]){
                cylinder(width*2,1.5,1.5,true);
            }
        }
    }
}
module rib_nacelle(width, size, wireOffset, length, diameter, offset, holeSide, gap, angle=0, angleOffset=0){
    difference(){
        union(){
            rib_internal(width,size,wireOffset);
            rotate([90,0,0]){
                translate(offset){
                    translate([0,angleOffset,0]){
                        rotate([angle,0,0]){
                            intersection(){
                                cylinder(length+1+gap,diameter/2+1,diameter/2+1,true);
                                cube([width,diameter+2,length*2],true);
                            }
                        } 
                    } 
                }
            }
        }
        rotate([90,0,0]){
            translate(offset){
                translate([0,angleOffset,0]){
                    rotate([angle,0,0]){
                        cylinder(length+gap,diameter/2,diameter/2,true);
                        translate([-holeSide*diameter/2,0,0]){
                            cube([diameter,diameter-3*clearance,length],true);
                        }
                    }
                }
            }
            translate(offset+[0,(length+gap)*sin(angle)/2,-(length+gap)*cos(angle)/2]){
                translate([0,angleOffset,0]){
                    rotate([angle,0,0]){
                        cylinder(5,1.5,1.5,true);
                    }
                }
            }
        }
    }
}
module wheel(width, diameter, hole, e=0){
    r=diameter/2;
    w=width/2;
    ws=w*(1-e);
    rotate([0,90,0]){
        rotate_extrude(){
            polygon(concat(
                [
                    [r-ws,w],
                    [hole/2,w],[hole/2,-w],
                    [r-ws,-w]
                ],
                [
                    for(a=[0:10:180])
                    [
                        r-ws+sin(a)*ws,
                        -cos(a)*w
                    ]
                ]
            ));
        }
    }
    //     difference(){
    //         cylinder(width, diameter/2, diameter/2,true);
    //         cylinder(width+1, hole/2, hole/2,true);
    //     }
}