{mode}: let
  mode = "light";
in
  if mode == "dark"
  then {}
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
    dgreen = "006A4F";
    green = "95E575";
    lgreen = "d0f1a6";
    dyellow = "BA5624";
    yellow = "fea346";
    lyellow = "ffdeaa";
    dred = "6B0F1A";
    red = "D10000";
    lred = "FF8787";
    dpurple = "5c284f";
    purple = "C880B7";
    lpurple = "C7B2C2";

    primary = yellow;
    secondary = purple;

    active = gray;
    inactive = lgray;
  }
