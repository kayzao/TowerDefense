//CONSTANTS
final int TOWER_SIZE = 25, RANGE = 200, SHOP_BUTTON_SIZE = 90, PATH_WIDTH = 40, MENU_WIDTH = 200, ENEMY_SIZE = 50, ENEMY_MAX_HEALTH = 10;
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
  
  if(placingTower){
    
    tempTower.displayRadius();
    tempTower.display();
    tempTower.pos.x = min(mouseX, width - MENU_WIDTH);
    tempTower.pos.y = mouseY;
    
    if(mousePressed && mouseX > width - MENU_WIDTH){ //cancel buying of tower
      placingTower = false;
      tempTower = null;
    } else if(mousePressed){
      //PURCHASE COMPLETE
      money -= tempTower.cost;
      purchasedTowers.add(tempTower.copy());
      placingTower = false;
    }
  }

  runShop();

  runTowersEnemies();
}

void keyReleased() {
  spawnedEnemies.add(possibleEnemies[int(random(possibleEnemies.length))].copy());
}

void mouseClicked() {
  
}

void runShop() {

  //strokeWeight(1);
  //fill(BASE_TOWER_COLOR);
  //circle(width-SHOP_BUTTON_SIZE * 2, 50 + SHOP_BUTTON_SIZE, SHOP_BUTTON_SIZE * 2);
  noStroke();
  fill(MENU_COLOR);
  rect(width-MENU_WIDTH, 0, MENU_WIDTH, height);

  boolean[] pressed = new boolean[shopButtons.length];
  for (int i = 0; i < shopButtons.length; i++) {
    pressed[i] = shopButtons[i].pressed;
    shopButtons[i].run();
    shopButtons[i].display();
    
    //tower bought
    if(pressed[i] && !shopButtons[i].pressed && money > shopButtons[i].cost){ 
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
