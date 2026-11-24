public class Main extends javax.microedition.midlet.MIDlet {
  private f a;

  public void <init>() {
    /*@1*/ this.<init>();
    /*@8*/ var t1 = new f;
    /*@10*/ t1.<init>(this);
    /*@13*/ this.a = t1;
    /*@16*/ return;
  }

  protected void startApp() {
    /*@0*/ return;
  }

  protected void pauseApp() {
    /*@4*/ if (this.a == null) goto @11;
  @7:
    /*@8*/ f.c = 1;
  @11:
    /*@11*/ return;
  }

  protected void destroyApp(boolean p0) {
    /*@4*/ f.a(0);
    /*@6*/ f.d = 0;
    /*@9*/ return;
  }

}
