//CONSTANTS
final int TOWER_SIZE = 25, RANGE = 200, SHOP_BUTTON_R = 50, PATH_WIDTH = 40, MENU_WIDTH = 200, ENEMY_SIZE = 50, ENEMY_MAX_HEALTH = 10;
final float ENEMY_BASE_SPEED = 1.5;
final color RADIUS_COLOR = color(200, 200, 200, 50), PATH_COLOR = color(192, 196, 179), MENU_COLOR = #c98200, BASE_TOWER_COLOR = color(150, 255, 255);

boolean placingTower, towerSelected;
int lives, towerSelectedIndex;

Path path;
PImage background;

final Enemy[] possibleEnemies = {
  new Enemy(5),
  new Enemy(1)
};

final BaseTower[] possibleTowers = {
  new DartMonkey()
};

ArrayList<Enemy> spawnedEnemies = new ArrayList<Enemy>();
ArrayList<BaseTower> purchasedTowers = new ArrayList<BaseTower>();

void setup() {
  size(1420, 780);
  path = new Path();
  lives = 250;
  background = loadImage("MonkeyMeadow.png");
  background.resize(width - MENU_WIDTH, height);
}

void draw() {
  //draw background
  //background(100, 201, 63);
  image(background, 0, 0);
  
  //DEBUG:
  //path.display();
  fill(0);
  textSize(30);
  textAlign(CENTER);
  text("LIVES: " + lives, 170, 50);
  fill(255, 255, 0);
  text(int(frameRate), width - MENU_WIDTH - 50, 50);
  if(purchasedTowers.size() > 0){
    for(int i = 0; i < purchasedTowers.size(); i++){
      text("TARGET: " + purchasedTowers.get(i).target, purchasedTowers.get(i).pos.x, purchasedTowers.get(i).pos.y + 50);
    }
  }
  
  displayShop();
  
  runTowersEnemies();
}

void keyReleased() {
  spawnedEnemies.add(possibleEnemies[int(random(possibleEnemies.length))].copy());
}

void mouseClicked() {
  //BaseTower toAdd = new BaseTower(1, 1, 1, RANGE, 200);
  //toAdd.pos.x = mouseX;
  //toAdd.pos.y = mouseY;
  //towers.add(toAdd);
  
  if(mouseX < width - MENU_WIDTH){
    
  }
  
}

void displayShop(){
  noStroke();
  fill(MENU_COLOR);
  rect(width-MENU_WIDTH, 0, MENU_WIDTH, height);
  strokeWeight(1);
  fill(BASE_TOWER_COLOR);
  circle(width-SHOP_BUTTON_R * 2, 50 + SHOP_BUTTON_R, SHOP_BUTTON_R * 2);
}

void runTowersEnemies(){
  //calculate towers
  for(int i = 0; i < purchasedTowers.size(); i++){
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
  for(int i = 0; i < purchasedTowers.size(); i++){
    purchasedTowers.get(i).display(); 
  }
}
