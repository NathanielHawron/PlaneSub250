include <modules.scad>


module spars(padding=0){
    translate([wing_chord*0.25,0,wing_chord*0.015]){
        spar(wingspan+padding,spar_radius+padding);
    } 
    translate([wing_chord*0.70,0,wing_chord*0.015]){
        spar(wingspan+padding,subspar_radius+padding);
    }
}
module ribs(side,types,params,widths){
    dt = 1/len(types);
    start = side*wing_start;
    end = side*wing_end;
    echo("First Rib: ",start+dt*(end-start));
    echo("Rib spacing:",dt*(end-start));
    for(i=[1:1:len(types)]){
        t = start*(1-i*dt) + end*(i*dt);
        translate([0,t-side*rib_width/2,0]){
            rib(widths[i-1],wing_chord,types[i-1],params[i-1],side);
        }
    }
}

module plane(){
    color("pink"){
        spars();
    }
    color("green"){
        params_template = [
            // NACELLE (offset, angle, length, diameter, )
            [[0,0,0],5,motor_length+motor_diameter,motor_diameter+clearance,1,3,[motor_diameter-1,motor_length]],
            // LED
            [[12,1,0],led_diameter+clearance],
            // SERVO
            [[]]
        ];
        types = [["NACELLE"],[],["NACELLE"],["TRUNCATE","LED","SERVO"],["LED"]];
        parameters = [
            [
                params_template[0]
            ],
            [
                
            ],
            [
                params_template[0]
            ],
            [
                [wing_chord*0.75],      // TRUNCATE
                params_template[1],
                params_template[2]
            ],
            [
                params_template[1]
            ]
        ];
        widths = [nacelle_width,rib_width,nacelle_width,rib_width,rib_width];
        difference(){
            union(){
                ribs(1,types,params=parameters,widths=widths);
                ribs(-1,types,params=parameters,widths=widths);
            }
            spars(clearance);
        }
    }
}

plane();