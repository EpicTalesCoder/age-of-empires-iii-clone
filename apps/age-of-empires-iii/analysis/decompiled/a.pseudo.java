public final class a {
  private static int[] a;
  private static int[] b;
  private static javax.microedition.media.Player a;

  public void <init>() {
    /*@1*/ this.<init>();
    /*@4*/ return;
  }

  public static void a(int p0) {
    // try [38..135) catch (java.lang.Exception) -> @136
    /*@6*/ p0 = a.b[p0];
    /*@8*/ if (a.b[p0] != -1) goto @12;
  @11:
    /*@11*/ return;
  @12:
    /*@18*/ if (a.a[p0] == 5) goto @25;
  @21:
    /*@22*/ f.a = p0;
  @25:
    /*@28*/ if (f.f == 0) goto @37;
  @31:
    /*@34*/ if (f.e == 0) goto @38;
  @37:
    /*@37*/ return;
  @38:
    /*@38*/ a.a();
    /*@44*/ var t1 = new java.io.ByteArrayInputStream;
    /*@53*/ t1.<init>(h.a(a.a[p0]));
    /*@61*/ var t2 = javax.microedition.media.Manager.createPlayer(t1, "audio/midi");
    /*@62*/ a.a = t2;
    /*@65*/ t2.realize();
    /*@73*/ a.a.prefetch();
    /*@87*/ if (a.a[p0] != 5) { _phi_94_0 = a.a; goto @94; }
    _phi_90_0 = a.a;
  @90: [stack=1: _phi_90_0]
    /*@91*/ { _phi_95_0 = _phi_90_0; _phi_95_1 = 1; goto @95; }
  @94: [stack=1: _phi_94_0]
    _phi_95_0 = _phi_94_0;
    _phi_95_1 = -1;
  @95: [stack=2: _phi_95_0, _phi_95_1]
    /*@95*/ _phi_95_0.setLoopCount(_phi_95_1);
    /*@113*/ var t3 = ((javax.microedition.media.control.VolumeControl) a.a.getControl("VolumeControl"));
    /*@114*/ p0 = t3;
    /*@115*/ if (t3 == null) goto @127;
  @118:
    /*@126*/ p0.setLevel(50);
  @127:
    /*@130*/ a.a.start();
    /*@135*/ return;
  @136:
    /*@137*/ return;
  }

  public static void a() {
    // try [0..26) catch (java.lang.Exception) -> @27
    /*@3*/ if (a.a == null) goto @26;
  @6:
    /*@9*/ a.a.stop();
    /*@17*/ a.a.close();
    /*@23*/ a.a = null;
  @26:
    /*@26*/ return;
  @27:
    /*@28*/ return;
  }

  public static boolean a() {
    /*@3*/ v0 = f.a;
    /*@7*/ if (f.f == 0) goto @31;
  @10:
    /*@12*/ if (v0 == -1) goto @31;
  @15:
    /*@18*/ if (a.b() != 0) goto @31;
  @21:
    /*@23*/ v0 = v0;
    /*@24*/ a.a(v0);
    /*@30*/ return a.b();
  @31:
    /*@32*/ return 1;
  }

  private static boolean b() {
    /*@3*/ if (a.a == null) goto @22;
  @6:
    /*@17*/ if (a.a.getState() != 400) goto @22;
  @20:
    /*@21*/ return 1;
  @22:
    /*@23*/ return 0;
  }

  static void <clinit>() {
    /*@3*/ var t1 = new int[4];
    /*@6*/ t1[0] = 4;
    /*@10*/ t1[1] = 2;
    /*@14*/ t1[2] = 3;
    /*@18*/ t1[3] = 5;
    /*@19*/ a.a = t1;
    /*@26*/ var t2 = new int[13];
    /*@29*/ t2[0] = 0;
    /*@33*/ t2[1] = 1;
    /*@37*/ t2[2] = 2;
    /*@41*/ t2[3] = 1;
    /*@45*/ t2[4] = -1;
    /*@49*/ t2[5] = -1;
    /*@54*/ t2[6] = -1;
    /*@59*/ t2[7] = -1;
    /*@64*/ t2[8] = -1;
    /*@69*/ t2[9] = -1;
    /*@74*/ t2[10] = -1;
    /*@79*/ t2[11] = -1;
    /*@84*/ t2[12] = 3;
    /*@85*/ a.b = t2;
    /*@88*/ return;
  }

}
