import org.apache.commons.math3.linear.*;

//CV_3
//Homography
//Yuta Fujii
//2620160565
//3-4-47
PImage img;
PImage img_out;

//最初にわかるところだけパラメータを設定
int x0 = 141;
int y0 = 109;
int u0 = 0;
int v0 = 0;
int x1 = 407;
int y1 = 32;
int u1 = 500;
int v1 = 0;
int x2 = 53;
int y2 = 304;
int u2 = 0;
int v2 = 400;
int x3 = 217;
int y3 = 157;
int u3 = 231;
int v3 = 168;
int x4 = 452;
int y4 = 352;
int u4 = 500;
int v4 = 400;

void setup() {
  //基本設定
  size(500, 400);
  img = loadImage("test.jpg");
  img_out = createImage(img.width, img.height, RGB);
  image(img, 0, 0);
  loadPixels();
  //Aの部分を作る
  double[][] _A = {{x0, y0, 1, 0, 0, 0, -x0*u0, -y0*u0}, 
    {0, 0, 0, x0, y0, 1, -x0*v0, -y0*v0}, 
    {x1, y1, 1, 0, 0, 0, -x1*u1, -y1*u1}, 
    {0, 0, 0, x1, y1, 1, -x1*v1, -y1*v1}, 
    {x2, y2, 1, 0, 0, 0, -x2*u2, -y2*u2}, 
    {0, 0, 0, x2, y2, 1, -x2*v2, -y2*v2}, 
    {x3, y3, 1, 0, 0, 0, -x3*u3, -y3*u3}, 
    {0, 0, 0, x3, y3, 1, -x3*v3, -y3*v3}, 
    {x4, y4, 1, 0, 0, 0, -x4*u4, -y4*u4}, 
    {0, 0, 0, x4, y4, 1, -x4*v4, -y4*v4}};

  //bを作る
  double [] _b = {u0, v0, u1, v1, u2, v2, u3, v3, u4, v4};

  //h00 ~ h21を導出 -> Hに線形代数ライブラリを用いてそれぞれ入れていく
  //AとBを配列からベクトルに変換
  RealMatrix A = MatrixUtils.createRealMatrix(_A);
  RealVector b = MatrixUtils.createRealVector(_b);

  //X = (A^T * A) ^(-1) * A^T * b を用いてXを導出
  //ここで強引に初期化
  //RealVector X = ((A.transpose()).multiply(MatrixUtils.inverse(A.multiply(A.transpose())))).operate(b);
  RealMatrix AT = A.transpose();
  RealMatrix ATA = AT.multiply(A);
  RealMatrix ATA_ = MatrixUtils.inverse(ATA);
  RealMatrix ATATA = ATA_.multiply(AT);
  RealVector X = ATATA.operate(b);

  //線形代数ライブラリを用いてXを作る
  //3*3行列を作成
  RealMatrix _X = MatrixUtils.createRealMatrix(3, 3);

  //Xから_Xにパラメータを移行
  _X.setEntry(0, 0, X.getEntry(0));    //h00
  _X.setEntry(0, 1, X.getEntry(1));    //h01   
  _X.setEntry(0, 2, X.getEntry(2));    //h02  
  _X.setEntry(1, 0, X.getEntry(3));    //h10
  _X.setEntry(1, 1, X.getEntry(4));    //h11    
  _X.setEntry(1, 2, X.getEntry(5));    //h12  
  _X.setEntry(2, 0, X.getEntry(6));    //h20  
  _X.setEntry(2, 1, X.getEntry(7));    //h21
  _X.setEntry(2, 2, 1);
  for (int i=0; i<_X.getRowDimension(); i++) {
    for (int j=0; j<_X.getColumnDimension(); j++) {
      print(_X.getEntry(i, j)+" " );
    }
    println();
  }
  //_Xの逆行列X_
  RealMatrix X_ = MatrixUtils.inverse(_X);

  //double[] Homography = new double [9];
  int count = 0;
  /*for (int i=0; i<3; i++) {
    Homography[count]=X_.getEntry(i, 0);
    count++;
    Homography[count]=X_.getEntry(i, 1);
    count++;
    Homography[count]=X_.getEntry(i, 2);
    count++;
  }*/
  //行列を二次元配列に変換
  double[][] Homography = X_.getData();
  for (int v = 0; v < img.height; v++) {
    for (int u = 0; u < img.width; u++) {
      //出力画像をラスタスキャン
      //1画素ずつ、元画像の対応画素を探す
      //_Xの逆行列X_をかけてみる
      //int型にして最近傍法を利用する(時間あったら補間してみたい)
      int x = (int)((Homography[0][0]*u+Homography[0][1]*v+Homography[0][2])/(Homography[2][0]*u+Homography[2][1]*v+Homography[2][2]));
      int y = (int)((Homography[1][0]*u+Homography[1][1]*v+Homography[1][2])/(Homography[2][0]*u+Homography[2][1]*v+Homography[2][2]));
      color c = img.get(x, y);
      //color d = img.pixels[157*img.width+217];
      //最終的に以下のようになる
      //println("y: "+y+" x: "+x+" c: "+c);
      //println("v_: "+v_+" u_: "+u+" c: "+c);
      //println(red(c)+", "+green(c)+", "+blue(c));
      img_out.pixels[v*img.width+u] = c;
    }
  }
  updatePixels();
  image(img_out, 0, 0);
  save("after.png");
}

void draw() {
}
