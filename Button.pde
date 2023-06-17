class Button {
  int w, h, c, b;
  boolean pressed;
  color borderColor, fillColor;
  
  PVector pos;
  PImage image;
  
  Button(int x, int y, int w, int h, int c, int b, color borderColor, color fillColor){
    pos = new PVector(x, y);
    this.w = w;
    this.h = h;
    this.c = c;
    this.b = b;
    this.borderColor = borderColor;
    this.fillColor = fillColor;
  }

  void display() {
    strokeWeight(b);
    stroke(borderColor);
    fill(fillColor);
    rect(pos.x, pos.y, w, h, c);
    image(image, pos.x, pos.y);
    if(pressed){
      fill(200, 200, 200, 50);
      noStroke();
      rect(pos.x, pos.y, w, h, c);
    }
  }
  
  boolean isPressed(){
    return (mouseX >= pos.x + c && mouseX <= pos.x + w - c && mouseY >= pos.y - 0.5 * b && mouseY <= pos.y + h + 0.5 * b) 
        || (mouseX >= pos.x - 0.5 * b && mouseX <= pos.x + w + 0.5 * b && mouseY >= pos.y + c && mouseY <= pos.y + h - c)
        || dist(pos.x + c, pos.y + c, mouseX, mouseY) <= c + 0.5 * b
        || dist(pos.x + w - c, pos.y + c, mouseX, mouseY) <= c + 0.5 * b
        || dist(pos.x + c, pos.y + h - c, mouseX, mouseY) <= c + 0.5 * b
        || dist(pos.x + w - c, pos.y + h - c, mouseX, mouseY) <= c + 0.5 * b;
  }
}
