PImage img;
PImage img_out;

//CV
//Yuta Fujii
//2018/10/8

color BLACK = color(0, 0, 0);
color WHITE = color(255, 255, 255);
color OUTSIDE = color(0, 0, 0, 0);
void setup() {
  size(500, 1000);
  img = loadImage("target", "png");

  int w = img.width;
  int h = img.height;

  img_out = createImage(w, h, RGB);
}

void draw() {
  background(0);
  image(img, 0, 0);
  image(img_out, img.width, 0);

  color c = img.get(-1, -1);
  float r = red(c);
  float g = green(c);
  float b = blue(c);

  if (c == WHITE) {
  }
  if (c == BLACK) {
  }
}
