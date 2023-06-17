class ShopButton extends Button{
  int cost;
  BaseTower tower;
  
  ShopButton(BaseTower tower, int x, int y, int cost, int w, int h){
    super(x, y, w, h, 4, 1, color(255, 255, 255, 100), color(0, 0, 0, 0));
    this.tower = tower;
    this.cost = cost;
    image = tower.image.copy();
    image.resize(w, h);
  }
  
}
