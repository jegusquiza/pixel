import codeanticode.glgraphics.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

int cellSize= 5;                  // the size of each element
PImage pixeleye;
float angle;
float jitter;

float fx;
float fy;

Capture video;
OpenCV opencv;
float[][][] floatPixels = new float[640][480][3];  
float transparancy= 0.99;
void setup() {
  //size(640, 480);
  size(750, 500,P3D);
   pixeleye = loadImage("ojo.jpg");
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
  
  //frameRate(120);
}

void draw() {
background(0);


  opencv.loadImage(video);                     //live video as the source for openCV
  //image(video, 0, 0 );                         // show the live video

  Rectangle[] faces = opencv.detect();         // track the faces and storage results in array

  loadPixels() ;                           
  video.loadPixels();
  updatePixels();
  //text("found "+faces.length+" faces",10,10);
  for(int i = 0; i < faces.length; i++){
    print(faces[i]);
    fx = faces[i].x;
    fy = faces[i].y;
    float fw = faces[i].width;
    float fh = faces[i].height;
    stroke(255);
    //rect(fx, fy, fw, fh);
    
    text(fx + " " + fy + " " + fw + " " + fh,10,20 + i*10 );
    
    }
    for (int x = 0; x < pixeleye.width  ; x+=cellSize){
   for (int y = 0; y < pixeleye.height ; y+=cellSize){
    
     int index = x + y * pixeleye.width;
     color pix = pixeleye.pixels[index];
     
     float r = red(pix);
     float g = green(pix);
     float b = blue(pix) ;
     //float distanceToMouse= dist(x + 10,y + 10,mouseX, mouseY);
     //float distanceToMouse= dist(x + 10,y + 10,fx, fy);
     float distanceToFace = dist(x + 20, y + 20, fx, fy);
 
     pushMatrix();                      // we want a fresh matrix for every item
    //translate(0,0,distanceToMouse/1.0); // we are translating just on the Z axis
     //translate(0, 0, fx/1.0);
     translate(0, 0, distanceToFace/2.0);
    if (second() % 1 == 0){
      jitter = random(-0.05, 0.05);
    }
    angle = angle + jitter;
    float c = cos(angle);
   
    rotate(c/40);
    
  
     line(x, y, x - random(-1, 0), y - random(-1,0));
     stroke(r ,g  ,b );
     strokeWeight(14);
     popMatrix();                        // pop thre matrix so we can start fresh
   }
 
}    
  pixeleye.updatePixels();
}

void captureEvent(Capture c) {
  c.read();
}