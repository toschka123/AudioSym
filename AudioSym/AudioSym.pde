import processing.sound.*;
Amplitude amp;
AudioIn in; 

BeatDetector BD;
Boolean backgroundcolor = false;
int colorr = 255;
float new_decayy;
float multipl;
float drop;
float new_decay;
FloatList baseavg;
FloatList highavg;
int beatCount;
int beatLimit=4;
int decay = 80;
int ColorToChange= 3;
int Background = 255;
int colorCircle = 150;
int colorSafe = 0;
int counter = 0;
Boolean stop = false;
int rCircle = 255;
int bCircle = 255;
int gCircle= 255;
int rBorder = 255;
int gBorder = 255;
int bBorder = 255 ;
int circleSize = decay; 
Boolean colorChangeMode = true;
Boolean sizeChangeMode = false;
float xoff=2.0; 
float yoff = 2.0;
FloatList listory; 
int w = 1048;
int h = 1048;
int mountains = 100;
float flying = 0;
float   pointsX[];
float pointsY[];
float tempStoreX=0.1;
float tempStoreY= 0.1;
float startX = random(0,1048);
float startY = random(0, 1048);
float xoff2;
float yoff2;
FFT fft;
int bands = 512;
float[] spectrum = new float[bands];

//AudioIn song;
SoundFile song;
void setup(){
size( 1048, 1048);
background(colorr);
//stroke(255);
noStroke();
fft = new FFT(this, bands);
song = new SoundFile(this, "Lui Mafuta & Kunterweiß - Brunching [kośa].mp3");
//song = new AudioIn(this, 0);
amp = new Amplitude(this);
BD = new BeatDetector(this);
song.play();
//song.start();
amp.input(song);
BD.input(song);
fft.input(song);
listory = new FloatList();
baseavg = new FloatList();
highavg = new FloatList();
for(int i = 0; i < 25; i++){listory.append(0);} //initalize emtpy list

for(int i = 0; i < 50; i++){baseavg.append(0);} //initalize emtpy list

for(int i = 0; i < 25; i++){highavg.append(0);} //initalize emtpy list
}

void draw(){

  if (keyPressed){if(key=='B'){colorr=255;}}
if (keyPressed){if(key=='b'){colorr=0;}}
  listory.append(amp.analyze());
  listory.remove(0);
  float avg=0; 
  for(int i = 0; i< listory.size();i++){
    avg = avg + listory.get(i);}
    avg=avg/listory.size();
    
    

    println(beatCount);
    
    //println(avg);
    float avgSave = avg;
   avg= map(avg,0,1,8,230);
 // new_decay = map(amp.analyze(), 0, 0.4, 0.0008,0.025); 
 // new_decayy = map(amp.analyze(), 0, 0.4, 0.0006,0.02); 
  
  fft.analyze(spectrum);
  float highs =0;
  float mids =0 ;
  float lows = 0;
  for(int i = 0; i < bands; i++){
   if(i<170){lows=lows+spectrum[i];}
   if(i>170 && i<340){mids = mids + spectrum[i];}
   if(i>340){highs= highs + spectrum[i];}
}
highs = highs/170;
lows = lows / 170;
mids = mids/180;
println(highs,lows, mids);

    baseavg.append(lows);
    baseavg.remove(0);
    float baseavgs=0;
      for(int i = 0; i< baseavg.size();i++){
    baseavgs =baseavgs  + baseavg.get(i);}
    baseavgs=baseavgs/baseavg.size();
    
    highavg.append(highs);
    highavg.remove(0);
    float highavgs=0;
      for(int i = 0; i< highavg.size();i++){
    highavgs =highavgs  + highavg.get(i);}
    highavgs=highavgs/highavg.size();
    println(highavgs);
//float minMove = map(avgSave,0,1,0.00005,0.00009);
//float maxMove = map(avgSave,0,1,0.0005,0.001);
float minMove = 0.00005;
float maxMove = 0.001;
 new_decay = map(highavgs, 0, 1, minMove,maxMove); 
 new_decayy = map(highavgs, 0, 1, maxMove-0.02,maxMove-0.02); 

  decay = int(avg);
  //println(amp.analyze(), decay);
  
//  circleSize=int( float(decay) * avg);
 background(colorr);
  xoff = tempStoreX;
  yoff = tempStoreY;
  tempStoreX = xoff + new_decay;
  tempStoreY = yoff +new_decayy;
  pointsX = new float[decay];
  pointsY = new float[decay];
  for(int i =0; i<decay;i++){
 // xoff = xoff + new_decay;
    xoff = xoff + 0.01;
  float x = noise(xoff) * width;
  float y = noise(yoff) * height;
  //yoff = yoff + new_decayy;
  yoff = yoff + 0.02;
      pointsX[i] =int(x);
      pointsY[i] =int(y);
    
  }
    if(ColorToChange==3 && stop==false){
    ColorToChange=1;stop=true;}
    if(ColorToChange==2&& stop==false){
      ColorToChange=3;stop=true;}
  if(ColorToChange==1&& stop==false){
    ColorToChange=2;stop=true;}
    counter += 1;
    if (BD.isBeat() && counter>126){stop=false;counter=0;}
  //background(255);
float beatSize =  map(baseavgs,0,0.6,0.5,1.25);
if (BD.isBeat()){multipl = 1.8*beatSize;}
      multipl = (multipl-0.05*beatSize);
       float multipl1 = max(multipl*beatSize  , 0.4*beatSize);
     // float multipl1=beatSize; //remove
      float shift = 610/decay; //this if black background
      // float shift = 255/decay //this generally
       shift = decay;//remove
  for(int i=0; i<decay;i++){
      if(ColorToChange==1){
      rCircle = i*int(shift);
      bCircle = bCircle - 1;
      gCircle = gCircle - 1;}
      if(ColorToChange==2){
      gCircle = i*int(shift);
       bCircle = bCircle - 1;
      rCircle = rCircle - 1;}
      if(ColorToChange==3)
      {bCircle = i*int(shift);
       rCircle = rCircle - 1;
      gCircle = gCircle - 1;}
      
      fill(rCircle, gCircle, bCircle);
      ellipse(pointsX[i], pointsY[i],(circleSize-i)*multipl1  , (circleSize-i)*multipl1);
      ellipse(pointsY[i], pointsX[i],(circleSize-i)*multipl1, (circleSize-i)*multipl1);
      ellipse(1048-pointsX[i], 1048-pointsY[i],(circleSize-i)*multipl1, (circleSize-i)*multipl1);
      ellipse(1048-pointsX[i], pointsY[i],(circleSize-i)*multipl1, (circleSize-i)*multipl1);
      ellipse(pointsX[i], 1048-pointsY[i],(circleSize-i)*multipl1, (circleSize-i)*multipl1);
      ellipse(1048-pointsY[i],1048-pointsX[i],(circleSize-i)*multipl1, (circleSize-i)*multipl1);   
      ellipse( 1048-pointsY[i],pointsX[i],(circleSize-i)*multipl1, (circleSize-i)*multipl1);
      ellipse( pointsY[i],1048-pointsX[i],(circleSize-i)*multipl1, (circleSize-i)*multipl1);
      
      

  }

/*
if (colorChangeMode==true){
if (colorToChange==1){ if(rCircle<256) {rCircle = rCircle+2;gCircle=gCircle-1;bCircle=bCircle-1;}}
if (colorToChange==1){if(rCircle>255) {colorToChange=2; }}
if (colorToChange==2){if( bCircle<256) {bCircle = bCircle+2;gCircle=gCircle-1;rCircle=rCircle-1;}}
if (colorToChange==2){if( bCircle>255) {colorToChange=3; }}
if (colorToChange==3){if(gCircle<256) {gCircle = gCircle+2;bCircle=bCircle-1;rCircle=rCircle-1;}}
if (colorToChange==3){if(gCircle>255) {colorToChange=1;}}}*/
}
