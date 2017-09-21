Brain b = null;
class Brain {
  Node[] l1, l2, l3;
  Brain(int len1, int len2, int len3) {
    l3 = new Node[len3];
    for (int i = 0; i < len3; i++) {
      l3[i] = new Node(width*0.75, height*0.5); //Use LERP!
    }
    l2 = new Node[len2];
    for (int i = 0; i < len2; i++) {
      l2[i] = new Node(l3, width*0.5, height*(0.5+lerp(-0.3, 0.3, map(i, 0, len2-1, 0, 1))));
    }
    l1 = new Node[len1];
    for (int i = 0; i < len1; i++) {
      l1[i] = new Node(l2, width*0.25, height*(0.5+lerp(-0.3, 0.3, map(i, 0, len1-1, 0, 1))));
    }
  }

  void display() {
    for (int i = 0; i < l1.length; i++) {
      l1[i].displaySyns();
    }
    for (int i = 0; i < l2.length; i++) {
      l2[i].displaySyns();
    }
    for (int i = 0; i < l1.length; i++) {
      l1[i].display();
      l1[i].val = 0;
      l1[i].disval = 0;
    }
    for (int i = 0; i < l2.length; i++) {
      l2[i].display();
      l2[i].val = 0;
      l2[i].disval = 0;
    }
    for (int i = 0; i < l3.length; i++) {
      l3[i].display();
      l3[i].val = 0;
      l3[i].disval = 0;
    }
  }

  float propForward(float[] inputs) {
    for (int i = 0; i < inputs.length; i++) {
      l1[i].disval = inputs[i];
      l1[i].val = l1[i].disval;
      l1[i].propForward();
    }
    for (int i = 0; i < l2.length; i++) {
      l2[i].disval += 1;
      l2[i].val = sig(l2[i].disval);
      l2[i].propForward();
    }
    for (int i = 0; i < l3.length; i++) {
      l3[i].val = sig(l3[i].disval);
    }
    return l3[0].val;
  }

  void propBackward(float[] inputs, float target) {
    float marginError = target-l3[0].val;//0.5*pow(target-l3[0].val, 2);
    float deltaValOutput = deriv(l3[0].disval) * marginError;
    float[] deltaWeightsHidden = new float[l2.length];
    float[] deltaValHidden = new float[l2.length];
    for (int i = 0; i < l2.length; i++) {
      deltaWeightsHidden[i] = l2[i].val*deltaValOutput;
      deltaValHidden[i] = deltaValOutput*l2[i].syns[0]*deriv(l2[i].disval);
    }
    float deltaWeightsInput[] = new float[deltaValHidden.length*inputs.length];
    for (int i = 0; i < inputs.length; i++) {
      for (int j = 0; j < deltaValHidden.length; j++) {
        deltaWeightsInput[i*deltaValHidden.length+j] = deltaValHidden[j]*inputs[i];
      }
    }
    for (int i = 0; i < l2.length; i++) {
      l2[i].syns[0] += deltaWeightsHidden[i];
    }
    for (int i = 0; i < l1.length; i++) {
      for (int j = 0; j < l1[i].syns.length; j++) {/*
        println(i+"."+j);
       println(i*deltaValHidden.length+j);
       println(deltaWeightsInput[i*deltaValHidden.length+j]);
       println();*/
        l1[i].syns[j] += deltaWeightsInput[i*deltaValHidden.length+j];
      }
    }
  }

  //void propBackward(float[] inputs, float[] out, float target) {
  //  float errorMargin = target-out[1];
  //  float deltaOut = deriv(out[0])*errorMargin;
  //  println(errorMargin);
  //  println(""+target+" : "+out[0]);
  //  println(deltaOut);

  //  float[] oldHidden = new float[3];
  //  for (int i = 0; i < l2.length; i++) {
  //    oldHidden[i] = l2[i].syns[0];
  //  }

  //  for (int i = 0; i < l2.length; i++) { //Change hidden layer weights
  //    l2[i].syns[0] += l2[i].val*deltaOut;
  //  }

  //  float[] deltaHidden = new float[l2.length*2];
  //  for (int i = 0; i < deltaHidden.length/2; i++) {
  //    deltaHidden[i] = l2[i].syns[0]*deltaOut;
  //    deltaHidden[i] *= deriv(l2[i].oldVal);
  //  }

  //  for (int i = 0; i < l1.length; i++) {
  //    for (int j = 0; j < l1[i].syns.length; j++) {
  //      if (i == 0) {
  //        l1[i].syns[j]+=deltaHidden[j];
  //      } else {
  //        l1[i].syns[j]+=deltaHidden[l1[i].syns.length+j];
  //      }
  //    }
  //  }
  //}

  class Node {
    float val = 0, disval = 0, syns[];
    int x, y;

    Node[] nxtLayer;
    Node(float x, float y) {
      syns = new float[0];
      this.x = (int)x; 
      this.y = (int)y;
    }
    Node(Node[] nxt, float _x, float _y) {
      nxtLayer = nxt;
      syns = new float[nxtLayer.length];
      for (int i = 0; i < syns.length; i++) {
        syns[i] = random(1);
      }
      this.x = (int)_x; 
      this.y = (int)_y;
    }


    void display() {
      fill(50);
      ellipse(x, y, width*0.1, width*0.1);
      fill(200);
      text("("+nf(disval, 1, 2)+")\n"+nf(val, 1, 2), x, y);
      fill(255);
      for (int i = 0; i < syns.length; i++) {
        text(nf(syns[i], 1, 2), lerp(x, nxtLayer[i].x, 0.3), lerp(y, nxtLayer[i].y, 0.3));
      }
    }
    void displaySyns() {
      for (int i = 0; i < syns.length; i++) {
        strokeWeight(constrain(abs(syns[i])*20,1,100));
        line(x, y, nxtLayer[i].x, nxtLayer[i].y);
      }
      strokeWeight(2);
    }

    void propForward() {
      for (int i = 0; i < nxtLayer.length; i++) {
        nxtLayer[i].disval += val*syns[i];
      }
    }
  }
}