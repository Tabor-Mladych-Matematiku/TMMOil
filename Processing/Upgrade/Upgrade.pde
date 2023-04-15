import processing.serial.*;
import processing.sound.*;
int seconds = 0;
Serial myPort;
byte cVal;
boolean changedState;
Player[] Players = new Player[5];

String dataPath= "../../data/"; 

PFont font;
PImage miningBackground, upgradeBackground, up, down;
float oilPrice;
IntList list = new IntList();
int lastTime, lastTimeSold;
float lastPrice;
float soldBuffer;
float sellInfluence = 3;
boolean[] playerSold = new boolean[5];
float tempDelta;
int sign = 1;
float sellDelta;
int sellCounter;
float a1, a2, a3, b1, b2, b3, c1, c2, c3;

String winner;
float landPrice;
boolean won;


boolean playingSound;
SoundFile sound;

float X=0;

int year = 2;


int leap = 1;
int timeLimit = 365;
String gameState = "upgrade";
int startTime;
void setup() {


  frameRate(30);

  sound = new SoundFile(this,dataPath + "Turmoil OST - 07 - Oil Spill Hoedown.mp3");
  for (int i = 0; i < 5; i++) {
    list.append(0);
  }
  list.shuffle();

     String portName = Serial.list()[0];
    myPort = new Serial(this, portName, 9600);

  font = createFont(dataPath + "WesternBangBang-Regular.ttf", 80);
  textFont(font);
  fullScreen();
  size(1920, 1080);


  String[] inputLines = loadStrings(dataPath + "save.txt");

  String[][] lines = new String[inputLines.length][3];

  for (int i = 0; i < inputLines.length; i ++) {

    lines[i] = split(inputLines[i], ' ');
  }
  year = int(lines[0][1]);
  Players[0] = new Player("Červení", 0, list.get(0));
  Players[1] = new Player("Oranžoví", 375, list.get(1));
  Players[2] = new Player("Žlutí", 2*375, list.get(2));
  Players[3] = new Player("Zelení", 3*375, list.get(3));
  Players[4] = new Player("Modří", 4*375, list.get(4));

  for (int i = 0; i < Players.length; i++) {
    Players[i].loadStats(lines);
    Players[i].initializeStats();
    Players[i].loadImages();
  }
  miningBackground = loadImage(dataPath + "background/background-rev2.png");
  upgradeBackground = loadImage(dataPath + "background/upgrades-3.png");
  up = loadImage(dataPath + "background/arrow-up.png");
  down = loadImage(dataPath + "background/arrow-down.png");
}



void draw() {
setButtons();
  ///////////////////////////////////////////////////////////////////UPGRADE

  if (gameState.equals("upgrade")) {


    imageMode(CORNER);
    image(upgradeBackground, 0, 0);
    fill(0);

    for (int i = 0; i < Players.length; i++) {
      if(!Players[i].ready) {
      Players[i].upgrade();
      Players[i].showUpgrades();
      }
      else {
      Players[i].ready();
      Players[i].showUpgrades();
      
      }
    }
  }
  
  
  if(
  Players[0].ready &&
  Players[1].ready &&
  Players[2].ready &&
  Players[3].ready &&
  Players[4].ready
  ){
  switchState();
  }

}

void keyPressed () {
  if (!changedState);
  if (key == '\n')
    switchState();
}
void keyReleased() {
  changedState = false;
}

void switchState() {

  if (gameState.equals("upgrade"))
    savePlayers();
    exit();

}



void mouseReleased() {
  if (gameState.equals("upgrade"))
    for (int i = 0; i < Players.length; i++) {
      Players[i].changedStat = false;
      Players[i].loadImages();
      savePlayers();
      Players[i].initializeStats();
    }
}


void setButtons() {

  if ( myPort.available() > 0) {
    cVal = byte(myPort.read());
    if ((cVal != 10)&&(cVal != 13)) {

      for (int i = 4; i >= 0; i --) {
        int power = 1;
        for (int j = i; j > 0; j--) {
          power = power *2;
        }
        if (cVal >= power) {
          Players[i].buttonPressed = true;
          if (cVal != 1)
            cVal = byte(cVal - byte(power));
        } else Players[i].buttonPressed = false;
      }
    
  }
}}


float round2 (float num) {

  return (round(num*100)/100);
}
