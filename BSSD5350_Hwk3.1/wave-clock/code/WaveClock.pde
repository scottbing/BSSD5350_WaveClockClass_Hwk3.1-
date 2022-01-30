class WaveClock{
  float _x;
  float _y;
	float _angnoise, _radiusnoise;
	float _xnoise, _ynoise;
	float _angle = -PI/2;
	float _radius;  color _strokeCol;
	int _strokeChange = -1;
  int strokeW = 1;
  int factor = height/16;
  int padding = 20;
  int x0, y0, x1, y1;    // Line start and end
  float vpct = 0.29;     // Variation in line as %
  float llength;         // Line length
  float lthresh = 7.0;
  int count = 0;

WaveClock(float x, float y, color strokeCol) {
  _x = x;
  _y = y;
  _angnoise = random(10);
  _radiusnoise = random(10);
	_xnoise = random(10);
  _ynoise = random(10);
  _strokeCol = strokeCol;	
}

void show() {
  _radiusnoise += 0.005;
  _radius = (noise(_radiusnoise) * 550) +1;
  _angnoise += 0.005;
  _angle += (noise(_angnoise) * 6) - 3;
  if (_angle > 360) { _angle -= 360; }
  if (_angle < 0) { _angle += 360; }
  _xnoise += 0.01;
  _ynoise += 0.01;
  float centerX = width/2 + (noise(_xnoise) * 100) - 50;
  float centerY = height/2 + (noise(_ynoise) * 100) - 50;
  float rad = radians(_angle);
  float x1 = centerX + (_radius * cos(rad));
  float y1 = centerY + (_radius * sin(rad));
  float opprad = rad + PI;
  float x2 = centerX + (_radius * cos(opprad));
  float y2 = centerY + (_radius * sin(opprad));
  _strokeCol += _strokeChange;
  if (_strokeCol > 254) { _strokeChange = -1; }
  if (_strokeCol < 0) { _strokeChange = 1; }
  stroke(_strokeCol, 60);
  strokeWeight(1);
  line(x1, y1, x2, y2);
  }
}
