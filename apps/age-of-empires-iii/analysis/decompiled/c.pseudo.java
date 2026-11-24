public class c extends javax.microedition.lcdui.game.GameCanvas {
  public static boolean a;
  public static final javax.microedition.lcdui.Font[] a;
  public static final int[] a;
  public static final int[] b;
  public static int[] c;
  public static final int[] d;
  private static int a;
  private static int b;
  private static int[][] a;
  private static int c;
  private static javax.microedition.lcdui.Image a;
  private static boolean b;

  public void <init>() {
    // try [10..18) catch (java.io.IOException) -> @19
    /*@2*/ this.<init>(0);
    /*@7*/ this.setFullScreenMode(1);
    /*@15*/ c.a = javax.microedition.lcdui.Image.createImage("/touch.png");
    /*@18*/ return;
  @19:
    /*@20*/ this = caughtException<java.io.IOException>;
    /*@21*/ caughtException<java.io.IOException>.printStackTrace();
    /*@24*/ return;
  }

  public void pointerDragged(int p0, int p1) {
    /*@3*/ if (c.c == 0) goto @7;
  @6:
    /*@6*/ return;
  @7:
    /*@7*/ return;
  }

  public void pointerPressed(int p0, int p1) {
    /*@3*/ v3 = c.a;
    /*@11*/ if (p1 <= (c.b - 40)) goto @100;
  @14:
    /*@18*/ if (p1 >= c.b) goto @100;
  @21:
    /*@25*/ v4 = (v3.length - 2);
  @27:
    /*@31*/ if (v4 >= v3.length) goto @99;
  @34:
    /*@41*/ if (p0 < v3[v4][0]) goto @93;
  @44:
    /*@51*/ if (p1 < v3[v4][1]) goto @93;
  @54:
    /*@61*/ if (p0 > v3[v4][2]) goto @93;
  @64:
    /*@71*/ if (p1 > v3[v4][3]) goto @93;
  @74:
    /*@80*/ c.c = v3[v4][4];
    /*@87*/ this.keyPressed(c.c);
    /*@90*/ goto @206;
  @93:
    /*@93*/ v4 += 1;
    /*@96*/ goto @27;
  @99:
    /*@99*/ return;
  @100:
    /*@104*/ if (p1 <= c.b) goto @206;
  @107:
    /*@110*/ if (c.c == 0) goto @125;
  @113:
    /*@117*/ this.keyReleased(c.c);
    /*@121*/ c.c = 0;
    /*@124*/ return;
  @125:
    /*@130*/ p1 = (p1 - c.b);
    /*@132*/ v4 = 0;
  @134:
    /*@140*/ if (v4 >= (v3.length - 2)) goto @206;
  @143:
    /*@150*/ if (p0 < v3[v4][0]) goto @200;
  @153:
    /*@160*/ if (p1 < v3[v4][1]) goto @200;
  @163:
    /*@170*/ if (p0 > v3[v4][2]) goto @200;
  @173:
    /*@180*/ if (p1 > v3[v4][3]) goto @200;
  @183:
    /*@189*/ c.c = v3[v4][4];
    /*@196*/ this.keyPressed(c.c);
    /*@199*/ return;
  @200:
    /*@200*/ v4 += 1;
    /*@203*/ goto @134;
  @206:
    /*@206*/ return;
  }

  public void pointerReleased(int p0, int p1) {
    /*@3*/ if (c.c == 0) goto @17;
  @6:
    /*@10*/ this.keyReleased(c.c);
    /*@14*/ c.c = 0;
  @17:
    /*@17*/ return;
  }

  public static int a(int p0) {
    /*@4*/ var t1 = new int[1];
    /*@7*/ t1[0] = 0;
    /*@11*/ return c.a(p0, t1);
  }

  public static int a(int p0, int[] p1) {
    /*@1*/ switch (p0) { 0->@36, 1->@48, 2->@54, 3->@39, 4->@64, default->@64 }
  @36:
    /*@36*/ goto @64;
  @39:
    /*@42*/ a.a(p1[0]);
    /*@45*/ goto @64;
  @48:
    /*@48*/ a.a();
    /*@51*/ goto @64;
  @54:
    /*@57*/ if (a.a() == 0) goto @62;
  @60:
    /*@61*/ return 1;
  @62:
    /*@63*/ return 0;
  @64:
    /*@65*/ return 0;
  }

  public static int a(int p0, String p1) {
    /*@1*/ switch (p0) { 0->@28, 1->@39, default->@48 }
  @28:
    /*@35*/ f.a.platformRequest(p1);
    /*@36*/ goto @48;
  @39:
    /*@45*/ c.a = p1.equals("1");
  @48:
    /*@49*/ return 0;
  }

  public void hideNotify() {
    /*@1*/ f.c = 1;
    /*@5*/ f.e = 1;
    /*@8*/ return;
  }

  public void showNotify() {
    /*@0*/ f.b();
    /*@4*/ f.e = 0;
    /*@7*/ return;
  }

  public final int b(int p0) {
    /*@3*/ if (p0 != 53) goto @9;
  @6:
    /*@8*/ return 16;
  @9:
    /*@12*/ if (p0 == -6) goto @21;
  @15:
    /*@18*/ if (p0 != 6) goto @34;
  @21:
    /*@24*/ if (f.k == 0) goto @31;
  @27:
    /*@30*/ return 128;
  @31:
    /*@33*/ return 64;
  @34:
    /*@37*/ if (p0 == -7) goto @46;
  @40:
    /*@43*/ if (p0 != 7) goto @59;
  @46:
    /*@49*/ if (f.k == 0) goto @55;
  @52:
    /*@54*/ return 64;
  @55:
    /*@58*/ return 128;
  @59:
    /*@62*/ if (p0 != 50) goto @67;
  @65:
    /*@66*/ return 1;
  @67:
    /*@70*/ if (p0 != 56) goto @75;
  @73:
    /*@74*/ return 2;
  @75:
    /*@78*/ if (p0 != 52) goto @83;
  @81:
    /*@82*/ return 4;
  @83:
    /*@86*/ if (p0 != 54) goto @92;
  @89:
    /*@91*/ return 8;
  @92:
    /*@95*/ if (p0 != 49) goto @102;
  @98:
    /*@101*/ return 256;
  @102:
    /*@105*/ if (p0 != 51) goto @112;
  @108:
    /*@111*/ return 512;
  @112:
    /*@115*/ if (p0 != 55) goto @122;
  @118:
    /*@121*/ return 1024;
  @122:
    /*@125*/ if (p0 != 57) goto @132;
  @128:
    /*@131*/ return 2048;
  @132:
    /*@135*/ if (p0 != 42) goto @142;
  @138:
    /*@141*/ return 4096;
  @142:
    /*@145*/ if (p0 != 35) goto @152;
  @148:
    /*@151*/ return 8192;
  @152:
    /*@155*/ if (p0 != 48) goto @162;
  @158:
    /*@161*/ return 16384;
  @162:
    /*@167*/ switch (this.getGameAction(p0)) { 1->@212, 2->@216, 3->@224, 4->@224, 5->@218, 6->@214, 7->@224, 8->@221, default->@224 }
  @212:
    /*@213*/ return 1;
  @214:
    /*@215*/ return 2;
  @216:
    /*@217*/ return 4;
  @218:
    /*@220*/ return 8;
  @221:
    /*@223*/ return 16;
  @224:
    /*@225*/ return 0;
  }

  public void paint(javax.microedition.lcdui.Graphics p0) {
    /*@3*/ if (c.a == null) goto @32;
  @6:
    /*@17*/ p0.setClip(0, 0, this.getWidth(), this.getHeight());
    /*@29*/ p0.drawImage(c.a, 0, 400, 0);
  @32:
    /*@39*/ if (this.getWidth() == 360) goto @186;
  @42:
    /*@49*/ if (this.getHeight() == 640) goto @186;
  @52:
    /*@55*/ if (f.j == 0) goto @186;
  @58:
    /*@60*/ p0.setColor(0);
    /*@74*/ p0.setClip(0, 0, this.getWidth(), this.getHeight());
    /*@88*/ p0.fillRect(0, 0, this.getWidth(), this.getHeight());
    /*@97*/ v2 = (this.getWidth() >> 1);
    /*@104*/ v3 = (this.getHeight() >> 1);
    /*@108*/ p0.setColor(16777215);
    /*@126*/ v4 = f.a(f.a(337), 350, f.b);
    /*@133*/ v3 = ((v3 * 3) / 4);
    /*@135*/ v5 = 0;
  @137:
    /*@142*/ if (v5 >= v4.length) goto @177;
  @145:
    /*@158*/ l.a(f.b, p0, v4[v5], v2, v3, 17);
    /*@170*/ v3 = (v3 + l.a[f.b]);
    /*@171*/ v5 += 1;
    /*@174*/ goto @137;
  @177:
    /*@178*/ c.b = 1;
    /*@182*/ this.hideNotify();
    /*@185*/ return;
  @186:
    /*@189*/ if (c.b == 0) goto @196;
  @192:
    /*@193*/ this.showNotify();
  @196:
    /*@197*/ c.b = 0;
    /*@200*/ return;
  }

  public static void a(javax.microedition.lcdui.Graphics p0, int p1, int p2, int p3, int p4, int p5) {
    /*@2*/ p0.setColor(p1);
    /*@12*/ p0.fillRect(p2, p3, p4, p5);
    /*@15*/ return;
  }

  static void <clinit>() {
    /*@4*/ var t1 = new javax.microedition.lcdui.Font[3];
    /*@13*/ t1[0] = javax.microedition.lcdui.Font.getFont(0, 0, 8);
    /*@22*/ t1[1] = javax.microedition.lcdui.Font.getFont(0, 0, 0);
    /*@32*/ t1[2] = javax.microedition.lcdui.Font.getFont(0, 0, 16);
    /*@33*/ c.a = t1;
    /*@40*/ var t2 = new int[6];
    /*@43*/ t2[0] = -1;
    /*@47*/ t2[1] = 0;
    /*@51*/ t2[2] = -1;
    /*@55*/ t2[3] = -1;
    /*@59*/ t2[4] = -1;
    /*@64*/ t2[5] = -2;
    /*@65*/ c.a = t2;
    /*@71*/ var t3 = new int[2];
    /*@74*/ t3[0] = 0;
    /*@78*/ t3[1] = 1;
    /*@79*/ c.b = t3;
    /*@85*/ var t4 = new int[2];
    /*@88*/ t4[0] = 0;
    /*@92*/ t4[1] = 1;
    /*@93*/ c.c = t4;
    /*@99*/ var t5 = new int[4];
    /*@102*/ t5[0] = 0;
    /*@106*/ t5[1] = -1;
    /*@110*/ t5[2] = 0;
    /*@115*/ t5[3] = -2;
    /*@116*/ c.d = t5;
    /*@124*/ var t6 = new String[8];
    /*@128*/ t6[0] = "2";
    /*@133*/ t6[1] = "8";
    /*@138*/ t6[2] = "4";
    /*@143*/ t6[3] = "6";
    /*@148*/ t6[4] = "1";
    /*@153*/ t6[5] = "3";
    /*@159*/ t6[6] = "7";
    /*@164*/ t6[7] = "9";
    /*@168*/ c.a = 360;
    /*@174*/ c.b = 400;
    /*@182*/ var t7 = new [I[14];
    /*@187*/ var t8 = new int[5];
    /*@190*/ t8[0] = 0;
    /*@194*/ t8[1] = 3;
    /*@199*/ t8[2] = 90;
    /*@204*/ t8[3] = 82;
    /*@209*/ t8[4] = 49;
    /*@210*/ t7[0] = t8;
    /*@216*/ var t9 = new int[5];
    /*@220*/ t9[0] = 91;
    /*@224*/ t9[1] = 3;
    /*@230*/ t9[2] = 180;
    /*@235*/ t9[3] = 82;
    /*@240*/ t9[4] = 50;
    /*@241*/ t7[1] = t9;
    /*@247*/ var t10 = new int[5];
    /*@252*/ t10[0] = 181;
    /*@256*/ t10[1] = 3;
    /*@262*/ t10[2] = 270;
    /*@267*/ t10[3] = 82;
    /*@272*/ t10[4] = 51;
    /*@273*/ t7[2] = t10;
    /*@279*/ var t11 = new int[5];
    /*@284*/ t11[0] = 271;
    /*@288*/ t11[1] = 3;
    /*@294*/ t11[2] = 360;
    /*@299*/ t11[3] = 82;
    /*@304*/ t11[4] = 42;
    /*@305*/ t7[3] = t11;
    /*@311*/ var t12 = new int[5];
    /*@314*/ t12[0] = 0;
    /*@319*/ t12[1] = 83;
    /*@324*/ t12[2] = 90;
    /*@330*/ t12[3] = 161;
    /*@335*/ t12[4] = 52;
    /*@336*/ t7[4] = t12;
    /*@342*/ var t13 = new int[5];
    /*@346*/ t13[0] = 91;
    /*@351*/ t13[1] = 83;
    /*@357*/ t13[2] = 180;
    /*@363*/ t13[3] = 161;
    /*@368*/ t13[4] = 53;
    /*@369*/ t7[5] = t13;
    /*@376*/ var t14 = new int[5];
    /*@381*/ t14[0] = 181;
    /*@386*/ t14[1] = 83;
    /*@392*/ t14[2] = 270;
    /*@398*/ t14[3] = 161;
    /*@403*/ t14[4] = 54;
    /*@404*/ t7[6] = t14;
    /*@411*/ var t15 = new int[5];
    /*@416*/ t15[0] = 271;
    /*@421*/ t15[1] = 83;
    /*@427*/ t15[2] = 360;
    /*@433*/ t15[3] = 161;
    /*@438*/ t15[4] = 48;
    /*@439*/ t7[7] = t15;
    /*@446*/ var t16 = new int[5];
    /*@449*/ t16[0] = 0;
    /*@455*/ t16[1] = 162;
    /*@460*/ t16[2] = 90;
    /*@466*/ t16[3] = 240;
    /*@471*/ t16[4] = 55;
    /*@472*/ t7[8] = t16;
    /*@479*/ var t17 = new int[5];
    /*@483*/ t17[0] = 91;
    /*@489*/ t17[1] = 162;
    /*@495*/ t17[2] = 180;
    /*@501*/ t17[3] = 240;
    /*@506*/ t17[4] = 56;
    /*@507*/ t7[9] = t17;
    /*@514*/ var t18 = new int[5];
    /*@519*/ t18[0] = 181;
    /*@525*/ t18[1] = 162;
    /*@531*/ t18[2] = 270;
    /*@537*/ t18[3] = 240;
    /*@542*/ t18[4] = 57;
    /*@543*/ t7[10] = t18;
    /*@550*/ var t19 = new int[5];
    /*@555*/ t19[0] = 271;
    /*@561*/ t19[1] = 162;
    /*@567*/ t19[2] = 360;
    /*@573*/ t19[3] = 240;
    /*@578*/ t19[4] = 35;
    /*@579*/ t7[11] = t19;
    /*@586*/ var t20 = new int[5];
    /*@589*/ t20[0] = 0;
    /*@598*/ t20[1] = (c.b - 40);
    /*@603*/ t20[2] = 60;
    /*@609*/ t20[3] = c.b;
    /*@614*/ t20[4] = -6;
    /*@615*/ t7[12] = t20;
    /*@622*/ var t21 = new int[5];
    /*@630*/ t21[0] = (c.a - 60);
    /*@639*/ t21[1] = (c.b - 40);
    /*@645*/ t21[2] = c.a;
    /*@651*/ t21[3] = c.b;
    /*@656*/ t21[4] = -7;
    /*@657*/ t7[13] = t21;
    /*@658*/ c.a = t7;
    /*@662*/ c.c = 0;
    /*@666*/ c.b = 0;
    /*@669*/ return;
  }

}
