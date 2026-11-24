public final class f extends c implements java.lang.Runnable, javax.microedition.lcdui.CommandListener {
  private static char[] a;
  private static int[] f;
  private static int o;
  private static int p;
  public static boolean b;
  private static boolean l;
  private boolean m;
  public static boolean c;
  public static boolean d;
  public static boolean e;
  public static int a;
  private static boolean n;
  public static boolean f;
  public static boolean g;
  public static boolean h;
  public static boolean i;
  public e a;
  private static javax.microedition.lcdui.Display a;
  public static Main a;
  public static f a;
  private static java.util.Random a;
  private static int q;
  private int r;
  public static k[] a;
  public static k[] b;
  public static k[] c;
  private static k[] e;
  public static k[] d;
  private static k c;
  public static k a;
  private static k d;
  private static k e;
  private static k[] f;
  public static int b;
  private static int s;
  private static int t;
  private static boolean o;
  public static g a;
  public static int c;
  public static int d;
  public static int e;
  public static int f;
  public static int g;
  public static int h;
  public static int i;
  public static int j;
  public static byte[] a;
  private static boolean[] a;
  private static boolean p;
  public static k b;
  private static long a;
  public static int k;
  public static int l;
  private int u;
  private int v;
  private int w;
  private int x;
  private int y;
  private int z;
  private int A;
  private int B;
  private int C;
  private int D;
  private int E;
  private static int F;
  private static int G;
  private static k f;
  private k g;
  private g f;
  private String[] a;
  public static boolean j;
  public static boolean k;
  private static int H;
  public static g b;
  public static g c;
  private static g g;
  private static g h;
  private static g i;
  public static g d;
  private static g j;
  private static g k;
  private static g l;
  private static g m;
  private static g n;
  private static g o;
  private static g p;
  private static g q;
  private static g r;
  public static g e;
  private static g s;
  private static g t;
  private static g u;
  private static int I;
  private static int J;
  private static int K;
  private static int L;
  private static int M;
  private static int N;
  public static int m;
  private static int O;
  private int P;
  private static int[][] a;
  private static boolean q;
  private static String[] b;
  private static int Q;
  private static int R;
  private static boolean r;
  private static int S;
  private static int T;
  private static int U;
  private static int V;
  private static String[] c;
  public static int n;
  private static int W;
  private static int X;
  public static int[] e;
  private static int Y;
  private static int Z;
  private static int aa;
  private static int ab;

  public void <init>(Main p0) {
    /*@1*/ this.<init>();
    /*@5*/ f.a = p0;
    /*@9*/ f.a = this;
    /*@16*/ var t1 = javax.microedition.lcdui.Display.getDisplay(p0);
    /*@17*/ f.a = t1;
    /*@21*/ t1.setCurrent(this);
    /*@27*/ var t2 = new java.lang.Thread;
    /*@29*/ t2.<init>(this);
    /*@33*/ this = t2;
    /*@34*/ t2.start();
    /*@37*/ return;
  }

  public final void run() {
    // try [86..1611) catch (java.lang.Exception) -> @1614
    // try [28..1649) catch (java.lang.Exception) -> @1652
    /*@1*/ f.d = 1;
    /*@5*/ f.s = 0;
    /*@15*/ f.a = java.lang.System.currentTimeMillis();
  @18:
    /*@21*/ if (f.d == 0) goto @1656;
  @24:
    /*@27*/ v1 = java.lang.System.currentTimeMillis();
    /*@31*/ if (f.c == 0) goto @78;
  @34:
    /*@35*/ v3 = this;
    /*@37*/ f.c = 0;
    /*@41*/ f.R = 0;
    /*@48*/ if (f.s == 4) goto @78;
  @51:
    /*@54*/ if (f.T != 0) goto @78;
  @57:
    /*@61*/ c.a(1);
    /*@65*/ if (f.b == null) goto @78;
  @68:
    /*@71*/ f.t = f.s;
    /*@75*/ f.s = 4;
  @78:
    /*@81*/ if (f.e != 0) goto @1618;
  @84:
    /*@85*/ v3 = this;
    /*@90*/ if (v3.m == 0) goto @122;
  @93:
    /*@96*/ if (f.T != 0) goto @122;
  @99:
    /*@103*/ if (f.s == 4) goto @122;
  @106:
    /*@111*/ if (c.a(2) != 0) { _phi_118_0 = v3; goto @118; }
    _phi_114_0 = v3;
  @114: [stack=1: _phi_114_0]
    /*@115*/ { _phi_119_0 = _phi_114_0; _phi_119_1 = 1; goto @119; }
  @118: [stack=1: _phi_118_0]
    _phi_119_0 = _phi_118_0;
    _phi_119_1 = 0;
  @119: [stack=2: _phi_119_0, _phi_119_1]
    /*@119*/ _phi_119_0.m = _phi_119_1;
  @122:
    /*@125*/ if (f.S <= 0) goto @141;
  @128:
    /*@138*/ f.S = java.lang.Math.max(0, (f.S - 50));
  @141:
    /*@144*/ if (f.T == 0) goto @187;
  @147:
    /*@151*/ if (f.T != 2) goto @1603;
  @154:
    /*@157*/ if (f.b() == 0) goto @1603;
  @160:
    /*@161*/ f.c = null;
    /*@164*/ f.p();
    /*@170*/ if (f.p != 0) goto @180;
  @173:
    /*@177*/ v3.a.g();
  @180:
    /*@181*/ f.p = 0;
    /*@184*/ goto @1603;
  @187:
    /*@191*/ if (f.n == 1) goto @201;
  @194:
    /*@198*/ if (f.n != 2) goto @419;
  @201:
    /*@205*/ if (f.W <= -1) goto @411;
  @208:
    /*@208*/ f.b();
    /*@215*/ if (f.n != 1) goto @225;
  @218:
    /*@219*/ f.n = 0;
    /*@222*/ goto @419;
  @225:
    /*@229*/ if (f.n != 2) goto @408;
  @232:
    /*@233*/ f.n = 3;
    /*@242*/ v5 = f.X;
    /*@244*/ v4 = f.a;
    /*@249*/ if (v5 < 5) goto @265;
  @252:
    /*@259*/ v4.a.b(v5);
    /*@262*/ goto @404;
  @265:
    /*@267*/ switch (v5) { 0->@300, 1->@321, 2->@368, 3->@376, 4->@384, default->@404 }
  @300:
    /*@303*/ if (f.c != 0) goto @310;
  @306:
    /*@307*/ f.p = 1;
  @310:
    /*@310*/ f.o();
    /*@315*/ v4.e();
    /*@318*/ goto @404;
  @321:
    /*@321*/ f.o();
    /*@327*/ var t1 = new java.lang.StringBuffer;
    /*@328*/ t1.<init>();
    /*@347*/ t1.append("Loading slot ").append(f.e[0]).toString();
    /*@353*/ f.b(f.e[0]);
    /*@358*/ v4.e();
    /*@362*/ e.I = null;
    /*@365*/ goto @404;
  @368:
    /*@370*/ v4.g();
    /*@373*/ goto @404;
  @376:
    /*@378*/ v4.f();
    /*@381*/ goto @404;
  @384:
    /*@387*/ v4 = v4;
    /*@390*/ v4.g = null;
    /*@397*/ v5 = f.c;
    /*@401*/ f.a(f.c, 0, 1);
  @404:
    /*@405*/ f.b(0);
  @408:
    /*@408*/ goto @419;
  @411:
    /*@416*/ f.W = (f.W + 1);
  @419:
    /*@422*/ if (d.a() != 0) goto @512;
  @425:
    /*@430*/ if (f.s != 10) goto @512;
  @433:
    /*@440*/ if (f.b.b == 2) goto @512;
  @443:
    /*@447*/ if (f.p == -1) goto @512;
  @450:
    /*@460*/ if (f.p != f.f[f.o]) goto @504;
  @463:
    /*@468*/ var t2 = (f.o + 1);
    /*@469*/ f.o = t2;
    /*@476*/ if (t2 < f.f.length) goto @508;
  @479:
    /*@480*/ f.o = 0;
    /*@483*/ f.b();
    /*@487*/ v3.i();
    /*@494*/ v5 = f.u;
    /*@498*/ f.a(f.u, 0, 1);
    /*@501*/ goto @508;
  @504:
    /*@505*/ f.o = 0;
  @508:
    /*@509*/ f.p = -1;
  @512:
    /*@515*/ switch (f.s) { 0->@1426, 2->@1433, 4->@1456, 5->@598, 10->@661, 30->@1453, 40->@1492, 100->@588, default->@1603 }
  @588:
    /*@592*/ v3.a.f();
    /*@595*/ goto @1603;
  @598:
    /*@601*/ if (f.a() != 0) goto @1603;
  @604:
    /*@605*/ v4 = v3;
    /*@612*/ if (f.c(16) != 0) goto @623;
  @615:
    /*@620*/ if (f.c(64) == 0) goto @631;
  @623:
    /*@625*/ f.a(0, 3);
    /*@628*/ goto @1603;
  @631:
    /*@634*/ if (f.a() != 0) goto @658;
  @637:
    /*@650*/ if ((((int) java.lang.System.currentTimeMillis()) - v4.r) <= 3000) goto @658;
  @653:
    /*@655*/ f.a(0, 3);
  @658:
    /*@658*/ goto @1603;
  @661:
    /*@664*/ if (f.a() != 0) goto @1603;
  @667:
    /*@668*/ v4 = v3;
    /*@674*/ if (f.b(1) == 0) goto @812;
  @677:
    /*@686*/ f.b.a = (f.b.a - 1);
    /*@695*/ if (f.b.a >= 0) goto @757;
  @698:
    /*@705*/ if (f.b.b != 2) goto @718;
  @708:
    /*@712*/ f.b.a = 0;
    /*@715*/ goto @961;
  @718:
    /*@725*/ v5 = f.b;
    /*@733*/ f.b.a = (f.b.a.length - 1);
    /*@751*/ f.b.d = ((f.b.a - f.N) + 1);
    /*@754*/ goto @961;
  @757:
    /*@769*/ if (f.b.a >= f.b.d) goto @787;
  @772:
    /*@781*/ f.b.d = (f.b.d - 1);
    /*@784*/ goto @961;
  @787:
    /*@794*/ if (f.b.b != 2) goto @961;
  @797:
    /*@806*/ f.b.d = (f.b.d - 1);
    /*@809*/ goto @961;
  @812:
    /*@816*/ if (f.b(2) == 0) goto @961;
  @819:
    /*@823*/ v5 = f.b;
    /*@829*/ v5 = f.b.a.length;
    /*@840*/ f.b.a = (f.b.a + 1);
    /*@850*/ if (f.b.b != 2) goto @898;
  @853:
    /*@865*/ if (f.b.a <= (v5 - f.N)) goto @883;
  @868:
    /*@877*/ f.b.a = (v5 - f.N);
    /*@880*/ goto @961;
  @883:
    /*@892*/ f.b.d = (f.b.d + 1);
    /*@895*/ goto @961;
  @898:
    /*@908*/ if (f.b.a <= (v5 - 1)) goto @928;
  @911:
    /*@915*/ f.b.a = 0;
    /*@922*/ f.b.d = 0;
    /*@925*/ goto @961;
  @928:
    /*@946*/ if (f.b.a <= ((f.b.d + f.N) - 1)) goto @961;
  @949:
    /*@958*/ f.b.d = (f.b.d + 1);
  @961:
    /*@966*/ if (f.c(16) != 0) goto @977;
  @969:
    /*@974*/ if (f.c(64) == 0) goto @1350;
  @977:
    /*@980*/ if (d.a() == 0) goto @1005;
  @983:
    /*@990*/ if (f.b.f == -1) goto @1005;
  @993:
    /*@999*/ d.b(f.b.f);
    /*@1002*/ goto @1603;
  @1005:
    /*@1012*/ if (f.b.e == -1) goto @1207;
  @1015:
    /*@1023*/ v3 = f.b.e;
    /*@1024*/ v4 = v4;
    /*@1027*/ switch (v3) { 0->@1064, 1->@1111, 2->@1166, 3->@1177, 4->@1185, 5->@1199, default->@1204 }
  @1064:
    /*@1068*/ if (f.c != 1) goto @1082;
  @1071:
    /*@1076*/ f.a(f.c, 1, 1);
    /*@1079*/ goto @1423;
  @1082:
    /*@1087*/ f.e = (f.e + 1);
    /*@1093*/ if (d.a() == 0) goto @1103;
  @1096:
    /*@1100*/ if (f.e >= 2) goto @1199;
  @1103:
    /*@1105*/ f.a(0, 0);
    /*@1108*/ goto @1423;
  @1111:
    /*@1119*/ if (v4.a.j == null) goto @1147;
  @1122:
    /*@1132*/ if (v4.a.j[0] != 0) goto @1147;
  @1135:
    /*@1141*/ v4.a.j = null;
    /*@1144*/ goto @1158;
  @1147:
    /*@1151*/ v5 = f.d;
    /*@1155*/ f.a(f.d, 0, 1);
  @1158:
    /*@1160*/ f.s = 100;
    /*@1163*/ goto @1423;
  @1166:
    /*@1171*/ f.a(f.p, 1, 1);
    /*@1174*/ goto @1423;
  @1177:
    /*@1179*/ f.a(0, 0);
    /*@1182*/ goto @1423;
  @1185:
    /*@1189*/ v5 = f.s;
    /*@1193*/ f.a(f.s, 0, 1);
    /*@1196*/ goto @1423;
  @1199:
    /*@1201*/ f.s = 40;
  @1204:
    /*@1204*/ goto @1603;
  @1207:
    /*@1213*/ if (f.b.a == null) goto @1333;
  @1216:
    /*@1231*/ if (f.b.a != f.c) { _phi_1238_0 = f.b.a; goto @1238; }
    _phi_1234_0 = f.b.a;
  @1234: [stack=1: _phi_1234_0]
    /*@1235*/ { _phi_1239_0 = _phi_1234_0; _phi_1239_1 = 1; goto @1239; }
  @1238: [stack=1: _phi_1238_0]
    _phi_1239_0 = _phi_1238_0;
    _phi_1239_1 = 0;
  @1239: [stack=2: _phi_1239_0, _phi_1239_1]
    /*@1240*/ f.a(_phi_1239_0, _phi_1239_1, 1);
    /*@1249*/ if (f.b != f.e) goto @1261;
  @1252:
    /*@1258*/ f.b.b = f.r;
  @1261:
    /*@1273*/ if (f.b.a >= f.b.d) goto @1291;
  @1276:
    /*@1285*/ f.b.d = f.b.a;
    /*@1288*/ goto @1603;
  @1291:
    /*@1309*/ if (f.b.a <= ((f.b.d + f.N) - 1)) goto @1423;
  @1312:
    /*@1327*/ f.b.d = ((f.b.a - f.N) + 1);
    /*@1330*/ goto @1603;
  @1333:
    /*@1344*/ v4.a(f.b, f.b.a);
    /*@1347*/ goto @1603;
  @1350:
    /*@1356*/ if (f.c(128) == 0) goto @1423;
  @1359:
    /*@1362*/ if (d.a() == 0) goto @1418;
  @1365:
    /*@1372*/ if (f.b.f == -1) goto @1418;
  @1375:
    /*@1382*/ v4 = f.b.f;
    /*@1385*/ if (f.b.f != 2) goto @1395;
  @1388:
    /*@1389*/ f.d = 0;
    /*@1392*/ goto @1423;
  @1395:
    /*@1400*/ f.a(f.c, 0, 0);
    /*@1407*/ var t3 = new int[1];
    /*@1410*/ t3[0] = 0;
    /*@1414*/ c.a(3, t3);
    /*@1415*/ goto @1603;
  @1418:
    /*@1420*/ v4.k();
  @1423:
    /*@1423*/ goto @1603;
  @1426:
    /*@1427*/ v3.d();
    /*@1430*/ goto @1603;
  @1433:
    /*@1436*/ if (f.a() != 0) goto @1603;
  @1439:
    /*@1442*/ if (f.b() == 0) goto @1450;
  @1445:
    /*@1447*/ f.a(0, 4);
  @1450:
    /*@1450*/ goto @1603;
  @1453:
    /*@1453*/ goto @1603;
  @1456:
    /*@1459*/ if (f.b() == 0) goto @1603;
  @1462:
    /*@1465*/ f.s = f.t;
    /*@1472*/ if (f.a == -1) goto @1603;
  @1475:
    /*@1479*/ var t4 = new int[1];
    /*@1484*/ t4[0] = f.a;
    /*@1488*/ c.a(3, t4);
    /*@1489*/ goto @1603;
  @1492:
    /*@1493*/ b.a = null;
    /*@1498*/ v3.a = null;
    /*@1501*/ f.n();
    /*@1507*/ var t5 = new k;
    /*@1510*/ t5.<init>(46);
    /*@1513*/ f.c = t5;
    /*@1519*/ f.a(100, 1);
    /*@1522*/ f.p();
    /*@1532*/ if (f.b.b != 2) goto @1539;
  @1535:
    /*@1536*/ { _phi_1540_0 = 4; goto @1540; }
  @1539:
    _phi_1540_0 = -1;
  @1540: [stack=1: _phi_1540_0]
    /*@1540*/ v3 = _phi_1540_0;
    /*@1544*/ if (d.a() == 0) goto @1559;
  @1547:
    /*@1549*/ if (v3 == -1) goto @1559;
  @1552:
    /*@1553*/ d.a(4);
    /*@1556*/ goto @1597;
  @1559:
    /*@1568*/ if (f.a != f.c) { _phi_1575_0 = f.a; goto @1575; }
    _phi_1571_0 = f.a;
  @1571: [stack=1: _phi_1571_0]
    /*@1572*/ { _phi_1576_0 = _phi_1571_0; _phi_1576_1 = 1; goto @1576; }
  @1575: [stack=1: _phi_1575_0]
    _phi_1576_0 = _phi_1575_0;
    _phi_1576_1 = 0;
  @1576: [stack=2: _phi_1576_0, _phi_1576_1]
    /*@1577*/ f.a(_phi_1576_0, _phi_1576_1, 0);
    /*@1584*/ var t6 = new int[1];
    /*@1587*/ t6[0] = 0;
    /*@1591*/ c.a(3, t6);
    /*@1594*/ f.s = 10;
  @1597:
    /*@1600*/ f.a = f.c;
  @1603:
    /*@1608*/ f.q = (f.q + 1);
    /*@1611*/ goto @1615;
  @1614:
  @1615:
    /*@1615*/ f.m();
  @1618:
    /*@1624*/ v3 = (java.lang.System.currentTimeMillis() - v1);
    /*@1629*/ if (cmp((java.lang.System.currentTimeMillis() - v1), 45L) >= 0) goto @1643;
  @1632: [stack=1: _phi_1632_0]
    /*@1637*/ java.lang.Thread.sleep((50L - v3));
    /*@1640*/ goto @1653;
  @1643: [stack=1: _phi_1643_0]
    /*@1646*/ java.lang.Thread.sleep(5L);
    /*@1649*/ goto @18;
  @1652:
  @1653:
    /*@1653*/ goto @18;
  @1656:
    /*@1660*/ c.a(1);
    /*@1665*/ f.a.destroyApp(1);
    /*@1671*/ f.a.notifyDestroyed();
    /*@1674*/ return;
  }

  public final void paint(javax.microedition.lcdui.Graphics p0) {
    // try [28..1649) catch (java.lang.Exception) -> @1652
    /*@11*/ if (cmp((java.lang.System.currentTimeMillis() - f.a), 2000L) <= 0) goto @22;
  @14:
    /*@15*/ this.hideNotify();
    /*@19*/ this.showNotify();
  @22:
    /*@25*/ f.a = java.lang.System.currentTimeMillis();
    /*@31*/ if (f.T == 0) goto @378;
  @34:
    /*@36*/ v3 = p0;
    /*@37*/ v2 = this;
    /*@41*/ if (f.c == null) goto @52;
  @44:
    /*@46*/ f.c(v3, 0);
    /*@49*/ goto @57;
  @52:
    /*@54*/ f.a(v3, 0);
  @57:
    /*@58*/ v4 = null;
    /*@63*/ v5 = 200;
    /*@68*/ if (f.b == null) goto @75;
  @71:
    /*@72*/ { _phi_76_0 = 1; goto @76; }
  @75:
    _phi_76_0 = 0;
  @76: [stack=1: _phi_76_0]
    /*@76*/ v6 = _phi_76_0;
    /*@81*/ if (f.b != null) goto @91;
  @84:
    /*@86*/ v4 = "...";
    /*@88*/ goto @241;
  @91:
    /*@95*/ if (f.T == 1) goto @105;
  @98:
    /*@102*/ if (f.T != 2) goto @211;
  @105:
    /*@109*/ if (f.T != 2) goto @130;
  @112:
    /*@117*/ if ((f.q & 4) == 0) goto @137;
  @120:
    /*@125*/ v4 = f.a(113);
    /*@127*/ goto @137;
  @130:
    /*@135*/ v4 = f.a(110);
  @137:
    /*@140*/ if (f.c == null) goto @200;
  @143:
    /*@148*/ v7 = (f.l / 2);
    /*@151*/ v8 = 0;
  @153:
    /*@159*/ if (v8 >= f.c.length) goto @200;
  @162:
    /*@179*/ l.a(f.b, v3, f.c[v8], 180, v7, 17);
    /*@192*/ v7 = (v7 + l.a[f.b]);
    /*@194*/ v8 += 1;
    /*@197*/ goto @153;
  @200:
    /*@206*/ v5 = (v2.w - 2);
    /*@208*/ goto @241;
  @211:
    /*@215*/ if (f.T != 3) goto @231;
  @218:
    /*@223*/ v4 = f.a(111);
    /*@226*/ v6 = 0;
    /*@228*/ goto @241;
  @231:
    /*@236*/ v4 = f.a(112);
    /*@239*/ v6 = 0;
  @241:
    /*@243*/ if (v4 == null) goto @280;
  @246:
    /*@250*/ if (l.a(0) == 0) goto @257;
  @253:
    /*@254*/ { _phi_258_0 = 0; goto @258; }
  @257:
    _phi_258_0 = 1;
  @258: [stack=1: _phi_258_0]
    /*@268*/ if (v6 == 0) { _phi_276_0 = _phi_258_0; _phi_276_1 = v3; _phi_276_2 = v4; _phi_276_3 = 180; _phi_276_4 = v5; goto @276; }
    _phi_271_0 = _phi_258_0;
    _phi_271_1 = v3;
    _phi_271_2 = v4;
    _phi_271_3 = 180;
    _phi_271_4 = v5;
  @271: [stack=5: _phi_271_0, _phi_271_1, _phi_271_2, _phi_271_3, _phi_271_4]
    /*@273*/ { _phi_277_0 = _phi_271_0; _phi_277_1 = _phi_271_1; _phi_277_2 = _phi_271_2; _phi_277_3 = _phi_271_3; _phi_277_4 = _phi_271_4; _phi_277_5 = 65; goto @277; }
  @276: [stack=5: _phi_276_0, _phi_276_1, _phi_276_2, _phi_276_3, _phi_276_4]
    _phi_277_0 = _phi_276_0;
    _phi_277_1 = _phi_276_1;
    _phi_277_2 = _phi_276_2;
    _phi_277_3 = _phi_276_3;
    _phi_277_4 = _phi_276_4;
    _phi_277_5 = 3;
  @277: [stack=6: _phi_277_0, _phi_277_1, _phi_277_2, _phi_277_3, _phi_277_4, _phi_277_5]
    /*@277*/ l.a(_phi_277_0, _phi_277_1, _phi_277_2, _phi_277_3, _phi_277_4, _phi_277_5);
  @280:
    /*@282*/ if (v6 == 0) goto @375;
  @285:
    /*@296*/ v7 = ((f.V * v2.B) / 100);
    /*@314*/ f.a(v3, f.e, v2.D, v2.w, v2.E);
    /*@336*/ f.a(v3, f.d, v2.x, v2.y, (v2.x + v7));
    /*@353*/ f.f[0].a(v3, v2.u, v2.w);
    /*@372*/ f.f[1].a(v3, v2.v, v2.w, 24);
  @375:
    /*@375*/ goto @1653;
  @378:
    /*@381*/ switch (f.s) { 2->@1431, 4->@1577, 5->@459, 10->@512, 30->@1524, 40->@1527, 100->@448, default->@1613 }
  @448:
    /*@453*/ this.a.a(p0);
    /*@456*/ goto @1613;
  @459:
    /*@461*/ v2 = p0;
    /*@463*/ f.a(p0, 0);
    /*@469*/ if (f.f == null) goto @503;
  @472:
    /*@500*/ f.f.a(v2, ((360 - f.f.a) >> 1), ((400 - f.f.b) >> 1));
  @503:
    /*@506*/ f.b(v2, 8);
    /*@509*/ goto @1613;
  @512:
    /*@514*/ v3 = p0;
    /*@515*/ v2 = this;
    /*@525*/ f.a(v3, 0, 0, 360, 400);
    /*@531*/ if (d.a() == 0) goto @571;
  @534:
    /*@541*/ if (f.b.f == -1) goto @571;
  @544:
    /*@547*/ if (f.b == null) goto @571;
  @550:
    /*@552*/ f.a(v3, 0);
    /*@565*/ f.b.a(v3, 180, 0, 17);
    /*@568*/ goto @625;
  @571:
    /*@577*/ if (f.a.a != null) goto @615;
  @580:
    /*@583*/ if (f.c == null) goto @607;
  @586:
    /*@588*/ f.a(v3, 0);
    /*@601*/ f.c.a(v3, 180, 0, 17);
    /*@604*/ goto @625;
  @607:
    /*@609*/ f.a(v3, 0);
    /*@612*/ goto @625;
  @615:
    /*@622*/ f.a.a.a(v3);
  @625:
    /*@628*/ if (f.a != null) goto @639;
  @631:
    /*@633*/ f.a(v3, 0);
    /*@636*/ goto @650;
  @639:
    /*@647*/ f.c(v3, (400 - f.K));
  @650:
    /*@656*/ if (f.b.a == null) goto @722;
  @659:
    /*@665*/ if (f.b != f.i) goto @690;
  @668:
    /*@687*/ { _phi_700_0 = (((400 - f.L) / 2) - (2 * l.a[f.b])); goto @700; }
  @690:
    _phi_700_0 = ((400 - f.K) + -2);
  @700: [stack=1: _phi_700_0]
    /*@700*/ v4 = _phi_700_0;
    /*@719*/ l.a(f.b, v3, f.b.a, 180, v4, 17);
  @722:
    /*@730*/ if ((f.b.c & 2) == 0) goto @755;
  @733:
    /*@750*/ v4 = ((400 - f.K) + ((f.K - f.L) / 2));
    /*@752*/ goto @770;
  @755:
    /*@768*/ v4 = ((400 - f.K) + (f.l / 2));
  @770:
    /*@772*/ v5 = v4;
    /*@780*/ v6 = f.b.d;
    /*@783*/ v7 = 0;
  @785:
    /*@791*/ v2 = f.b;
    /*@796*/ if (v6 >= f.b.a.length) goto @1064;
  @799:
    /*@804*/ if (v7 >= f.N) goto @1064;
  @807:
    /*@814*/ if (f.b.b == 2) goto @983;
  @817:
    /*@822*/ if (f.e.length != 4) goto @894;
  @825:
    /*@833*/ if (v6 != f.b.a) goto @842;
  @836:
    /*@837*/ v8 = 2;
    /*@839*/ goto @845;
  @842:
    /*@843*/ v8 = 0;
  @845:
    /*@869*/ f.e[v8].a(v3, (180 - f.e[v8].a), v5, 20);
    /*@888*/ f.e[(v8 + 1)].a(v3, 180, v5, 20);
    /*@891*/ goto @983;
  @894:
    /*@907*/ f.e[0].a(v3, 180, v5, 24);
    /*@923*/ f.e[1].a(v3, 180, v5, 20);
    /*@934*/ if (v6 != f.b.a) goto @983;
  @937:
    /*@940*/ v3.setColor(16777215);
    /*@980*/ v3.drawRect((180 - f.e[0].a), v5, ((2 * f.e[0].a) - 1), (f.e[0].b - 1));
  @983:
    /*@991*/ if ((f.b.c & 4) == 0) goto @1006;
  @994:
    /*@1003*/ { _phi_1009_0 = ((360 - f.I) / 2); goto @1009; }
  @1006:
    _phi_1009_0 = 180;
  @1009: [stack=1: _phi_1009_0]
    /*@1009*/ v8 = _phi_1009_0;
    /*@1040*/ l.a(f.b, v3, f.b.a[v6], v8, (v5 + (f.H / 2)), f.b.c);
    /*@1053*/ v5 = (v5 + (f.H + f.M));
    /*@1055*/ v6 += 1;
    /*@1058*/ v7 += 1;
    /*@1061*/ goto @785;
  @1064:
    /*@1071*/ if (f.b.b != 2) goto @1148;
  @1074:
    /*@1080*/ if (f.b.d <= 0) goto @1101;
  @1083:
    /*@1098*/ f.c[0].a(v3, 180, (v4 + 2), 33);
  @1101:
    /*@1111*/ v2 = f.b;
    /*@1120*/ if (f.b.d >= (f.b.a.length - f.N)) goto @1201;
  @1123:
    /*@1142*/ f.c[1].a(v3, 180, ((v4 + f.L) + 2), 17);
    /*@1145*/ goto @1201;
  @1148:
    /*@1152*/ v2 = f.b;
    /*@1158*/ if (f.b.a.length <= 1) goto @1201;
  @1161:
    /*@1176*/ f.c[0].a(v3, 180, (v4 - 2), 33);
    /*@1198*/ f.c[1].a(v3, 180, ((v4 + f.L) + 2), 17);
  @1201:
    /*@1204*/ if (f.a() != 0) goto @1424;
  @1207:
    /*@1210*/ if (d.a() == 0) goto @1331;
  @1213:
    /*@1220*/ if (f.b.f == -1) goto @1331;
  @1223:
    /*@1224*/ v2 = v3;
    /*@1226*/ v4 = null;
    /*@1229*/ v5 = null;
    /*@1238*/ if (f.b.f != 2) goto @1260;
  @1241:
    /*@1247*/ v4 = f.a(332);
    /*@1255*/ v5 = f.a(333);
    /*@1257*/ goto @1286;
  @1260:
    /*@1267*/ if (f.b.f != 3) goto @1278;
  @1270:
    /*@1276*/ v4 = f.a(334);
  @1278:
    /*@1284*/ v5 = f.a(331);
  @1286:
    /*@1288*/ if (v4 == null) goto @1306;
  @1291:
    /*@1303*/ l.a(f.b, v2, v4, 2, 399, 36);
  @1306:
    /*@1308*/ if (v5 == null) goto @1328;
  @1311:
    /*@1325*/ l.a(f.b, v2, v5, 358, 399, 40);
  @1328:
    /*@1328*/ goto @1424;
  @1331:
    /*@1332*/ v6 = 0;
    /*@1340*/ if (f.b.b != null) goto @1352;
  @1343:
    /*@1349*/ if (f.b != f.d) goto @1355;
  @1352:
    /*@1353*/ v6 = 1;
  @1355:
    /*@1361*/ if (f.b.a != null) goto @1384;
  @1364:
    /*@1371*/ if (f.b.e != -1) goto @1384;
  @1374:
    /*@1381*/ if (f.b.b == 2) goto @1418;
  @1384:
    /*@1387*/ if (f.q != 0) goto @1412;
  @1390:
    /*@1396*/ if (f.b != f.l) goto @1412;
  @1399:
    /*@1409*/ if (f.a[f.b.a] == null) goto @1418;
  @1412:
    /*@1416*/ v6 = (v6 | 2);
  @1418:
    /*@1421*/ f.b(v3, v6);
  @1424:
    /*@1425*/ f.a(v3);
    /*@1428*/ goto @1613;
  @1431:
    /*@1433*/ v3 = p0;
    /*@1435*/ v2 = this;
    /*@1442*/ this.g.a(v3, 0, 0);
    /*@1448*/ if (d.a() == 0) goto @1488;
  @1451:
    /*@1466*/ f.b(v3, 0, 0, 360, l.a[f.b], -1728053248);
    /*@1485*/ l.a(f.b, v3, f.a(302), 180, 0, 17);
  @1488:
    /*@1491*/ if (f.a() != 0) goto @1521;
  @1494:
    /*@1499*/ if ((f.q & 4) == 0) goto @1521;
  @1502:
    /*@1518*/ l.a(f.b, v3, f.a(113), 180, 266, 3);
  @1521:
    /*@1521*/ goto @1613;
  @1524:
    /*@1524*/ goto @1613;
  @1527:
    /*@1529*/ f.a(p0, 0);
    /*@1539*/ if (f.b != null) { _phi_1547_0 = f.b; _phi_1547_1 = p0; goto @1547; }
    _phi_1542_0 = f.b;
    _phi_1542_1 = p0;
  @1542: [stack=2: _phi_1542_0, _phi_1542_1]
    /*@1544*/ { _phi_1553_0 = _phi_1542_0; _phi_1553_1 = _phi_1542_1; _phi_1553_2 = "..."; goto @1553; }
  @1547: [stack=2: _phi_1547_0, _phi_1547_1]
    _phi_1553_0 = _phi_1547_0;
    _phi_1553_1 = _phi_1547_1;
    _phi_1553_2 = f.b[110];
  @1553: [stack=3: _phi_1553_0, _phi_1553_1, _phi_1553_2]
    /*@1571*/ l.a(_phi_1553_0, _phi_1553_1, _phi_1553_2, 180, ((400 - l.a[f.b]) >> 1), 17);
    /*@1574*/ goto @1613;
  @1577:
    /*@1579*/ f.a(p0, 0);
    /*@1610*/ l.a(f.b, p0, f.b[113], 180, ((400 - l.a[f.b]) >> 1), 17);
  @1613:
    /*@1616*/ if (f.n == 0) goto @1649;
  @1619:
    /*@1621*/ v2 = p0;
    /*@1630*/ f.a(p0, 0, 0, 360, 400);
    /*@1637*/ if (f.n != 3) goto @1645;
  @1640:
    /*@1642*/ f.a(v2, 0);
  @1645:
    /*@1646*/ f.a(v2);
  @1649:
    /*@1649*/ goto @1653;
  @1652:
  @1653:
    /*@1655*/ this.paint(p0);
    /*@1659*/ f.o = 0;
    /*@1662*/ return;
  }

  public static void a(javax.microedition.lcdui.Graphics p0, k p1, int p2, int p3, int p4) {
    /*@1*/ p2 = p2;
  @2:
    /*@10*/ if (p2 > (p4 - p1.a)) goto @30;
  @13:
    /*@17*/ p1.a(p0, p2, p3);
    /*@26*/ p2 = (p2 + p1.a);
    /*@27*/ goto @2;
  @30:
    /*@33*/ if (p2 >= p4) goto @84;
  @36:
    /*@46*/ p4 = 400;
    /*@48*/ v6 = (p4 - p2);
    /*@50*/ p4 = 0;
    /*@52*/ v5 = p2;
    /*@55*/ p4 = p0;
    /*@57*/ f.b(p0);
    /*@70*/ p4.clipRect(v5, 0, v6, 400);
    /*@77*/ p1.a(p0, p2, p3);
    /*@81*/ f.a(p0);
  @84:
    /*@84*/ return;
  }

  private void d() {
    // try [245..252) catch (java.lang.Exception) -> @255
    /*@0*/ f.n();
    /*@6*/ var t1 = new k;
    /*@9*/ t1.<init>(52);
    /*@16*/ f.a = t1.a(4);
    /*@22*/ var t2 = new k;
    /*@25*/ t2.<init>(37);
    /*@32*/ f.b = t2.a(2);
    /*@38*/ var t3 = new k;
    /*@41*/ t3.<init>(38);
    /*@48*/ f.c = t3.a(2);
    /*@56*/ f.d = new k[8];
    /*@62*/ var t4 = new k;
    /*@65*/ t4.<init>(45);
    /*@72*/ v1 = t4.a(3);
    /*@80*/ f.d[0] = v1[0];
    /*@88*/ var t5 = new k;
    /*@93*/ t5.<init>(v1[0], 5);
    /*@96*/ f.d[1] = t5;
    /*@104*/ var t6 = new k;
    /*@109*/ t6.<init>(v1[0], 3);
    /*@112*/ f.d[2] = t6;
    /*@120*/ var t7 = new k;
    /*@126*/ t7.<init>(v1[0], 6);
    /*@129*/ f.d[3] = t7;
    /*@137*/ f.d[4] = v1[1];
    /*@145*/ var t8 = new k;
    /*@150*/ t8.<init>(v1[1], 1);
    /*@153*/ f.d[5] = t8;
    /*@162*/ f.d[6] = v1[2];
    /*@171*/ var t9 = new k;
    /*@176*/ t9.<init>(v1[2], 2);
    /*@179*/ f.d[7] = t9;
    /*@184*/ f.f = new k[2];
    /*@190*/ var t10 = new k;
    /*@193*/ t10.<init>(43);
    /*@196*/ v1 = t10;
    /*@202*/ f.f[0] = v1;
    /*@210*/ var t11 = new k;
    /*@213*/ t11.<init>(v1, 2);
    /*@216*/ f.f[1] = t11;
    /*@220*/ var t12 = new k;
    /*@223*/ t12.<init>(41);
    /*@226*/ f.d = t12;
    /*@232*/ var t13 = new k;
    /*@235*/ t13.<init>(42);
    /*@238*/ f.e = t13;
    /*@242*/ f.d(0);
    /*@251*/ c.a(1, "1");
    /*@252*/ goto @256;
  @255:
  @256:
    /*@259*/ l.a(f.b);
    /*@263*/ v1 = this;
    /*@272*/ f.k = f.d[0].a;
    /*@283*/ f.l = f.d[0].b;
    /*@294*/ v1.z = (360 - f.k);
    /*@306*/ v1.A = f.f[0].b;
    /*@320*/ v1.u = ((360 - v1.z) / 2);
    /*@332*/ v1.v = (360 - v1.u);
    /*@350*/ v1.w = ((400 - (f.l / 2)) - v1.A);
    /*@360*/ v1.C = f.d.b;
    /*@383*/ v1.x = ((v1.u + f.f[0].a) - f.a(0, 5));
    /*@403*/ v1.y = (v1.w + ((v1.A - v1.C) / 2));
    /*@417*/ v1.B = (360 - (2 * v1.x));
    /*@425*/ v1.D = v1.x;
    /*@437*/ v1.E = (360 - v1.D);
    /*@450*/ f.J = ((360 - f.k) - 6);
    /*@458*/ var t14 = f.a("ms-skPos");
    /*@459*/ v1 = t14;
    /*@460*/ if (t14 == null) goto @472;
  @463:
    /*@469*/ f.k = v1.equals("1");
  @472:
    /*@474*/ v1 = this;
    /*@475*/ this.h();
    /*@478*/ f.p();
    /*@481*/ return;
  }

  public static k[] a(int p0, int p1) {
    /*@5*/ p0 = new k[11];
    /*@7*/ p1 = 0;
  @8:
    /*@11*/ if (p1 >= 11) goto @36;
  @14:
    /*@19*/ var t1 = new k;
    /*@26*/ t1.<init>(h.a((p1 + -1)));
    /*@29*/ p0[p1] = t1;
    /*@30*/ p1 += 1;
    /*@33*/ goto @8;
  @36:
    /*@37*/ return p0;
  }

  private void e() {
    /*@4*/ c.a(1);
    /*@6*/ f.c = null;
    /*@13*/ if (this.a == null) goto @28;
  @16:
    /*@18*/ this.a = null;
    /*@22*/ b.a = null;
    /*@25*/ java.lang.System.gc();
  @28:
    /*@28*/ java.lang.System.gc();
    /*@33*/ f.s = 100;
    /*@39*/ new e.<init>();
    /*@42*/ f.p();
    /*@45*/ return;
  }

  private void f() {
    // try [206..242) catch (java.lang.Exception) -> @245
    // try [12..77) catch (java.lang.Exception) -> @80
    /*@4*/ if (f.s == 5) goto @10;
  @7:
    /*@7*/ f.n();
  @10:
    /*@11*/ v1 = 0;
    /*@13*/ f.f = null;
    /*@19*/ var t1 = new java.lang.StringBuffer;
    /*@20*/ t1.<init>();
    /*@45*/ var t2 = h.a(t1.append("brand").append(f.G).append(".png").toString());
    /*@46*/ v2 = t2;
    /*@47*/ if (t2 == null) goto @61;
  @50:
    /*@53*/ var t3 = new k;
    /*@55*/ t3.<init>(v2);
    /*@58*/ f.f = t3;
  @61:
    /*@64*/ if (f.f != null) goto @69;
  @67:
    /*@68*/ v1 = 1;
  @69:
    /*@74*/ f.G = (f.G + 1);
    /*@77*/ goto @87;
  @80:
    /*@81*/ v2 = caughtException<Exception>;
    /*@82*/ caughtException<Exception>.printStackTrace();
    /*@86*/ v1 = 1;
  @87:
    /*@88*/ if (v1 == 0) goto @115;
  @91:
    /*@92*/ f.f = null;
    /*@95*/ f.b();
    /*@99*/ f.s = 2;
    /*@106*/ var t4 = new int[1];
    /*@109*/ t4[0] = 0;
    /*@113*/ c.a(3, t4);
    /*@114*/ return;
  @115:
    /*@119*/ if (f.s == 5) goto @364;
  @122:
    /*@123*/ f.s = 5;
    /*@127*/ v1 = this;
    /*@131*/ v2 = 10;
    /*@133*/ f.a(10, 0);
    /*@139*/ var t5 = new k;
    /*@142*/ t5.<init>(56);
    /*@145*/ f.a = t5;
    /*@149*/ f.d(1);
    /*@158*/ f.F = f.c.b;
    /*@164*/ v2 = 35;
    /*@166*/ f.a(35, 0);
    /*@173*/ var t6 = new k;
    /*@179*/ t6.<init>(h.a("splash.png"));
    /*@182*/ v1.g = t6;
    /*@188*/ v2 = 60;
    /*@190*/ f.a(60, 0);
    /*@197*/ c.a(0);
    /*@201*/ v2 = 70;
    /*@203*/ f.a(70, 0);
    /*@212*/ var t7 = javax.microedition.rms.RecordStore.openRecordStore("aoe3", 1);
    /*@213*/ v1 = t7;
    /*@217*/ if (t7.getNumRecords() != 0) goto @238;
  @220:
    /*@221*/ v2 = 0;
  @222:
    /*@224*/ if (v2 > 4) goto @238;
  @227:
    /*@231*/ f.a(v2);
    /*@232*/ v2 += 1;
    /*@235*/ goto @222;
  @238:
    /*@239*/ v1.closeRecordStore();
    /*@242*/ goto @246;
  @245:
  @246:
    /*@247*/ f.b(0);
    /*@251*/ f.b(1);
    /*@257*/ v2 = 80;
    /*@259*/ f.a(80, 0);
    /*@262*/ e.a();
    /*@268*/ v2 = 95;
    /*@270*/ f.a(95, 0);
    /*@276*/ var t8 = new java.util.Vector;
    /*@277*/ t8.<init>();
    /*@280*/ v1 = t8;
    /*@282*/ v2 = 0;
  @283:
    /*@288*/ if (v2 >= e.y.length) goto @335;
  @291:
    /*@296*/ v3 = e.y[v2];
    /*@301*/ var t9 = new java.lang.StringBuffer;
    /*@302*/ t9.<init>();
    /*@326*/ v1.addElement(t9.append(f.a(((v3 + 208) + 1))).append("").toString());
    /*@329*/ v2 += 2;
    /*@332*/ goto @283;
  @335:
    /*@338*/ var t10 = new g;
    /*@349*/ t10.<init>(f.a(20), f.a(v1), 1);
    /*@352*/ f.q = t10;
    /*@358*/ f.a(100, 1);
    /*@361*/ f.p();
  @364:
    /*@367*/ if (f.f == null) goto @378;
  @370:
    /*@375*/ this.r = ((int) java.lang.System.currentTimeMillis());
  @378:
    /*@378*/ f.b();
    /*@381*/ return;
  }

  public static void a(javax.microedition.lcdui.Graphics p0, int p1) {
    /*@2*/ p0.setColor(p1);
    /*@22*/ p0.fillRect(p0.getClipX(), p0.getClipY(), p0.getClipWidth(), p0.getClipHeight());
    /*@25*/ return;
  }

  private void g() {
    // try [0..10) catch (java.lang.Exception) -> @13
    /*@9*/ c.a(1, f.b[0]);
    /*@10*/ goto @14;
  @13:
  @14:
    /*@17*/ if (c.a != 0) goto @30;
  @20:
    /*@23*/ l.b(f.b);
    /*@27*/ f.b = 1;
  @30:
    /*@31*/ this = this;
    /*@36*/ var t1 = new String[2];
    /*@43*/ t1[0] = f.a(26);
    /*@51*/ t1[1] = f.a(27);
    /*@52*/ v1 = t1;
    /*@54*/ f.O = 0;
    /*@62*/ var t2 = f.a("ms-upSell");
    /*@63*/ v2 = t2;
    /*@64*/ if (t2 == null) goto @77;
  @67:
    /*@74*/ f.O = java.lang.Integer.valueOf(v2).intValue();
  @77:
    /*@80*/ if (f.O == 0) goto @129;
  @83:
    /*@88*/ v3 = f.a("ms-upSellUrl");
    /*@96*/ var t3 = new String[1];
    /*@99*/ t3[0] = v3;
    /*@103*/ v2 = f.a(306, t3);
    /*@108*/ if (f.O != 1) goto @129;
  @111:
    /*@126*/ f.j = f.a(f.b[305], v2, f.c, null);
  @129:
    /*@132*/ var t4 = new java.util.Vector;
    /*@133*/ t4.<init>();
    /*@136*/ v2 = t4;
    /*@140*/ if (d.a() == 0) goto @190;
  @143:
    /*@150*/ v2.addElement(f.a(303));
    /*@160*/ var t5 = ((String) d.a(0));
    /*@161*/ v3 = t5;
    /*@162*/ if (t5 == null) goto @171;
  @165:
    /*@168*/ v2.insertElementAt(v3, 0);
  @171:
    /*@174*/ if (f.O == 0) goto @187;
  @177:
    /*@184*/ v2.addElement(f.a(305));
  @187:
    /*@187*/ goto @230;
  @190:
    /*@195*/ v2.addElement(f.a(3));
    /*@203*/ v2.addElement(f.a(4));
    /*@209*/ if (f.O == 0) goto @222;
  @212:
    /*@219*/ v2.addElement(f.a(305));
  @222:
    /*@227*/ v2.addElement(f.a(5));
  @230:
    /*@236*/ v2.addElement(f.a(6));
    /*@245*/ v2.addElement(f.a(7));
    /*@254*/ v2.addElement(f.a(8));
    /*@263*/ v2.addElement(f.a(9));
    /*@269*/ var t6 = new g;
    /*@273*/ if (d.a() == 0) { _phi_285_0 = t6; _phi_285_1 = t6; goto @285; }
    _phi_276_0 = t6;
    _phi_276_1 = t6;
  @276: [stack=2: _phi_276_0, _phi_276_1]
    /*@282*/ { _phi_286_0 = _phi_276_0; _phi_286_1 = _phi_276_1; _phi_286_2 = f.a(302); goto @286; }
  @285: [stack=2: _phi_285_0, _phi_285_1]
    _phi_286_0 = _phi_285_0;
    _phi_286_1 = _phi_285_1;
    _phi_286_2 = null;
  @286: [stack=3: _phi_286_0, _phi_286_1, _phi_286_2]
    /*@291*/ _phi_286_1.<init>(_phi_286_2, f.a(v2), 0);
    /*@295*/ f.c = _phi_286_0;
    /*@298*/ f.a = _phi_286_0;
    /*@302*/ v2.removeAllElements();
    /*@311*/ v2.addElement(f.a(11));
    /*@320*/ v2.addElement(f.a(30));
    /*@326*/ if (d.a() != 0) goto @338;
  @329:
    /*@335*/ v2.addElement(f.a(29));
  @338:
    /*@344*/ v2.addElement(f.a(18));
    /*@353*/ v2.addElement(f.a(6));
    /*@362*/ v2.addElement(f.a(7));
    /*@370*/ v2.addElement(f.a(2));
    /*@376*/ var t7 = new g;
    /*@388*/ t7.<init>(f.b[10], f.a(v2), 0);
    /*@391*/ f.d = t7;
    /*@397*/ var t8 = new g;
    /*@405*/ t8.<init>(f.a(17), v1, 1);
    /*@408*/ f.m = t8;
    /*@414*/ var t9 = new g;
    /*@422*/ t9.<init>(f.a(18), v1, 1);
    /*@425*/ f.o = t9;
    /*@431*/ var t10 = new g;
    /*@439*/ t10.<init>(f.a(9), v1, 1);
    /*@442*/ f.h = t10;
    /*@448*/ var t11 = new g;
    /*@456*/ t11.<init>(f.a(16), v1, 1);
    /*@459*/ f.n = t11;
    /*@465*/ var t12 = new g;
    /*@474*/ t12.<init>(f.b[25], v1, 0);
    /*@477*/ f.i = t12;
    /*@483*/ var t13 = new g;
    /*@493*/ var t14 = new String[2];
    /*@500*/ t14[0] = f.a(18);
    /*@507*/ t14[1] = f.a(2);
    /*@509*/ t13.<init>(f.a(120), t14, 1);
    /*@512*/ f.p = t13;
    /*@516*/ v2.removeAllElements();
    /*@525*/ v2.addElement(f.a(41));
    /*@534*/ v2.addElement(f.a(43));
    /*@543*/ v2.addElement(f.a(45));
    /*@552*/ v2.addElement(f.a(49));
    /*@558*/ var t15 = new g;
    /*@569*/ t15.<init>(f.a(7), f.a(v2), 1);
    /*@572*/ f.k = t15;
    /*@578*/ var t16 = new g;
    /*@588*/ var t17 = new String[2];
    /*@595*/ t17[0] = f.a(35);
    /*@603*/ t17[1] = f.a(36);
    /*@605*/ t16.<init>(f.a(97), t17, 0);
    /*@608*/ f.s = t16;
    /*@614*/ var t18 = new g;
    /*@624*/ var t19 = new String[2];
    /*@631*/ t19[0] = f.a(23);
    /*@639*/ t19[1] = f.a(24);
    /*@641*/ t18.<init>(f.a(22), t19, 1);
    /*@644*/ f.t = t18;
    /*@648*/ this.i();
    /*@655*/ this = f.i;
    /*@658*/ f.a(f.i, 0, 1);
    /*@665*/ f.b.a = 1;
    /*@668*/ return;
  }

  private void h() {
    // try [19..133) catch (java.lang.Exception) -> @134
    /*@5*/ var t1 = f.a("ms-multiLang");
    /*@6*/ v1 = t1;
    /*@7*/ if (t1 == null) goto @145;
  @10:
    /*@16*/ if (v1.equals("1") == 0) goto @136;
  @19:
    /*@24*/ v1 = h.a("multi.dat");
    /*@28*/ var t2 = new java.io.DataInputStream;
    /*@32*/ var t3 = new java.io.ByteArrayInputStream;
    /*@34*/ t3.<init>(v1);
    /*@37*/ t2.<init>(t3);
    /*@41*/ v1 = t2;
    /*@45*/ var t4 = t2.readInt();
    /*@46*/ v2 = t4;
    /*@50*/ v3 = new String[t4];
    /*@56*/ this.a = new String[v2];
    /*@60*/ v4 = 0;
  @62:
    /*@65*/ if (v4 >= v2) goto @82;
  @68:
    /*@75*/ v3[v4] = v1.readUTF();
    /*@76*/ v4 += 1;
    /*@79*/ goto @62;
  @82:
    /*@83*/ v4 = 0;
  @85:
    /*@88*/ if (v4 >= v2) goto @108;
  @91:
    /*@101*/ this.a[v4] = v1.readUTF();
    /*@102*/ v4 += 1;
    /*@105*/ goto @85;
  @108:
    /*@112*/ var t5 = new g;
    /*@116*/ t5.<init>(null, v3, 0);
    /*@119*/ this.f = t5;
    /*@127*/ this = this.f;
    /*@130*/ f.a(this.f, 0, 1);
    /*@133*/ return;
  @134:
    /*@135*/ return;
  @136:
    /*@137*/ f.b(v1);
    /*@141*/ this.g();
    /*@144*/ return;
  @145:
    /*@147*/ f.b("lang.dat");
    /*@151*/ this.g();
    /*@154*/ return;
  }

  private static void b(String p0) {
    /*@3*/ var t1 = new java.lang.StringBuffer;
    /*@4*/ t1.<init>();
    /*@19*/ f.c(t1.append("/").append(p0).toString());
    /*@23*/ f.j = 1;
    /*@27*/ d.a(1);
    /*@30*/ return;
  }

  public static void b(javax.microedition.lcdui.Graphics p0, int p1) {
    /*@14*/ v2 = ((360 - f.a[0].a) - 1);
    /*@29*/ v3 = ((400 - f.a[0].b) - 2);
    /*@33*/ if ((p1 & 1) == 0) goto @60;
  @36:
    /*@45*/ if (f.k == 0) { _phi_52_0 = f.a[1]; _phi_52_1 = p0; goto @52; }
    _phi_48_0 = f.a[1];
    _phi_48_1 = p0;
  @48: [stack=2: _phi_48_0, _phi_48_1]
    /*@49*/ { _phi_53_0 = _phi_48_0; _phi_53_1 = _phi_48_1; _phi_53_2 = 1; goto @53; }
  @52: [stack=2: _phi_52_0, _phi_52_1]
    _phi_53_0 = _phi_52_0;
    _phi_53_1 = _phi_52_1;
    _phi_53_2 = v2;
  @53: [stack=3: _phi_53_0, _phi_53_1, _phi_53_2]
    /*@54*/ _phi_53_0.a(_phi_53_1, _phi_53_2, v3);
    /*@57*/ goto @87;
  @60:
    /*@63*/ if ((p1 & 4) == 0) goto @87;
  @66:
    /*@75*/ if (f.k == 0) { _phi_82_0 = f.a[2]; _phi_82_1 = p0; goto @82; }
    _phi_78_0 = f.a[2];
    _phi_78_1 = p0;
  @78: [stack=2: _phi_78_0, _phi_78_1]
    /*@79*/ { _phi_83_0 = _phi_78_0; _phi_83_1 = _phi_78_1; _phi_83_2 = 1; goto @83; }
  @82: [stack=2: _phi_82_0, _phi_82_1]
    _phi_83_0 = _phi_82_0;
    _phi_83_1 = _phi_82_1;
    _phi_83_2 = v2;
  @83: [stack=3: _phi_83_0, _phi_83_1, _phi_83_2]
    /*@84*/ _phi_83_0.a(_phi_83_1, _phi_83_2, v3);
  @87:
    /*@90*/ if ((p1 & 2) == 0) goto @115;
  @93:
    /*@102*/ if (f.k == 0) { _phi_109_0 = f.a[0]; _phi_109_1 = p0; goto @109; }
    _phi_105_0 = f.a[0];
    _phi_105_1 = p0;
  @105: [stack=2: _phi_105_0, _phi_105_1]
    /*@106*/ { _phi_110_0 = _phi_105_0; _phi_110_1 = _phi_105_1; _phi_110_2 = v2; goto @110; }
  @109: [stack=2: _phi_109_0, _phi_109_1]
    _phi_110_0 = _phi_109_0;
    _phi_110_1 = _phi_109_1;
    _phi_110_2 = 1;
  @110: [stack=3: _phi_110_0, _phi_110_1, _phi_110_2]
    /*@111*/ _phi_110_0.a(_phi_110_1, _phi_110_2, v3);
    /*@114*/ return;
  @115:
    /*@119*/ if ((p1 & 16) == 0) goto @143;
  @122:
    /*@131*/ if (f.k == 0) { _phi_138_0 = f.a[3]; _phi_138_1 = p0; goto @138; }
    _phi_134_0 = f.a[3];
    _phi_134_1 = p0;
  @134: [stack=2: _phi_134_0, _phi_134_1]
    /*@135*/ { _phi_139_0 = _phi_134_0; _phi_139_1 = _phi_134_1; _phi_139_2 = v2; goto @139; }
  @138: [stack=2: _phi_138_0, _phi_138_1]
    _phi_139_0 = _phi_138_0;
    _phi_139_1 = _phi_138_1;
    _phi_139_2 = 1;
  @139: [stack=3: _phi_139_0, _phi_139_1, _phi_139_2]
    /*@140*/ _phi_139_0.a(_phi_139_1, _phi_139_2, v3);
  @143:
    /*@143*/ return;
  }

  private void i() {
    /*@3*/ var t1 = new g;
    /*@14*/ if (this.a != null) { _phi_57_0 = t1; _phi_57_1 = t1; _phi_57_2 = f.a(297); goto @57; }
    _phi_17_0 = t1;
    _phi_17_1 = t1;
    _phi_17_2 = f.a(297);
  @17: [stack=3: _phi_17_0, _phi_17_1, _phi_17_2]
    /*@21*/ var t2 = new String[1];
    /*@26*/ var t3 = new java.lang.StringBuffer;
    /*@27*/ t3.<init>();
    /*@53*/ t2[0] = t3.append(f.a(298)).append(": ").append(f.l).toString();
    /*@54*/ { _phi_145_0 = _phi_17_0; _phi_145_1 = _phi_17_1; _phi_145_2 = _phi_17_2; _phi_145_3 = t2; goto @145; }
  @57: [stack=3: _phi_57_0, _phi_57_1, _phi_57_2]
    /*@61*/ var t4 = new String[4];
    /*@66*/ var t5 = new java.lang.StringBuffer;
    /*@67*/ t5.<init>();
    /*@93*/ t4[0] = t5.append(f.a(298)).append(": ").append(f.l).toString();
    /*@99*/ var t6 = new java.lang.StringBuffer;
    /*@100*/ t6.<init>();
    /*@126*/ t4[1] = t6.append(f.a(299)).append(": ").append(f.b).toString();
    /*@135*/ t4[2] = f.a(300);
    /*@144*/ t4[3] = f.a(301);
    _phi_145_0 = _phi_57_0;
    _phi_145_1 = _phi_57_1;
    _phi_145_2 = _phi_57_2;
    _phi_145_3 = t4;
  @145: [stack=4: _phi_145_0, _phi_145_1, _phi_145_2, _phi_145_3]
    /*@146*/ _phi_145_1.<init>(_phi_145_2, _phi_145_3, 1);
    /*@149*/ f.u = _phi_145_0;
    /*@152*/ return;
  }

  public static void a() {
    /*@3*/ var t1 = new java.util.Vector;
    /*@4*/ t1.<init>();
    /*@7*/ v0 = t1;
    /*@9*/ v1 = 0;
  @10:
    /*@14*/ if (f.l == 0) { _phi_26_0 = v1; goto @26; }
    _phi_17_0 = v1;
  @17: [stack=1: _phi_17_0]
    /*@23*/ { _phi_29_0 = _phi_17_0; _phi_29_1 = (e.a.length - 1); goto @29; }
  @26: [stack=1: _phi_26_0]
    _phi_29_0 = _phi_26_0;
    _phi_29_1 = f.j;
  @29: [stack=2: _phi_29_0, _phi_29_1]
    /*@29*/ if (_phi_29_0 > _phi_29_1) goto @75;
  @32:
    /*@39*/ var t2 = new String[1];
    /*@44*/ var t3 = new java.lang.StringBuffer;
    /*@45*/ t3.<init>();
    /*@62*/ t2[0] = t3.append("").append((v1 + 1)).toString();
    /*@66*/ v0.addElement(f.a(19, t2));
    /*@69*/ v1 += 1;
    /*@72*/ goto @10;
  @75:
    /*@78*/ if (f.e != null) goto @102;
  @81:
    /*@84*/ var t4 = new g;
    /*@95*/ t4.<init>(f.a(14), f.a(v0), 1);
    /*@98*/ f.e = t4;
    /*@101*/ return;
  @102:
    /*@109*/ f.e.a = f.a(v0);
    /*@112*/ return;
  }

  private static void j() {
    /*@4*/ v0 = new String[3];
    /*@6*/ v1 = 0;
  @7:
    /*@9*/ if (v1 >= 3) goto @195;
  @12:
    /*@18*/ v2 = f.a[v1];
    /*@19*/ if (f.a[v1] != null) goto @33;
  @22:
    /*@29*/ v0[v1] = f.a(15);
    /*@30*/ goto @189;
  @33:
    /*@38*/ var t1 = new java.lang.StringBuffer;
    /*@39*/ t1.<init>();
    /*@45*/ if (v2[0] != 0) { _phi_79_0 = v0; _phi_79_1 = v1; _phi_79_2 = t1; goto @79; }
    _phi_48_0 = v0;
    _phi_48_1 = v1;
    _phi_48_2 = t1;
  @48: [stack=3: _phi_48_0, _phi_48_1, _phi_48_2]
    /*@51*/ var t2 = new java.lang.StringBuffer;
    /*@52*/ t2.<init>();
    /*@76*/ { _phi_83_0 = _phi_48_0; _phi_83_1 = _phi_48_1; _phi_83_2 = _phi_48_2; _phi_83_3 = t2.append(f.a(3)).append(" ").append(v2[1]).toString(); goto @83; }
  @79: [stack=3: _phi_79_0, _phi_79_1, _phi_79_2]
    _phi_83_0 = _phi_79_0;
    _phi_83_1 = _phi_79_1;
    _phi_83_2 = _phi_79_2;
    _phi_83_3 = f.a(4);
  @83: [stack=4: _phi_83_0, _phi_83_1, _phi_83_2, _phi_83_3]
    /*@94*/ var t3 = new java.lang.StringBuffer;
    /*@95*/ t3.<init>();
    /*@127*/ var t4 = new java.lang.StringBuffer;
    /*@128*/ t4.<init>();
    /*@160*/ var t5 = new java.lang.StringBuffer;
    /*@161*/ t5.<init>();
    /*@188*/ _phi_83_0[_phi_83_1] = _phi_83_2.append(_phi_83_3).append(" ").append(f.a(t3.append("").append(v2[2]).toString(), 2)).append(":").append(f.a(t4.append("").append(v2[3]).toString(), 2)).append(":").append(f.a(t5.append("").append(v2[4]).toString(), 2)).toString();
  @189:
    /*@189*/ v1 += 1;
    /*@192*/ goto @7;
  @195:
    /*@198*/ if (f.l != null) goto @229;
  @201:
    /*@204*/ var t6 = new g;
    /*@208*/ if (f.q == 0) { _phi_216_0 = t6; _phi_216_1 = t6; goto @216; }
    _phi_211_0 = t6;
    _phi_211_1 = t6;
  @211: [stack=2: _phi_211_0, _phi_211_1]
    /*@213*/ { _phi_217_0 = _phi_211_0; _phi_217_1 = _phi_211_1; _phi_217_2 = 29; goto @217; }
  @216: [stack=2: _phi_216_0, _phi_216_1]
    _phi_217_0 = _phi_216_0;
    _phi_217_1 = _phi_216_1;
    _phi_217_2 = 5;
  @217: [stack=3: _phi_217_0, _phi_217_1, _phi_217_2]
    /*@222*/ _phi_217_1.<init>(f.a(_phi_217_2), v0, 1);
    /*@225*/ f.l = _phi_217_0;
    /*@228*/ return;
  @229:
    /*@233*/ f.l.a = v0;
    /*@236*/ return;
  }

  public static void a(g p0) {
    /*@3*/ f.a(p0, 0, 1);
    /*@6*/ return;
  }

  public static void a(g p0, boolean p1, boolean p2) {
    /*@1*/ if (p0 != null) goto @5;
  @4:
    /*@4*/ return;
  @5:
    /*@5*/ f.b();
    /*@9*/ if (p2 == 0) goto @26;
  @12:
    /*@16*/ if (p0.b == 0) goto @26;
  @19:
    /*@23*/ p0.b = f.b;
  @26:
    /*@27*/ f.b = p0;
    /*@35*/ if (p0.b != 2) goto @51;
  @38:
    /*@45*/ f.H = l.a[f.b];
    /*@48*/ goto @62;
  @51:
    /*@59*/ f.H = f.e[0].b;
  @62:
    /*@63*/ if (p1 == 0) goto @80;
  @66:
    /*@70*/ f.b.a = 0;
    /*@77*/ f.b.d = 0;
  @80:
    /*@81*/ f.a(0);
    /*@88*/ p1 = f.b;
    /*@99*/ var t1 = java.lang.Math.min(f.b.a.length, f.m);
    /*@100*/ f.N = t1;
    /*@115*/ f.L = ((t1 * (f.H + f.M)) - f.M);
    /*@123*/ if (p0.b != 2) goto @135;
  @126:
    /*@129*/ f.I = f.J;
    /*@132*/ goto @148;
  @135:
    /*@145*/ f.I = (2 * f.e[0].a);
  @148:
    /*@150*/ f.s = 10;
    /*@153*/ return;
  }

  public static void a(boolean p0) {
    /*@6*/ if (f.a.a == null) goto @22;
  @9:
    /*@16*/ f.K = (400 - f.F);
    /*@19*/ goto @51;
  @22:
    /*@23*/ if (p0 != 0) goto @32;
  @26:
    /*@29*/ if (f.c == null) goto @45;
  @32:
    /*@39*/ f.K = (400 - f.F);
    /*@42*/ goto @51;
  @45:
    /*@48*/ f.K = 400;
  @51:
    /*@69*/ var t1 = ((f.K - f.l) - (2 * f.c[0].b));
    /*@70*/ f.L = t1;
    /*@85*/ f.m = ((t1 + f.M) / (f.H + f.M));
    /*@88*/ return;
  }

  private static void c(javax.microedition.lcdui.Graphics p0, int p1) {
    /*@3*/ if (f.a == null) goto @39;
  @6:
    /*@7*/ v2 = p1;
  @8:
    /*@12*/ if (v2 >= 400) goto @39;
  @15:
    /*@24*/ f.a(p0, f.a, 0, v2, 360);
    /*@35*/ v2 = (v2 + f.a.b);
    /*@36*/ goto @8;
  @39:
    /*@42*/ if (f.d == null) goto @267;
  @45:
    /*@53*/ v2 = f.d[0].a;
  @54:
    /*@67*/ if (v2 >= (360 - f.d[0].a)) goto @110;
  @70:
    /*@78*/ f.d[4].a(p0, v2, p1);
    /*@93*/ f.d[5].a(p0, v2, 400, 36);
    /*@106*/ v2 = (v2 + f.d[0].a);
    /*@107*/ goto @54;
  @110:
    /*@120*/ v2 = (p1 + f.d[0].b);
  @121:
    /*@134*/ if (v2 >= (400 - f.d[0].b)) goto @188;
  @137:
    /*@146*/ f.d[6].a(p0, 0, v2);
    /*@171*/ f.d[7].a(p0, (360 - f.d[0].a), v2, 20);
    /*@184*/ v2 = (v2 + f.d[0].b);
    /*@185*/ goto @121;
  @188:
    /*@196*/ f.d[0].a(p0, 0, p1);
    /*@221*/ f.d[1].a(p0, (360 - f.d[0].a), p1, 2, 20);
    /*@237*/ f.d[2].a(p0, 0, 400, 1, 36);
    /*@264*/ f.d[3].a(p0, (360 - f.d[0].a), 400, 3, 36);
  @267:
    /*@267*/ return;
  }

  private void k() {
    /*@6*/ if (f.b != f.g) goto @14;
  @9:
    /*@13*/ f.a(0);
  @14:
    /*@20*/ if (f.b.b == null) goto @42;
  @23:
    /*@27*/ f.b.a = 0;
    /*@38*/ f.a(f.b.b, 0, 0);
    /*@41*/ return;
  @42:
    /*@48*/ if (f.b != f.d) goto @63;
  @51:
    /*@53*/ f.s = 100;
    /*@60*/ this.a.g();
  @63:
    /*@63*/ return;
  }

  private void a(g p0, int p1) {
    /*@5*/ if (p0 != this.f) goto @37;
  @8:
    /*@20*/ f.b(this.a[this.f.a]);
    /*@25*/ v4 = this;
    /*@28*/ this.a = null;
    /*@33*/ f.a(0, 2);
    /*@36*/ return;
  @37:
    /*@43*/ v3 = p0.a[p1];
    /*@48*/ if (p0 != f.i) goto @85;
  @51:
    /*@57*/ if (v3 != f.a(26)) goto @67;
  @60:
    /*@61*/ f.f = 1;
    /*@64*/ goto @80;
  @67:
    /*@73*/ if (v3 != f.a(27)) goto @80;
  @76:
    /*@77*/ f.f = 0;
  @80:
    /*@82*/ f.a(0, 3);
  @85:
    /*@89*/ if (p0 != f.c) goto @317;
  @92:
    /*@97*/ if (v3 != f.a(3)) goto @173;
  @100:
    /*@101*/ f.c = 0;
    /*@107*/ var t1 = new java.util.Vector;
    /*@108*/ t1.<init>();
    /*@112*/ v4 = t1;
    /*@119*/ t1.addElement(f.a(12));
    /*@125*/ if (f.l != 0) goto @134;
  @128:
    /*@131*/ if (f.j <= 0) goto @144;
  @134:
    /*@141*/ v4.addElement(f.a(13));
  @144:
    /*@147*/ var t2 = new g;
    /*@158*/ t2.<init>(f.a(3), f.a(v4), 1);
    /*@162*/ f.r = t2;
    /*@167*/ f.a(t2, 1, 1);
    /*@170*/ goto @317;
  @173:
    /*@178*/ if (v3 != f.a(4)) goto @196;
  @181:
    /*@182*/ f.c = 1;
    /*@190*/ f.a(f.q, 1, 1);
    /*@193*/ goto @317;
  @196:
    /*@201*/ if (v3 != f.a(5)) goto @222;
  @204:
    /*@205*/ f.q = 0;
    /*@208*/ f.j();
    /*@216*/ f.a(f.l, 1, 1);
    /*@219*/ goto @317;
  @222:
    /*@228*/ if (v3 != f.a(8)) goto @290;
  @231:
    /*@236*/ var t3 = f.a("MIDlet-Version");
    /*@237*/ v4 = t3;
    /*@239*/ if (t3 != null) goto @246;
  @242:
    /*@244*/ v4 = "?";
  @246:
    /*@258*/ var t4 = new String[2];
    /*@265*/ t4[0] = f.b[1];
    /*@270*/ t4[1] = v4;
    /*@279*/ var t5 = f.a(f.b[8], f.a(39, t4), p0, null);
    /*@280*/ v4 = t5;
    /*@284*/ f.a(t5, 0, 1);
    /*@287*/ goto @317;
  @290:
    /*@296*/ if (v3 != f.a(9)) goto @317;
  @299:
    /*@303*/ v4 = f.h;
    /*@307*/ f.a(f.h, 0, 1);
    /*@314*/ f.b.a = 1;
  @317:
    /*@321*/ if (p0 != f.h) goto @353;
  @324:
    /*@330*/ if (v3 != f.a(26)) goto @340;
  @333:
    /*@334*/ f.d = 0;
    /*@337*/ goto @353;
  @340:
    /*@346*/ if (v3 != f.a(27)) goto @353;
  @349:
    /*@350*/ this.k();
  @353:
    /*@357*/ if (p0 != f.r) goto @423;
  @360:
    /*@366*/ if (v3 != f.a(12)) goto @408;
  @369:
    /*@370*/ f.c = 0;
    /*@374*/ f.d = 0;
    /*@378*/ f.e = 0;
    /*@382*/ f.h = 2;
    /*@389*/ v4 = f.t;
    /*@393*/ f.a(f.t, 0, 1);
    /*@402*/ f.t.a = f.i;
    /*@405*/ goto @423;
  @408:
    /*@409*/ f.d = 1;
    /*@412*/ f.a();
    /*@420*/ f.a(f.e, 1, 1);
  @423:
    /*@427*/ if (p0 != f.q) goto @491;
  @430:
    /*@437*/ f.f = e.y[(p1 * 2)];
    /*@449*/ f.g = e.y[((p1 * 2) + 1)];
    /*@455*/ var t6 = new byte[2];
    /*@458*/ t6[0] = 0;
    /*@462*/ t6[1] = 1;
    /*@464*/ f.a = t6;
    /*@468*/ f.h = t6.length;
    /*@475*/ v4 = f.t;
    /*@479*/ f.a(f.t, 0, 1);
    /*@488*/ f.t.a = f.i;
  @491:
    /*@497*/ if (f.b != f.p) goto @534;
  @500:
    /*@506*/ if (v3 != f.a(18)) goto @521;
  @509:
    /*@510*/ e.g = 1;
    /*@515*/ f.a(0, 0);
    /*@518*/ goto @534;
  @521:
    /*@526*/ if (v3 != f.a(2)) goto @534;
  @529:
    /*@531*/ f.s = 40;
  @534:
    /*@540*/ if (f.b != f.s) goto @597;
  @543:
    /*@544*/ if (p1 != 0) goto @551;
  @547:
    /*@548*/ { _phi_552_0 = 1; goto @552; }
  @551:
    _phi_552_0 = 0;
  @552: [stack=1: _phi_552_0]
    /*@552*/ f.h = _phi_552_0;
    /*@559*/ f.a(0);
    /*@565*/ this.a.j = null;
    /*@583*/ var t7 = f.a(f.a(88), f.a(99), null, null);
    /*@584*/ v4 = t7;
    /*@587*/ t7.e = 1;
    /*@594*/ f.a(v4, 1, 0);
  @597:
    /*@603*/ if (v3 != f.a(6)) goto @736;
  @606:
    /*@609*/ var t8 = new java.util.Vector;
    /*@610*/ t8.<init>();
    /*@614*/ v4 = t8;
    /*@619*/ if (f.f == 0) { _phi_627_0 = t8; goto @627; }
    _phi_622_0 = t8;
  @622: [stack=1: _phi_622_0]
    /*@624*/ { _phi_629_0 = _phi_622_0; _phi_629_1 = 31; goto @629; }
  @627: [stack=1: _phi_627_0]
    _phi_629_0 = _phi_627_0;
    _phi_629_1 = 32;
  @629: [stack=2: _phi_629_0, _phi_629_1]
    /*@632*/ _phi_629_0.addElement(f.a(_phi_629_1));
    /*@640*/ var t9 = new java.lang.StringBuffer;
    /*@641*/ t9.<init>();
    /*@660*/ if (f.h == 0) { _phi_668_0 = v4; _phi_668_1 = t9.append(f.a(43)).append(": "); goto @668; }
    _phi_663_0 = v4;
    _phi_663_1 = t9.append(f.a(43)).append(": ");
  @663: [stack=2: _phi_663_0, _phi_663_1]
    /*@665*/ { _phi_670_0 = _phi_663_0; _phi_670_1 = _phi_663_1; _phi_670_2 = 35; goto @670; }
  @668: [stack=2: _phi_668_0, _phi_668_1]
    _phi_670_0 = _phi_668_0;
    _phi_670_1 = _phi_668_1;
    _phi_670_2 = 36;
  @670: [stack=3: _phi_670_0, _phi_670_1, _phi_670_2]
    /*@679*/ _phi_670_0.addElement(_phi_670_1.append(f.a(_phi_670_2)).toString());
    /*@687*/ if (f.g == 0) { _phi_695_0 = v4; goto @695; }
    _phi_690_0 = v4;
  @690: [stack=1: _phi_690_0]
    /*@692*/ { _phi_697_0 = _phi_690_0; _phi_697_1 = 37; goto @697; }
  @695: [stack=1: _phi_695_0]
    _phi_697_0 = _phi_695_0;
    _phi_697_1 = 38;
  @697: [stack=2: _phi_697_0, _phi_697_1]
    /*@700*/ _phi_697_0.addElement(f.a(_phi_697_1));
    /*@706*/ var t10 = new g;
    /*@718*/ t10.<init>(f.a(6), f.a(v4), 1);
    /*@722*/ f.g = t10;
    /*@726*/ v4 = t10;
    /*@730*/ f.a(t10, 0, 1);
    /*@733*/ goto @753;
  @736:
    /*@742*/ if (v3 != f.a(7)) goto @753;
  @745:
    /*@750*/ f.a(f.k, 1, 1);
  @753:
    /*@757*/ if (p0 != f.d) goto @879;
  @760:
    /*@767*/ if (v3 != f.b[11]) goto @777;
  @770:
    /*@771*/ this.k();
    /*@774*/ goto @879;
  @777:
    /*@783*/ if (v3 != f.a(30)) goto @796;
  @786:
    /*@790*/ this.a.h();
    /*@793*/ goto @879;
  @796:
    /*@802*/ if (v3 != f.a(29)) goto @823;
  @805:
    /*@806*/ f.q = 1;
    /*@809*/ f.j();
    /*@817*/ f.a(f.l, 1, 1);
    /*@820*/ goto @879;
  @823:
    /*@829*/ if (v3 != f.a(18)) goto @853;
  @832:
    /*@836*/ v4 = f.o;
    /*@840*/ f.a(f.o, 0, 1);
    /*@847*/ f.b.a = 1;
    /*@850*/ goto @879;
  @853:
    /*@858*/ if (v3 != f.a(2)) goto @879;
  @861:
    /*@865*/ v4 = f.n;
    /*@869*/ f.a(f.n, 0, 1);
    /*@876*/ f.b.a = 1;
  @879:
    /*@883*/ if (p0 != f.n) goto @907;
  @886:
    /*@892*/ if (v3 != f.a(26)) goto @903;
  @895:
    /*@897*/ f.s = 40;
    /*@900*/ goto @907;
  @903:
    /*@904*/ this.k();
  @907:
    /*@911*/ if (p0 != f.o) goto @939;
  @914:
    /*@920*/ if (v3 != f.a(26)) goto @935;
  @923:
    /*@924*/ e.g = 1;
    /*@929*/ f.a(0, 0);
    /*@932*/ goto @939;
  @935:
    /*@936*/ this.k();
  @939:
    /*@943*/ if (p0 != f.t) goto @1070;
  @946:
    /*@947*/ f.i = p1;
    /*@954*/ if (f.c != 1) goto @1065;
  @957:
    /*@960*/ if (e.g != 0) goto @1065;
  @963:
    /*@966*/ var t11 = new java.lang.StringBuffer;
    /*@967*/ t11.<init>();
    /*@1031*/ v4 = t11.append(f.a(122)).append(f.a(((208 + f.f) + 1))).append("\n").append("").append(f.a(22)).append(": ").append(f.a((23 + f.i))).toString();
    /*@1045*/ var t12 = f.a(f.a(121), v4, null, null);
    /*@1046*/ v4 = t12;
    /*@1049*/ t12.e = 3;
    /*@1055*/ v4 = v4;
    /*@1059*/ f.a(v4, 0, 1);
    /*@1062*/ goto @1070;
  @1065:
    /*@1067*/ f.a(0, 0);
  @1070:
    /*@1074*/ if (p0 != f.l) goto @1152;
  @1077:
    /*@1080*/ if (f.q == 0) goto @1127;
  @1083:
    /*@1085*/ this.P = p1;
    /*@1096*/ if (f.a[this.P] == null) goto @1120;
  @1099:
    /*@1103*/ v4 = f.m;
    /*@1107*/ f.a(f.m, 0, 1);
    /*@1114*/ f.b.a = 1;
    /*@1117*/ goto @1152;
  @1120:
    /*@1121*/ this.l();
    /*@1124*/ goto @1152;
  @1127:
    /*@1132*/ if (f.a[p1] == null) goto @1152;
  @1135:
    /*@1137*/ f.a(0, 1);
    /*@1143*/ var t13 = new int[1];
    /*@1148*/ t13[0] = (p1 + 2);
    /*@1149*/ f.e = t13;
  @1152:
    /*@1156*/ if (p0 != f.m) goto @1176;
  @1159:
    /*@1165*/ if (v3 != f.a(26)) goto @1172;
  @1168:
    /*@1169*/ this.l();
  @1172:
    /*@1173*/ this.k();
  @1176:
    /*@1180*/ if (p0 != f.e) goto @1221;
  @1183:
    /*@1184*/ f.e = p1;
    /*@1190*/ if (p1 != 14) goto @1197;
  @1193:
    /*@1194*/ { _phi_1198_0 = 3; goto @1198; }
  @1197:
    _phi_1198_0 = 2;
  @1198: [stack=1: _phi_1198_0]
    /*@1198*/ f.h = _phi_1198_0;
    /*@1205*/ v4 = f.t;
    /*@1209*/ f.a(f.t, 0, 1);
    /*@1218*/ f.t.a = f.i;
  @1221:
    /*@1225*/ if (p0 != f.g) goto @1516;
  @1228:
    /*@1234*/ if (v3 != f.a(31)) goto @1258;
  @1237:
    /*@1238*/ f.f = 0;
    /*@1247*/ p0.a(f.a(32));
    /*@1254*/ c.a(1);
    /*@1255*/ goto @1516;
  @1258:
    /*@1264*/ if (v3 != f.a(32)) goto @1311;
  @1267:
    /*@1268*/ f.f = 1;
    /*@1277*/ p0.a(f.a(31));
    /*@1284*/ if (this.a != null) goto @1295;
  @1287:
    /*@1291*/ c.a(2);
    /*@1292*/ goto @1516;
  @1295:
    /*@1299*/ var t14 = new int[1];
    /*@1303*/ t14[0] = 12;
    /*@1307*/ c.a(3, t14);
    /*@1308*/ goto @1516;
  @1311:
    /*@1317*/ if (v3 != f.a(33)) goto @1336;
  @1320:
    /*@1321*/ f.n = 0;
    /*@1330*/ p0.a(f.a(34));
    /*@1333*/ goto @1516;
  @1336:
    /*@1342*/ if (v3 != f.a(34)) goto @1361;
  @1345:
    /*@1346*/ f.n = 1;
    /*@1355*/ p0.a(f.a(33));
    /*@1358*/ goto @1516;
  @1361:
    /*@1370*/ if (v3.endsWith(f.a(35)) == 0) goto @1415;
  @1373:
    /*@1374*/ f.h = 0;
    /*@1381*/ var t15 = new java.lang.StringBuffer;
    /*@1382*/ t15.<init>();
    /*@1409*/ p0.a(t15.append(f.a(43)).append(": ").append(f.a(36)).toString());
    /*@1412*/ goto @1516;
  @1415:
    /*@1424*/ if (v3.endsWith(f.a(36)) == 0) goto @1469;
  @1427:
    /*@1428*/ f.h = 1;
    /*@1435*/ var t16 = new java.lang.StringBuffer;
    /*@1436*/ t16.<init>();
    /*@1463*/ p0.a(t16.append(f.a(43)).append(": ").append(f.a(35)).toString());
    /*@1466*/ goto @1516;
  @1469:
    /*@1475*/ if (v3 != f.a(37)) goto @1494;
  @1478:
    /*@1479*/ f.g = 0;
    /*@1488*/ p0.a(f.a(38));
    /*@1491*/ goto @1516;
  @1494:
    /*@1500*/ if (v3 != f.a(38)) goto @1516;
  @1503:
    /*@1504*/ f.g = 1;
    /*@1513*/ p0.a(f.a(37));
  @1516:
    /*@1520*/ if (p0 != f.k) goto @1646;
  @1523:
    /*@1529*/ if (v3 != f.a(49)) goto @1601;
  @1532:
    /*@1535*/ var t17 = new java.lang.StringBuffer;
    /*@1536*/ t17.<init>();
    /*@1539*/ v4 = t17;
    /*@1543*/ p1 = 50;
  @1544:
    /*@1547*/ if (p1 > 55) goto @1591;
  @1550:
    /*@1554*/ var t18 = f.a(p1);
    /*@1555*/ v5 = t18;
    /*@1560*/ if (t18.length() <= 0) goto @1585;
  @1563:
    /*@1570*/ v4.append(v5);
    /*@1574*/ if (p1 >= 55) goto @1585;
  @1577:
    /*@1584*/ v4.append("\n\n");
  @1585:
    /*@1585*/ p1 += 1;
    /*@1588*/ goto @1544;
  @1591:
    /*@1596*/ v4 = v4.toString();
    /*@1598*/ goto @1630;
  @1601:
    /*@1603*/ if (p1 != 1) goto @1617;
  @1606:
    /*@1612*/ v4 = f.a(307);
    /*@1614*/ goto @1630;
  @1617:
    /*@1628*/ v4 = f.a(((40 + (p1 * 2)) + 2));
  @1630:
    /*@1638*/ var t19 = f.a(v3, v4, p0, null);
    /*@1639*/ v4 = t19;
    /*@1643*/ f.a(t19, 0, 1);
  @1646:
    /*@1650*/ if (p0 != f.u) goto @1910;
  @1653:
    /*@1663*/ if (v3.startsWith(f.a(298)) == 0) goto @1717;
  @1666:
    /*@1669*/ if (f.l != 0) goto @1676;
  @1672:
    /*@1673*/ { _phi_1677_0 = 1; goto @1677; }
  @1676:
    _phi_1677_0 = 0;
  @1677: [stack=1: _phi_1677_0]
    /*@1677*/ f.l = _phi_1677_0;
    /*@1684*/ var t20 = new java.lang.StringBuffer;
    /*@1685*/ t20.<init>();
    /*@1711*/ p0.a(t20.append(f.a(298)).append(": ").append(f.l).toString());
    /*@1714*/ goto @1910;
  @1717:
    /*@1727*/ if (v3.startsWith(f.a(299)) == 0) goto @1789;
  @1730:
    /*@1733*/ if (f.b != 0) goto @1740;
  @1736:
    /*@1737*/ { _phi_1741_0 = 1; goto @1741; }
  @1740:
    _phi_1741_0 = 0;
  @1741: [stack=1: _phi_1741_0]
    /*@1741*/ f.b = _phi_1741_0;
    /*@1748*/ var t21 = new java.lang.StringBuffer;
    /*@1749*/ t21.<init>();
    /*@1775*/ p0.a(t21.append(f.a(299)).append(": ").append(f.b).toString());
    /*@1783*/ this.a.a(0);
    /*@1786*/ goto @1910;
  @1789:
    /*@1796*/ if (v3 != f.a(300)) goto @1846;
  @1799:
    /*@1803*/ if (this.a == null) goto @1910;
  @1806:
    /*@1817*/ this.a.getClass();
    /*@1822*/ var t22 = new short[3];
    /*@1827*/ t22[0] = 500;
    /*@1833*/ t22[1] = 500;
    /*@1839*/ t22[2] = 500;
    /*@1840*/ this.a.a(0, t22);
    /*@1843*/ goto @1910;
  @1846:
    /*@1853*/ if (v3 != f.a(301)) goto @1910;
  @1856:
    /*@1860*/ if (this.a == null) goto @1910;
  @1863:
    /*@1864*/ v4 = 1;
  @1866:
    /*@1871*/ if (v4 >= f.h) goto @1910;
  @1874:
    /*@1883*/ var t23 = new short[3];
    /*@1888*/ t23[0] = 500;
    /*@1894*/ t23[1] = 500;
    /*@1900*/ t23[2] = 500;
    /*@1901*/ this.a.a(v4, t23);
    /*@1904*/ v4 += 1;
    /*@1907*/ goto @1866;
  @1910:
    /*@1913*/ if (d.a() == 0) goto @1985;
  @1916:
    /*@1923*/ if (v3 != f.a(303)) goto @1953;
  @1926:
    /*@1927*/ f.c = 0;
    /*@1931*/ f.d = 0;
    /*@1935*/ f.e = 0;
    /*@1939*/ f.h = 2;
    /*@1943*/ f.i = 0;
    /*@1947*/ d.a(3);
    /*@1950*/ goto @1969;
  @1953:
    /*@1961*/ if (v3 != ((String) d.a(0))) goto @1969;
  @1964:
    /*@1966*/ d.a(0, null);
  @1969:
    /*@1977*/ if (p0 != ((g) d.a(1))) goto @1985;
  @1980:
    /*@1982*/ d.a(1, v3);
  @1985:
    /*@1993*/ if (v3 != f.b[305]) goto @2023;
  @1996:
    /*@2000*/ if (f.O != 2) goto @2012;
  @2003:
    /*@2008*/ f.a(f.a("ms-upSellUrl"));
    /*@2011*/ return;
  @2012:
    /*@2016*/ v4 = f.j;
    /*@2020*/ f.a(f.j, 0, 1);
  @2023:
    /*@2023*/ return;
  }

  public static void a(String p0) {
    // try [4..10) catch (java.lang.Exception) -> @13
    /*@1*/ if (p0 == null) goto @18;
  @4:
    /*@9*/ c.a(0, p0);
    /*@10*/ goto @14;
  @13:
  @14:
    /*@15*/ f.d = 0;
  @18:
    /*@18*/ return;
  }

  private void l() {
    // try [88..94) catch (java.lang.Exception) -> @97
    /*@1*/ f.c(3);
    /*@11*/ v1 = this.a.a();
    /*@22*/ var t1 = new int[5];
    /*@27*/ t1[0] = f.c;
    /*@35*/ t1[1] = (f.e + 1);
    /*@41*/ t1[2] = v1[0];
    /*@47*/ t1[3] = v1[1];
    /*@53*/ t1[4] = v1[2];
    /*@54*/ f.a[this.P] = t1;
    /*@59*/ f.a(1);
    /*@64*/ this.a.b();
    /*@76*/ f.a((2 + this.P));
    /*@78*/ e.I = null;
    /*@81*/ f.j();
    /*@85*/ f.c(4);
    /*@91*/ java.lang.Thread.sleep(1000L);
    /*@94*/ goto @98;
  @97:
  @98:
    /*@98*/ f.p();
    /*@101*/ return;
  }

  public static g a(String p0, String p1, g p2, g p3) {
    /*@3*/ var t1 = new g;
    /*@16*/ t1.<init>(p0, f.a(p1, f.J, f.b), 2);
    /*@20*/ p0 = t1;
    /*@22*/ t1.b = p2;
    /*@27*/ p0.a = null;
    /*@31*/ return p0;
  }

  public final void commandAction(javax.microedition.lcdui.Command p0, javax.microedition.lcdui.Displayable p1) {
    /*@0*/ return;
  }

  public static boolean a(int p0) {
    // try [5..245) catch (java.lang.Exception) -> @248
    /*@2*/ v1 = "aoe3";
    /*@4*/ v2 = p0;
    /*@10*/ v1 = javax.microedition.rms.RecordStore.openRecordStore(v1, 1);
    /*@14*/ var t1 = new java.io.ByteArrayOutputStream;
    /*@15*/ t1.<init>();
    /*@18*/ v3 = t1;
    /*@22*/ var t2 = new java.io.DataOutputStream;
    /*@24*/ t2.<init>(v3);
    /*@27*/ v4 = t2;
    /*@30*/ if (v2 != 0) goto @92;
  @33:
    /*@38*/ v4.writeBoolean(f.i);
    /*@46*/ v4.writeBoolean(f.n);
    /*@54*/ v4.writeBoolean(f.h);
    /*@62*/ v4.writeBoolean(f.g);
    /*@70*/ v4.writeByte(f.i);
    /*@78*/ f.a(f.a, v4);
    /*@86*/ v4.writeByte(f.j);
    /*@89*/ goto @196;
  @92:
    /*@94*/ if (v2 != 1) goto @168;
  @97:
    /*@98*/ v2 = 0;
  @99:
    /*@101*/ if (v2 >= 3) goto @165;
  @104:
    /*@109*/ if (f.a[v2] == null) goto @116;
  @112:
    /*@113*/ { _phi_117_0 = 1; goto @117; }
  @116:
    _phi_117_0 = 0;
  @117: [stack=1: _phi_117_0]
    /*@117*/ v5 = _phi_117_0;
    /*@123*/ v4.writeBoolean(v5);
    /*@128*/ if (v5 == 0) goto @159;
  @131:
    /*@132*/ v5 = 0;
  @134:
    /*@137*/ if (v5 >= 5) goto @159;
  @140:
    /*@150*/ v4.writeInt(f.a[v2][v5]);
    /*@153*/ v5 += 1;
    /*@156*/ goto @134;
  @159:
    /*@159*/ v2 += 1;
    /*@162*/ goto @99;
  @165:
    /*@165*/ goto @196;
  @168:
    /*@170*/ if (v2 < 2) goto @196;
  @173:
    /*@176*/ if (e.I == null) goto @196;
  @179:
    /*@185*/ v4.writeShort(e.I.length);
    /*@193*/ v4.write(e.I);
  @196:
    /*@200*/ v2 = v3.toByteArray();
    /*@203*/ v4.close();
    /*@207*/ v3.close();
    /*@215*/ if (v1.getNumRecords() > p0) goto @230;
  @218:
    /*@226*/ v1.addRecord(v2, 0, v2.length);
    /*@227*/ goto @241;
  @230:
    /*@238*/ v1.setRecord((p0 + 1), v2, 0, v2.length);
  @241:
    /*@242*/ v1.closeRecordStore();
    /*@245*/ goto @251;
  @248:
    /*@250*/ return 0;
  @251:
    /*@252*/ return 1;
  }

  private static void b(int p0) {
    // try [5..202) catch (java.lang.Exception) -> @203
    /*@2*/ v1 = "aoe3";
    /*@4*/ v2 = p0;
    /*@10*/ var t1 = javax.microedition.rms.RecordStore.openRecordStore(v1, 1);
    /*@11*/ v1 = t1;
    /*@16*/ if (t1.getNumRecords() <= p0) goto @198;
  @19:
    /*@26*/ p0 = v1.getRecord((p0 + 1));
    /*@30*/ var t2 = new java.io.ByteArrayInputStream;
    /*@32*/ t2.<init>(p0);
    /*@35*/ p0 = t2;
    /*@39*/ var t3 = new java.io.DataInputStream;
    /*@41*/ t3.<init>(p0);
    /*@44*/ v3 = t3;
    /*@46*/ if (v2 != 0) goto @101;
  @49:
    /*@53*/ f.i = v3.readBoolean();
    /*@60*/ f.n = v3.readBoolean();
    /*@67*/ f.h = v3.readBoolean();
    /*@74*/ f.g = v3.readBoolean();
    /*@81*/ f.i = v3.readByte();
    /*@88*/ f.a = f.a(v3);
    /*@95*/ f.j = v3.readByte();
    /*@98*/ goto @190;
  @101:
    /*@103*/ if (v2 != 1) goto @167;
  @106:
    /*@107*/ v2 = 0;
  @108:
    /*@110*/ if (v2 >= 3) goto @164;
  @113:
    /*@117*/ var t4 = v3.readBoolean();
    /*@118*/ v4 = t4;
    /*@120*/ if (t4 == 0) goto @158;
  @123:
    /*@130*/ f.a[v2] = new int[5];
    /*@132*/ v4 = 0;
  @134:
    /*@137*/ if (v4 >= 5) goto @158;
  @140:
    /*@151*/ f.a[v2][v4] = v3.readInt();
    /*@152*/ v4 += 1;
    /*@155*/ goto @134;
  @158:
    /*@158*/ v2 += 1;
    /*@161*/ goto @108;
  @164:
    /*@164*/ goto @190;
  @167:
    /*@169*/ if (v2 < 2) goto @190;
  @172:
    /*@176*/ var t5 = v3.readShort();
    /*@177*/ v2 = t5;
    /*@180*/ e.I = new byte[t5];
    /*@187*/ v3.readFully(e.I);
  @190:
    /*@191*/ v3.close();
    /*@195*/ p0.close();
  @198:
    /*@199*/ v1.closeRecordStore();
    /*@202*/ return;
  @203:
    /*@204*/ return;
  }

  private static void c(String p0) {
    // try [0..59) catch (java.lang.Exception) -> @60
    /*@1*/ v1 = null;
    /*@3*/ v1 = null;
    /*@14*/ v1 = f.a.getClass().getResourceAsStream(p0);
    /*@18*/ var t1 = new java.io.DataInputStream;
    /*@20*/ t1.<init>(v1);
    /*@24*/ v1 = t1;
    /*@31*/ f.b = new String[t1.readInt()];
    /*@35*/ p0 = 0;
  @36:
    /*@41*/ if (p0 >= f.b.length) goto @59;
  @44:
    /*@52*/ f.b[p0] = v1.readUTF();
    /*@53*/ p0 += 1;
    /*@56*/ goto @36;
  @59:
    /*@59*/ return;
  @60:
    /*@61*/ return;
  }

  public static String a(int p0) {
    /*@5*/ if (p0 >= f.b.length) goto @14;
  @8:
    /*@13*/ return f.b[p0];
  @14:
    /*@15*/ return null;
  }

  public static String a(int p0, String[] p1) {
    /*@3*/ var t1 = new java.lang.String;
    /*@8*/ t1.<init>(f.a(p0));
    /*@11*/ p0 = t1;
    /*@15*/ if (p1.length != 1) goto @31;
  @18:
    /*@27*/ p0 = f.a(p0, "%U", p1[0]);
    /*@28*/ goto @55;
  @31:
    /*@32*/ v2 = 0;
  @33:
    /*@36*/ if (v2 >= p1.length) goto @55;
  @39:
    /*@48*/ p0 = f.a(p0, "%U", p1[v2]);
    /*@49*/ v2 += 1;
    /*@52*/ goto @33;
  @55:
    /*@56*/ return p0;
  }

  private static String a(String p0, String p1, String p2) {
    /*@1*/ v3 = null;
    /*@3*/ v3 = 0;
    /*@9*/ var t1 = p0.indexOf(p1);
    /*@10*/ v3 = t1;
    /*@12*/ if (t1 == -1) goto @55;
  @15:
    /*@18*/ var t2 = new java.lang.StringBuffer;
    /*@19*/ t2.<init>();
    /*@51*/ v3 = t2.append(p0.substring(0, v3)).append(p2).append(p0.substring((v3 + p1.length()))).toString();
    /*@52*/ goto @57;
  @55:
    /*@56*/ v3 = p0;
  @57:
    /*@58*/ return v3;
  }

  public static String[] a(String p0, int p1, int p2) {
    /*@3*/ var t1 = new java.util.Vector;
    /*@4*/ t1.<init>();
    /*@7*/ v3 = t1;
    /*@9*/ v4 = 0;
    /*@15*/ v5 = p0.length();
    /*@18*/ v6 = null;
  @20:
    /*@22*/ v8 = v4;
    /*@32*/ v9 = p0.indexOf(10, v8);
  @34:
    /*@36*/ v10 = v8;
    /*@40*/ v7 = v6;
    /*@48*/ v8 = f.a(p0, v8);
    /*@53*/ if (v9 <= -1) goto @67;
  @56:
    /*@60*/ if (v9 >= v8) goto @67;
  @63:
    /*@65*/ v8 = v9;
  @67:
    /*@78*/ v6 = p0.substring(v4, v8).trim();
    /*@87*/ if (l.a(p2, v6) <= p1) goto @165;
  @90:
    /*@94*/ if (v10 != v4) goto @154;
  @97:
    /*@104*/ v4 = (v6.length() - 1);
  @106:
    /*@108*/ if (v4 <= 0) goto @151;
  @111:
    /*@119*/ v7 = v6.substring(0, v4);
    /*@128*/ if (l.a(p2, v7) > p1) goto @145;
  @131:
    /*@136*/ v8 = (v10 + v4);
    /*@140*/ v6 = v7;
    /*@142*/ goto @185;
  @145:
    /*@145*/ v4 -= 1;
    /*@148*/ goto @106;
  @151:
    /*@151*/ goto @185;
  @154:
    /*@156*/ v8 = v10;
    /*@160*/ v6 = v7;
    /*@162*/ goto @185;
  @165:
    /*@169*/ if (v8 != v9) goto @178;
  @172:
    /*@172*/ v8 += 1;
    /*@175*/ goto @185;
  @178:
    /*@182*/ if (v8 < v5) goto @34;
  @185:
    /*@188*/ v3.addElement(v6);
    /*@194*/ v4 = v8;
    /*@198*/ if (v8 >= v5) goto @204;
  @201:
    /*@201*/ goto @20;
  @204:
    /*@211*/ v8 = new String[v3.size()];
    /*@216*/ v3.copyInto(v8);
    /*@221*/ return v8;
  }

  private static int a(String p0, int p1) {
    /*@5*/ var t1 = p0.charAt(p1);
    /*@6*/ v2 = t1;
    /*@10*/ if (f.d(t1) == 0) goto @17;
  @13:
    /*@16*/ return (p1 + 1);
  @17:
    /*@18*/ v2 = 0;
  @19:
    /*@26*/ var t2 = p0.indexOf(32, p1);
    /*@27*/ v3 = t2;
    /*@28*/ if (t2 != 0) goto @37;
  @31:
    /*@31*/ p1 += 1;
    /*@34*/ goto @19;
  @37:
    /*@38*/ v2 = v3;
    /*@39*/ goto @42;
  @42:
    /*@44*/ if (v2 != -1) goto @55;
  @47:
    /*@51*/ v2 = p0.length();
    /*@52*/ goto @58;
  @55:
    /*@55*/ v2 += 1;
  @58:
    /*@61*/ v3 = (p1 + 1);
  @62:
    /*@64*/ if (v3 >= v2) goto @86;
  @67:
    /*@75*/ if (f.d(p0.charAt(v3)) == 0) goto @80;
  @78:
    /*@79*/ return v3;
  @80:
    /*@80*/ v3 += 1;
    /*@83*/ goto @62;
  @86:
    /*@87*/ return v2;
  }

  private static boolean d(int p0) {
    /*@4*/ if (p0 < 11904) goto @13;
  @7:
    /*@10*/ if (p0 < 44032) goto @37;
  @13:
    /*@16*/ if (p0 < 63744) goto @25;
  @19:
    /*@22*/ if (p0 < 64256) goto @37;
  @25:
    /*@28*/ if (p0 < 65280) goto @39;
  @31:
    /*@34*/ if (p0 >= 65504) goto @39;
  @37:
    /*@38*/ return 1;
  @39:
    /*@40*/ return 0;
  }

  public static String a(String p0) {
    /*@7*/ var t1 = f.a.getAppProperty(p0);
    /*@8*/ p0 = t1;
    /*@9*/ if (t1 == null) goto @17;
  @12:
    /*@16*/ return p0.trim();
  @17:
    /*@18*/ return null;
  }

  public static int c(int p0) {
    /*@8*/ return (f.a.nextInt() % p0);
  }

  public static int d(int p0) {
    /*@11*/ return java.lang.Math.abs((f.a.nextInt() % p0));
  }

  public static boolean b(int p0) {
    /*@3*/ if (f.S != 0) goto @52;
  @6:
    /*@7*/ p0 = p0;
    /*@13*/ if ((f.Q & p0) == 0) goto @20;
  @16:
    /*@17*/ { _phi_21_0 = 1; goto @21; }
  @20:
    _phi_21_0 = 0;
  @21: [stack=1: _phi_21_0]
    /*@22*/ p0 = _phi_21_0;
    /*@23*/ if (_phi_21_0 == 0) goto @50;
  @26:
    /*@29*/ if (f.r == 0) goto @45;
  @32:
    /*@35*/ f.S = 400;
    /*@39*/ f.r = 0;
    /*@42*/ goto @50;
  @45:
    /*@47*/ f.S = 80;
  @50:
    /*@51*/ return p0;
  @52:
    /*@53*/ return 0;
  }

  public static boolean c(int p0) {
    /*@5*/ if ((f.R & p0) == 0) goto @14;
  @8:
    /*@9*/ f.R = 0;
    /*@13*/ return 1;
  @14:
    /*@15*/ return 0;
  }

  private static boolean b() {
    /*@3*/ if (f.R == 0) goto @12;
  @6:
    /*@7*/ f.R = 0;
    /*@11*/ return 1;
  @12:
    /*@13*/ return 0;
  }

  public static void b() {
    /*@1*/ f.Q = 0;
    /*@5*/ f.R = 0;
    /*@9*/ f.S = 0;
    /*@13*/ f.r = 0;
    /*@16*/ return;
  }

  public final synchronized void keyPressed(int p0) {
    // try [0..30) catch (java.lang.Exception) -> @31
    /*@5*/ this = this.b(p0);
    /*@11*/ f.Q = (f.Q | this);
    /*@15*/ f.p = this;
    /*@23*/ f.R = (f.R | this);
    /*@27*/ f.r = 1;
    /*@30*/ return;
  @31:
    /*@32*/ return;
  }

  public final synchronized void keyReleased(int p0) {
    // try [0..24) catch (java.lang.Exception) -> @25
    /*@5*/ this = this.b(p0);
    /*@13*/ f.Q = (f.Q & (this ^ -1));
    /*@17*/ f.S = 0;
    /*@21*/ f.r = 0;
    /*@24*/ return;
  @25:
    /*@26*/ return;
  }

  private static void m() {
    /*@1*/ f.o = 1;
    /*@7*/ f.a.repaint();
    /*@13*/ f.a.serviceRepaints();
  @16:
    /*@19*/ if (f.o == 0) goto @28;
  @22:
    /*@22*/ java.lang.Thread.yield();
    /*@25*/ goto @16;
  @28:
    /*@28*/ return;
  }

  public static byte[] a(byte[] p0, byte[] p1) {
    /*@2*/ v2 = 37;
    /*@4*/ v3 = 0;
  @5:
    /*@10*/ if (v3 >= (p0.length - 4)) goto @62;
  @13:
    /*@18*/ if (p0[v3] != 80) goto @56;
  @21:
    /*@28*/ if (p0[(v3 + 1)] != 76) goto @56;
  @31:
    /*@38*/ if (p0[(v3 + 2)] != 84) goto @56;
  @41:
    /*@48*/ if (p0[(v3 + 3)] != 69) goto @56;
  @51:
    /*@52*/ v2 = v3;
    /*@53*/ goto @62;
  @56:
    /*@56*/ v3 += 1;
    /*@59*/ goto @5;
  @62:
    /*@65*/ v3 = (v2 - 4);
    /*@112*/ v2 = (((((p0[v3] & 255) << 24) | ((p0[(v3 + 1)] & 255) << 16)) | ((p0[(v3 + 2)] & 255) << 8)) | (p0[(v3 + 3)] & 255));
    /*@113*/ v2 += 12;
    /*@125*/ v4 = new byte[((p0.length - v2) + p1.length)];
    /*@133*/ java.lang.System.arraycopy(p0, 0, v4, 0, v3);
    /*@143*/ java.lang.System.arraycopy(p1, 0, v4, v3, p1.length);
    /*@162*/ java.lang.System.arraycopy(p0, (v3 + v2), v4, (v3 + p1.length), (p0.length - (v3 + v2)));
    /*@167*/ return v4;
  }

  public static int a(int p0, int p1) {
    /*@7*/ if (f.a[0] != 100) goto @12;
  @10:
    /*@11*/ return p1;
  @12:
    /*@22*/ return ((f.a[0] * p1) / 100);
  }

  public static int[] a(int[] p0, int[] p1, boolean p2) {
    /*@1*/ if (p2 == 0) goto @13;
  @4:
    /*@6*/ if (p0.length <= 0) goto @13;
  @9:
    /*@10*/ { _phi_14_0 = 1; goto @14; }
  @13:
    _phi_14_0 = 0;
  @14: [stack=1: _phi_14_0]
    /*@14*/ p2 = _phi_14_0;
    /*@16*/ v3 = p0;
    /*@24*/ v4 = new int[(p0.length + p1.length)];
    /*@27*/ if (p2 == 0) goto @44;
  @30:
    /*@38*/ java.lang.System.arraycopy(v3, 0, v4, p1.length, v3.length);
    /*@41*/ goto @54;
  @44:
    /*@51*/ java.lang.System.arraycopy(v3, 0, v4, 0, v3.length);
  @54:
    /*@55*/ v3 = 0;
  @56:
    /*@59*/ if (v3 >= p1.length) goto @92;
  @62:
    /*@63*/ if (p2 == 0) goto @76;
  @66:
    /*@72*/ v4[v3] = p1[v3];
    /*@73*/ goto @86;
  @76:
    /*@85*/ v4[(p0.length + v3)] = p1[v3];
  @86:
    /*@86*/ v3 += 1;
    /*@89*/ goto @56;
  @92:
    /*@94*/ return v4;
  }

  public static int[] a(int[] p0, int p1, boolean p2) {
    /*@6*/ p2 = new int[(p0.length - p1)];
    /*@13*/ java.lang.System.arraycopy(p0, p1, p2, 0, p2.length);
    /*@17*/ return p2;
  }

  public static int[] a(int[] p0, int p1, int p2) {
    /*@3*/ v3 = new int[p1];
    /*@10*/ java.lang.System.arraycopy(p0, 0, v3, 0, v3.length);
    /*@25*/ v4 = new int[java.lang.Math.max(0, ((p0.length - p2) - 1))];
    /*@37*/ java.lang.System.arraycopy(p0, (p2 + 1), v4, 0, v4.length);
    /*@50*/ p0 = new int[((p0.length - (p2 - p1)) - 1)];
    /*@57*/ java.lang.System.arraycopy(v3, 0, p0, 0, v3.length);
    /*@69*/ java.lang.System.arraycopy(v4, 0, p0, v3.length, v4.length);
    /*@73*/ return p0;
  }

  public static int[] a(java.util.Vector p0) {
    /*@6*/ v1 = new int[p0.size()];
    /*@8*/ v2 = 0;
  @9:
    /*@12*/ if (v2 >= v1.length) goto @35;
  @15:
    /*@28*/ v1[v2] = ((Integer) p0.elementAt(v2)).intValue();
    /*@29*/ v2 += 1;
    /*@32*/ goto @9;
  @35:
    /*@36*/ return v1;
  }

  private static String[] a(java.util.Vector p0) {
    /*@7*/ v1 = new String[p0.size()];
    /*@9*/ v2 = 0;
  @10:
    /*@13*/ if (v2 >= v1.length) goto @33;
  @16:
    /*@26*/ v1[v2] = ((String) p0.elementAt(v2));
    /*@27*/ v2 += 1;
    /*@30*/ goto @10;
  @33:
    /*@34*/ return v1;
  }

  private static void n() {
    /*@3*/ if (f.c == null) goto @10;
  @6:
    /*@7*/ f.c = null;
  @10:
    /*@11*/ f.c(1);
    /*@14*/ return;
  }

  private static void o() {
    /*@11*/ var t1 = f.a((50 + f.d(6)));
    /*@12*/ v0 = t1;
    /*@16*/ if (t1.length() == 0) goto @0;
  @19:
    /*@33*/ f.c = f.a(v0, (360 - f.k), f.b);
    /*@37*/ f.c(1);
    /*@40*/ return;
  }

  private static void c(int p0) {
    /*@5*/ c.a(1, null);
    /*@7*/ f.T = p0;
    /*@11*/ f.U = 0;
    /*@15*/ f.V = 0;
    /*@18*/ f.m();
    /*@21*/ return;
  }

  public static void a(int p0) {
    /*@2*/ f.a(p0, 0);
    /*@5*/ return;
  }

  public static void a(int p0, boolean p1) {
    /*@1*/ if (p1 != 0) goto @10;
  @4:
    /*@7*/ f.V = f.U;
  @10:
    /*@11*/ f.U = p0;
    /*@15*/ if (p1 == 0) goto @24;
  @18:
    /*@21*/ f.V = f.U;
  @24:
    /*@24*/ f.m();
    /*@27*/ return;
  }

  public static void c() {
    /*@6*/ if (f.V >= f.U) goto @20;
  @9:
    /*@14*/ f.V = (f.V + 1);
    /*@17*/ f.m();
  @20:
    /*@20*/ return;
  }

  private static void p() {
    /*@3*/ if (f.c == null) goto @13;
  @6:
    /*@7*/ f.T = 2;
    /*@10*/ goto @17;
  @13:
    /*@14*/ f.T = 0;
  @17:
    /*@17*/ f.b();
    /*@20*/ h.a();
    /*@27*/ return;
  }

  public static int b(int p0, int p1) {
    /*@1*/ if (p0 >= 0) goto @11;
  @4:
    /*@10*/ return java.lang.Math.max(p0, (-p1));
  @11:
    /*@12*/ if (p0 <= 0) goto @21;
  @15:
    /*@20*/ return java.lang.Math.min(p0, p1);
  @21:
    /*@22*/ return p0;
  }

  public static String a(String p0, int p1) {
    /*@5*/ if (p0.length() >= 2) goto @48;
  @8:
    /*@14*/ p1 = (2 - p0.length());
    /*@16*/ v2 = 0;
  @17:
    /*@19*/ if (v2 >= p1) goto @48;
  @22:
    /*@25*/ var t1 = new java.lang.StringBuffer;
    /*@26*/ t1.<init>();
    /*@41*/ p0 = t1.append("0").append(p0).toString();
    /*@42*/ v2 += 1;
    /*@45*/ goto @17;
  @48:
    /*@49*/ return p0;
  }

  public static byte[] a(java.io.DataInputStream p0) {
    /*@5*/ return f.a(p0, 0);
  }

  public static byte[] a(java.io.DataInputStream p0, boolean p1) {
    /*@1*/ if (p1 == 0) goto @11;
  @4:
    /*@8*/ { _phi_15_0 = p0.readShort(); goto @15; }
  @11:
    _phi_15_0 = p0.readByte();
  @15: [stack=1: _phi_15_0]
    /*@16*/ p1 = _phi_15_0;
    /*@19*/ v2 = new byte[_phi_15_0];
    /*@21*/ v3 = 0;
  @22:
    /*@24*/ if (v3 >= p1) goto @40;
  @27:
    /*@33*/ v2[v3] = p0.readByte();
    /*@34*/ v3 += 1;
    /*@37*/ goto @22;
  @40:
    /*@41*/ return v2;
  }

  public static byte[][] a(java.io.DataInputStream p0) {
    /*@4*/ var t1 = p0.readByte();
    /*@5*/ v1 = t1;
    /*@9*/ v2 = new [B[t1];
    /*@11*/ v3 = 0;
  @12:
    /*@14*/ if (v3 >= v1) goto @66;
  @17:
    /*@21*/ var t2 = p0.readByte();
    /*@22*/ v4 = t2;
    /*@24*/ if (t2 <= 0) goto @60;
  @27:
    /*@33*/ v2[v3] = new byte[v4];
    /*@35*/ v5 = 0;
  @37:
    /*@41*/ if (v5 >= v4) goto @60;
  @44:
    /*@53*/ v2[v3][v5] = p0.readByte();
    /*@54*/ v5 += 1;
    /*@57*/ goto @37;
  @60:
    /*@60*/ v3 += 1;
    /*@63*/ goto @12;
  @66:
    /*@67*/ return v2;
  }

  public static int[] a(java.io.DataInputStream p0) {
    /*@4*/ var t1 = p0.readInt();
    /*@5*/ v1 = t1;
    /*@8*/ v2 = new int[t1];
    /*@10*/ v3 = 0;
  @11:
    /*@13*/ if (v3 >= v1) goto @29;
  @16:
    /*@22*/ v2[v3] = p0.readInt();
    /*@23*/ v3 += 1;
    /*@26*/ goto @11;
  @29:
    /*@30*/ return v2;
  }

  public static short[] a(java.io.DataInputStream p0) {
    /*@4*/ var t1 = p0.readShort();
    /*@5*/ v1 = t1;
    /*@8*/ v2 = new short[t1];
    /*@10*/ v3 = 0;
  @11:
    /*@13*/ if (v3 >= v1) goto @29;
  @16:
    /*@22*/ v2[v3] = p0.readShort();
    /*@23*/ v3 += 1;
    /*@26*/ goto @11;
  @29:
    /*@30*/ return v2;
  }

  public static short[][] a(java.io.DataInputStream p0) {
    /*@4*/ var t1 = p0.readShort();
    /*@5*/ v1 = t1;
    /*@9*/ v2 = new [S[t1];
    /*@11*/ v3 = 0;
  @12:
    /*@14*/ if (v3 >= v1) goto @66;
  @17:
    /*@21*/ var t2 = p0.readShort();
    /*@22*/ v4 = t2;
    /*@24*/ if (t2 <= 0) goto @60;
  @27:
    /*@33*/ v2[v3] = new short[v4];
    /*@35*/ v5 = 0;
  @37:
    /*@41*/ if (v5 >= v4) goto @60;
  @44:
    /*@53*/ v2[v3][v5] = p0.readShort();
    /*@54*/ v5 += 1;
    /*@57*/ goto @37;
  @60:
    /*@60*/ v3 += 1;
    /*@63*/ goto @12;
  @66:
    /*@67*/ return v2;
  }

  public static int[][] a(java.io.DataInputStream p0) {
    /*@4*/ var t1 = p0.readInt();
    /*@5*/ v1 = t1;
    /*@9*/ v2 = new [I[t1];
    /*@11*/ v3 = 0;
  @12:
    /*@14*/ if (v3 >= v1) goto @66;
  @17:
    /*@21*/ var t2 = p0.readInt();
    /*@22*/ v4 = t2;
    /*@24*/ if (t2 <= 0) goto @60;
  @27:
    /*@33*/ v2[v3] = new int[v4];
    /*@35*/ v5 = 0;
  @37:
    /*@41*/ if (v5 >= v4) goto @60;
  @44:
    /*@53*/ v2[v3][v5] = p0.readInt();
    /*@54*/ v5 += 1;
    /*@57*/ goto @37;
  @60:
    /*@60*/ v3 += 1;
    /*@63*/ goto @12;
  @66:
    /*@67*/ return v2;
  }

  public static int a(byte[] p0, int p1) {
    /*@1*/ v2 = 0;
  @2:
    /*@5*/ if (v2 >= p0.length) goto @27;
  @8:
    /*@12*/ if (p1 != p0[v2]) goto @21;
  @15:
    /*@20*/ return p0[(v2 + 1)];
  @21:
    /*@21*/ v2 += 2;
    /*@24*/ goto @2;
  @27:
    /*@28*/ return -1;
  }

  public static short a(short[] p0, int p1) {
    /*@1*/ v2 = 0;
  @2:
    /*@5*/ if (v2 >= p0.length) goto @27;
  @8:
    /*@12*/ if (p1 != p0[v2]) goto @21;
  @15:
    /*@20*/ return p0[(v2 + 1)];
  @21:
    /*@21*/ v2 += 2;
    /*@24*/ goto @2;
  @27:
    /*@28*/ return -1;
  }

  public static int b(byte[] p0, int p1) {
    /*@1*/ v2 = 0;
  @2:
    /*@5*/ if (v2 >= p0.length) goto @23;
  @8:
    /*@12*/ if (p1 != p0[v2]) goto @17;
  @15:
    /*@16*/ return v2;
  @17:
    /*@17*/ v2 += 1;
    /*@20*/ goto @2;
  @23:
    /*@24*/ return -1;
  }

  public static int c(int p0, int p1) {
    /*@7*/ return ((p0 >> 4) * (p1 >> 4));
  }

  public static int d(int p0, int p1) {
    /*@4*/ if ((p1 >> 8) != 0) goto @12;
  @7:
    /*@8*/ p0 = p0;
    /*@9*/ goto @19;
  @12:
    /*@18*/ p0 = ((p0 << 8) / p1);
  @19:
    /*@20*/ return p0;
  }

  public static void a(int[] p0, java.io.DataOutputStream p1) {
    /*@1*/ if (p0 != null) goto @10;
  @4:
    /*@6*/ p1.writeByte(-1);
    /*@9*/ return;
  @10:
    /*@13*/ p1.writeByte(p0.length);
    /*@17*/ v2 = 0;
  @18:
    /*@21*/ if (v2 >= p0.length) goto @37;
  @24:
    /*@28*/ p1.writeInt(p0[v2]);
    /*@31*/ v2 += 1;
    /*@34*/ goto @18;
  @37:
    /*@37*/ return;
  }

  public static void a(short[] p0, java.io.DataOutputStream p1) {
    /*@1*/ if (p0 != null) goto @10;
  @4:
    /*@6*/ p1.writeByte(-1);
    /*@9*/ return;
  @10:
    /*@13*/ p1.writeByte(p0.length);
    /*@17*/ v2 = 0;
  @18:
    /*@21*/ if (v2 >= p0.length) goto @37;
  @24:
    /*@28*/ p1.writeShort(p0[v2]);
    /*@31*/ v2 += 1;
    /*@34*/ goto @18;
  @37:
    /*@37*/ return;
  }

  public static void a(int[][] p0, java.io.DataOutputStream p1) {
    /*@1*/ if (p0 != null) goto @10;
  @4:
    /*@6*/ p1.writeByte(-1);
    /*@9*/ return;
  @10:
    /*@13*/ p1.writeByte(p0.length);
    /*@17*/ v2 = 0;
  @18:
    /*@21*/ if (v2 >= p0.length) goto @51;
  @24:
    /*@27*/ if (p0[v2] != null) goto @38;
  @30:
    /*@32*/ p1.writeByte(-1);
    /*@35*/ goto @45;
  @38:
    /*@42*/ f.a(p0[v2], p1);
  @45:
    /*@45*/ v2 += 1;
    /*@48*/ goto @18;
  @51:
    /*@51*/ return;
  }

  public static void a(boolean[] p0, java.io.DataOutputStream p1) {
    /*@1*/ if (p0 != null) goto @10;
  @4:
    /*@6*/ p1.writeShort(-1);
    /*@9*/ return;
  @10:
    /*@13*/ p1.writeShort(p0.length);
    /*@17*/ v2 = 0;
  @18:
    /*@21*/ if (v2 >= p0.length) goto @37;
  @24:
    /*@28*/ p1.writeBoolean(p0[v2]);
    /*@31*/ v2 += 1;
    /*@34*/ goto @18;
  @37:
    /*@37*/ return;
  }

  public static void a(b[] p0, java.io.DataOutputStream p1) {
    /*@1*/ if (p0 != null) goto @10;
  @4:
    /*@6*/ p1.writeByte(-1);
    /*@9*/ return;
  @10:
    /*@13*/ p1.writeByte(p0.length);
    /*@17*/ v2 = 0;
  @18:
    /*@21*/ if (v2 >= p0.length) goto @50;
  @24:
    /*@28*/ if (p0[v2] != null) { _phi_35_0 = p1; goto @35; }
    _phi_31_0 = p1;
  @31: [stack=1: _phi_31_0]
    /*@32*/ { _phi_41_0 = _phi_31_0; _phi_41_1 = -1; goto @41; }
  @35: [stack=1: _phi_35_0]
    _phi_41_0 = _phi_35_0;
    _phi_41_1 = p0[v2].b;
  @41: [stack=2: _phi_41_0, _phi_41_1]
    /*@41*/ _phi_41_0.writeShort(_phi_41_1);
    /*@44*/ v2 += 1;
    /*@47*/ goto @18;
  @50:
    /*@50*/ return;
  }

  public static int[] b(java.io.DataInputStream p0) {
    /*@4*/ var t1 = p0.readByte();
    /*@5*/ v1 = t1;
    /*@7*/ if (t1 != -1) goto @12;
  @10:
    /*@11*/ return null;
  @12:
    /*@15*/ v2 = new int[v1];
    /*@17*/ v3 = 0;
  @18:
    /*@20*/ if (v3 >= v1) goto @36;
  @23:
    /*@29*/ v2[v3] = p0.readInt();
    /*@30*/ v3 += 1;
    /*@33*/ goto @18;
  @36:
    /*@37*/ return v2;
  }

  public static short[] b(java.io.DataInputStream p0) {
    /*@4*/ var t1 = p0.readByte();
    /*@5*/ v1 = t1;
    /*@7*/ if (t1 != -1) goto @12;
  @10:
    /*@11*/ return null;
  @12:
    /*@15*/ v2 = new short[v1];
    /*@17*/ v3 = 0;
  @18:
    /*@20*/ if (v3 >= v1) goto @36;
  @23:
    /*@29*/ v2[v3] = p0.readShort();
    /*@30*/ v3 += 1;
    /*@33*/ goto @18;
  @36:
    /*@37*/ return v2;
  }

  public static int[][] b(java.io.DataInputStream p0) {
    /*@4*/ var t1 = p0.readByte();
    /*@5*/ v1 = t1;
    /*@7*/ if (t1 != -1) goto @12;
  @10:
    /*@11*/ return null;
  @12:
    /*@16*/ v2 = new [I[v1];
    /*@18*/ v3 = 0;
  @19:
    /*@21*/ if (v3 >= v1) goto @74;
  @24:
    /*@28*/ var t2 = p0.readByte();
    /*@29*/ v4 = t2;
    /*@32*/ if (t2 == -1) goto @68;
  @35:
    /*@41*/ v2[v3] = new int[v4];
    /*@43*/ v5 = 0;
  @45:
    /*@49*/ if (v5 >= v4) goto @68;
  @52:
    /*@61*/ v2[v3][v5] = p0.readInt();
    /*@62*/ v5 += 1;
    /*@65*/ goto @45;
  @68:
    /*@68*/ v3 += 1;
    /*@71*/ goto @19;
  @74:
    /*@75*/ return v2;
  }

  public static boolean[] a(java.io.DataInputStream p0) {
    /*@4*/ var t1 = p0.readShort();
    /*@5*/ v1 = t1;
    /*@7*/ if (t1 != -1) goto @12;
  @10:
    /*@11*/ return null;
  @12:
    /*@15*/ v2 = new boolean[v1];
    /*@17*/ v3 = 0;
  @18:
    /*@20*/ if (v3 >= v1) goto @36;
  @23:
    /*@29*/ v2[v3] = p0.readBoolean();
    /*@30*/ v3 += 1;
    /*@33*/ goto @18;
  @36:
    /*@37*/ return v2;
  }

  public static b[] a(java.io.DataInputStream p0) {
    /*@4*/ var t1 = p0.readByte();
    /*@5*/ v1 = t1;
    /*@7*/ if (t1 != -1) goto @12;
  @10:
    /*@11*/ return null;
  @12:
    /*@16*/ v2 = new b[v1];
    /*@18*/ v3 = 0;
  @19:
    /*@21*/ if (v3 >= v1) goto @54;
  @24:
    /*@28*/ var t2 = p0.readShort();
    /*@29*/ v4 = t2;
    /*@32*/ if (t2 == -1) goto @48;
  @35:
    /*@40*/ var t3 = new b;
    /*@44*/ t3.<init>(v4, 0);
    /*@47*/ v2[v3] = t3;
  @48:
    /*@48*/ v3 += 1;
    /*@51*/ goto @19;
  @54:
    /*@55*/ return v2;
  }

  public static void a(byte[] p0, java.io.DataOutputStream p1) {
    /*@1*/ if (p0 != null) goto @10;
  @4:
    /*@6*/ p1.writeShort(-1);
    /*@9*/ return;
  @10:
    /*@13*/ p1.writeShort(p0.length);
    /*@18*/ p1.write(p0);
    /*@21*/ return;
  }

  public static byte[] b(java.io.DataInputStream p0) {
    /*@4*/ var t1 = p0.readShort();
    /*@5*/ v1 = t1;
    /*@7*/ if (t1 != -1) goto @12;
  @10:
    /*@11*/ return null;
  @12:
    /*@15*/ v1 = new byte[v1];
    /*@18*/ p0.readFully(v1);
    /*@22*/ return v1;
  }

  public static void a(boolean p0, int p1) {
    /*@1*/ f.W = 0;
    /*@5*/ f.n = 2;
    /*@9*/ f.X = p1;
    /*@12*/ return;
  }

  public static void b(boolean p0) {
    /*@1*/ f.W = 0;
    /*@5*/ f.n = 1;
    /*@9*/ f.X = -1;
    /*@12*/ return;
  }

  public static boolean a() {
    /*@3*/ if (f.n == 0) goto @8;
  @6:
    /*@7*/ return 1;
  @8:
    /*@9*/ return 0;
  }

  public static void b(javax.microedition.lcdui.Graphics p0, int p1, int p2, int p3, int p4, int p5) {
    /*@8*/ c.a(p0, p5, p1, p2, p3, p4);
    /*@11*/ return;
  }

  public static void a(javax.microedition.lcdui.Graphics p0, int p1, int p2, int p3, int p4) {
    /*@1*/ f.b(p0);
    /*@12*/ p0.setClip(0, 0, 360, p4);
    /*@15*/ return;
  }

  private static void b(javax.microedition.lcdui.Graphics p0) {
    /*@4*/ f.Y = p0.getClipX();
    /*@11*/ f.Z = p0.getClipY();
    /*@18*/ f.aa = p0.getClipWidth();
    /*@25*/ f.ab = p0.getClipHeight();
    /*@28*/ return;
  }

  public static void a(javax.microedition.lcdui.Graphics p0) {
    /*@13*/ p0.setClip(f.Y, f.Z, f.aa, f.ab);
    /*@16*/ return;
  }

  private static void d(int p0) {
    /*@1*/ if (p0 == 0) goto @12;
  @4:
    /*@6*/ if (p0 != 2) goto @81;
  @9:
    /*@9*/ goto @81;
  @12:
    /*@16*/ f.e = new k[4];
    /*@22*/ var t1 = new k;
    /*@25*/ t1.<init>(44);
    /*@32*/ v1 = t1.a(2);
    /*@40*/ f.e[0] = v1[0];
    /*@48*/ var t2 = new k;
    /*@53*/ t2.<init>(v1[0], 2);
    /*@56*/ f.e[1] = t2;
    /*@64*/ f.e[2] = v1[1];
    /*@72*/ var t3 = new k;
    /*@77*/ t3.<init>(v1[1], 2);
    /*@80*/ f.e[3] = t3;
  @81:
    /*@83*/ if (p0 != 2) goto @94;
  @86:
    /*@89*/ v1 = 50;
    /*@91*/ f.a(50, 0);
  @94:
    /*@96*/ if (p0 == 1) goto @104;
  @99:
    /*@101*/ if (p0 != 2) goto @116;
  @104:
    /*@107*/ var t4 = new k;
    /*@110*/ t4.<init>(46);
    /*@113*/ f.c = t4;
  @116:
    /*@118*/ if (p0 != 2) goto @127;
  @121:
    /*@124*/ f.a(100, 1);
  @127:
    /*@127*/ return;
  }

  static void <clinit>() {
    /*@3*/ var t1 = new char[3];
    /*@7*/ t1[0] = 67;
    /*@12*/ t1[1] = 100;
    /*@18*/ t1[2] = 150;
    /*@19*/ f.a = t1;
    /*@26*/ var t2 = new int[13];
    /*@29*/ t2[0] = 4;
    /*@34*/ t2[1] = 8;
    /*@38*/ t2[2] = 4;
    /*@42*/ t2[3] = 4;
    /*@47*/ t2[4] = 8;
    /*@52*/ t2[5] = 8;
    /*@57*/ t2[6] = 4;
    /*@62*/ t2[7] = 4;
    /*@67*/ t2[8] = 4;
    /*@73*/ t2[9] = 8;
    /*@79*/ t2[10] = 8;
    /*@85*/ t2[11] = 8;
    /*@92*/ t2[12] = 16384;
    /*@93*/ f.f = t2;
    /*@97*/ f.a = -1;
    /*@101*/ f.n = 0;
    /*@105*/ f.f = 1;
    /*@109*/ f.g = 1;
    /*@113*/ f.h = 1;
    /*@117*/ f.i = 1;
    /*@123*/ var t3 = new java.util.Random;
    /*@124*/ t3.<init>();
    /*@127*/ f.a = t3;
    /*@131*/ f.b = 0;
    /*@135*/ f.s = -1;
    /*@141*/ f.a = new boolean[2];
    /*@145*/ f.j = 0;
    /*@157*/ f.M = java.lang.Math.max(1, f.a(0, 2));
    /*@164*/ f.a = new [I[3];
    /*@167*/ return;
  }

}
