import processing.pdf.*;

HelperFunctions hf = new HelperFunctions();
color _strokeCol;
WaveClock wc1;
WaveClock wc2;

void setup() {
  ColorPalette randomC = new ColorPalette();
  _strokeCol = randomC.getBaseColor();
  int seedVal = int(random(0,200));
  background(randomC.getComplement());
  wc1 = new WaveClock(width/2, 40);
  wc2 = new WaveClock(width/2, height - 40);
   //println(seedVal);
   randomSeed(seedVal);
  size(700, 500);
  smooth();
  frameRate(30);
  noFill();
}

void draw() {
  wc1.show();
  wc2.show();
  hf.save("video");
}
