/**
 * oscP5broadcastClient by andreas schlegel
 * an osc broadcast client.
 * an example for broadcast server is located in the oscP5broadcaster exmaple.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;


OscP5 oscP5;

int msgDelay = 100;
int num = 7;

DI arrSquare[] = new DI[num];

/* a NetAddress contains the ip address and port number of a remote location in the network. */
NetAddress myBroadcastLocation; 

void setup() {
  size(400,400);
  frameRate(25);
  
  oscP5 = new OscP5(this,6004);
  
  /* the address of the osc broadcast server */
  myBroadcastLocation = new NetAddress("10.100.35.205",6004);
  
  //Load Square coordinates
  arrSquare[0] = new DI(TYPE_MOVE_TO,0,0);
  arrSquare[1] = new DI(TYPE_MOVE_TO,.1,.1);
  arrSquare[2] = new DI(TYPE_DRAW_TO,.8,.1);
  arrSquare[3] = new DI(TYPE_DRAW_TO,.8,.8);
  arrSquare[4] = new DI(TYPE_DRAW_TO,.1,.8);
  arrSquare[5] = new DI(TYPE_DRAW_TO,.1,.1);
  arrSquare[6] = new DI(TYPE_MOVE_TO,0,0);

}


void draw() {

  background(0);
}

void drawSquare() {
  
   OscMessage m;
 
   println("Draw square");

   m = new OscMessage("/coords");
   int _lastPenPosition = TYPE_MOVE_TO;
 
   for (int i=0; i<arrSquare.length; i++)
   {
        //If we are switching from moving to drawing, or vs versa, move pen first
        if (arrSquare[i].type != _lastPenPosition && i>0) {
          m.add(arrSquare[i-1].movePen(arrSquare[i].type));
          _lastPenPosition = arrSquare[i].type;
        }
 
        m.add(arrSquare[i].write());
   }
    
   //Send It out
   oscP5.send(m, myBroadcastLocation);
}


void keyPressed() {
  OscMessage m;
  switch(key) {
  
     case('b'):
      println("Move Pen to Boundries");

      /* disconnect from the broadcaster */
      m = new OscMessage("/coords");
      m.add("[0.0,0.0," + COORD_PEN_DOWN + "]");
      m.add("[1,0," + COORD_PEN_UP + "]");
      m.add("[1,1," + COORD_PEN_UP + "]");
      m.add("[0,1," + COORD_PEN_UP + "]");
      m.add("[0,0," + COORD_PEN_UP + "]");
    
      //Send It out
      oscP5.send(m, myBroadcastLocation);
      break;
      
    case('p'):
      println("PEN UP AND DOWN");

      /* disconnect from the broadcaster */
      m = new OscMessage("/coords");
      m.add("[0.0,0.0," + COORD_PEN_UP + "]");
      m.add("[0.1,0.1," + COORD_PEN_DOWN + "]");
      m.add("[0.0,0.0," + COORD_PEN_DOWN + "]");
      //m.add("[0.0,0.0," + COORD_PEN_LOAD + "]");
    
      //Send It out
      oscP5.send(m, myBroadcastLocation);
      break;
 
    case('s'):
    
      //DRAW A SQUARE
      drawSquare();
  
      break;

  }  
}



/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* get and print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  theOscMessage.print();
}