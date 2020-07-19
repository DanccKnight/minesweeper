class Square {
  bool isBombPresent;
  bool isTapped;
  bool isMarked;
  int bombsAround;

  Square(
      {this.isBombPresent = false,
      this.isTapped = false,
      this.isMarked = false,
      this.bombsAround = 0});
}
