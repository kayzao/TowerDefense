class Path { //a series of points that makes up the vertices of a path (straight line connections)
  int[][] points = {
    {-100, 330},
    {610, 330},
    {610, 150},
    {400, 150},
    {400, 630},
    {200, 630},
    {200, 450},
    {760, 440},
    {770, 430},
    {780, 410},
    {780, 270},
    {910, 270},
    {910, 560},
    {540, 560},
    {540, height+100}
  };

  int[] lengths = new int[points.length-1];

  Path() {
    for (int i = 0; i < points.length-1; i++) {
      lengths[i] = int(dist(points[i][0], points[i][1], points[i+1][0], points[i+1][1]));
    }
  }

  void display() {
    strokeWeight(PATH_WIDTH);
    stroke(PATH_COLOR);
    for (int i = 0; i < points.length-1; i++) {
      line(points[i][0], points[i][1], points[i+1][0], points[i+1][1]);
    }
  }
}
