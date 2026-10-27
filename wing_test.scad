include <scad/NACA3410.scad>

linear_extrude(height=100){
    polygon(airfoil_profile*100);
}