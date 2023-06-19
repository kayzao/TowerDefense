class Projectile {
  int dmg, pierce, size, spd;
  float range;
  boolean dead;
  PVector pos, prevPos, vel;
  ArrayList<String> attackedEnemies = new ArrayList<String>();

  Projectile(PVector startPos, PVector targetPos, int dmg, int pierce) {
    pos = startPos.copy();
    prevPos = new PVector(0, 0);
    vel = PVector.sub(targetPos.copy(), startPos.copy());
    this.dmg = dmg;
    this.pierce = pierce;
    size = PROJ_SIZE;
    range = PROJ_RANGE;
    spd = PROJ_SPD;
    dead = false;
    vel.setMag(spd);
  }

  int run() {
    int tempCounter = 0;
    prevPos = pos.copy();
    pos.add(vel);
    range -= vel.mag();
    if (range <= 0) {
      dead = true;
      return 0;
    }
    //check if it is colliding with any enemies
    for (int i = 0; i < spawnedEnemies.size(); i++) {
      boolean attacked = false;
      for (int j = 0; j < attackedEnemies.size(); j++) {
        if (attackedEnemies.get(j).equals(spawnedEnemies.get(i).toString())) { //ensures that each projectile can only hit an enemy once
          attacked = true;
          break;
        }
      }
      if (attacked) continue;
      if (pointSegmentDistance(prevPos, pos, spawnedEnemies.get(i).pos) < spawnedEnemies.get(i).size + size / 2) {
        spawnedEnemies.get(i).health -= dmg;
        pierce -= 1;
        tempCounter += dmg;
        attackedEnemies.add(spawnedEnemies.get(i).toString());
        money += dmg;
      }
      if (pierce <= 0) {
        dead = true;
        return tempCounter;
      }
    }
    return tempCounter;
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.heading());
    stroke(100, 255, 150);
    strokeWeight(size);
    line(-size, 0, size, 0);
    popMatrix();
  }
}
