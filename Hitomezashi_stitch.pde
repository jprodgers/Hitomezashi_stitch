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
int numXlines = 94;
int numYlines = 52;
int numZlines = 80;
int gap = 20;
int strokeThickness = 5;

//Here's your patterns. Only use a 1 or 0. Live with it, embrace it.
String patternX = "010010";
String patternY = "01";
String patternZ = "01";

//If you like your image you can save it!
boolean SAVE_IMAGE = false;
boolean SAVE_ON_DRAW = false;
String fileName = "hitomezashi_stitch-###.png";

//Choose one or the other.
boolean RANDOM_OFFSET = true; //Randomly offsets each row and column.
boolean PATTERN_OFFSET = false; //Uses the pattern to offset.

boolean DRAW_SINGLE = false;
boolean DRAW_MANY = false;

//Choose one color method, otherwise it's single color.
boolean RANDOM_COLORS = false; //Random colors for each row and column.
boolean PATTERN_COLORS = false; //Uses colors[] to set the color
boolean RAINBOW_COLORS = true; //Rainbow gradient, it's fun.

int colorSpace = 1024; //This will define the steps between colors.
//Make a pretty color pattern if you like.
color colors[] = {color(255, colorSpace, colorSpace), color(550, colorSpace, colorSpace), color(1000, colorSpace, colorSpace)};

//Don't fuck with these, used below.
int xWidth = numXlines * gap;
int yWidth = numYlines * gap;
int zWidth = numZlines * gap;

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
      stroke(x*(colorSpace/numXlines), colorSpace, colorSpace);
    } else stroke(colorSpace);
    int offset = 0;
    //Sets the offset from above, else it's just 0.
    if (RANDOM_OFFSET) offset = gap*(int(random(10)%2));
    else if (PATTERN_OFFSET) {
      offset = (int(patternX.charAt(x%patternX.length()))-48)*gap;
    }
    dash.line(x*gap+gap, gap+offset, x*gap+gap, yWidth+gap+offset);
  }
  //Draws all the y lines.
  for (int y=1; y<numYlines; y++) {
    //Sets colors as selected above.
    if (RANDOM_COLORS) stroke(random(255), random(255), random(255));
    else if (PATTERN_COLORS) stroke(colors[y%colors.length]);
    else if (RAINBOW_COLORS) {
      colorMode(HSB, colorSpace);
      stroke(y*(colorSpace/numYlines), colorSpace, colorSpace);
    } else stroke(colorSpace);
    int offset = 0;
    //Sets the offset from above, else it's just 0.
    if (RANDOM_OFFSET) offset = gap*(int(random(10)%2));
    else if (PATTERN_OFFSET) {
      offset = (int(patternY.charAt(y%patternY.length()))-48)*gap;
    }
    dash.line(gap+offset, y*gap+gap, xWidth+gap+offset, y*gap+gap);
  }
  if (DRAW_SINGLE)delay(500);
  if(SAVE_ON_DRAW)saveFrame(fileName);
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
