/* autogenerated by Processing revision 1286 on 2023-04-13 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class Map extends PApplet {


float x, y;
  int offsetX, offsetY;
boolean changed;
int size = 10;
int[][] map;
boolean[][] mask;
boolean move;

 public void setup() {
  
map = new int[size][size];
mask = new boolean[size][size];
background(255);
/* size commented out by preprocessor */;
}
 public void draw() {
    noiseDetail(PApplet.parseInt(y),0.2f);
if(move){
  y = map(height - mouseY,0, height, 0, 1);
  x = map(mouseX,0, width, 0, y);
}
  background(255);
for (int i = 0; i < size; i ++){
for (int j = 0; j < size; j ++){
  map[i][j] = 3 + PApplet.parseInt(30*(noise((i+offsetX)*x,(j+offsetY)*x)));
}}
for (int i = 0; i < size; i ++){
for (int j = 0; j < size; j ++){
 
  if((i+j) % 2 == 0) 
fill(255);
else fill(180);
if (mask[i][j]) fill(20, 50, 200);
  rect(i*width/size,j*width/size,height/size,height/size);
  fill(0);
  textSize(height/(size * 2));
  strokeWeight(map[i][j]);
   textSize(map(map[i][j],3,33,30,45));
  textAlign(CENTER,CENTER);
  text(map[i][j], (i*width/size) + width/(size*2),j*height/size + height/(size*2));
  
}

}}

 public void mousePressed() {
  if (!move)
mask[PApplet.parseInt(map(mouseX, 0, width, 0, size))][PApplet.parseInt(map(mouseY, 0, height, 0, size))] = !mask[PApplet.parseInt(map(mouseX, 0, width, 0, size))][PApplet.parseInt(map(mouseY, 0, height, 0, size))];
}

 public void keyPressed () {
if(!changed){
  //if (key == '+')
  //size ++;
  //  if ((key == '-')&&size > 1)
  //size --;
  
  if ((key == '\n')&&size > 1)
  saveMap();
if (key==CODED) {

if (keyCode == LEFT) {
offsetX ++;

}
if (keyCode == RIGHT) {
offsetX --;


}
if (keyCode == UP) {
offsetY ++;


}
if (keyCode == DOWN) {
offsetY --;


}}
if (key == ' ')
noiseSeed((long)random(99999));
if (key == 'm')
move = !move;
}

}
 public void keyReleased() {
changed = false;
}

 public void saveMap() {
PrintWriter output = createWriter("../data/map.txt");
for (int i = 0; i < size; i ++){
for (int j = 0; j < size; j ++){
  if(mask[j][i])
  output.print("-1");
  else 
  output.print(map[j][i]);
  output.println();
}



}
output.flush();
output.close();


}


  public void settings() { size(800, 800, P2D); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Map" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
