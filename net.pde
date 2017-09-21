void setup() {
  fullScreen();
  if (b == null) {
    stroke(250, 150, 0);
    textSize(width*0.015);
    b = new Brain(2, 3, 1);
    textAlign(CENTER, CENTER);
  }
}
void draw() {
  background(0);
  if (test) {
    test();
  } else {
    train();
  }
}
import java.lang.Math;
float sig(float x) {
  return 1/(1+pow((float)Math.E, -x));
}
float deriv(float x) {
  return sig(x)*(1-sig(x));
}