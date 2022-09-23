import java.awt.*;
import java.applet.*;
import java.lang.Math;
import java.io.*;

public class Graph extends Applet {

public void polarPlot(Graphics g,Double r1, Double theta1,Double r2, Double theta2){
    plot(g,(int)(r1*Math.cos(theta1)),(int)(r1*Math.sin(theta1)),(int)(r2*Math.cos(theta2)),(int)(r2*Math.sin(theta2)));
}

public void plot(Graphics g, int x1, int y1, int x2, int y2){
g.drawLine(x1+100,600-y1,x2+100,600-y2);
}

public void write(Graphics g,String msg, Double x1, Double y1){
g.drawString(msg,x1.intValue()+100,600-y1.intValue());
}

public Double [] ReadDataFromFile(int length){ 
  File file = new File("Data.txt"); 
  Double [] yD = new Double [length];
  int index=0;

  try{BufferedReader br = new BufferedReader(new FileReader(file));
  String st; 
  while ((st = br.readLine()) != null) 
    //System.out.println(Double.valueOf(st));
  	{yD[index]=Double.valueOf(st);
  	index++;}
  	}
  catch(IOException e){} 
  
 return yD;
}



public void paint(Graphics g) {

String msg = "123";
//g.setColor(Color.red);
int length=1001;
Double [] xD = new Double [length];
Double [] yD = new Double [length];

//Double xD []={-10.0,-5.0,1.0,-1.0,2.0,3.0,4.0,5.0,6.0,10.0};
//Double yD []={-30.0,40.0,400.0,13.0,-200.0,37.0,54.0,1000.0,-135.0,13.0};
yD=ReadDataFromFile(length);
Double xMax=Double.NEGATIVE_INFINITY;
Double xMin=Double.POSITIVE_INFINITY;
Double yMax=Double.NEGATIVE_INFINITY;
Double yMin=Double.POSITIVE_INFINITY;
Double yUpperLimit=100.0;
Double yLowerLimit=-10.0;
Double xScalingFactor=0.0;
Double yScalingFactor=0.0;
Double xOffset=0.0;
Double yOffset=0.0;
Double xRange=0.0;
Double yRange=0.0;
int xPixels=1200;
int yPixels=550;
int xOrigin=0;
int yOrigin=0;
int xDivisions=10;
int yDivisions=10;

for (int i=0;i<length ;i++ ) {
	xD[i]=(Double.valueOf(i))*0.01;
    if(xD[i]>xMax){xMax=xD[i];}
    if(xD[i]<xMin){xMin=xD[i];}
}
xRange=xMax-xMin;
xScalingFactor=Double.valueOf(xPixels)/xRange;

for (int i=0;i<length ;i++ ) {
	//yD[i]=6*(xD[i]*xD[i])+9*xD[i]+5500000;
    //yD[i]=100*Math.sin(Math.toRadians(xD[i]))*(Math.exp(-xD[i]/1000));
    //yD[i]=Math.exp(xD[i]);

    if(xD[i]==0.0){xOrigin=i;}
    if(yD[i]==0.0){yOrigin=i;}
    if((yD[i]>yUpperLimit)&&(i>0)){yD[i]=yUpperLimit;}
    if((yD[i]<yLowerLimit)&&(i>0)){yD[i]=yLowerLimit;}
    if((yD[i]==Double.POSITIVE_INFINITY)&&(i>0)){yD[i]=yD[i-1];}
    if((yD[i]==(Double.NEGATIVE_INFINITY))&&(i>0)){yD[i]=yD[i-1];}
    if(yD[i]>yMax){yMax=yD[i];}
    if(yD[i]<yMin){yMin=yD[i];}
    xD[i]=xD[i]*xScalingFactor;
}

System.out.println(xMax);
System.out.println(xMin);
System.out.println(yMax);
System.out.println(yMin);

yRange=yMax-yMin;
yScalingFactor=Double.valueOf(yPixels)/yRange;
for (int i=0;i<length ;i++ ) {yD[i]=yD[i]*yScalingFactor;}

yOffset=(Double)((yMin)*yScalingFactor);
xOffset=(Double)((xMin)*xScalingFactor);

System.out.println(yOffset);
System.out.println(xOffset);

for (int i=0;i<(length-1) ;i++ ) {
   plot(g,(int)(xD[i]-xOffset),(int)(yD[i]-yOffset),(int)(xD[i+1]-xOffset),(int)(yD[i+1]-yOffset));
   g.fillOval((int)(xD[i]-xOffset)+100,600-(int)(yD[i]-yOffset),5,5);
   g.fillOval((int)(xD[i+1]-xOffset)+100,600-(int)(yD[i+1]-yOffset),5,5);
   /*Double r1=Math.hypot((xD[i]-xOffset),(yD[i]-yOffset));
   Double r2=Math.hypot((xD[i+1]-xOffset),(yD[i+1]-yOffset));
   Double theta1=Math.atan2((yD[i]-yOffset),(xD[i]-xOffset));
   Double theta2=Math.atan2((yD[i+1]-yOffset),(xD[i+1]-xOffset));
   polarPlot(g,r1,theta1,r2,theta2);*/
}


   plot(g,(int)(-1.0*xOffset),(int)(0),(int)(-1.0*xOffset),(int)(yPixels));
   plot(g,(int)(-1.0*xOffset-1.0),(int)(0),(int)(-1.0*xOffset-1.0),(int)(yPixels));
   plot(g,(int)(-1.0*xOffset+1.0),(int)(0),(int)(-1.0*xOffset+1.0),(int)(yPixels));
   plot(g,(int)(-1.0*xOffset),(int)(0),(int)(-1.0*xOffset-10),(int)(10));
   plot(g,(int)(-1.0*xOffset),(int)(0),(int)(-1.0*xOffset+10),(int)(10));
   plot(g,(int)(-1.0*xOffset),(int)(yPixels),(int)(-1.0*xOffset-10),(int)(yPixels-10));
   plot(g,(int)(-1.0*xOffset),(int)(yPixels),(int)(-1.0*xOffset+10),(int)(yPixels-10));

   plot(g,(int)(0),(int)(yOffset*-1.0),(int)(xPixels),(int)(yOffset*-1.0));
   plot(g,(int)(0),(int)(-1.0+yOffset*-1.0),(int)(xPixels),(int)(-1.0+yOffset*-1.0));
   plot(g,(int)(0),(int)(1.0+yOffset*-1.0),(int)(xPixels),(int)(1.0+yOffset*-1.0));
   plot(g,(int)(0),(int)(yOffset*-1.0),(int)(10),(int)(10+yOffset*-1.0));
   plot(g,(int)(0),(int)(yOffset*-1.0),(int)(10),(int)(-10+yOffset*-1.0));
   plot(g,(int)(xPixels),(int)(yOffset*-1.0),(int)(xPixels-10),(int)(10+yOffset*-1.0));
   plot(g,(int)(xPixels),(int)(yOffset*-1.0),(int)(xPixels-10),(int)(-10+yOffset*-1.0));

for (int x=0;x<=xPixels ;x=x+(xPixels/xDivisions)) {
		plot(g,x,-5,x,yPixels);
        msg=String.format("%.4g%n", xMin+x/xScalingFactor);
        write(g,msg, Double.valueOf(x-10), Double.valueOf(-25));
}

for (int y=0;y<=yPixels ;y=y+(yPixels/yDivisions)) {
		plot(g,-5,y,xPixels,y);
        msg=String.format("%.4g%n",yMin+y/yScalingFactor);
        write(g,msg, Double.valueOf(-35), Double.valueOf(y-5));
}

msg="Time ((1/100)s)";write(g,msg, Double.valueOf(600), Double.valueOf(-50));
msg="Angle (radians)";write(g,msg, Double.valueOf(-50), Double.valueOf(565));
msg="Linear DC Motor Angular Displacement as a Function of Time";write(g,msg, Double.valueOf(500), Double.valueOf(565));
}

}

/*
(0,0)=(100,600)
(0,600)=(100,50)
(1200,0)=(1300,600)
*/