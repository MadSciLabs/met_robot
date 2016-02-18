int TYPE_MOVE_TO = 0;
int TYPE_DRAW_TO = 1;

float COORD_PEN_UP = .2;
float COORD_PEN_DOWN = 0.0;
float COORD_PEN_LOAD = 0.02;

class DI {
 
    PVector loc;
    int type;
    
    DI(int _type, float _x, float _y) {
     
        type = _type;
        loc = new PVector(_x,_y);
    }
    
    String write()
    {
       float _z = COORD_PEN_DOWN;
       if (type == TYPE_MOVE_TO) {
         _z = COORD_PEN_UP;
       }
       
       return "[" + loc.x + "," + loc.y + "," + _z + "]";
    }
    
    //Move pen in place before we draw or move to next
    String movePen(int _type)
    {    
         float _z = COORD_PEN_DOWN;
         if (_type == TYPE_MOVE_TO) {
           _z = COORD_PEN_UP;
         }
       
         return "[" + loc.x + "," + loc.y + "," + _z + "]";  
    }
 
    void drawSegment()
    {}
}