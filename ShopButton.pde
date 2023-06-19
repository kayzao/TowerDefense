class ShopButton extends Button {
  int cost;
  BaseTower tower;

  ShopButton(BaseTower tower, int x, int y, int cost, int w, int h) {
    super(x, y, w, h, 6, 2, color(255, 255, 255, 100), color(120, 120, 102));
    this.tower = tower;
    this.cost = cost;

    //image = tower.image.copy();
    //image.resize(w, h);
  }

  @Override
    void display() {
    super.display();
    tower.display();
    if (money < cost) {
      noStroke();
      fill(color(0, 0, 0, 150));
      rect(pos.x, pos.y, w, h, c);
    }
    fill(0);
    text(tower.name, pos.x, pos.y + h / 2);
  }
}
