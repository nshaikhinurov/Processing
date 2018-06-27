import processing.pdf.*;
import java.util.*;

float screenWidth = 1000;
float screenHeight = 1000;
float strokeThickness = 5;
int n = 15;
float minRectDimention = 1;

color redColor = #F44336;
color yellowColor = #FFEB3B;
color indigoColor = #3F51B5;
color blackColor = #212121;
color whiteColor = #eeeeee;

color[] palette = {
  redColor
  ,yellowColor
  ,indigoColor
  // ,blackColor
};

List<Line> horizontalLines;
List<Line> verticalLines;
List<Box> boxes;

void setup(){
  size(1000, 1000);
  noLoop();
}

void draw(){
  beginRecord(PDF, "Mondrian.pdf");
  background(#eeeeee);
  do{
    generateMondrian();
  } while (!checkMondrian());

  removeBorders();

  translate(0.1*screenWidth, 0.1*screenHeight);
  drawMondrian();
  endRecord();
}

void generateMondrian(){
  initLists();
  addBorders();
  addLines();
  addBoxes();
}

void initLists(){
  horizontalLines = new ArrayList<Line>();
  verticalLines = new ArrayList<Line>();
  boxes = new ArrayList<Box>();
}

void addBorders(){
  Line topLine = new Line(0, 0, 1);
  Line bottomLine = new Line(1, 0, 1);
  Line leftLine = new Line(0, 0, 1);
  Line rightLine = new Line(1, 0, 1);
  horizontalLines.add(topLine);
  horizontalLines.add(bottomLine);
  verticalLines.add(leftLine);
  verticalLines.add(rightLine);
}

void addLines(){
  for (int i = 0; i < n; i++){
    int chosenLineIndex = floor(random(horizontalLines.size() + verticalLines.size()));
    if (chosenLineIndex < horizontalLines.size()){
      addVerticalLine(chosenLineIndex);
    }
    else {
      addHorizontalLine(chosenLineIndex - horizontalLines.size());
    }
  }
}

void addVerticalLine(int chosenLineIndex){
  Line line = horizontalLines.get(chosenLineIndex);
  float pointCoordinate = map(random(1), 0, 1, line.beginCoordinate, line.endCoordinate);

  List<Line> lineSet = new ArrayList<Line>();
  for(Line hLine : horizontalLines){
    if (hLine != line
      && hLine.beginCoordinate <= pointCoordinate
      && hLine.endCoordinate >= pointCoordinate
    )
      lineSet.add(hLine);
  }

  int chosenSecondLineIndex = floor(random(lineSet.size()));
  Line secondLine = lineSet.get(chosenSecondLineIndex);
  float beginCoordinate = min(line.level, secondLine.level);
  float endCoordinate = max(line.level, secondLine.level);
  Line newVerticalLine = new Line(pointCoordinate, beginCoordinate, endCoordinate);
  verticalLines.add(newVerticalLine);
}

void addHorizontalLine(int chosenLineIndex){
  Line line = verticalLines.get(chosenLineIndex);
  float pointCoordinate = map(random(1), 0, 1, line.beginCoordinate, line.endCoordinate);

  List<Line> lineSet = new ArrayList<Line>();
  for(Line vLine : verticalLines){
    if (vLine != line
      && vLine.beginCoordinate <= pointCoordinate
      && vLine.endCoordinate >= pointCoordinate
    )
      lineSet.add(vLine);
  }

  int chosenSecondLineIndex = floor(random(lineSet.size()));
  Line secondLine = lineSet.get(chosenSecondLineIndex);
  float beginCoordinate = min(line.level, secondLine.level);
  float endCoordinate = max(line.level, secondLine.level);
  Line newHorizontalLine = new Line(pointCoordinate, beginCoordinate, endCoordinate);
  horizontalLines.add(newHorizontalLine);
}

void addBoxes(){
  sortHorizontalLines();
  sortVerticalLines();
  for (int i = 1; i < horizontalLines.size(); i++){
    Line hLine = horizontalLines.get(i);
    List<Line> vLines = new ArrayList<Line>();
    for (Line vLine : verticalLines){
      if (vLine.beginCoordinate < hLine.level
        && vLine.endCoordinate >= hLine.level)
        vLines.add(vLine);
    }
    for (int j = 0; j < vLines.size()-1; j++){
      float bx1 = vLines.get(j).level;
      float by1 = hLine.level;
      float bx2 = vLines.get(j+1).level;
      float by2 = 0;
      for (int k = i-1; k >= 0; k--){
        Line upperLine = horizontalLines.get(k);
        if (upperLine.beginCoordinate <= bx1 && upperLine.endCoordinate >= bx2){
          by2 = upperLine.level;
          break;
        }
      }
      color boxColor;
      if (random(1) > 0.65)
        boxColor = getRandomPaletteColor();
      else
        boxColor = whiteColor;
      boxes.add(new Box(bx1, by1, bx2, by2, boxColor));
    }
  }
}

void sortHorizontalLines(){
  Collections.sort(horizontalLines, new Comparator<Line>() {
    @Override
    public int compare(Line lLine, Line rLine) {
        return Float.compare(lLine.level, rLine.level);
    }
  });
}

void sortVerticalLines(){
  Collections.sort(verticalLines, new Comparator<Line>() {
    @Override
    public int compare(Line lLine, Line rLine) {
        return Float.compare(lLine.level, rLine.level);
    }
  });
}

boolean checkMondrian(){
  println("\n========================\n");
  float minLevelHeight = 1.0;
  for (int i = 1; i < horizontalLines.size(); i++){
    minLevelHeight = min(minLevelHeight, horizontalLines.get(i).level - horizontalLines.get(i-1).level);
  }
  float minLevelWidth = 1.0;
  for (int i = 1; i < verticalLines.size(); i++){
    minLevelWidth = min(minLevelWidth, verticalLines.get(i).level - verticalLines.get(i-1).level);
  }
  float minDimention = min(minLevelHeight, minLevelWidth);
  if (minDimention < minRectDimention){
    minRectDimention *= 0.9999;
    return false;
  }
  println(minRectDimention);
  return true;
}

void removeBorders(){
  horizontalLines.remove(0);
  horizontalLines.remove(horizontalLines.size()-1);
  verticalLines.remove(0);
  verticalLines.remove(verticalLines.size()-1);
}

void drawMondrian(){
  noStroke();
  for (Box box : boxes){
    drawBox(box);
  }
  stroke(#111111);
  strokeWeight(strokeThickness);
  for (Line line : horizontalLines){
    drawHorizontalLine(line);
  }
  for (Line line : verticalLines){
    drawVerticalLine(line);
  }
}

void drawHorizontalLine(Line line){
  float x1 = map(line.beginCoordinate, 0, 1, 0, 0.8*screenWidth);
  float x2 = map(line.endCoordinate, 0, 1, 0, 0.8*screenWidth);
  float y1 = map(line.level, 0, 1, 0, 0.8*screenHeight);
  float y2 = map(line.level, 0, 1, 0, 0.8*screenHeight);
  line(x1, y1, x2, y2);
}

void drawVerticalLine(Line line){
  float x1 = map(line.level, 0, 1, 0, 0.8*screenWidth);
  float x2 = map(line.level, 0, 1, 0, 0.8*screenWidth);
  float y1 = map(line.beginCoordinate, 0, 1, 0, 0.8*screenHeight);
  float y2 = map(line.endCoordinate, 0, 1, 0, 0.8*screenHeight);
  line(x1, y1, x2, y2);
}

void drawBox(Box box){
  float x1 = map(box.bx1, 0, 1, 0, 0.8*screenWidth);
  float x2 = map(box.bx2, 0, 1, 0, 0.8*screenWidth);
  float y1 = map(box.by2, 0, 1, 0, 0.8*screenHeight);
  float y2 = map(box.by1, 0, 1, 0, 0.8*screenHeight);
  fill(box.boxColor);
  rect(x1, y1, x2-x1, y2-y1);
}

color getRandomPaletteColor(){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  minRectDimention = 1;
  redraw();
}
