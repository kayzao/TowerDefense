class BaseTower {
  boolean beingPlaced, selected, inMenu;
  int dmg, pierce, projWidth, tSize, range, cost, dmgCount;
  float fireRate;
  color towerColor;

  PImage image;
  PVector pos;
  Enemy target;

  BaseTower(int dmg, int pierce, int projWidth, int range, int cost) {
    this.dmg = dmg;
    this.pierce = pierce;
    this.projWidth = projWidth;
    this.range = range;
    this.cost = cost;
    tSize = TOWER_SIZE;
    pos = new PVector(0, 0);
    towerColor = BASE_TOWER_COLOR;
  }

  void run() {
    target = getTarget();
  }
  
   void display() {
    //text("target: " + target, 200, 200);
    //text("delayTimer: " + delayTimer, 200, 230);
    //text("projectiles: " + projectiles.size(), 200, 260);

    //for (int i = 0; i < projectiles.size(); i++) {
    //  projectiles.get(i).display();
    //}
    if (selected) {
      fill(RADIUS_COLOR);
      noStroke();
      circle(pos.x, pos.y, RANGE * 2);
    }
    fill(towerColor);
    strokeWeight(1);
    stroke(0);
    circle(pos.x, pos.y, tSize * 2);
  }

  Enemy getTarget() {
    Enemy[] inRange = new Enemy[spawnedEnemies.size()];
    int counter = 0;
    for (int i = 0; i < spawnedEnemies.size(); i++) {
      if (dist(spawnedEnemies.get(i).pos.x, spawnedEnemies.get(i).pos.y, pos.x, pos.y) < range) {
        inRange[counter] = spawnedEnemies.get(i);
        counter++;
      }
    }
    
    if (counter == 0) return null;
    if (counter == 1) return inRange[0];
    
    //else return target with largest prog value
    float maxProg = 0;
    int maxProgIndex = 0;
    for(int i = 0; i < counter; i++){
      if(inRange[i].prog > maxProg){
        maxProg = inRange[i].prog;
        maxProgIndex = i;
      }
    }
    return inRange[maxProgIndex];
  }
  
  BaseTower copy(){
    return new BaseTower(dmg, pierce, projWidth, range, cost);
  }
}
