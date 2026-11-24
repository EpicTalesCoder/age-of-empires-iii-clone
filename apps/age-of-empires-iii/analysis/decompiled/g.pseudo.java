public final class g {
  public g a;
  public g b;
  public String a;
  public String[] a;
  public int a;
  public int b;
  public int c;
  public int d;
  public int e;
  public int f;

  public void <init>(String p0, String[] p1, int p2) {
    /*@1*/ this.<init>();
    /*@6*/ this.c = 3;
    /*@11*/ this.e = -1;
    /*@16*/ this.f = -1;
    /*@21*/ this.a = p0;
    /*@26*/ this.a = p1;
    /*@31*/ this.b = p2;
    /*@34*/ return;
  }

  public final void a(String p0) {
    /*@9*/ this.a[this.a] = p0;
    /*@10*/ return;
  }

  public final void a(int p0) {
    /*@2*/ this.a = p0;
    /*@10*/ if (p0 >= this.d) goto @19;
  @13:
    /*@15*/ this.d = p0;
    /*@18*/ return;
  @19:
    /*@30*/ if (p0 <= ((this.d + f.m) - 1)) goto @48;
  @33:
    /*@45*/ this.d = java.lang.Math.max(0, ((p0 - f.m) + 1));
  @48:
    /*@48*/ return;
  }

}
