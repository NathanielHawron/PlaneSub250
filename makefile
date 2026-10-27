FOIL = NACA1403

RE = 500000
M = 0.08
N = 6
A = -3 3 0.5

OPTIONS = $(RE) $(M) $(N) $(A)
POLARPATH = ./polar/N$(N)/RE$(RE)

xfoil:
	mkdir $(POLARPATH) -p
#	-rm $(POLARPATH)/$(FOIL)_polar.txt
	node ./xfoil.js $(FOIL) $(OPTIONS)
	-rm :00.bl

scad: scad/$(FOIL).scad

scad/$(FOIL).scad:
	node ./dat_to_scad.js $(FOIL)