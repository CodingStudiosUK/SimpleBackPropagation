int LIMIT = 30;
int right = 0, total = 0, timer = 0;
boolean test = false;
void test() {
  output = b.propForward(inputs);
  if (round(target)!=round(output) && LIMIT > 5) {
    frameCount = -2;
  }
  if (frameCount < 0) {
    b.propBackward(inputs, target);
  }
  b.display();
  text(right+"/"+total+" correct within at most "+LIMIT+" frames"
    +"\n"+floor(float(right)/total*100)+"% correct rate", width*0.5, height*0.05);
  timer++;
  if (round(target)==round(output) || timer == LIMIT) {
    if (round(target)==round(output)) {
      right++;
    }
    total++;
    inputs[0] = int(random(0, 2));
    inputs[1] = int(random(0, 2));
    target = (int(inputs[0])^int(inputs[1]))==0?0:1; //IF statement necessary???
    timer = 0;
    if (right%100==99&&LIMIT>1) {
      LIMIT--;
    }
  }
}