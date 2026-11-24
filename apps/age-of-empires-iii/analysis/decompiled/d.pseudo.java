public final class d {
  private static int a;
  private static String a;
  private static int b;

  public void <init>() {
    /*@1*/ this.<init>();
    /*@4*/ return;
  }

  public static void a(int p0) {
    /*@2*/ d.a = p0;
    /*@6*/ if (p0 != 1) goto @63;
  @9:
    /*@14*/ var t1 = f.a("ms-demoMode");
    /*@15*/ p0 = t1;
    /*@16*/ if (t1 == null) goto @29;
  @19:
    /*@26*/ d.b = java.lang.Integer.valueOf(p0).intValue();
  @29:
    /*@34*/ d.a = f.a("ms-demoUrl");
    /*@42*/ var t2 = h.a("demo.png");
    /*@43*/ p0 = t2;
    /*@44*/ if (t2 == null) goto @58;
  @47:
    /*@50*/ var t3 = new k;
    /*@52*/ t3.<init>(p0);
    /*@55*/ { _phi_59_0 = t3; goto @59; }
  @58:
    _phi_59_0 = null;
  @59: [stack=1: _phi_59_0]
    /*@59*/ f.b = _phi_59_0;
    /*@62*/ return;
  @63:
    /*@67*/ if (d.a != 3) goto @130;
  @70:
    /*@74*/ var t4 = new java.lang.StringBuffer;
    /*@75*/ t4.<init>();
    /*@121*/ var t5 = f.a(null, t4.append(f.a(1)).append("\n").append(f.a(302)).append("\n\n").append(f.a(329)).toString(), null, null);
    /*@122*/ p0 = t5;
    /*@124*/ t5.f = 2;
    /*@127*/ goto @201;
  @130:
    /*@134*/ if (d.a == 4) goto @144;
  @137:
    /*@141*/ if (d.a != -1) goto @205;
  @144:
    /*@145*/ f.b = null;
    /*@158*/ if (d.b != 2) { _phi_167_0 = f.a(304); goto @167; }
    _phi_161_0 = f.a(304);
  @161: [stack=1: _phi_161_0]
    /*@164*/ { _phi_170_0 = _phi_161_0; _phi_170_1 = 327; goto @170; }
  @167: [stack=1: _phi_167_0]
    _phi_170_0 = _phi_167_0;
    _phi_170_1 = 328;
  @170: [stack=2: _phi_170_0, _phi_170_1]
    /*@180*/ p0 = f.a(_phi_170_0, f.a(_phi_170_1), f.c, null);
    /*@185*/ if (d.b != 2) goto @196;
  @188:
    /*@190*/ p0.f = 3;
    /*@193*/ goto @201;
  @196:
    /*@198*/ p0.f = 0;
  @201:
    /*@202*/ f.a(p0);
  @205:
    /*@205*/ return;
  }

  public static void b(int p0) {
    /*@2*/ if (p0 != 2) goto @11;
  @5:
    /*@7*/ f.a(0, 0);
    /*@10*/ return;
  @11:
    /*@13*/ if (p0 != 3) goto @22;
  @16:
    /*@19*/ f.a(d.a);
  @22:
    /*@22*/ return;
  }

  public static boolean a() {
    /*@3*/ if (d.b == 0) goto @8;
  @6:
    /*@7*/ return 1;
  @8:
    /*@9*/ return 0;
  }

  public static Object a(int p0) {
    /*@1*/ switch (p0) { 0->@20, default->@27 }
  @20:
    /*@26*/ return f.a(330);
  @27:
    /*@28*/ return null;
  }

  public static void a(int p0, String p1) {
    /*@1*/ switch (p0) { 0->@28, 1->@77, default->@108 }
  @28:
    /*@32*/ if (d.b != 1) goto @63;
  @35:
    /*@52*/ var t1 = f.a(f.a(330), f.a(327), null, null);
    /*@53*/ p0 = t1;
    /*@55*/ t1.f = 1;
    /*@59*/ f.a(p0);
    /*@62*/ return;
  @63:
    /*@67*/ if (d.b != 2) goto @108;
  @70:
    /*@73*/ f.a(d.a);
    /*@76*/ return;
  @77:
    /*@83*/ if (p1 != f.a(26)) goto @93;
  @86:
    /*@89*/ f.a(d.a);
    /*@92*/ return;
  @93:
    /*@99*/ if (p1 != f.a(27)) goto @108;
  @102:
    /*@105*/ f.a(f.c);
  @108:
    /*@108*/ return;
  }

}
