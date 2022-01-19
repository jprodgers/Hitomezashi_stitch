/*
1/14/2022 - Hitomezashi Stich generator
 By Jimmie Rodgers
 Released under public domain!
 
 Inspired by Numberphile: https://www.youtube.com/watch?v=JbfhzlMk2eY
 
 I made a few of these by hand, and then did a large page, which took
 me longer to draw than to write this program. I just wanted to play
 around with the basic patterns, and to add arbitrary colors. Being
 that it's Genuary, I went ahead and wrote this. Enjoy!
 */

//Didn't feel like rolling my own dashed lines, so here's a library.
import garciadelcastillo.dashedlines.*;
DashedLines dash;

//Fuck with these variables to change the size of the grid and spacing.
int numXlines = 95;
int numYlines = 53;
int numZlines = 80;
int gap = 20;
int strokeThickness = 5;

//Here's your patterns. Use 1 or 0 to keep it simple, but any letter will work as well.
//A,E,I,O,U,Y will all give a 1, all other chars a 0.
//1 will start a line on the first stitch, 0 will skip and start on the second stich.
String patternX = "Jimmie";
String patternY = "Rodgers";

//If you like your image you can save it!
boolean SAVE_IMAGE = false;
boolean SAVE_ON_DRAW = false;
int maxSaves = 30;
String fileName = "hitomezashi_stitch-###.png";

//Choose one or the other.
boolean RANDOM_OFFSET = true; //Randomly offsets each row and column.
boolean PATTERN_OFFSET = false; //Uses the pattern to offset.
boolean GAP_BORDER = false;

boolean DRAW_SINGLE = false;
boolean DRAW_MANY = false;

//Choose one color method, otherwise it's single color.
boolean RANDOM_COLORS = false; //Random colors for each row and column.
boolean PATTERN_COLORS = false; //Uses colors[] to set the color
boolean RAINBOW_COLORS = true; //Rainbow gradient, it's fun.
boolean RAINBOW_OFFSET = true;

int colorSpace = numXlines; //This will define the steps between colors.
//Make a pretty color pattern if you like.
color colors[] = {color(255, colorSpace, colorSpace), 
                  color(550, colorSpace, colorSpace), 
                  color(1000, colorSpace, colorSpace)};

//Don't fuck with these, used below.
int xWidth = numXlines * gap;
int yWidth = numYlines * gap;
int zWidth = numZlines * gap;
int gapBorder = 0;
int rainbowOffset = 0;

void setup() {
  /*
For fuck's sake processsing, why, why, WHY, the fuck do I have to put
   a number into size()?!?! I get that I should be working based on window
   size, but sometimes I just want to bang out a thing, and you make me
   do manual math to make sure all my shit lines up. Size could have been
   a variable, but NOOOOOOO, I've got to calculate this shit manually.
   
   size = (numXlines*gap + 2*gap, numYlines*gap + 2*gap)
   Don't type that in though or the interpreter will yell at you.
   */
  size(1920, 1080);
  dash = new DashedLines(this);
  dash.pattern(gap, gap);
  colorMode(HSB, colorSpace, 1, 1);
  if(GAP_BORDER) gapBorder = gap;
  noFill();
  noLoop();
}

void draw() {
  background(0);
  strokeWeight(strokeThickness);
  //Draws all the x lines.
  for (int x=1; x<numXlines; x++) {
    //Sets colors as selected above.
    if (RANDOM_COLORS) stroke(random(255), random(255), random(255));
    else if (PATTERN_COLORS) stroke(colors[x%colors.length]);
    else if (RAINBOW_COLORS) {
      colorMode(HSB, colorSpace);
      if(RAINBOW_OFFSET){
        stroke(rainbowOffset, colorSpace, colorSpace);
        rainbowOffset++;
        if(rainbowOffset>colorSpace) rainbowOffset = 0;
      } 
      else stroke(x*(colorSpace/numXlines), colorSpace, colorSpace);
    } 
    else stroke(colorSpace);
    int offset = 0;
    //Sets the offset from above, else it's just 0.
    if (RANDOM_OFFSET) offset = gap*(int(random(10)%2));
    else if (PATTERN_OFFSET) {
      char patternTemp = patternX.charAt(x%patternX.length());
      if (patternTemp == '1'|| patternTemp == 'A' || patternTemp == 'a' || patternTemp == 'E' || patternTemp == 'e' || 
          patternTemp == 'I' || patternTemp == 'i' || patternTemp == 'O' || patternTemp == 'o' || patternTemp == 'U' || 
          patternTemp == 'Y' || patternTemp == 'y') offset = gap;
      else offset = 0;
    }
    dash.line(x*gap+gapBorder, gapBorder+offset, x*gap+gapBorder, yWidth+gapBorder+offset);
  }
  //Draws all the y lines.
  for (int y=1; y<numYlines; y++) {
    //Sets colors as selected above.
    if (RANDOM_COLORS) stroke(random(255), random(255), random(255));
    else if (PATTERN_COLORS) stroke(colors[y%colors.length]);
    else if (RAINBOW_COLORS) {
      colorMode(HSB, colorSpace);
      if(RAINBOW_OFFSET){
        stroke(rainbowOffset, colorSpace, colorSpace);
        rainbowOffset++;
        if(rainbowOffset>colorSpace) rainbowOffset = 0;
      } 
      else stroke(y*(colorSpace/numYlines), colorSpace, colorSpace);
    } 
    else stroke(colorSpace);
    int offset = 0;
    //Sets the offset from above, else it's just 0.
    if (RANDOM_OFFSET) offset = gap*(int(random(10)%2));
    else if (PATTERN_OFFSET) {
      char patternTemp = patternY.charAt(y%patternY.length());
      if (patternTemp == '1'|| patternTemp == 'A' || patternTemp == 'a' || patternTemp == 'E' || patternTemp == 'e' || 
          patternTemp == 'I' || patternTemp == 'i' || patternTemp == 'O' || patternTemp == 'o' || patternTemp == 'U' || 
          patternTemp == 'Y' || patternTemp == 'y') offset = gap;
      else offset = 0;
    }
    dash.line(gapBorder+offset, y*gap+gapBorder, xWidth+gapBorder+offset, y*gap+gapBorder);
  }
  if (DRAW_SINGLE)delay(500);
  if(maxSaves>0 && SAVE_ON_DRAW){
    saveFrame(fileName);
    maxSaves--;
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame(fileName);
  }
}

void mousePressed() {
  loop();
}

void mouseReleased() {
  noLoop();
}
