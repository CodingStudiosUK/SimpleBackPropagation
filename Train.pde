float[] inputs = {0, 0};
float target = (int(inputs[0])^int(inputs[1]))==0?0:1;
float output;
int correctionTimer = 0;
void train() {
  output = b.propForward(inputs);
  if (round(target)!=round(output)) {
    frameCount = -2;
    correctionTimer++;
  }
  if (frameCount < 0 || mousePressed) {
    b.propBackward(inputs, target);
  }
  b.display();
  text(round(inputs[0])+"^"+round(inputs[1])+"="+round(target)
    +"\n"+round(output)+(round(target)==round(output)?" is right.":" is wrong.")
    +"\nCorrected in "+correctionTimer+" frames", width*0.5, height*0.05);
}
void keyPressed() {
  if (!test) {
    correctionTimer = 0;
    switch (key) {
    case 'q':
      inputs[0] = 0;
      inputs[1] = 0;
      break;
    case 'w':
      inputs[0] = 1;
      inputs[1] = 0;
      break;
    case 'e':
      inputs[0] = 1;
      inputs[1] = 1;
      break;
    case 'r':
      inputs[0] = 0;
      inputs[1] = 1;
      break;
    }
    target = (int(inputs[0])^int(inputs[1]))==0?0:1;
  }
  if (key == ' ') {
    test = !test;
    if (test) {
      LIMIT = 30;
      right = 0;
      total = 0;
      timer = 0;
    } else {
      correctionTimer = 0;
    }
  }
}