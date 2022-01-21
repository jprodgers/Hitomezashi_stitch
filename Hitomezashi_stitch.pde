/*
1/14/2022 - Hitomezashi Stich generator
 By Jimmie Rodgers
 Released under public domain!
 
 Inspired by Numberphile: https://www.youtube.com/watch?v=JbfhzlMk2eY
 
 I made a few of these by hand, and then did a large page, which took
 me longer to draw than to write this program. I just wanted to play
 around with the basic patterns, and to add arbitrary colors. Being
 that it's Genuary, I went ahead and wrote this. Enjoy!

 Press S to save a frame.
 Press L to start loop again.
 */

// Didn't feel like rolling my own dashed lines, so here's a library.
import garciadelcastillo.dashedlines.*;
DashedLines dash;

// Fuck with these variables to change the size of the grid and spacing.
// Lots of this is still manual, so you'll have to choose lines based on
// your desired image size. I'd make it all variables, but see size() below.
int numXlines = 94;
int numYlines = 53;
int gap = 20;
int strokeThickness = 3;

// Here's your patterns. Use 1 or 0 to keep it simple, but any letter will work as well.
// A,E,I,O,U,Y,! will all give a 1, all other chars a 0.
// 1 will start a line on the first stitch, 0 will skip and start on the second stich.
String patternX = "Jimmie Rodgers was here making art!";
String patternY = "010101010101010101010101010101";

// Choose either DRAW_HORRIZONTAL or DRAW_DIAGONAL. Default is horrizontal, as that was
// the original orientation of the stitch pattern. Diagonal is fun though.
boolean DRAW_HORRIZONTAL = false;
boolean DRAW_DIAGONAL = true;

// ColorSpace will define the steps between colors, for gradients it is
// highly recommended that you use numXlines, or less, if you want the full
// gradient to display. For chosen colors, any colorSpace is fine.
int colorSpace = numXlines*2; 
// Make a pretty color pattern if you like. We are using HSB mode with
// saturation and brightness cranked up to make it easy. Keep your numbers
// lower than colorSpace, otherwise everything will just be red.
int colors[] = {colorSpace/8,colorSpace/7,colorSpace/6,colorSpace/5,colorSpace/4,colorSpace/3,colorSpace/2,colorSpace};

// If you like your image you can save it!
boolean SAVE_ON_DRAW = false;
int maxSaves = 60;
String fileName = "hitomezashi_stitch-###.png";

// Draws a single frame, and then delays. Useful to set the screen refresh.
boolean DELAY_SINGLE = false;
int delaySingle = 100;
// Loops like normal, default should be false.
// Use with DRAW_SINGLE to set the refresh rate.
boolean LOOP_MODE = false;

// Creates a gap around the stich pattern. It's currently broken, leave it false.
boolean GAP_BORDER = false;

// Choose one or the other.
boolean RANDOM_OFFSET = true; // Randomly offsets each row and column.
boolean PATTERN_OFFSET = false; // Uses the pattern to offset.

// If PATTERN_OFFSET is true, you can have it mutate each refresh.
// Currently it just randomizes a single X and Y, so it won't always change.
boolean PATTERN_MUTATE = false;
int numMutationsX = 1; // How many X to mutate.
int numMutationsY = 1; // How many Y to mutate.

// Choose one color method, otherwise it's single color.
boolean RANDOM_COLORS = false; // Random colors for each row and column.
boolean PATTERN_COLORS = false; // Uses colors[] to set the color
boolean RAINBOW_COLORS = true; // Rainbow gradient, it's fun.

// If RAINBOW_COLORS is true, RAINBOW_OFFSET will move through a gradient.
// It changes the colors each time based on the number of times called.
// Some line #s work better than others.
boolean RAINBOW_OFFSET = true;

// Don't fuck with these, used below.
int xWidth = numXlines * gap;
int yWidth = numYlines * gap;
int gapBorder = 0;
int rainbowOffset = 0;
float offsetDiagonal = sqrt(sq(gap)+sq(gap));

// Sets size() based on the number of lines chosen.
void settings(){
  size(xWidth, yWidth);
}

void setup() {  
  dash = new DashedLines(this);
  if(DRAW_HORRIZONTAL) dash.pattern(gap, gap);
  else if(DRAW_DIAGONAL) dash.pattern(offsetDiagonal, offsetDiagonal);
  colorMode(HSB, colorSpace, 1, 1);
  if(GAP_BORDER) gapBorder = gap;
  noFill();
  if(LOOP_MODE == false)noLoop();
}

void draw() {
  background(0);
  strokeWeight(strokeThickness);
  
  // Draws all the lines, depending on orientation.
  if(DRAW_HORRIZONTAL)drawHorrizontal();
  else if(DRAW_DIAGONAL)drawDiagonal();
  
  // Mutates the pattern by a single digit in both of the patternX & Y arrays.
  if (PATTERN_MUTATE) mutatePattern(numMutationsX, numMutationsY);
  
  // Draws a single frame and then pauses. This is warrented if you actually want to see each frame between refreshes.
  if (DELAY_SINGLE)delay(delaySingle);
  // Saves an image as defined above, up to maxSaves (in case you leave it running).
  if(maxSaves>0 && SAVE_ON_DRAW){
    saveFrame(fileName);
    maxSaves--;
  }
}

// S or s saves, l or L loops.
void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame(fileName);
  }
  if (key == 'l' || key == 'L'){
    redraw();
  }
  if (key == 'r' || key == 'R'){
    mutatePattern(numMutationsX, numMutationsY);
  }
}

void drawHorrizontal(){
for (int x=1; x<numXlines; x++) {
    // Sets colors as selected above.
    if (RANDOM_COLORS) stroke(random(255), random(255), random(255));
    else if (PATTERN_COLORS) stroke(colors[x%colors.length],colorSpace,colorSpace);
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
    // Sets the offset from above, else it's just 0.
    if (RANDOM_OFFSET) offset = gap*(int(random(10)%2));
    else if (PATTERN_OFFSET) {
      char patternTemp = patternX.charAt(x%patternX.length());
      if (patternTemp == '1' || patternTemp == 'A' || patternTemp == 'a' || patternTemp == 'E' || patternTemp == 'e' || 
          patternTemp == 'I' || patternTemp == 'i' || patternTemp == 'O' || patternTemp == 'o' || patternTemp == 'U' || 
          patternTemp == 'Y' || patternTemp == 'y' || patternTemp == '!') offset = gap;
      else offset = 0;
    }
    dash.line(x*gap+gapBorder, gapBorder+offset, x*gap+gapBorder, yWidth+gapBorder+offset);
  }
  // Draws all the y lines.
  for (int y=1; y<numYlines; y++) {
    // Sets colors as selected above.
    if (RANDOM_COLORS) stroke(random(255), random(255), random(255));
    else if (PATTERN_COLORS) stroke(colors[y%colors.length],colorSpace,colorSpace);
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
    // Sets the offset from above, else it's just 0.
    if (RANDOM_OFFSET) offset = gap*(int(random(10)%2));
    else if (PATTERN_OFFSET) {
      char patternTemp = patternY.charAt(y%patternY.length());
      if (patternTemp == '1' || patternTemp == 'A' || patternTemp == 'a' || patternTemp == 'E' || patternTemp == 'e' || 
          patternTemp == 'I' || patternTemp == 'i' || patternTemp == 'O' || patternTemp == 'o' || patternTemp == 'U' || 
          patternTemp == 'Y' || patternTemp == 'y' || patternTemp == '!') offset = gap;
      else offset = 0;
    }
    dash.line(gapBorder+offset, y*gap+gapBorder, xWidth+gapBorder+offset, y*gap+gapBorder);
  }

}

void drawDiagonal(){
  int offset = 0;
  for (int x=-numYlines; x<numXlines+numYlines; x++) {
    if (RANDOM_COLORS) stroke(random(colorSpace), colorSpace, colorSpace);
    else if (PATTERN_COLORS) stroke(colors[(x+numYlines)%colors.length],colorSpace,colorSpace);
    else if (RAINBOW_COLORS) {
      colorMode(HSB, colorSpace);
      if(RAINBOW_OFFSET){
        stroke(rainbowOffset, colorSpace, colorSpace);
        rainbowOffset++;
        if(rainbowOffset>colorSpace) rainbowOffset = 0;
      } 
      else stroke((x-numYlines)*(colorSpace/numXlines), colorSpace, colorSpace);
    } 
    else stroke(colorSpace);
    if (RANDOM_OFFSET) offset = gap*(int(random(10)%2));
    else if (PATTERN_OFFSET) {
      char patternTemp = patternX.charAt((x+numYlines)%patternX.length());
      if (patternTemp == '1' || patternTemp == 'A' || patternTemp == 'a' || patternTemp == 'E' || patternTemp == 'e' || 
          patternTemp == 'I' || patternTemp == 'i' || patternTemp == 'O' || patternTemp == 'o' || patternTemp == 'U' || 
          patternTemp == 'Y' || patternTemp == 'y' || patternTemp == '!') offset = gap;
      else offset = 0;
    }
    dash.line(x*gap-offset,0+offset,(x-numYlines)*gap-offset,height+offset);
  }
  for (int y=-numYlines; y<numXlines+numYlines; y++) {
    if (RANDOM_COLORS) stroke(random(colorSpace), colorSpace, colorSpace);
    else if (PATTERN_COLORS) stroke(colors[(y+numYlines)%colors.length],colorSpace,colorSpace);
    else if (RAINBOW_COLORS) {
      colorMode(HSB, colorSpace);
      if(RAINBOW_OFFSET){
        stroke(rainbowOffset, colorSpace, colorSpace);
        rainbowOffset++;
        if(rainbowOffset>colorSpace) rainbowOffset = 0;
      } 
      else stroke((y-numYlines)*(colorSpace/numXlines), colorSpace, colorSpace);
    } 
    else stroke(colorSpace);
    if (RANDOM_OFFSET) offset = gap*(int(random(10)%2));
    else if (PATTERN_OFFSET) {
      char patternTemp = patternY.charAt((y+numYlines)%patternY.length());
      if (patternTemp == '1' || patternTemp == 'A' || patternTemp == 'a' || patternTemp == 'E' || patternTemp == 'e' || 
          patternTemp == 'I' || patternTemp == 'i' || patternTemp == 'O' || patternTemp == 'o' || patternTemp == 'U' || 
          patternTemp == 'Y' || patternTemp == 'y' || patternTemp == '!') offset = gap;
      else offset = 0;
    }
    dash.line(y*gap+offset,0+offset,(y+numYlines)*gap+offset,height+offset);
  }
}

void mutatePattern(int numX, int numY){
    String xTemp1 = "";
    String xTemp2 = "";
    String yTemp1 = "";
    String yTemp2 = "";
    
    for(int i = 0; i<numX; i++){
      int xBreak = int(random(patternX.length()));
      if (xBreak>0) xTemp1 = patternX.substring(0, xBreak);
      if (xBreak<patternX.length()) xTemp2 = patternX.substring(xBreak+1, patternX.length());
      String xMutant = str(int(random(10)%2));
      patternX = xTemp1 + xMutant + xTemp2;
    }
    
    for(int i = 0; i<numY; i++){
      int yBreak = int(random(patternY.length()));
      if (yBreak>0) yTemp1 = patternY.substring(0, yBreak);
      if (yBreak<patternY.length()) yTemp2 = patternY.substring(yBreak+1, patternY.length());
      String yMutant = str(int(random(10)%2));
      patternY = yTemp1 + yMutant + yTemp2;
    }
};
