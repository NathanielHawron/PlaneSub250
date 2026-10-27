import matplotlib.pyplot as plt
import numpy as np


N = 6
Re = 500000
foils = [
    # "AG24",
    # "AG27",
    # "MH32",
    "NACA0002",
    "NACA0005",
    "NACA1402",
    "NACA1403",
    "NACA1405",
    # "NACA2409",
    # "NACA2410",
    # "NACA2412",
    # "NACA2415",
    "NACA3410",
    # "NACA3415",
    # "NACA3417",
    # "NACA3420",
    # "NACA4410",
    # "NACA4415",
    # "NACA5415",
]
colors = [
    # "black",
    # "brown",
    # "pink",
    "red",
    "orange",
    # "yellow",
    # "lime",
    "green",
    # "cyan",
    "blue",
    "indigo",
    "violet"
]
dataList = []

for foil in foils:
    dataList.append(np.loadtxt(f"./polar/N{N}/RE{Re}/{foil}_polar.txt", skiprows=12))

fig, axes = plt.subplots(2,3,figsize=(15,9))
fig.suptitle(f"Airfoil Performance (Re {Re}, N {N})")

plots = []

for i,data in enumerate(dataList):
    alpha = data[:,0]
    cl =    data[:,1]
    cd =    data[:,2]
    cm =    data[:,4]
    ld =    cl/cd
    E  =    ld/cm
    line, = axes[0,0].plot(cd, cl, colors[i], linewidth=2)
    axes[0,1].plot(alpha, cl, colors[i], linewidth=2)
    axes[0,2].plot(alpha, cd, colors[i], linewidth=2)
    axes[1,0].plot(alpha, cm, colors[i], linewidth=2)
    axes[1,1].plot(alpha, ld, colors[i], linewidth=2)
    axes[1,2].plot(alpha, E, colors[i], linewidth=2)

    plots.append(line)

axes[0,0].set_xlabel("Cd", fontsize=12)
axes[0,0].set_ylabel("Cl", fontsize=12)
axes[0,0].set_title("Cl vs Cd", fontsize=14)
axes[0,0].grid(True, linestyle='--', alpha=0.6)

axes[0,1].set_xlabel("alpha", fontsize=12)
axes[0,1].set_ylabel("Cl", fontsize=12)
axes[0,1].set_title("Cl vs alpha", fontsize=14)
axes[0,1].grid(True, linestyle='--', alpha=0.6)

axes[0,2].set_xlabel("alpha", fontsize=12)
axes[0,2].set_ylabel("Cd", fontsize=12)
axes[0,2].set_title("Cd vs alpha", fontsize=14)
axes[0,2].grid(True, linestyle='--', alpha=0.6)

axes[1,0].set_xlabel("alpha", fontsize=12)
axes[1,0].set_ylabel("Cm", fontsize=12)
axes[1,0].set_title("Cm vs alpha", fontsize=14)
axes[1,0].grid(True, linestyle='--', alpha=0.6)

axes[1,1].set_xlabel("alpha", fontsize=12)
axes[1,1].set_ylabel("Cl/Cd", fontsize=12)
axes[1,1].set_title("Cl/Cd vs alpha", fontsize=14)
axes[1,1].grid(True, linestyle='--', alpha=0.6)

axes[1,2].set_xlabel("alpha", fontsize=12)
axes[1,2].set_ylabel("Cl/Cd/Cm", fontsize=12)
axes[1,2].set_title("Cl/Cd/Cm vs alpha", fontsize=14)
axes[1,2].grid(True, linestyle='--', alpha=0.6)

axes[1,2].legend(plots,foils,loc="lower right",frameon=True,facecolor="white",framealpha=0.6)

plt.tight_layout()
plt.show()