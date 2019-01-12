//4_47_FujiiYuta.pde
//Yuta Fujii
//2018/10/20
//描画にかなりの時間を要します。(3.5minほど)
//非効率のアルゴリズムで申し訳ありません。
//そこまで手が回りませんでした。
PImage img;
PImage img_out;

color BLACK = color(0, 0, 0);
color WHITE = color(255, 255, 255);
color OUTSIDE = color(0, 0, 0, 0);
int [][]  pixelArray = new int[800][600];
int [] lookup = new int[800];
float [] red = new float[800];
float [] blue = new float[800];
float [] green = new float[800];
int [] a = new int[800];
int _a = 0;
int b = 0;
int counter;
//本当はArrayListを使うべきだとは思いますが、
//今回は長さの取得などもないため、配列の要素数を限定します。

void setup() {
  //background(0);

  img = loadImage("target.png");
  image(img, 0, 0);
  //println(img.width, img.height);
  size(800, 600);
  img_out = createImage(img.width, img.height, RGB);
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      //pixelArray配列の初期化
      pixelArray[x][y] = 0;
    }
  }
  int cnt = 0;
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      //color c = img.get(x, y);
      color c = img.pixels[y * img.width + x];
      //println(c);
      if (c == WHITE) {
        //println(a);
        //a++;
        if (img.pixels[(y - 1) * img.width + x] == WHITE) {
          //上の画素が白の場合
          if (img.pixels[y * img.width + (x - 1)] == WHITE) {
            //かつ左の画素も白の場合
            if (pixelArray[x-1][y] > pixelArray[x][y-1]) {
              //左の画素のラベルよりも上の画素のラベルの方が小さい場合
              pixelArray[x][y] = pixelArray[x][y-1];
              for (int y1 = 0; y1 < img.height; y1++) {
                for (int x1 = 0; x1 < img.width; x1++) {
                  if(pixelArray[x1][y1] == pixelArray[x-1][y]){
                  pixelArray[x1][y1] = pixelArray[x][y];
                  }
                }
              }
            } else if (pixelArray[x][y-1] >= pixelArray[x-1][y]) {
              //上の画素のラベルよりも左の画素のラベルの方が小さい場合
              //pixelArray[x][y] = cnt;
              pixelArray[x][y] = pixelArray[x-1][y];
              for (int y1 = 0; y1 < img.height; y1++) {
                for (int x1 = 0; x1 < img.width; x1++) {
                  if(pixelArray[x1][y1] == pixelArray[x][y-1]){
                  pixelArray[x1][y1] = pixelArray[x][y];
                  }
                }
              }
            }
          } else {
            //上の画素だけが白の場合
            pixelArray[x][y] = pixelArray[x][y-1];
          }
        } else if (img.pixels[y * img.width + (x - 1)] == WHITE) {
          //左の画素のみ白の場合
          pixelArray[x][y] = pixelArray[x-1][y];
        } else {
          //初めて白になる場合
          //最大800 
          cnt++;
          pixelArray[x][y] = cnt;
          //println(cnt);
        }
      }
    }
  }

  for (int i = 0; i < 800; i++) {
    a[i] =800;
  }

  //ルックアップテーブルが連番になるように修正する
  //使える変数は,a[], _a, b


  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      //println(pixelArray[x][y]);
      //最大600くらい

      if (pixelArray[x][y] != 0 ) {
        //白の時
        counter = 0;
        for (int i = 0; i < 800; i++) {

          if (pixelArray[x][y] == a[i]) {
            //前と同じ数の時
            //println(i);
            pixelArray[x][y] = i+1;
          } else {
            counter++;
          }
        }
        if (counter == 800) {
          //println("true");
          //初めてその数が出た時
          //12回呼び出されるはず
          //append(a, pixelArray[x][y]);
          a[_a] = pixelArray[x][y];
          _a++;
          b++;
          pixelArray[x][y] = b;
          //println(b);
        }
      }
      //println(pixelArray[x][y]);
    }
  }

  //ルックアップテーブルの更新後の処理
  //cntごとの色をつける
  //println(b);
  for (int i = 1; i <= b; i++) {
    //println(i);
    red[i] = random(256);
    green[i] = random(256);
    blue[i] = random(256);
    //println(red[b], green[i], blue[i]);
  }
  //その色を実際につける
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      if (pixelArray[x][y] != 0) {
        //白の時
        for (int i = 1; i <= b; i++) {
          //1 <= b <= 239
          if (pixelArray[x][y] == i) {
            img_out.pixels[y * img.width + x] = color(red[i], green[i], blue[i]);
            //println(i);
          }
        }
      } else {
        img_out.pixels[y * img.width + x] = color(0, 0, 0);
      }
    }
  }
  updatePixels();
  image(img_out, 0, 0);
  save("after.png");
}

void draw() {
  //background(0);
  //image(img, 0, 0);
  //これやったらloadPixelsが効かなくなる
  //image(img_out, img.width, 0);
  //loadPixels();
  //int a = 0;
  //fill(red[3], green[3], blue[3]);
  //ellipse(400, 300, 100, 100);
}
