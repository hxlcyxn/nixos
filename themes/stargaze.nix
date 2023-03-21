{mode}:
if mode == "dark"
then rec {
  bg = "101017";
  fg = "d9d9d9";

  black = "18181b";
  gray = "53515b";
  lgray = "b0b0b0";
  llgray = "cbcbcb";
  grayblue = "0c0c20";
  blue = "1c4778";
  lblue = "413fc0";
  cyan = "0e7867";
  lcyan = "97c6c1";
  green = "10372d";
  lgreen = "477112";
  yellow = "ba5624";
  lyellow = "fea346";
  red = "6b0f1a";
  lred = "d10000";
  purple = "5c284f";
  lpurple = "C880B7";

  primary = lblue;
  secondary = purple;

  active = gray;
  inactive = lgray;
}
else rec {
  bg = "dedede";
  fg = "232830";

  black = "1E1B1F";
  gray = "9CA0A4";
  lgray = "D6D6D6";
  llgray = "E3E3E3";
  grayblue = "d8e4f8";
  blue = "2B2A80";
  lblue = "a3cff4";
  cyan = "15B097";
  lcyan = "b7e6e1";
  green = "95E575";
  lgreen = "d0f1a6";
  yellow = "fea346";
  lyellow = "ffdeaa";
  red = "D10000";
  lred = "FF8787";
  purple = "C880B7";
  lpurple = "C7B2C2";

  primary = yellow;
  secondary = purple;

  active = gray;
  inactive = lgray;
}
