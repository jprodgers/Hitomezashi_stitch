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
int numXlines = 133;
int numYlines = 80;
int gap = 15;

//Here's your pattern. Only use a 1 or 0. Live with it, embrace it.
//I could do this differently and accept any number, but this was easy.
byte patternX[] = {1,1,1,0,0,0,1,0,1};
byte patternY[] = {0,0,1,1,1,0,1,1,0};

//If you like your image you can save it!
boolean SAVE_IMAGE = false;
String fileName = "hitomezashi_stitch-0000.png";

//Choose one or the other.
boolean RANDOM_OFFSET = false; //Randomly offsets each row and column.
boolean PATTERN_OFFSET = true; //Uses the pattern to offset.

//Choose one color method, otherwise it's single color.
boolean RANDOM_COLORS = false; //Random colors for each row and column.
boolean PATTERN_COLORS = false; //Uses colors[] to set the color
boolean RAINBOW_COLORS = true; //Rainbow gradient, it's fun.

int colorSpace = 1024; //This will define the steps between colors.
//Make a pretty color pattern if you like.
color colors[] = {color(255,0,0),color(0,255,0),color(0,0,255)};

//Don't fuck with these, used below.
int xWidth = numXlines * gap;
int yWidth = numYlines * gap;
int xLength = yWidth;
int yLength = xWidth;

/*
For fuck's sake processsing, why, why, WHY, the fuck do I have to put
a number into size()?!?! I get that I should be working based on window
size, but sometimes I just want to bang out a thing, and you make me
do manual math to make sure all my shit lines up. Size could have been
a variable, but NOOOOOOO, I've got to calculate this shit manually.

size = (numXlines*gap + 2*gap, numYlines*gap + 2*gap)
Don't type that in though or the interpreter will yell at you.
*/
size(2030, 1230);
background(0);
dash = new DashedLines(this);
dash.pattern(gap, gap);
noFill();

//Draws all the x lines.
for (int x=0; x<numXlines; x++) {
  //Sets colors as selected above.
  if (RANDOM_COLORS) stroke(random(255), random(255), random(255));
  else if (PATTERN_COLORS) stroke(colors[x%colors.length]);
  else if (RAINBOW_COLORS){
    colorMode(HSB,colorSpace);
    stroke(x*(colorSpace/numXlines),colorSpace,colorSpace);
  }
  else stroke(255);
  int offset = 0;
  //Sets the offset from above, else it's just 0.
  if (RANDOM_OFFSET) offset = gap*(int(random(10)%2));
  else if(PATTERN_OFFSET){
    offset = patternX[x%(patternX.length)]*gap;
  }
  dash.line(x*gap+gap, gap+offset, x*gap+gap, yWidth+gap+offset);
}
//Draws all the y lines.
for (int y=0; y<numYlines; y++) {
  //Sets colors as selected above.
  if (RANDOM_COLORS) stroke(random(255), random(255), random(255));
  else if (PATTERN_COLORS) stroke(colors[y%colors.length]);
  else if (RAINBOW_COLORS){
    colorMode(HSB,colorSpace);
    stroke(y*(colorSpace/numYlines),colorSpace,colorSpace);
  }
  else stroke(255);
  int offset = 0;
  //Sets the offset from above, else it's just 0.
  if (RANDOM_OFFSET) offset = gap*(int(random(10)%2));
  else if(PATTERN_OFFSET){
    offset = patternY[y%(patternY.length)]*gap;
  }
  dash.line(gap+offset, y*gap+gap, xWidth+gap+offset, y*gap+gap);
}
if(SAVE_IMAGE)saveFrame(fileName);
