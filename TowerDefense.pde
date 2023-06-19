//CONSTANTS
final int TOWER_SIZE = 25, TOWER_FOOTPRINT = 15, RANGE = 200, SHOP_BUTTON_SIZE = 90, PATH_WIDTH = 50, MENU_WIDTH = 200, ENEMY_SIZE = 50, ENEMY_MAX_HEALTH = 10;
final float ENEMY_BASE_SPEED = 1.5;
final color RADIUS_COLOR = color(100, 100, 100, 80), PATH_COLOR = color(192, 196, 179), MENU_COLOR = #c98200, BASE_TOWER_COLOR = color(150, 255, 255);

boolean placingTower, towerSelected;
int lives, towerSelectedIndex, money;

Path path;
PImage background;
BaseTower tempTower;

final Enemy[] possibleEnemies = {
  new Enemy(5),
  new Enemy(1)
};

final BaseTower[] possibleTowers = {
  new DartMonkey()
};

ShopButton[] shopButtons = new ShopButton[possibleTowers.length];

ArrayList<Enemy> spawnedEnemies = new ArrayList<Enemy>();
ArrayList<BaseTower> purchasedTowers = new ArrayList<BaseTower>();

void setup() {
  //frameRate(1);
  size(1420, 780);
  lives = 250;
  placingTower = false;
  towerSelected = false;
  path = new Path();

  background = loadImage("MonkeyMeadow.png");
  background.resize(width - MENU_WIDTH, height);

  for (int i = 0; i < shopButtons.length; i++) {
    shopButtons[i] = new ShopButton(possibleTowers[i].copy(), width - MENU_WIDTH + 5 + (i % 2) * SHOP_BUTTON_SIZE, 5 + (i / 2) * SHOP_BUTTON_SIZE, possibleTowers[i].cost, SHOP_BUTTON_SIZE, SHOP_BUTTON_SIZE);
    shopButtons[i].tower.pos = new PVector(shopButtons[i].pos.x + SHOP_BUTTON_SIZE / 2, shopButtons[i].pos.y + SHOP_BUTTON_SIZE / 2);
    shopButtons[i].tower.tSize = SHOP_BUTTON_SIZE / 2 - 8;
  }

  //DEBUG
  money = 10000;
}

void draw() {
  //draw background
  //background(100, 201, 63);
  image(background, 0, 0);

  //DEBUG:
  //path.display();

  fill(0);
  textSize(30);
  text("LIVES: " + lives, 210, 50);
  text("MONEY: " + money, 210, 75);
  fill(255, 255, 0);
  text(int(frameRate), width - MENU_WIDTH - 50, 50);
  if (purchasedTowers.size() > 0) {
    for (int i = 0; i < purchasedTowers.size(); i++) {
      text("TARGET: " + purchasedTowers.get(i).target, purchasedTowers.get(i).pos.x, purchasedTowers.get(i).pos.y + 50);
    }
  }

  runTowersEnemies();

  if (placingTower) {

    tempTower.displayRadius();
    tempTower.display();
    tempTower.pos.x = min(mouseX, width - MENU_WIDTH);
    tempTower.pos.y = mouseY;

    checkPlacingTower();
  }

  runShop();
}

void keyReleased() {
  spawnedEnemies.add(possibleEnemies[int(random(possibleEnemies.length))].copy());
}

void mouseClicked() {
}

void checkPlacingTower() {
  if (mousePressed && mouseX > width - MENU_WIDTH) {
    //cancel buying of tower
    placingTower = false;
    tempTower = null;
  } else if (mousePressed) {
    //check to make sure its not being blocked by other towers or path
    if (!CheckTowerInPath(tempTower)) {
      boolean insideTower = false;
      for (BaseTower t : purchasedTowers) {
        if (dist(t.pos.x, t.pos.y, tempTower.pos.x, tempTower.pos.y) <= t.footprint + tempTower.footprint) {
          insideTower = true;
          break;
        }
      }
      if (!insideTower) {
        //PURCHASE COMPLETE
        money -= tempTower.cost;
        purchasedTowers.add(tempTower.copy());
        placingTower = false;
      }
    }
  }
}

boolean CheckTowerInPath(BaseTower t) {
  BaseTower temp = t.copy();
  for (int i = 0; i < path.lengths.length; i++) {
    float distance = PointSegmentDistance(new PVector(path.points[i][0], path.points[i][1]), new PVector(path.points[i+1][0], path.points[i+1][1]), temp.pos);
    if (distance < temp.footprint + path.pathWidth / 2.) {
      return true;
    }
  }
  return false;
}

float PointSegmentDistance(PVector s1, PVector s2, PVector p) {
  //returns float value of the distance between line segment s1s2 and point p
  //theres a lot of math here that i barely understand so idk how to explain it in comment form
  //basically, we're centering the entire system to the origin, and getting the dot product of the line segment and the point.
  //if the dot product is greater than 1,


  PVector s1s2 = new PVector(s2.x - s1.x, s2.y - s1.y); //s1s2 is a line segemtn where point A is the origin, and point B is s2-s1.
  PVector s1p = new PVector(p.x - s1.x, p.y - s1.y);
  float len = dist(0, 0, s1s2.x, s1s2.y); //length of path
  float projection = constrain((s1s2.x * s1p.x + s1s2.y * s1p.y) / pow(len, 2), 0, 1);
  //strokeWeight(4);
  //stroke(0, 255, 0);
  //line(p.x, p.y, s1.x + projection * s1s2.x, s1.y + projection * s1s2.y);
  return dist(p.x, p.y, s1.x + projection * s1s2.x, s1.y + projection * s1s2.y);
}

void runShop() {
  noStroke();
  fill(MENU_COLOR);
  rect(width-MENU_WIDTH, 0, MENU_WIDTH, height);

  boolean[] pressed = new boolean[shopButtons.length];
  for (int i = 0; i < shopButtons.length; i++) {
    pressed[i] = shopButtons[i].pressed;
    shopButtons[i].run();
    shopButtons[i].display();

    //tower bought
    if (pressed[i] && !shopButtons[i].pressed && money > shopButtons[i].cost) {
      placingTower = true;
      towerSelected = false;
      tempTower = shopButtons[i].tower.copy();
      tempTower.tSize = possibleTowers[i].tSize;
      tempTower.pos = new PVector(mouseX, mouseY);
    }
  }
}

void runTowersEnemies() {
  //calculate towers
  for (int i = 0; i < purchasedTowers.size(); i++) {
    purchasedTowers.get(i).run();
  }

  //calculate enemies
  for (int i = 0; i < spawnedEnemies.size(); i++) {
    spawnedEnemies.get(i).run();
    if (spawnedEnemies.get(i).end) {
      lives -= spawnedEnemies.get(i).dmg;
      spawnedEnemies.remove(i);
      continue;
    }
    if (spawnedEnemies.get(i).health < 1) {
      spawnedEnemies.remove(i);
      continue;
    }
  }

  //display both
  for (int i = 0; i < spawnedEnemies.size(); i++) {
    spawnedEnemies.get(i).display();
  }
  for (int i = 0; i < purchasedTowers.size(); i++) {
    purchasedTowers.get(i).display();
  }
}
