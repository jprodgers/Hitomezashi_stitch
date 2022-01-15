import garciadelcastillo.dashedlines.*;
DashedLines dash;

int numXlines = 200;
int numYlines = 120;
int gap = 10;
int xWidth = numXlines * gap;
int yWidth = numYlines * gap;
int xLength = yWidth;
int yLength = xWidth;
int patternX[] = {0,1,1,1,0,0,1,1,1,1};
int patternY[] = {0,0,1,1,1};

boolean SAVE_IMAGE = true;
String fileName = "hitomezashi_stitch-####.png";

boolean RANDOM_OFFSET = false;
boolean PATTERN_OFFSET = true;

boolean RANDOM_COLORS = false;
boolean PATTERN_COLORS = false;
color colors[] = {color(255,0,0),color(0,255,0),color(0,0,255)};

size(2020, 1220);
background(0);
dash = new DashedLines(this);
dash.pattern(gap, gap);
noFill();

for (int x=0; x<numXlines; x++) {
  if (RANDOM_COLORS) stroke(random(255), random(255), random(255));
  else if (PATTERN_COLORS) stroke(colors[x%colors.length]);
  else stroke(255);
  int offset = 0;
  if (RANDOM_OFFSET) offset = gap*(int(random(10)%2));
  else if(PATTERN_OFFSET){
    offset = patternX[x%(patternX.length)]*gap;
  }
  dash.line(x*gap+gap, gap+offset, x*gap+gap, yWidth+gap+offset);
}
for (int y=0; y<numYlines; y++) {
  if (RANDOM_COLORS) stroke(random(255), random(255), random(255));
  else if (PATTERN_COLORS) stroke(colors[y%colors.length]);
  else stroke(255);
  int offset = 0;
  if (RANDOM_OFFSET) offset = gap*(int(random(10)%2));
  else if(PATTERN_OFFSET){
    offset = patternY[y%(patternY.length)]*gap;
  }
  dash.line(gap+offset, y*gap+gap, xWidth+gap+offset, y*gap+gap);
}
if(SAVE_IMAGE)saveFrame(fileName);
