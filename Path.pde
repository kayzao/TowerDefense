class Path { //a series of points that makes up the vertices of a path (straight line connections)
  int pathWidth = PATH_WIDTH;
  int[][] points = {
    {-100, 330},
    {603, 330},
    {603, 150},
    {400, 150},
    {400, 600},
    {370, 630},
    {220, 630},
    {200, 610},
    {200, 450},
    {730, 450},
    {760, 440},
    {770, 430},
    {780, 410},
    {780, 270},
    {920, 270},
    {910, 560},
    {540, 560},
    {540, height+100}
  };
  //int[][] points = {{0, 400}, {1000, 400}};

  int[] lengths = new int[points.length-1];

  Path() {
    for (int i = 0; i < points.length-1; i++) {
      lengths[i] = int(dist(points[i][0], points[i][1], points[i+1][0], points[i+1][1]));
    }
  }

  void display() {
    strokeWeight(pathWidth);
    stroke(PATH_COLOR);
    for (int i = 0; i < points.length-1; i++) {
      line(points[i][0], points[i][1], points[i+1][0], points[i+1][1]);
    }
  }
}
