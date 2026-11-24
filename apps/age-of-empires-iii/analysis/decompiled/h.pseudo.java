public final class h {

  public void <init>() {
    /*@1*/ this.<init>();
    /*@4*/ return;
  }

  public static byte[] a(int p0) {
    // try [31..59) catch (java.lang.Exception) -> @62
    /*@3*/ java.lang.System.out.println();
    /*@6*/ f.c();
    /*@11*/ if (p0 != -1) goto @16;
  @14:
    /*@15*/ return null;
  @16:
    /*@20*/ v1 = (p0 & 65535);
    /*@28*/ p0 = ((p0 >> 16) & 65535);
    /*@30*/ v2 = null;
    /*@32*/ if (p0 != 0) goto @59;
  @35:
    /*@38*/ var t1 = new java.lang.StringBuffer;
    /*@39*/ t1.<init>();
    /*@58*/ v2 = h.a(t1.append(v1).append(".res").toString(), 1);
  @59:
    /*@59*/ goto @63;
  @62:
  @63:
    /*@64*/ return v2;
  }

  public static byte[] a(String p0) {
    /*@5*/ return h.a(p0, 0);
  }

  private static byte[] a(String p0, boolean p1) {
    // try [0..77) catch (java.lang.Exception) -> @78
    /*@3*/ var t1 = new java.io.ByteArrayOutputStream;
    /*@4*/ t1.<init>();
    /*@7*/ v2 = t1;
    /*@17*/ var t2 = new java.lang.StringBuffer;
    /*@18*/ t2.<init>();
    /*@36*/ p0 = f.a.getClass().getResourceAsStream(t2.append("/").append(p0).toString());
    /*@38*/ if (p1 == 0) goto @49;
  @41:
  @49:
    /*@50*/ p1 = 0;
  @51:
    /*@55*/ var t3 = p0.read();
    /*@56*/ p1 = t3;
    /*@58*/ if (t3 == -1) goto @69;
  @61:
    /*@63*/ v2.write(p1);
    /*@66*/ goto @51;
  @69:
    /*@70*/ p0.close();
    /*@77*/ return v2.toByteArray();
  @78:
    /*@80*/ return null;
  }

  public static void a() {
    /*@0*/ goto @3;
  @3:
    /*@3*/ java.lang.System.gc();
    /*@6*/ return;
  }

  static void <clinit>() {
    /*@0*/ return;
  }

}
