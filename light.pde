import processing.video.*;

Capture video;

/*ENABLE OR DISABLE DEBUG MODE*/
boolean debug = true;

/*VARIABLES FOR CONTROLLING BACT BEHAVIOUR*/
float bactSpawnChance = 0.7;
float bactRadious = 15;
float bactGrowth = 2.5;
float bactDecay = 1;
float var = 0.7;

int camWidth = 176;
int camHeight = 144;

int maxDiff = 30;
float lightRadious = 150;

PVector bp;
ArrayList<Bact> bacts; 

PFont font;

void setup() {
  size(1200, 800);
  //fullScreen();
  background(255, 255, 255);
  video = new Capture(this, camWidth, camHeight);
  bp = new PVector(camWidth/2, camHeight/2);
  printArray(Capture.list());
  
  video.start();
  
  font = createFont("Arial Bold",48);
  
  bacts = new ArrayList<Bact>();
}

void draw() {
  background(255, 255, 255);
  
  //poisci najsvetlejso tocko v videu
  //isci le v okolici trenutne najsvetlejse tocke
  float maxC = 0;
  
  //preveri da okolica ni zunaj mej videa
  int minX = (int)(bp.x - (maxDiff/2));
  if(minX < 0)
    minX = 0;
   
  
  int maxX = (int)bp.x + (maxDiff/2);
  if(maxX > camWidth)
    maxX = camWidth; 
  
  int minY = (int)bp.y - (maxDiff/2);
  if(minY < 0)
    minY = 0; 
  
  int maxY = (int)bp.y + (maxDiff/2);
  if(maxY > camHeight)
    maxY = camHeight; 
  
  for (int x = minX; x < maxX; x++) {    
    for (int y = minY; y < maxY; y++) {
      color c = video.get(x, y);
      if (brightness (c) > maxC) {
        maxC = brightness (c);
        bp.x = x;
        bp.y = y;
      }
    }
  }
  
  //normaliziraj tocko na celotni zaslon
  PVector loc = new PVector(bp.x, bp.y);
  loc.x = (width - 0)*((loc.x - 0)/(camWidth-0))+0;
  loc.y = (height - 0)*((loc.y - 0)/(camHeight-0))+0;
  
  //obrni x koordinate
  if(loc.x < width/2){
    loc.x = (width/2)+((width/2)-loc.x);
  }
  else if(loc.x > width/2){
    loc.x = (width/2)-(loc.x-(width/2));
  }
  
  //osvetli del slike na katerega kaze luc
  //podobna implementacija kot v Processing tutorialu Images and Pixels
  loadPixels();
  for (int x = 0; x < width; x++) {    
    for (int y = 0; y < height; y++) {      
      int p = x + y * width;      
       
      float r = red  (pixels[p]);      
      float g = green(pixels[p]);      
      float b = blue (pixels[p]);      

      float d = dist(x, y, loc.x, loc.y);      
      float adjustbrightness = map(d, 0, random(160, 180), random(1.1, 1.2), 0);      
      r *= adjustbrightness;      
      g *= adjustbrightness;      
      b *= adjustbrightness;      
          
      r = constrain(r, 4, 255);      
      g = constrain(g, 4, 255);      
      b = constrain(b, 4, 255);      
       
      color c = color(r, g, b);      
      pixels[p] = c;    
    }  
  }
  updatePixels();
  
  //narisi bacte
  float p = random(0, 1);
  if(p < bactSpawnChance){
    bacts.add(new Bact(loc));
  }
  
  //posodobi vse bacte
  for(int i = bacts.size()-1; i >= 0; i --){
    bacts.get(i).update(loc);
    if(bacts.get(i).dead == true){
      bacts.remove(i);
    }
  }
  
  if(debug == true){
    //prikazi sliko videa
    image(video, 0, 0);
    
    //narisi tocko
    stroke(0, 255, 0);
    strokeWeight(4);
    noFill();
    ellipse(bp.x, bp.y, 10, 10);
    
    //narisi interpolirano tocko
    stroke(0, 0, 255);
    strokeWeight(4);
    noFill();
    ellipse(loc.x, loc.y, 10, 10);
    stroke(0, 0, 255);
    strokeWeight(1);
    noFill();
    ellipse(loc.x, loc.y, lightRadious, lightRadious);
    
    //fps
    textFont(font,30);
    fill(200);
    text("fps: "+(int)(frameRate),20,60);
  }
}

void captureEvent(Capture video) {
  video.read();
}

class Bact {
  float x;
  float y;
  float radious;
  boolean dead;
  
  Bact (PVector loc) {
    radious = random(bactRadious-(bactRadious/3), bactRadious+(bactRadious/3));
    dead = false;
    x = random(loc.x-(lightRadious/2), loc.x+(lightRadious/2));
    y = random(loc.y-(lightRadious/2), loc.y+(lightRadious/2));
    
    if(x < 0)
      x = 0;
    else if(x > width)
      x = width;
      
    if(y < 0)
      y = 0; 
    else if(y > height)
      y = height; 
    
    stroke(0, 0, 0, 220);
    strokeWeight(3); 
    fill(5, 200);
    ellipse(x, y, radious, radious);
  }
  
  void update(PVector loc) { 
    float d = dist(x, y, loc.x, loc.y);
    if(d <= lightRadious){
      radious = radious + random(bactGrowth-var, bactGrowth+var);
    }
    else{
      radious = radious - random(bactDecay-var, bactDecay+var);
    }
    
    if(radious < 0){
      dead = true;
    }
    else{
      stroke(0, 0, 0, 200);
      strokeWeight(3); 
      fill(5, 200);
      ellipse(x, y, radious, radious);
    }
  }
  
}
