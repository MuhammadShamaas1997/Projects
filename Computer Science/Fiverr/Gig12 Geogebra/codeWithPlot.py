"""
import numpy as np
from sympy import Point3D, Plane, Line3D, Segment3D, solve

# Origin point O
O = np.array([0, 0, 0])

# Given values
c = 419.5
hp = 90
h = 555
t = h * 0.936
hb = h * 0.55 - 80

# Point A
A = np.array([-61.5, -c, t - hb - hp])

# Coordinates and points
zj1 = 3.7
zj7 = -57.1
xc1 = -255.5 + 10.65 * 0
yc1 = -31.3
yc7 = -147.5

# C1J1 point
C1J1 = np.array([xc1, yc1, zj1])

# Vector A to C1J1
vc1j1 = C1J1 - A

# Line from A in the direction of vc1j1
A_sympy = Point3D(A)
C1J1_sympy = Point3D(C1J1)
drc1j1 = Line3D(A_sympy, C1J1_sympy)

# Points BO1 and BO2
BO1 = np.array([-265.3, -291, -72.6])
BO2 = np.array([265.3, -291, -72.6])

# Plane defined by points O, BO1, BO2
BO1_sympy = Point3D(BO1)
BO2_sympy = Point3D(BO2)
pE = Plane(O, BO1_sympy, BO2_sympy)

# Find the intersection of the line and the plane
IC1J1 = pE.intersection(drc1j1)

# Result of the intersection
if IC1J1:
    intersection_point = IC1J1[0]
    print(f"Intersection Point: {intersection_point}")
else:
    print("No intersection found.")

# Given point ANDIC1J1
ANDIC1J1 = np.array([0, -25.51, -6.36])

# Output intersection point and ANDIC1J1
print(f"ANDIC1J1: {ANDIC1J1}")
"""

import numpy as np
import matplotlib.pyplot as plt

# Origin point O
O = np.array([0, 0, 0])

# Given values
c = 419.5
hp = 90
h = 555
t = h * 0.936
hb = h * 0.55 - 80

# Point A
A = np.array([-61.5, -c, t - hb - hp])

# Coordinates and points
zj1 = 3.7
zj7 = -57.1
xc1 = -255.5 + 10.65 * 0
yc1 = -31.3
yc7 = -147.5

# C1J1 point
C1J1 = np.array([xc1, yc1, zj1])

# Vector A to C1J1
vc1j1 = C1J1 - A

# Points BO1 and BO2
BO1 = np.array([-265.3, -291, -72.6])
BO2 = np.array([265.3, -291, -72.6])

# Plot the points and vectors
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Plot the points
ax.scatter(O[0], O[1], O[2], color='black', label='O (Origin)')
ax.scatter(A[0], A[1], A[2], color='red', label='A')
ax.scatter(C1J1[0], C1J1[1], C1J1[2], color='green', label='C1J1')
ax.scatter(BO1[0], BO1[1], BO1[2], color='blue', label='BO1')
ax.scatter(BO2[0], BO2[1], BO2[2], color='purple', label='BO2')

# Plot the line A -> C1J1 (vc1j1)
ax.plot([A[0], C1J1[0]], [A[1], C1J1[1]], [A[2], C1J1[2]], color='green', label='Line A -> C1J1')

# Plot the line BO1 -> BO2
ax.plot([BO1[0], BO2[0]], [BO1[1], BO2[1]], [BO1[2], BO2[2]], color='blue', label='Line BO1 -> BO2')

# Labels and titles
ax.set_xlabel('X axis')
ax.set_ylabel('Y axis')
ax.set_zlabel('Z axis')
ax.set_title('3D Plot of Geometric Points and Lines')

plt.legend()
plt.show()
