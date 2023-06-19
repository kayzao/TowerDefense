class Enemy {
  int dmg, size, health, hitBox;
  float prog, spd;
  PVector pos;
  boolean reachedEnd;

  Enemy(int health) {
    this.health = health;
    dmg = health;
    spd = ENEMY_BASE_SPEED + dmg * 0.5;
    prog = 0;
    size = ENEMY_SIZE;
    hitBox = ENEMY_HITBOX;
    reachedEnd = false;

    pos = new PVector(0, 0);
  }

  void run() {
    prog += spd;
    calculatePos();
  }

  void display() {
    stroke(255);
    strokeWeight(2);
    fill(255, 255 * (float(health) / ENEMY_MAX_HEALTH), 120 + 135 * (float(health) / ENEMY_MAX_HEALTH));
    circle(pos.x, pos.y, size - 2);
    fill(255, 0, 0);
    //text(health, pos.x, pos.y - 2 * size / 3);
    text(this.toString().substring(this.toString().length() - 3), pos.x, pos.y - 2 * size / 3);
  }

  void calculatePos() {
    float mprog = prog;
    int pathCounter = 0;
    while (mprog > path.lengths[pathCounter]) {
      mprog -= path.lengths[pathCounter];
      pathCounter++;
      if (pathCounter == path.lengths.length) {
        reachedEnd = true;
        return;
      }
    }
    //mprog is progess along its current path between two points
    pos.x = (mprog / path.lengths[pathCounter]) * (path.points[pathCounter+1][0] - path.points[pathCounter][0]) + path.points[pathCounter][0];
    pos.y = (mprog / path.lengths[pathCounter]) * (path.points[pathCounter+1][1] - path.points[pathCounter][1]) + path.points[pathCounter][1];
  }

  Enemy copy() {
    return new Enemy(health);
  }
}
