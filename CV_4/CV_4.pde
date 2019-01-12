import org.apache.commons.math3.linear.*;

//CV_4
//ImageMosaicing
//Yuta Fujii
//2620160565
//3-4-47
PImage img1, img2;
PImage img1_out, img2_out;

//最初にわかるところだけパラメータを設定
//配列にした方が格好いい
int [] x1 = {0, 800, 400, 0, 800};
int [] y1 = {0, 0, 345, 689, 689};
int [] u1 = {0, 800, 400, 0, 800};
int [] v1 = {100, 100, 445, 789, 789};
int [] x2 = {0, 800, 400, 0, 800};
int [] y2 = {0, 0, 245, 450, 450};
int [] u2 = {0, 800, 400, 0, 800};
int [] v2 = {0, 0, 245, 455, 455};

void setup() {
  //基本設定
  size(1600, 1200);
  //img1 = loadImage("GOPR0136.JPG");
  //img2 = loadImage("GOPR0137.JPG");
  img1 = loadImage("LRG_DSC09821.JPG");
  img2 = loadImage("LRG_DSC09818.JPG");
  img1_out = createImage(img1.width, img1.height, RGB);
  img2_out = createImage(img2.width, img2.height, RGB);
  //image(img1, 0, 0);
  //image(img2, img1.width, 0);
  background(0);
  loadPixels();
}

//ホモグラフィー変換の関数を作っちゃおう
void createHomography(PImage input, PImage output, int [] x, int [] y, int [] u, int [] v) {
  //Aの部分を作る
  double[][] _A = {{x[0], y[0], 1, 0, 0, 0, -x[0]*u[0], -y[0]*u[0]}, 
    {0, 0, 0, x[0], y[0], 1, -x[0]*v[0], -y[0]*v[0]}, 
    {x[1], y[1], 1, 0, 0, 0, -x[1]*u[1], -y[1]*u[1]}, 
    {0, 0, 0, x[1], y[1], 1, -x[1]*v[1], -y[1]*v[1]}, 
    {x[2], y[2], 1, 0, 0, 0, -x[2]*u[2], -y[2]*u[2]}, 
    {0, 0, 0, x[2], y[2], 1, -x[2]*v[2], -y[2]*v[2]}, 
    {x[3], y[3], 1, 0, 0, 0, -x[3]*u[3], -y[3]*u[3]}, 
    {0, 0, 0, x[3], y[3], 1, -x[3]*v[3], -y[3]*v[3]}, 
    {x[4], y[4], 1, 0, 0, 0, -x[4]*u[4], -y[4]*u[4]}, 
    {0, 0, 0, x[4], y[4], 1, -x[4]*v[4], -y[4]*v[4]}};

  //bを作る
  double [] _b = {u[0], v[0], u[1], v[1], u[2], v[2], u[3], v[3], u[4], v[4]};

  //h00 ~ h21を導出 -> Hに線形代数ライブラリを用いてそれぞれ入れていく
  //AとBを配列からベクトルに変換
  RealMatrix A = MatrixUtils.createRealMatrix(_A);
  RealVector b = MatrixUtils.createRealVector(_b);
  
  //X = (A^T * A) ^(-1) * A^T * b を用いてXを導出
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
  
  //_Xの逆行列X_
  RealMatrix X_ = MatrixUtils.inverse(_X);

  //逆行列X_を二次元配列に変換
  double[][] Homography = X_.getData();
  
  //ここからラスタスキャン
  for (int i = 0; i < output.height; i++) {
    for (int j = 0; j < output.width; j++) {
      int k = (int)((Homography[0][0]*j+Homography[0][1]*i+Homography[0][2])/(Homography[2][0]*j+Homography[2][1]*i+Homography[2][2]));
      int l = (int)((Homography[1][0]*j+Homography[1][1]*i+Homography[1][2])/(Homography[2][0]*j+Homography[2][1]*i+Homography[2][2]));
      color c = input.get(k, l);
      output.pixels[i*output.width+j] = c;
    }
  }
  updatePixels();
}
void draw() {
  createHomography(img1, img1_out, x1, y1, u1, v1);
  createHomography(img2, img2_out, x2, y2, u2, v2);
  
  image(img1_out, 200, 200);
  image(img2_out, 685, 425);
  save("after.png");
  println(mouseX+" "+mouseY);
  delay(300);
}
