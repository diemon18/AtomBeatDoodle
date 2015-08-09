// Copyright (c) 2015 Diego Montoya diego_montoya@outlook.com

atom a, b;
ArrayList atoms;
//boolean atomCreated = false;
spacegrid grid;
//String mode = "all";
int ADragging = -1;
//int eDragging = 0;
//PImage createAtom;
//PImage deleteAtom;
color bkgColor;
Boolean darkTheme = false;
PFont font;

void setup () {
  //size(1000, 600, P2D);
  //fullScreen();
  size(window.innerWidth, window.innerHeight, P2D);
//  size(displayWidth, displayHeight); 
  a = new atom(320, 240, false);
  b = new atom(380, 240, true);
  atoms = new ArrayList();
  atoms.add(a);
  //  atoms.add(b);
  ADragging = atoms.size() - 1;
  grid = new spacegrid(42, int(round(42.0/width*height)));
  //  grid = new spacegrid(42,24);
  colorMode(HSB, 100);
//  bkgColor = color(0, 0, 0, 10);
//  bkgColor = color(0, 0, 0, 20);
  bkgColor = color(0, 0, 100, 20);
//  background(color(0,0,50,100));
  smooth();
//  font = createFont("Helvetica", width/20, true);
//  textFont(font, width/20);
//  textAlign(CENTER, CENTER);
}

void draw() {
  //background(0, 0, 0, 0);
  noStroke();
  fill(bkgColor);
  rect(0, 0, width, height);
  // stroke(0,100,100);
  // ellipse(50,50,50,50);
  grid.resetGrid();
  for (int i = 0; i < atoms.size (); i++) {
    atom tempA = (atom) atoms.get(i);
    grid.setGridPointPosition(tempA.xOsc, tempA.yOsc, 0, tempA.gravity);
  }
  grid.drawGrid();
  for (int i = atoms.size () - 1; i >= 0; i--) {
    atom tempA = (atom) atoms.get(i);
    tempA.drawAtom();
  }
  atom tempA = (atom) atoms.get(ADragging);
  dragAtom(tempA);

//  if (darkTheme) {
//    fill(0, 0, 100);
//    text("Diego Montoya", width/2, height/2);
//  }
}

void dragAtom(atom A) {
  A.x = mouseX * 0.1 + A.x * 0.9;
  A.y = mouseY * 0.1 + A.y * 0.9;
  A.dragged = true;
  A.osc = false;
}

void mouseReleased() {
  atom a = (atom)atoms.get(ADragging);
  if (mouseButton == RIGHT) {
    a.gravityMax *= -1;
    a.gravitySign *= -1;
    return;
  }
  a.dragged = false;
  a.osc = true;
  atom tempA = new atom(mouseX, mouseY, (random(1) > 0.5 ? true : false));
  //  atom tempA = new atom(mouseX, mouseY, ( ? true : false));
  tempA.drawAtom();
  ADragging = atoms.size();
  atoms.add(tempA);
  dragAtom(tempA);
}

void keyPressed() {
//  if (keyCode == 32) {
//    if (darkTheme) {
//      bkgColor = color(0, 0, 100, 20);
//    } else {
//      bkgColor = color(0, 0, 7, 20);
//    }
//    darkTheme = !darkTheme;
//  }

  if (key == 'r' || key == 'R') {
    atoms.removeAll;
  }
}
// Copyright (c) 2015 Diego Montoya diego_montoya@outlook.com

/* atom class */
int zFrames = 30;
int zoomingCount = zFrames;

class atom {
  float x, y;
  float oldX, oldY;
  float awayX, awayY;
  float xOsc;
  float yOsc;
  String ownMode;
  int aura = 0;

  //  float[] pathZoom = new float[60 * 2];
  //  float[] pathAway = new float[60 * 2];

  int trans;

  float alph, beta, gamma;
  float speed;

  float radius, sqrRadius;
  final float defaultR = 0; //40
  float oldRadius, oldSqrRadius;

  boolean osc;
  boolean dragged = false;
  float gravity;
  float gravitySign;
  float gravityMax;

  atom(int x, int y, boolean posG) {
    this.x = x;
    this.y = y;
    this.gravityMax = random(0.9, 1.5);
    this.gravity = 0;
    this.gravitySign = 1;
    if (!posG) {
      this.gravityMax *= -1;
      this.gravitySign *= -1;
    }
    trans = 200;
    radius = defaultR;
    sqrRadius = radius * radius;
    osc = true;
    alph = random(TWO_PI);
    beta = random(TWO_PI);
    gamma = random(0.7, 0.9);
    speed = random (0.03, 0.06);
    if (random(1) > 0.5)
      speed *= -1;
    ownMode = "all";
  }

  float magn = 40;
  void drawAtom() {
    if (gravitySign == 1) {
      if (gravityMax > gravity) {
        gravity += (gravityMax - gravity) * 0.3;
      }
    } else {
      if (gravityMax < gravity) {
        gravity += (gravityMax - gravity) * 0.3;
      }
    }
    if (osc) {
      xOsc = x + (magn * cos(alph));
      yOsc = y + (magn * cos(beta));
      alph = alph + speed;
      beta = beta + speed * gamma;
    } else {
      xOsc = x;
      yOsc = y;
      alph = HALF_PI;
      beta = HALF_PI;
    }
  }

  void setOsc() {
    osc = true;
  }

  void clearOsc() {
    osc = false;
  }

  void toggleOsc() {
    if (osc == true) {
      osc = false;
    } else {
      osc = true;
    }
  }

  //  void startZoomIn() {
  //   ownMode = "zoom+";
  //   float dx = 0 - xOsc;
  //   float dy = height/2 - yOsc;
  //   for (int i = 0; i < zFrames; i++) {
  //    pathZoom[i * 2] = (zFrames-i) *  dx / zFrames;
  //    pathZoom[i * 2 + 1] = (zFrames-i) *  dy / zFrames;
  //   }
  //   e1.startZoomIn();
  //   e2.startZoomIn();
  //  }
  //  
  //  void startZoomOut() {
  //   ownMode = "zoom-";
  //   e1.startZoomOut();
  //   e2.startZoomOut();
  //  }

  //  void flyAway() {
  //   ownMode = "fly+";
  //   float angle = random(-3.14159 * 3 / 4, 3.14159 * 7 / 4);
  //   float r = (max(height / 2, width / 2) + 2 * radius);
  //   awayX = width / 2 + cos(angle) * r;
  //   awayY = height / 2 + sin(angle) * r; 
  //   float dx = awayX - xOsc;
  //   float dy = awayY - yOsc;
  //   for (int i = 0; i < zFrames; i++) {
  //    pathAway[i * 2] = (zFrames-i) *  dx / zFrames;
  //    pathAway[i * 2 + 1] = (zFrames-i) *  dy / zFrames;
  //   }
  //   e1.flyAway();
  //   e2.flyAway();
  //  }

  //  void flyIn() {
  //   ownMode = "fly-"; 
  //   e1.flyIn();
  //   e2.flyIn();
  //  }

  //  void drawInPath(float pathX, float pathY, float r, float rAura) {
  //    stroke(strokeR,strokeG,strokeB,0);
  //    fill(fillR, fillG, fillB, trans);  
  //    float factor = 6 - zoomingCount*5.0/zFrames;
  //    ellipse(pathX, pathY, r, r);
  //    fill(strokeR, strokeG, strokeB, trans);
  //    ellipse(pathX, pathY, rAura, rAura); 
  //  }
}

// Copyright (c) 2015 Diego Montoya diego_montoya@outlook.com

class spacegrid{
  float px[], py[];
  int gridPointsX, gridPointsY, gridPoints;
  float gain = 1, offsetX = 0, offsetY = 0;
  float zoomCenterX, zoomCenterY;
  String ownMode = "all";
  float[] pathZoom = new float[60 * 2];
  int zoomingCount = zFrames;
  
  float factor = width / 640;
  
  spacegrid(int gridPointsX, int gridPointsY){
//    print("\n" + gridPointsY);
    this.gridPointsX = gridPointsX + 1;
    this.gridPointsY = gridPointsY + 1;
    gridPoints = this.gridPointsX * this.gridPointsY;
 
    px = new float[gridPoints];
    py = new float[gridPoints];
    factor = width / 640.0;
  } // end constructor
  
  
  void setGridPoint(int index, float x, float y){
    px[index] = x;
    py[index] = y;
  } // end void setGridPoint()
  
  
  void resetGrid(){
    //for(int i = 0; i < gridPoints; i++) pz[i] = 0;
    for(int i = 0; i < gridPointsY; i++){
      for(int j = 0; j < gridPointsX; j++){
        px[(i+0) * gridPointsX + (j+0)] = float(width + 100) * float(j) / float(gridPointsX - 1) - 50;
        py[(i+0) * gridPointsX + (j+0)] = float(height + 100) * float(i) / float(gridPointsY - 1) - 50;
      }
    }    
  } // end void REsetGridPointPositionZ()
  
  
  void setGridPointPosition( float gravityX, float gravityY,
                             float radius, float gravity){
    for(int i = 0; i < gridPoints; i++){
      float dx = gravityX - px[i];
      float dy = gravityY - py[i];
      float dis = sqrt(sq(dx) + sq(dy)) / factor / gravity;
      //float normdx = dx / dis;
      //float normdy = dy / dis;
//      px[i] += dx * exp(-dis*dis/3000);
//      py[i] += dy * exp(-dis*dis/3000);
      if (gravity > 0){
        px[i] += dx * exp(-dis*dis/3000);
        py[i] += dy * exp(-dis*dis/3000);
//        print("\n" + px[i]);
      }else{
        px[i] -= dx * exp(-dis*dis/3000);
        py[i] -= dy * exp(-dis*dis/3000);
      }
      //print("\n"+exp(-dis*dis/1000000));
    } // end for i
  } // end void setGridPointPositionZ
    
  void drawGrid(){
    strokeWeight(2);
    stroke(120/3.6, 80, 20);
//    noFill();
//    rect(0,0,width,height);
    //float alpaChannel;
    
    caculateGainAndOffset();
    
    for(int i = 0; i < gridPointsY-1; i++){
      for(int j = 0; j < gridPointsX-1; j++){
        float x1 = px[ (i+0) * gridPointsX + (j+0)];
        float y1 = py[ (i+0) * gridPointsX + (j+0)];
        //stroke(255); strokeWeight(1); point(x1,y1,0);  // draw original grid
  
        float x2 = px[ (i+1) * gridPointsX + (j+0)];
        float y2 = py[ (i+1) * gridPointsX + (j+0)];
        
        //float x3 = px[ (i+1) * gridPointsX + (j+1)];
        //float y3 = py[ (i+1) * gridPointsX + (j+1)];
        
        float x4 = px[ (i+0) * gridPointsX + (j+1)];
        float y4 = py[ (i+0) * gridPointsX + (j+1)];
        
        
        x1 = (x1 - zoomCenterX) * gain + offsetX + zoomCenterX;
        x2 = (x2 - zoomCenterX) * gain + offsetX + zoomCenterX;
        x4 = (x4 - zoomCenterX) * gain + offsetX + zoomCenterX;
        y1 = (y1 - zoomCenterY) * gain + offsetY + zoomCenterY;
        y2 = (y2 - zoomCenterY) * gain + offsetY + zoomCenterY;
        y4 = (y4 - zoomCenterY) * gain + offsetY + zoomCenterY;
        line(x1, y1, x2, y2);
        line(x1, y1, x4, y4);
//        line(x2,y2,x4,y4);
//        line(x1,y1,x3,y3);
        //noStroke();
        //beginShape(TRIANGLE_STRIP); vertex(x1, y1, z1); vertex(x2, y2, z2); vertex(x4, y4, z4); vertex(x3, y3, z3); endShape();
      } // end for j 
    } // end for i
    
  } // end void drawGrid()
  
  void startZoomIn(float x, float y) {
   ownMode = "zoom+";
   zoomCenterX = x;
   zoomCenterY = y;
   float dx = 0 - x;
   float dy = height/2 - y;
   for (int i = 0; i < zFrames; i++) {
    pathZoom[i * 2] = (zFrames-i) *  dx / zFrames;
    pathZoom[i * 2 + 1] = (zFrames-i) *  dy / zFrames;
   }
  }
  
  void startZoomOut() {
   ownMode = "zoom-"; 
  }
  
  void caculateGainAndOffset() {
    if (ownMode == "zoom+") {
      gain = 8 - zoomingCount * 7.0 / zFrames;
      offsetX = pathZoom[zoomingCount * 2];
      offsetY = pathZoom[zoomingCount * 2 + 1];   
      if (zoomingCount-- <= 0) {
        zoomingCount = zFrames;
        ownMode = "zoomed";        
        return;
      }
    } else if (ownMode == "zoom-") {
      gain = 8 - (zFrames - zoomingCount) * 7.0 / zFrames;
      offsetX = pathZoom[(zFrames - zoomingCount) * 2];
      offsetY = pathZoom[(zFrames - zoomingCount) * 2 + 1];   
      if (zoomingCount-- <= 0) {
        zoomingCount = zFrames;
        ownMode = "all";   
        return;
      }
    }
  }
  
} // end class Grid

