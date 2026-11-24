public final class k {
  public javax.microedition.lcdui.Image a;
  private int a;
  private int b;
  private int c;
  public short a;
  public short b;

  public void <init>() {
    /*@1*/ this.<init>();
    /*@6*/ this.a = 0;
    /*@9*/ return;
  }

  public void <init>(byte[] p0) {
    /*@1*/ this.<init>();
    /*@6*/ this.a = 0;
    /*@11*/ this.a(p0);
    /*@14*/ return;
  }

  public void <init>(int p0) {
    /*@1*/ this.<init>();
    /*@6*/ this.a = 0;
    /*@14*/ this.a(h.a(p0));
    /*@17*/ return;
  }

  private void a(byte[] p0) {
    // try [0..35) catch (java.lang.Exception) -> @36
    /*@8*/ this.a = javax.microedition.lcdui.Image.createImage(p0, 0, p0.length);
    /*@20*/ this.a = ((short) this.a.getWidth());
    /*@32*/ this.b = ((short) this.a.getHeight());
    /*@35*/ return;
  @36:
    /*@37*/ return;
  }

  public void <init>(k p0, int p1, int p2, int p3, int p4) {
    /*@1*/ this.<init>();
    /*@6*/ this.a = 0;
    /*@13*/ this.a = ((short) p3);
    /*@20*/ this.b = ((short) p4);
    /*@28*/ this.a = p0.a;
    /*@33*/ this.b = p1;
    /*@38*/ this.c = p2;
    /*@41*/ return;
  }

  public void <init>(k p0, int p1) {
    /*@1*/ this.<init>();
    /*@6*/ this.a = 0;
    /*@14*/ this.a = p0.a;
    /*@22*/ this.a = p0.a;
    /*@30*/ this.b = p0.b;
    /*@38*/ this.b = p0.b;
    /*@46*/ this.c = p0.c;
    /*@51*/ this.a = p1;
    /*@54*/ return;
  }

  public final k[] a(int p0) {
    /*@6*/ p0 = (this.a / p0);
    /*@11*/ v2 = this.b;
    /*@15*/ v2 = v2;
    /*@16*/ p0 = p0;
    /*@18*/ this = this;
    /*@24*/ v3 = (this.a / p0);
    /*@31*/ var t1 = (this.b / v2);
    /*@32*/ v4 = t1;
    /*@39*/ v5 = new k[(t1 * v3)];
    /*@42*/ v6 = 0;
    /*@45*/ v7 = 0;
  @47:
    /*@51*/ if (v7 >= v4) goto @101;
  @54:
    /*@55*/ v8 = 0;
  @57:
    /*@60*/ if (v8 >= v3) goto @95;
  @63:
    /*@67*/ v6 += 1;
    /*@73*/ var t2 = new k;
    /*@85*/ t2.<init>(this, (v8 * p0), (v7 * v2), p0, v2);
    /*@88*/ v5[v6] = t2;
    /*@89*/ v8 += 1;
    /*@92*/ goto @57;
  @95:
    /*@95*/ v7 += 1;
    /*@98*/ goto @47;
  @101:
    /*@103*/ return v5;
  }

  public final void a(javax.microedition.lcdui.Graphics p0, int p1, int p2) {
    /*@6*/ this.a(p0, p1, p2, 20);
    /*@9*/ return;
  }

  public final void a(javax.microedition.lcdui.Graphics p0, int p1, int p2, int p3) {
    /*@29*/ p0.drawRegion(this.a, this.b, this.c, this.a, this.b, this.a, p1, p2, p3);
    /*@32*/ return;
  }

  public final void a(javax.microedition.lcdui.Graphics p0, int p1, int p2, int p3, int p4) {
    /*@27*/ p0.drawRegion(this.a, this.b, this.c, this.a, this.b, p3, p1, p2, p4);
    /*@30*/ return;
  }

}
