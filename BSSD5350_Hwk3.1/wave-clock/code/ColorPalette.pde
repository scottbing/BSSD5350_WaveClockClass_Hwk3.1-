//Class based on Rob Camick's HSL Color library for Java
// Retrieved on August 20th, 2020
// https://tips4java.wordpress.com/2009/07/05/hsl-color/
//
// No license specified, but https://tips4java.wordpress.com/about/
//  claims code is freely distributable and modifable.
//
// Functions directly translated: HSLtoRGB, HueToRGB, RGBtoHSL

public class ColorPalette {

  private color baseColor; //stored, immutable, retrieve with getter
  private color complementColor = -1; //stored, immutable, retrieve with getter
  private color[] monochromes = {-1, -1};
  private color[] analogues = {-1, -1};

  int whiteThresh = 1; //any lightness less than this is white
  int blackThresh = 99; // any lightness greater than this is black
  int grayThresh = 1; // any saturation less than this is gray

  //use this exmpty param constructor for a random base color
  public ColorPalette() {
    baseColor = randomHue();
  }
  //use this constructor to specify the base color
  public ColorPalette(color col) {
    baseColor = col;
  }

  public float[] getHSLBase() {
    return RGBtoHSL(baseColor);
  }

  public color getBaseColor() {
    return baseColor;
  }

  public color getComplement() {
    if (complementColor == -1) {
      complementColor = findComplement(baseColor);
    }
    return complementColor;
  }

  public color[] getMonochromes() { //2 monochromes assumed
    if (monochromes[0] == -1) {
      monochromes[0] = getShade(baseColor, 25);
      monochromes[1] = getShade(baseColor, 50);
    }
    return monochromes;
  }

  public color[] getAnalogues() { //2 analogues assumed
    if (analogues[0] == -1) {
      analogues[0] = getShade(rotateHue(baseColor, -20), 10);
      analogues[1] = getShade(rotateHue(baseColor, 20), 10);
    }
    return analogues;
  }

  public color findComplement(color rgbColor) {
    float[] hslC = RGBtoHSL(rgbColor);
    if (hslC[2] < whiteThresh || hslC[2] > blackThresh) {//if black or white
      //swap black and white
      return color(abs(red(rgbColor) - 255));
    } else if (hslC[1] < grayThresh) { //if gray
      //take the red channel and use it as a gray
      // map 0-255 to be 0-360 so the math is the same
      float mappedG = map(red(rgbColor), 0, 256, 0, 360);
      mappedG = (mappedG + 180) % 360;
      //turn the rotated number back into a number between 0-255 for rgb gray
      return color(map(mappedG, 0, 360, 0, 256));
    } else { //presumed to be dealing with a color
      hslC[0] = (hslC[0] + 180) % 360;
      return HSLtoRGB(hslC);
    }
  }
  
  //changes alpha of an rgb color and return new color.
  public color transparent(color rgbColor, int newAlpha){
    //make sure alpha is between 0-255
    newAlpha = max(0, newAlpha %255);
    //must retrieve each channel and replace alpha
    return color(red(rgbColor), green(rgbColor), blue(rgbColor), newAlpha);
  }

  public color getShade(color rgbColor, int shift) {
    float[] hslC = RGBtoHSL(rgbColor);
    //if white, black, or gray
    if (hslC[2] < whiteThresh || hslC[2] > blackThresh || hslC[1] < grayThresh) { 
      //take the red channel and use it as a gray
      // map 0-255 to be 0-360 so the math is the same
      float mappedG = map(red(rgbColor), 0, 255, 0, 360);
      mappedG = max(0, (mappedG + shift)) % 360;
      //turn the rotated number back into a number between 0-255 for rgb gray
      return color(map(mappedG, 0, 360, 0, 255));
    } else {
      hslC[1] = max(0, hslC[1] + shift) % 100;
      return HSLtoRGB(hslC);
    }
  }

  public color getTint(color rgbColor, int shift) {
    float[] hslC = RGBtoHSL(rgbColor);
    hslC[2] = max(0, hslC[2] + shift) % 100;
    return HSLtoRGB(hslC);
  }

  public color rotateHue(color rgbColor, int angle) {
    float[] hslC = RGBtoHSL(rgbColor);
    //if black, white, or gray
    if (hslC[2] < whiteThresh || hslC[2] > blackThresh || hslC[1] < grayThresh) { //if gray
      //take the red channel and use it as a gray
      // map 0-255 to be 0-360 so the math is the same
      float mappedG = map(red(rgbColor), 0, 255, 0, 360);
      mappedG = max(0, (mappedG + angle)) % 360;
      //turn the rotated number back into a number between 0-255 for rgb gray
      return color(map(mappedG, 0, 360, 0, 255));
    } else { //presumed to be dealing with a color
      hslC[0] = max(0, hslC[0] + angle) % 360;
      return HSLtoRGB(hslC);
    }
  }

  public color randomHue() {
    float[] hslC = {parseInt(random(0, 360)), parseInt(random(0, 100)), parseInt(random(0, 100))};
    return HSLtoRGB(hslC);
  }

  color HSLtoRGB(float[] hsl) {
    float h = hsl[0];
    float s = hsl[1];
    float l = hsl[2];
    float alpha = 1.0;

    if (s <0.0f || s > 100.0f)
    {
      String message = "Color parameter outside of expected range - Saturation";
      throw new IllegalArgumentException( message );
    }

    if (l <0.0f || l > 100.0f)
    {
      String message = "Color parameter outside of expected range - Luminance";
      throw new IllegalArgumentException( message );
    }

    if (alpha <0.0f || alpha > 1.0f)
    {
      String message = "Color parameter outside of expected range - Alpha";
      throw new IllegalArgumentException( message );
    }

    //  Formula needs all values between 0 - 1.

    h = h % 360.0f;
    h /= 360f;
    s /= 100f;
    l /= 100f;

    float q = 0;

    if (l < 0.5)
      q = l * (1 + s);
    else
      q = (l + s) - (s * l);

    float p = 2 * l - q;

    float r = Math.max(0, HueToRGB(p, q, h + (1.0f / 3.0f)));
    float g = Math.max(0, HueToRGB(p, q, h));
    float b = Math.max(0, HueToRGB(p, q, h - (1.0f / 3.0f)));

    r = Math.min(r, 1.0f);
    g = Math.min(g, 1.0f);
    b = Math.min(b, 1.0f);

    r *=255;
    g *=255;
    b *=255;
    alpha *= 255;

    //print(r, g, b);
    return color(r, g, b, alpha);
  }

  private float HueToRGB(float p, float q, float h)
  {
    if (h < 0) h += 1;

    if (h > 1 ) h -= 1;

    if (6 * h < 1)
    {
      return p + ((q - p) * 6 * h);
    }

    if (2 * h < 1 )
    {
      return  q;
    }

    if (3 * h < 2)
    {
      return p + ( (q - p) * 6 * ((2.0f / 3.0f) - h) );
    }

    return p;
  }

  float[] RGBtoHSL(color col) {
    float r = red(col)/255;
    float g = green(col)/255;
    float b = blue(col)/255;

    float min = Math.min(r, Math.min(g, b));
    float max = Math.max(r, Math.max(g, b));

    //  Calculate the Hue

    float h = 0;

    if (max == min)
      h = 0;
    else if (max == r)
      h = ((60 * (g - b) / (max - min)) + 360) % 360;
    else if (max == g)
      h = (60 * (b - r) / (max - min)) + 120;
    else if (max == b)
      h = (60 * (r - g) / (max - min)) + 240;

    //  Calculate the Luminance

    float l = (max + min) / 2;

    //  Calculate the Saturation

    float s = 0;

    if (max == min)
      s = 0;
    else if (l <= .5f)
      s = (max - min) / (max + min);
    else
      s = (max - min) / (2 - max - min);

    return new float[] {h, s * 100, l * 100};
  }
}
