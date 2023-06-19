class BaseTower {
  boolean selected, placing;
  int dmg, pierce, projWidth, tSize, footprint, range, cost, dmgCount, invalidTime, fireFrame, fireRate, dmgCounter;
  color towerColor;

  String name;
  PImage image;
  PVector pos;
  Enemy target;
  ArrayList<Projectile> projectiles = new ArrayList<Projectile>();

  BaseTower(int dmg, int pierce, int projWidth, int range, int cost, int fireRate, String name) {
    this.dmg = dmg;
    this.pierce = pierce;
    this.projWidth = projWidth;
    this.range = range;
    this.cost = cost;
    this.name = name;
    this.fireRate = fireRate;
    tSize = TOWER_SIZE;
    footprint = TOWER_FOOTPRINT;
    fireFrame = -fireRate;
    pos = new PVector(0, 0);
    towerColor = BASE_TOWER_COLOR;
  }

  void run() {
    if (placing) {
      pos.x = min(mouseX, width - MENU_WIDTH);
      pos.y = mouseY;
    } else {
      for (Projectile p : projectiles) {
        dmgCounter += p.run();
      }

      target = getTarget();

      //get rid of any dead projectiles
      for (int i = 0; i < projectiles.size(); i++) {
        if (projectiles.get(i).dead) {
          projectiles.remove(i);
        }
      }

      if (target != null) {
        if (frameCount - fireRate > fireFrame) { //delay is over, fire projectile
          fireFrame = frameCount;
          projectiles.add(new Projectile(pos, target.pos, dmg, pierce));
        }
      }
    }
  }

  void display() {
    //text("target: " + target, 200, 200);
    //text("delayTimer: " + delayTimer, 200, 230);
    //text("projectiles: " + projectiles.size(), 200, 260);
    //println(projectiles.size());
    for (int i = 0; i < projectiles.size(); i++) {
      projectiles.get(i).display();
    }

    if (selected) {
      fill(255, 255, 0);
      text("popcount: " + dmgCounter, pos.x, pos.y + 50);
    }

    fill(towerColor);
    strokeWeight(1);
    stroke(0);
    circle(pos.x, pos.y, tSize * 2);
  }

  void displayRadius(boolean force) {
    if (selected || placing || force) {
      displayRadius();
    }
  }

  void displayRadius() {
    if (!(placing || selected)) return;
    if (placing) {
      if (invalidTime + INVALID_DELAY > millis()) {
        fill(INVALID_COLOR);
      } else {
        fill(PLACING_COLOR);
      }
    } else if (selected) {
      fill(RADIUS_COLOR);
    }
    noStroke();
    circle(pos.x, pos.y, range * 2);
  }

  Enemy getTarget() {
    Enemy[] inRange = new Enemy[spawnedEnemies.size()];
    int counter = 0;
    for (int i = 0; i < spawnedEnemies.size(); i++) {
      if (dist(spawnedEnemies.get(i).pos.x, spawnedEnemies.get(i).pos.y, pos.x, pos.y) < range + spawnedEnemies.get(i).hitBox) {
        inRange[counter] = spawnedEnemies.get(i);
        counter++;
      }
    }

    if (counter == 0) return null;
    if (counter == 1) return inRange[0];

    //else return target with largest prog value
    float maxProg = 0;
    int maxProgIndex = 0;
    for (int i = 0; i < counter; i++) {
      if (inRange[i].prog > maxProg) {
        maxProg = inRange[i].prog;
        maxProgIndex = i;
      }
    }
    return inRange[maxProgIndex];
  }

  BaseTower copy() {
    BaseTower toReturn = new BaseTower(dmg, pierce, projWidth, range, cost, fireRate, name);
    toReturn.pos = new PVector(pos.x, pos.y);
    toReturn.selected = placing;
    return toReturn;
  }
}
