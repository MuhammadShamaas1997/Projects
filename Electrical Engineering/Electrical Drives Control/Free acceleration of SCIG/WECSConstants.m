Xls=0.0775;
Xm=2.042;
Xs=Xls+Xm;
Xlr=0.0322;
Xr=Xlr+Xm;
Rs=0.0453;
Rr=0.0222;
P=6;
f=60;
wb=2*pi*f;
ws=(12*pi*f)/P;
H=0.5;
B=inv([
    (Xs/wb) 0       0        (Xm/wb) 0       0;
    0       (Xs/wb) 0        0       (Xm/wb) 0;
    0       0       (Xls/wb) 0       0       0;
    (Xm/wb) 0       0        (Xr/wb) 0       0;
    0       (Xm/wb) 0        0       (Xr/wb) 0;
    0       0       0        0       0       (Xlr/wb)
    ]);

Z=[
    Rs              ((ws/wb)*Xs)   0  0               ((ws/wb)*Xm)   0;
    -((ws/wb)*Xs)   Rs             0  -((ws/wb)*Xm)   0              0;
    0               0              Rs 0               0              0;
    0               (((ws)/wb)*Xm) 0  Rr              (((ws)/wb)*Xr) 0;
    -(((ws)/wb)*Xm) 0              0  -(((ws)/wb)*Xr) Rr             0;
    0               0              0  0               0              Rr
    ];