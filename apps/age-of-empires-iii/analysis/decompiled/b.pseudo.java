public final class b {
  public static int a;
  public int b;
  public int c;
  public int d;
  public int e;
  public int f;
  public int g;
  public int h;
  public int i;
  public int j;
  public boolean a;
  public static e a;
  public boolean b;
  public byte[] a;
  public int[] a;
  public int[][] a;
  public boolean[] a;
  public b[] a;
  public int k;
  private int m;
  private int n;
  private int o;
  public int l;
  public boolean c;

  public void <init>(int p0, int p1) {
    /*@1*/ this.<init>();
    /*@6*/ this.i = -1;
    /*@11*/ this.j = -1;
    /*@16*/ this.k = -1;
    /*@21*/ this.m = -1;
    /*@26*/ this.n = -1;
    /*@31*/ this.o = -1;
    /*@36*/ this.b = p0;
    /*@41*/ this.d = p1;
    /*@45*/ this.g();
    /*@48*/ return;
  }

  public void <init>(int p0) {
    /*@1*/ this.<init>();
    /*@6*/ this.i = -1;
    /*@11*/ this.j = -1;
    /*@16*/ this.k = -1;
    /*@21*/ this.m = -1;
    /*@26*/ this.n = -1;
    /*@31*/ this.o = -1;
    /*@41*/ b.a = (b.a + 1);
    /*@44*/ this.b = b.a;
    /*@49*/ this.d = p0;
    /*@53*/ this.g();
    /*@56*/ return;
  }

  public void <init>(int p0, int p1, int p2) {
    /*@2*/ this.<init>(p0);
    /*@14*/ p1 = (p2 << 8);
    /*@15*/ p0 = (p1 << 8);
    /*@17*/ this = this;
    /*@19*/ this.e(p0);
    /*@24*/ this.f(p1);
    /*@27*/ return;
  }

  public final byte[] a() {
    // try [0..189) catch (java.lang.Exception) -> @190
    /*@3*/ var t1 = new java.io.ByteArrayOutputStream;
    /*@4*/ t1.<init>();
    /*@7*/ v1 = t1;
    /*@11*/ var t2 = new java.io.DataOutputStream;
    /*@13*/ t2.<init>(v1);
    /*@17*/ v2 = t2;
    /*@22*/ t2.writeShort(this.b);
    /*@30*/ v2.writeByte(this.d);
    /*@38*/ v2.writeByte(this.c);
    /*@46*/ v2.writeInt(this.e);
    /*@54*/ v2.writeInt(this.f);
    /*@62*/ v2.writeInt(this.g);
    /*@70*/ v2.writeInt(this.h);
    /*@78*/ v2.writeShort(this.i);
    /*@86*/ v2.writeShort(this.j);
    /*@94*/ v2.writeBoolean(this.b);
    /*@102*/ v2.writeByte(this.k);
    /*@110*/ v2.writeByte(this.m);
    /*@118*/ v2.writeByte(this.l);
    /*@126*/ v2.writeByte(this.n);
    /*@134*/ v2.writeByte(this.o);
    /*@142*/ v2.writeBoolean(this.c);
    /*@150*/ f.a(this.a, v2);
    /*@158*/ f.a(this.a, v2);
    /*@166*/ f.a(this.a, v2);
    /*@174*/ f.a(this.a, v2);
    /*@182*/ f.a(this.a, v2);
    /*@189*/ return v1.toByteArray();
  @190:
    /*@192*/ return null;
  }

  public static b a(java.io.DataInputStream p0) {
    // try [0..173) catch (java.lang.Exception) -> @174
    /*@4*/ v1 = p0.readShort();
    /*@9*/ v2 = p0.readByte();
    /*@13*/ var t1 = new b;
    /*@16*/ t1.<init>(v1, v2);
    /*@20*/ v1 = t1;
    /*@25*/ t1.c = p0.readByte();
    /*@33*/ v1.e = p0.readInt();
    /*@41*/ v1.f = p0.readInt();
    /*@49*/ v1.g = p0.readInt();
    /*@57*/ v1.h = p0.readInt();
    /*@65*/ v1.i = p0.readShort();
    /*@73*/ v1.j = p0.readShort();
    /*@81*/ v1.b = p0.readBoolean();
    /*@89*/ v1.k = p0.readByte();
    /*@97*/ v1.m = p0.readByte();
    /*@105*/ v1.l = p0.readByte();
    /*@113*/ v1.n = p0.readByte();
    /*@121*/ v1.o = p0.readByte();
    /*@129*/ v1.c = p0.readBoolean();
    /*@137*/ v1.a = f.b(p0);
    /*@145*/ v1.a = f.b(p0);
    /*@153*/ v1.a = f.b(p0);
    /*@161*/ v1.a = f.a(p0);
    /*@169*/ v1.a = f.a(p0);
    /*@173*/ return v1;
  @174:
    /*@176*/ return null;
  }

  public static b a(int p0, int p1, int p2, int p3) {
    /*@3*/ var t1 = new b;
    /*@13*/ t1.<init>(2, (p3 * 48), (p2 * 48));
    /*@17*/ p2 = t1;
    /*@25*/ t1.a[12] = ((byte) p0);
    /*@33*/ p2.a[0] = ((byte) p1);
    /*@35*/ p3 = p1;
    /*@39*/ if (p0 != 7) goto @45;
  @42:
    /*@42*/ p3 += 3;
  @45:
    /*@52*/ p2.f(e.n[p0], p3);
    /*@62*/ p2.a[16] = -1;
    /*@70*/ p2.a[17] = -1;
    /*@78*/ p2.a[19] = -1;
    /*@86*/ p2.a[14] = -1;
    /*@94*/ p2.a[15] = -1;
    /*@101*/ p2.a[4] = -1;
    /*@108*/ p2.a[1] = -1;
    /*@116*/ b.a.getClass();
    /*@117*/ if (p1 == 0) goto @127;
  @120:
    /*@126*/ p2.a[1] = 1;
  @127:
    /*@136*/ p2.a[0] = p2.b();
    /*@138*/ return p2;
  }

  public static b a(int p0, int p1) {
    /*@3*/ var t1 = new b;
    /*@5*/ t1.<init>(3);
    /*@9*/ v2 = t1;
    /*@16*/ t1.a[4] = ((byte) p0);
    /*@24*/ v2.a[0] = ((byte) p1);
    /*@30*/ if (e.c[p0] == null) goto @42;
  @33:
    /*@41*/ v2.a[0] = new int[0];
  @42:
    /*@48*/ v2.a[1] = -1;
    /*@50*/ return v2;
  }

  public final void a(int p0, int p1) {
    /*@6*/ v3 = this.a[4];
    /*@10*/ if (e.e != 0) goto @35;
  @13:
    /*@21*/ this.e(((p1 * 48) << 8));
    /*@32*/ this.f(((p0 * 48) << 8));
  @35:
    /*@39*/ this.b();
    /*@41*/ v4 = p0;
    /*@44*/ v5 = p1;
    /*@50*/ v6 = e.a(v3);
    /*@53*/ v7 = 0;
  @55:
    /*@60*/ if (v7 >= v6.length) goto @179;
  @63:
    /*@70*/ v8 = (p0 + v6[v7]);
    /*@81*/ v9 = (p1 + v6[(v7 + 1)]);
    /*@90*/ b.a.getClass();
    /*@95*/ if (this.c(0) == 0) goto @112;
  @98:
    /*@109*/ b.a.a(2, 1, v8, v9, 1, 0);
  @112:
    /*@121*/ b.a.a(v8, v9, 33);
    /*@135*/ b.a.a(1, 0, v8, v9, 1, 0);
    /*@152*/ b.a.a(512, 9, v8, v9, 1, 0);
    /*@162*/ v4 = java.lang.Math.max(v4, v8);
    /*@171*/ v5 = java.lang.Math.max(v5, v9);
    /*@173*/ v7 += 3;
    /*@176*/ goto @55;
  @179:
    /*@187*/ this.a[5] = ((byte) v4);
    /*@197*/ this.a[6] = ((byte) v5);
    /*@201*/ if (e.e != 0) goto @253;
  @204:
    /*@213*/ v7 = (p0 + e.o[(v3 * 2)]);
    /*@226*/ v8 = (p1 + e.o[((v3 * 2) + 1)]);
    /*@237*/ this.a[7] = ((byte) v7);
    /*@247*/ this.a[8] = ((byte) v8);
    /*@250*/ this.c = 0;
  @253:
    /*@257*/ b.a.f = 1;
    /*@260*/ return;
  }

  public final void a(boolean p0) {
    /*@2*/ v2 = this;
    /*@8*/ v2 = this.a[0];
    /*@11*/ v3 = 1;
    /*@13*/ v3 = this;
    /*@20*/ v4 = this.a[4];
    /*@25*/ v5 = e.a(this.a[4]);
    /*@28*/ v6 = 0;
  @30:
    /*@35*/ if (v6 >= v5.length) goto @123;
  @38:
    /*@48*/ v7 = (v3.i + v5[v6]);
    /*@62*/ v8 = (v3.j + v5[(v6 + 1)]);
    /*@71*/ v9 = v5[(v6 + 2)];
    /*@80*/ b.a.getClass();
    /*@85*/ if (v3.c(0) == 0) goto @105;
  @88:
    /*@102*/ b.a.a(v7, v8, e.p[v4], 1);
  @105:
    /*@114*/ b.a.a(v7, v8, v9);
    /*@117*/ v6 += 3;
    /*@120*/ goto @30;
  @123:
    /*@126*/ if (e.e != 0) goto @259;
  @129:
    /*@139*/ if (e.q[this.a[4]] <= 0) goto @150;
  @142:
    /*@149*/ this.a[3] = 60;
  @150:
    /*@152*/ this.c = 1;
    /*@156*/ if (p0 == 0) goto @237;
  @159:
    /*@166*/ b.a.getClass();
    /*@167*/ if (v2 != 0) goto @210;
  @170:
    /*@180*/ var t1 = new String[1];
    /*@195*/ t1[0] = b.a.b(v2, this.a[4]);
    /*@207*/ b.a.a(f.a(144, t1), this.i, this.j);
  @210:
    /*@217*/ b.a.getClass();
    /*@218*/ if (v2 != 0) goto @259;
  @221:
    /*@233*/ b.a.i[1] = ((short) (b.a.i[1] + 1));
    /*@234*/ goto @259;
  @237:
    /*@240*/ if (e.e != 0) goto @259;
  @243:
    /*@258*/ this.a[0] = e.f[this.a[4]];
  @259:
    /*@266*/ if (this.a[4] != 1) goto @325;
  @269:
    /*@275*/ b.a.c(v2, 10);
    /*@286*/ b.a.a[v2] = 1;
    /*@294*/ b.a.getClass();
    /*@295*/ if (v2 != 0) goto @343;
  @298:
    /*@304*/ if (b.a.a == 0) goto @343;
  @307:
    /*@313*/ if (b.a.a != 0) goto @343;
  @316:
    /*@319*/ b.a.k();
    /*@322*/ goto @343;
  @325:
    /*@332*/ if (this.a[4] != 2) goto @343;
  @335:
    /*@340*/ b.a.c(v2, 5);
  @343:
    /*@350*/ b.a.getClass();
    /*@351*/ if (v2 == 0) goto @366;
  @354:
    /*@363*/ b.a.a[v2].a(this);
  @366:
    /*@383*/ b.a.G[this.a[4]] = ((byte) (b.a.G[this.a[4]] + 1));
    /*@399*/ this.a[9] = ((byte) (25 + f.d(15)));
    /*@400*/ return;
  }

  public final boolean a() {
    /*@7*/ v1 = this.a[4];
    /*@11*/ v1 = e.a(this.a[4]);
    /*@13*/ v2 = 0;
  @14:
    /*@17*/ if (v2 >= v1.length) goto @66;
  @20:
    /*@28*/ v3 = (this.i + v1[v2]);
    /*@39*/ v4 = (this.j + v1[(v2 + 1)]);
    /*@55*/ if (b.a.a(508, 2, v3, v4, 0) == 0) goto @60;
  @58:
    /*@59*/ return 1;
  @60:
    /*@60*/ v2 += 3;
    /*@63*/ goto @14;
  @66:
    /*@67*/ return 0;
  }

  public final boolean a(int p0) {
    /*@5*/ v2 = e.a[p0];
    /*@12*/ v3 = e.r[p0];
    /*@14*/ if (e.r[p0] == 2) goto @22;
  @17:
    /*@19*/ if (v3 != 4) goto @67;
  @22:
    /*@27*/ v4 = this;
    /*@35*/ b.a.b(this.a[0], v2);
    /*@52*/ var t1 = new int[2];
    /*@55*/ t1[0] = p0;
    /*@59*/ t1[1] = 1;
    /*@64*/ this.a[0] = f.a(this.a[0], t1, 0);
    /*@66*/ return 1;
  @67:
    /*@75*/ v4 = this;
    /*@91*/ v4 = this;
    /*@99*/ if (b.a.a[this.a[0]] >= b.a.b[this.a[0]]) goto @256;
  @102:
    /*@107*/ v4 = this;
    /*@115*/ b.a.b(this.a[0], v2);
    /*@123*/ v4 = this;
    /*@131*/ b.a.b(this.a[0], 1);
    /*@135*/ v2 = 0;
    /*@137*/ v4 = 0;
  @139:
    /*@148*/ if (v4 >= this.a[0].length) goto @223;
  @151:
    /*@161*/ if (this.a[0][v4] != p0) goto @217;
  @164:
    /*@165*/ if (v3 != 0) goto @212;
  @168:
    /*@172*/ v5 = (p0 - 8);
    /*@185*/ var t2 = this.a[0][(v4 + 1)];
    /*@186*/ v6 = t2;
    /*@194*/ if (t2 == e.m[v5]) goto @217;
  @197:
    /*@211*/ this.a[0][(v4 + 1)] = (this.a[0][(v4 + 1)] + 1);
  @212:
    /*@213*/ v2 = 1;
    /*@214*/ goto @223;
  @217:
    /*@217*/ v4 += 2;
    /*@220*/ goto @139;
  @223:
    /*@224*/ if (v2 != 0) goto @254;
  @227:
    /*@241*/ var t3 = new int[2];
    /*@244*/ t3[0] = p0;
    /*@248*/ t3[1] = 1;
    /*@253*/ this.a[0] = f.a(this.a[0], t3, 0);
  @254:
    /*@255*/ return 1;
  @256:
    /*@263*/ b.a.getClass();
    /*@268*/ if (this.b(0) == 0) goto @283;
  @271:
    /*@280*/ b.a.a(f.a(135));
  @283:
    /*@284*/ return 0;
  }

  public final void b(int p0, int p1) {
    /*@13*/ if (this.a[0][((p0 * 2) + 1)] != p1) goto @51;
  @16:
    /*@38*/ this.a[0] = f.a(this.a[0], (p0 * 2), ((p0 * 2) + 1));
    /*@40*/ if (p0 != 0) goto @67;
  @43:
    /*@45*/ this.c = 1;
    /*@48*/ goto @67;
  @51:
    /*@66*/ this.a[0][((p0 * 2) + 1)] = (this.a[0][((p0 * 2) + 1)] - p1);
  @67:
    /*@73*/ if (b.a.a == 0) goto @132;
  @76:
    /*@82*/ if (b.a.b == 0) goto @132;
  @85:
    /*@92*/ if (this != b.a.a) goto @132;
  @95:
    /*@102*/ if (this.a[0].length != 0) goto @119;
  @105:
    /*@109*/ b.a.b = 0;
    /*@115*/ b.a.k();
    /*@118*/ return;
  @119:
    /*@123*/ b.a.b(0);
    /*@129*/ b.a.m();
  @132:
    /*@132*/ return;
  }

  private static void a(int p0, int p1, boolean p2, boolean p3, int p4) {
    /*@3*/ var t1 = new b;
    /*@7*/ t1.<init>(5, p0, p1);
    /*@11*/ v5 = t1;
    /*@15*/ v7 = 14;
    /*@18*/ v6 = t1;
    /*@23*/ t1.f(v7, 0);
    /*@30*/ v5.g(p4);
    /*@36*/ v5.b = 1;
    /*@47*/ if (p2 == 0) { _phi_59_0 = 15; _phi_59_1 = p0; _phi_59_2 = p1; _phi_59_3 = 12800; goto @59; }
    _phi_50_0 = 15;
    _phi_50_1 = p0;
    _phi_50_2 = p1;
    _phi_50_3 = 12800;
  @50: [stack=4: _phi_50_0, _phi_50_1, _phi_50_2, _phi_50_3]
    /*@56*/ { _phi_63_0 = _phi_50_0; _phi_63_1 = _phi_50_1; _phi_63_2 = _phi_50_2; _phi_63_3 = _phi_50_3; _phi_63_4 = (1 + f.d(2)); goto @63; }
  @59: [stack=4: _phi_59_0, _phi_59_1, _phi_59_2, _phi_59_3]
    _phi_63_0 = _phi_59_0;
    _phi_63_1 = _phi_59_1;
    _phi_63_2 = _phi_59_2;
    _phi_63_3 = _phi_59_3;
    _phi_63_4 = f.d(2);
  @63: [stack=5: _phi_63_0, _phi_63_1, _phi_63_2, _phi_63_3, _phi_63_4]
    /*@63*/ b.a(_phi_63_0, _phi_63_1, _phi_63_2, _phi_63_3, _phi_63_4);
    /*@67*/ if (p3 != 0) goto @89;
  @70:
    /*@86*/ if (b.a.a(v5.i, v5.j) == 0) goto @142;
  @89:
    /*@95*/ if (p2 == 0) { _phi_107_0 = 16; _phi_107_1 = p0; _phi_107_2 = p1; _phi_107_3 = 0; goto @107; }
    _phi_98_0 = 16;
    _phi_98_1 = p0;
    _phi_98_2 = p1;
    _phi_98_3 = 0;
  @98: [stack=4: _phi_98_0, _phi_98_1, _phi_98_2, _phi_98_3]
    /*@104*/ { _phi_111_0 = _phi_98_0; _phi_111_1 = _phi_98_1; _phi_111_2 = _phi_98_2; _phi_111_3 = _phi_98_3; _phi_111_4 = (1 + f.d(2)); goto @111; }
  @107: [stack=4: _phi_107_0, _phi_107_1, _phi_107_2, _phi_107_3]
    _phi_111_0 = _phi_107_0;
    _phi_111_1 = _phi_107_1;
    _phi_111_2 = _phi_107_2;
    _phi_111_3 = _phi_107_3;
    _phi_111_4 = f.d(2);
  @111: [stack=5: _phi_111_0, _phi_111_1, _phi_111_2, _phi_111_3, _phi_111_4]
    /*@111*/ b.a(_phi_111_0, _phi_111_1, _phi_111_2, _phi_111_3, _phi_111_4);
    /*@120*/ if (p2 == 0) { _phi_132_0 = 17; _phi_132_1 = p0; _phi_132_2 = p1; _phi_132_3 = 0; goto @132; }
    _phi_123_0 = 17;
    _phi_123_1 = p0;
    _phi_123_2 = p1;
    _phi_123_3 = 0;
  @123: [stack=4: _phi_123_0, _phi_123_1, _phi_123_2, _phi_123_3]
    /*@129*/ { _phi_136_0 = _phi_123_0; _phi_136_1 = _phi_123_1; _phi_136_2 = _phi_123_2; _phi_136_3 = _phi_123_3; _phi_136_4 = (1 + f.d(2)); goto @136; }
  @132: [stack=4: _phi_132_0, _phi_132_1, _phi_132_2, _phi_132_3]
    _phi_136_0 = _phi_132_0;
    _phi_136_1 = _phi_132_1;
    _phi_136_2 = _phi_132_2;
    _phi_136_3 = _phi_132_3;
    _phi_136_4 = f.d(2);
  @136: [stack=5: _phi_136_0, _phi_136_1, _phi_136_2, _phi_136_3, _phi_136_4]
    /*@136*/ b.a(_phi_136_0, _phi_136_1, _phi_136_2, _phi_136_3, _phi_136_4);
    /*@139*/ goto @169;
  @142:
    /*@148*/ if (p2 == 0) { _phi_160_0 = 18; _phi_160_1 = p0; _phi_160_2 = p1; _phi_160_3 = 0; goto @160; }
    _phi_151_0 = 18;
    _phi_151_1 = p0;
    _phi_151_2 = p1;
    _phi_151_3 = 0;
  @151: [stack=4: _phi_151_0, _phi_151_1, _phi_151_2, _phi_151_3]
    /*@157*/ { _phi_166_0 = _phi_151_0; _phi_166_1 = _phi_151_1; _phi_166_2 = _phi_151_2; _phi_166_3 = _phi_151_3; _phi_166_4 = (3 + f.d(2)); goto @166; }
  @160: [stack=4: _phi_160_0, _phi_160_1, _phi_160_2, _phi_160_3]
    _phi_166_0 = _phi_160_0;
    _phi_166_1 = _phi_160_1;
    _phi_166_2 = _phi_160_2;
    _phi_166_3 = _phi_160_3;
    _phi_166_4 = (1 + f.d(2));
  @166: [stack=5: _phi_166_0, _phi_166_1, _phi_166_2, _phi_166_3, _phi_166_4]
    /*@166*/ b.a(_phi_166_0, _phi_166_1, _phi_166_2, _phi_166_3, _phi_166_4);
  @169:
    /*@174*/ b.a.a(v5);
    /*@183*/ v5.b(1);
    /*@184*/ return;
  }

  private static void a(int p0, int p1, int p2, int p3, int p4) {
    /*@1*/ v5 = 0;
  @3:
    /*@7*/ if (v5 >= p4) goto @225;
  @10:
    /*@13*/ if (p0 != 18) goto @25;
  @16:
    /*@22*/ { _phi_31_0 = f.c(256); goto @31; }
  @25:
    _phi_31_0 = f.c(768);
  @31: [stack=1: _phi_31_0]
    /*@31*/ v6 = _phi_31_0;
    /*@36*/ if (p0 != 18) goto @48;
  @39:
    /*@45*/ { _phi_54_0 = f.c(256); goto @54; }
  @48:
    _phi_54_0 = f.c(768);
  @54: [stack=1: _phi_54_0]
    /*@54*/ v7 = _phi_54_0;
    /*@59*/ if (p0 != 18) goto @75;
  @62:
    /*@72*/ { _phi_83_0 = (1536 + f.d(1024)); goto @83; }
  @75:
    _phi_83_0 = (1280 + f.d(2));
  @83: [stack=1: _phi_83_0]
    /*@83*/ v8 = _phi_83_0;
    /*@109*/ v6 = -128;
    /*@111*/ v11 = v8;
    /*@113*/ v10 = v7;
    /*@115*/ v9 = v6;
    /*@117*/ v8 = (p2 + f.c(12));
    /*@119*/ v7 = (p1 + f.c(12));
    /*@121*/ v6 = 18;
    /*@126*/ var t1 = new b;
    /*@132*/ t1.<init>(5, v7, v8);
    /*@136*/ v6 = t1;
    /*@140*/ v8 = 18;
    /*@143*/ v7 = t1;
    /*@148*/ t1.f(v8, 0);
    /*@165*/ v6.n = f.d(e.a[18][0].length);
    /*@172*/ v6.g = v9;
    /*@179*/ v6.h = v10;
    /*@190*/ v6.a[1] = v11;
    /*@199*/ v6.a[2] = -128;
    /*@203*/ v6 = v6;
    /*@210*/ v6.a[0] = p3;
    /*@216*/ b.a.a(v6);
    /*@219*/ v5 += 1;
    /*@222*/ goto @3;
  @225:
    /*@225*/ return;
  }

  private void e(int p0) {
    /*@2*/ this.e = p0;
    /*@8*/ this = this;
    /*@13*/ this.j = this.b(0);
    /*@16*/ return;
  }

  private void f(int p0) {
    /*@2*/ this.f = p0;
    /*@8*/ this = this;
    /*@13*/ this.i = this.a(0);
    /*@16*/ return;
  }

  public final int a(int p0) {
    /*@15*/ return ((((this.f >> 8) + p0) + 24) / 48);
  }

  public final int b(int p0) {
    /*@15*/ return ((((this.e >> 8) + p0) + 24) / 48);
  }

  public final void a(int p0) {
    /*@8*/ this.f(((p0 * 48) << 8));
    /*@11*/ return;
  }

  public final void b(int p0) {
    /*@8*/ this.e(((p0 * 48) << 8));
    /*@11*/ return;
  }

  public final void c(int p0, int p1) {
    /*@2*/ this.a(p0);
    /*@7*/ this.b(p1);
    /*@10*/ return;
  }

  public final boolean a(int p0, int p1) {
    /*@5*/ if (this.i != p0) goto @18;
  @8:
    /*@13*/ if (this.j != p1) goto @18;
  @16:
    /*@17*/ return 1;
  @18:
    /*@19*/ return 0;
  }

  public final void c(int p0) {
    /*@7*/ this.e((this.e + p0));
    /*@10*/ return;
  }

  public final void d(int p0) {
    /*@7*/ this.f((this.f + p0));
    /*@10*/ return;
  }

  private void g() {
    /*@8*/ if (e.a[this.d] <= 0) goto @25;
  @11:
    /*@22*/ this.a = new byte[e.a[this.d]];
  @25:
    /*@33*/ if (e.b[this.d] <= 0) goto @50;
  @36:
    /*@47*/ this.a = new int[e.b[this.d]];
  @50:
    /*@58*/ if (e.c[this.d] <= 0) goto @76;
  @61:
    /*@73*/ this.a = new [I[e.c[this.d]];
  @76:
    /*@84*/ if (e.d[this.d] <= 0) goto @101;
  @87:
    /*@98*/ this.a = new boolean[e.d[this.d]];
  @101:
    /*@109*/ if (e.e[this.d] <= 0) goto @127;
  @112:
    /*@124*/ this.a = new b[e.e[this.d]];
  @127:
    /*@127*/ return;
  }

  public final boolean b() {
    /*@5*/ if (this.d == 2) goto @16;
  @8:
    /*@13*/ if (this.d != 3) goto @18;
  @16:
    /*@17*/ return 1;
  @18:
    /*@19*/ return 0;
  }

  public final boolean b(int p0) {
    /*@2*/ this = this;
    /*@9*/ if (this.a[0] != p0) goto @14;
  @12:
    /*@13*/ return 1;
  @14:
    /*@15*/ return 0;
  }

  public final boolean c(int p0) {
    /*@5*/ this = this;
    /*@17*/ if (f.a[this.a[0]] != f.a[p0]) goto @22;
  @20:
    /*@21*/ return 1;
  @22:
    /*@23*/ return 0;
  }

  public final int a() {
    /*@2*/ v1 = this;
    /*@19*/ return b.a(this.a[0], this.a[12], 0);
  }

  private static int a(int p0, int p1, boolean p2) {
    /*@5*/ v3 = e.l[p1];
    /*@7*/ if (p2 == 0) goto @14;
  @10:
    /*@11*/ { _phi_24_0 = 3; goto @24; }
  @14:
    _phi_24_0 = b.a.g[p0][v3];
  @24: [stack=1: _phi_24_0]
    /*@25*/ p0 = _phi_24_0;
    /*@30*/ return b.a(_phi_24_0, p1);
  }

  public static int a(int p0, int p1) {
    /*@8*/ p0 = e.a[p1][p0];
    /*@9*/ if (e.a[p1][p0] != 0) goto @15;
  @12:
    /*@14*/ return 100;
  @15:
    /*@22*/ return (100 + (p0 * 10));
  }

  public final int b() {
    /*@2*/ v1 = this;
    /*@17*/ if (this.d != 2) { _phi_30_0 = this.a[0]; _phi_30_1 = this.d; goto @30; }
    _phi_20_0 = this.a[0];
    _phi_20_1 = this.d;
  @20: [stack=2: _phi_20_0, _phi_20_1]
    /*@27*/ { _phi_36_0 = _phi_20_0; _phi_36_1 = _phi_20_1; _phi_36_2 = this.a[12]; goto @36; }
  @30: [stack=2: _phi_30_0, _phi_30_1]
    _phi_36_0 = _phi_30_0;
    _phi_36_1 = _phi_30_1;
    _phi_36_2 = this.a[4];
  @36: [stack=3: _phi_36_0, _phi_36_1, _phi_36_2]
    /*@40*/ return b.a(_phi_36_0, _phi_36_1, _phi_36_2, 0);
  }

  public static int a(int p0, int p1, int p2, boolean p3) {
    /*@2*/ if (p1 != 2) goto @23;
  @5:
    /*@10*/ p1 = e.c[p2];
    /*@22*/ return ((b.a(p0, p2, 0) * p1) / 100);
  @23:
    /*@28*/ p1 = e.f[p2];
    /*@32*/ if (f.i != 0) goto @54;
  @35:
    /*@42*/ b.a.getClass();
    /*@43*/ if (p0 == 0) goto @54;
  @46:
    /*@53*/ p1 = ((p1 * 75) / 100);
  @54:
    /*@55*/ return p1;
  }

  private int g() {
    /*@2*/ v1 = this;
    /*@17*/ if (this.d != 2) { _phi_30_0 = this.a[0]; _phi_30_1 = this.d; goto @30; }
    _phi_20_0 = this.a[0];
    _phi_20_1 = this.d;
  @20: [stack=2: _phi_20_0, _phi_20_1]
    /*@27*/ { _phi_36_0 = _phi_20_0; _phi_36_1 = _phi_20_1; _phi_36_2 = this.a[12]; goto @36; }
  @30: [stack=2: _phi_30_0, _phi_30_1]
    _phi_36_0 = _phi_30_0;
    _phi_36_1 = _phi_30_1;
    _phi_36_2 = this.a[4];
  @36: [stack=3: _phi_36_0, _phi_36_1, _phi_36_2]
    /*@40*/ return b.b(_phi_36_0, _phi_36_1, _phi_36_2, 0);
  }

  public static int b(int p0, int p1, int p2, boolean p3) {
    /*@2*/ if (p1 != 2) goto @24;
  @5:
    /*@20*/ p1 = ((b.a(p0, p2, 0) * e.d[p2]) / 100);
    /*@21*/ goto @56;
  @24:
    /*@29*/ p1 = e.q[p2];
    /*@32*/ if (p2 != 3) goto @56;
  @35:
    /*@44*/ if (b.a.e[p0] != 2) goto @56;
  @47:
    /*@55*/ p1 = ((p1 * 150) / 100);
  @56:
    /*@59*/ if (f.i != 0) goto @81;
  @62:
    /*@69*/ b.a.getClass();
    /*@70*/ if (p0 == 0) goto @81;
  @73:
    /*@80*/ p1 = ((p1 * 75) / 100);
  @81:
    /*@82*/ return p1;
  }

  public final int c() {
    /*@19*/ return ((this.a() * e.b[this.a[12]]) / 100);
  }

  public final int d() {
    /*@19*/ return ((this.a() * e.e[this.a[12]]) / 100);
  }

  public final void a() {
    /*@12*/ if (e.j[this.a[12]] != 1) goto @125;
  @15:
    /*@23*/ if (this.a[16] == -1) goto @125;
  @26:
    /*@32*/ if (this.a[0] == null) goto @125;
  @35:
    /*@53*/ if (this.a[10] != ((this.a[0].length / 2) - 1)) goto @125;
  @56:
    /*@85*/ v1 = e.a(this.a[4], this.a[5], this.a[16], this.a[17]);
    /*@105*/ this.a[21] = ((byte) (12 * e.f[((v1 * 2) + 1)]));
    /*@123*/ this.a[22] = ((byte) (12 * e.f[(v1 * 2)]));
    /*@124*/ return;
  @125:
    /*@157*/ v1 = java.lang.Math.max(0, ((b.a.c(7168, 10, this.i, this.j) - 1) % (e.x.length / 2)));
    /*@171*/ this.a[21] = e.x[(v1 * 2)];
    /*@187*/ this.a[22] = e.x[((v1 * 2) + 1)];
    /*@188*/ return;
  }

  public final void d(int p0, int p1) {
    /*@6*/ if (this.a[1] == 0) goto @18;
  @9:
    /*@15*/ if (this.a[2] != 0) goto @26;
  @18:
    /*@22*/ v3 = this.c();
    /*@23*/ goto @33;
  @26:
    /*@32*/ v3 = this.a[2];
  @33:
    /*@39*/ if (this.a[4] == 0) goto @75;
  @42:
    /*@48*/ if (this.e >= p0) { _phi_55_0 = this; goto @55; }
    _phi_51_0 = this;
  @51: [stack=1: _phi_51_0]
    /*@52*/ { _phi_69_0 = _phi_51_0; _phi_69_1 = v3; goto @69; }
  @55: [stack=1: _phi_55_0]
    /*@60*/ if (this.e <= p0) { _phi_68_0 = _phi_55_0; goto @68; }
    _phi_63_0 = _phi_55_0;
  @63: [stack=1: _phi_63_0]
    /*@65*/ { _phi_69_0 = _phi_63_0; _phi_69_1 = (-v3); goto @69; }
  @68: [stack=1: _phi_68_0]
    _phi_69_0 = _phi_68_0;
    _phi_69_1 = 0;
  @69: [stack=2: _phi_69_0, _phi_69_1]
    /*@69*/ _phi_69_0.g = _phi_69_1;
    /*@72*/ goto @89;
  @75:
    /*@86*/ this.g = f.b((p0 - this.e), v3);
  @89:
    /*@95*/ if (this.a[5] == 0) goto @129;
  @98:
    /*@104*/ if (this.f >= p1) { _phi_111_0 = this; goto @111; }
    _phi_107_0 = this;
  @107: [stack=1: _phi_107_0]
    /*@108*/ { _phi_125_0 = _phi_107_0; _phi_125_1 = v3; goto @125; }
  @111: [stack=1: _phi_111_0]
    /*@116*/ if (this.f <= p1) { _phi_124_0 = _phi_111_0; goto @124; }
    _phi_119_0 = _phi_111_0;
  @119: [stack=1: _phi_119_0]
    /*@121*/ { _phi_125_0 = _phi_119_0; _phi_125_1 = (-v3); goto @125; }
  @124: [stack=1: _phi_124_0]
    _phi_125_0 = _phi_124_0;
    _phi_125_1 = 0;
  @125: [stack=2: _phi_125_0, _phi_125_1]
    /*@125*/ _phi_125_0.h = _phi_125_1;
    /*@128*/ return;
  @129:
    /*@140*/ this.h = f.b((p1 - this.f), v3);
    /*@143*/ return;
  }

  private boolean a(b p0, int p1) {
    /*@9*/ return b.a.a(this, p0, p1);
  }

  private int b(b p0) {
    /*@19*/ return e.d(this.i, this.j, p0.i, p0.j);
  }

  private b a() {
    /*@1*/ v1 = null;
    /*@9*/ b.a.getClass();
    /*@14*/ v2 = this.b(0);
    /*@17*/ v3 = 2147483647;
    /*@19*/ v4 = 0;
  @21:
    /*@26*/ if (v4 >= f.h) goto @217;
  @29:
    /*@35*/ if (this.c(v4) != 0) goto @211;
  @38:
    /*@47*/ v5 = b.a.a[v4];
    /*@50*/ v6 = 0;
  @52:
    /*@57*/ if (v6 >= v5.length) goto @211;
  @60:
    /*@66*/ v7 = v5[v6];
    /*@68*/ if (v5[v6] == null) goto @205;
  @71:
    /*@77*/ if (v7.d != 2) goto @88;
  @80:
    /*@85*/ if (v7.d() != 0) goto @97;
  @88:
    /*@94*/ if (v7.d != 3) goto @205;
  @97:
    /*@104*/ if (v7.a[0] != 0) goto @205;
  @107:
    /*@108*/ if (v2 == 0) goto @135;
  @111:
    /*@132*/ if (b.a.a(508, 2, v7.i, v7.j, 0) == 0) goto @205;
  @135:
    /*@141*/ v8 = this.b(v7);
    /*@144*/ if (v1 == null) goto @199;
  @147:
    /*@150*/ if (v8 < v3) goto @199;
  @153:
    /*@154*/ if (v2 != 0) goto @205;
  @157:
    /*@162*/ if (v1.d != 3) goto @205;
  @165:
    /*@171*/ if (v7.d != 2) goto @205;
  @174:
    /*@196*/ if (e.a(this.i, this.j, v7.i, v7.j, 3) == 0) goto @205;
  @199:
    /*@201*/ v1 = v7;
    /*@204*/ v3 = v8;
  @205:
    /*@205*/ v6 += 1;
    /*@208*/ goto @52;
  @211:
    /*@211*/ v4 += 1;
    /*@214*/ goto @21;
  @217:
    /*@218*/ return v1;
  }

  public final void b(boolean p0) {
    /*@5*/ if (this.d != 2) goto @142;
  @8:
    /*@15*/ if (this.a[12] != 0) goto @142;
  @18:
    /*@26*/ if (this.a[19] == -1) goto @142;
  @29:
    /*@48*/ if (this.a[1] == 0) { _phi_57_0 = b.a; _phi_57_1 = this.i; _phi_57_2 = this.j; _phi_57_3 = 2; _phi_57_4 = -1; goto @57; }
    _phi_51_0 = b.a;
    _phi_51_1 = this.i;
    _phi_51_2 = this.j;
    _phi_51_3 = 2;
    _phi_51_4 = -1;
  @51: [stack=5: _phi_51_0, _phi_51_1, _phi_51_2, _phi_51_3, _phi_51_4]
    /*@54*/ { _phi_59_0 = _phi_51_0; _phi_59_1 = _phi_51_1; _phi_59_2 = _phi_51_2; _phi_59_3 = _phi_51_3; _phi_59_4 = _phi_51_4; _phi_59_5 = 500; goto @59; }
  @57: [stack=5: _phi_57_0, _phi_57_1, _phi_57_2, _phi_57_3, _phi_57_4]
    _phi_59_0 = _phi_57_0;
    _phi_59_1 = _phi_57_1;
    _phi_59_2 = _phi_57_2;
    _phi_59_3 = _phi_57_3;
    _phi_59_4 = _phi_57_4;
    _phi_59_5 = 48;
  @59: [stack=6: _phi_59_0, _phi_59_1, _phi_59_2, _phi_59_3, _phi_59_4, _phi_59_5]
    /*@62*/ var t1 = new int[1];
    /*@71*/ t1[0] = this.a[19];
    /*@75*/ var t2 = _phi_59_0.a(_phi_59_1, _phi_59_2, _phi_59_3, _phi_59_4, _phi_59_5, t1);
    /*@76*/ v2 = t2;
    /*@77*/ if (t2 == null) goto @94;
  @80:
    /*@88*/ this.a(v2[0], v2[1], null);
    /*@91*/ goto @360;
  @94:
    /*@101*/ this.a[19] = -1;
    /*@109*/ b.a.getClass();
    /*@114*/ if (this.b(0) == 0) goto @141;
  @117:
    /*@118*/ if (p0 == 0) goto @141;
  @121:
    /*@138*/ b.a.a(f.a(145), this.i, this.j);
  @141:
    /*@141*/ return;
  @142:
    /*@144*/ p0 = this;
    /*@150*/ v2 = this.a[0];
    /*@155*/ var t3 = this.a();
    /*@156*/ p0 = t3;
    /*@157*/ if (t3 == null) goto @360;
  @160:
    /*@165*/ if (this.d != 3) goto @182;
  @168:
    /*@178*/ v3 = e.p[this.a[4]];
    /*@179*/ goto @262;
  @182:
    /*@188*/ if (this.a[1] == 0) goto @236;
  @191:
    /*@199*/ if (this.a[20] != 1) goto @236;
  @202:
    /*@213*/ if (b.a.a[v2].c != 0) goto @236;
  @216:
    /*@228*/ if (b.a.a[v2].d == -1) goto @236;
  @231:
    /*@232*/ v3 = -1;
    /*@233*/ goto @262;
  @236:
    /*@261*/ v3 = java.lang.Math.max(e.j[this.a[12]], e.k[this.a[12]]);
  @262:
    /*@264*/ if (v3 == -1) goto @276;
  @267:
    /*@273*/ if (this.a(p0, v3) == 0) goto @360;
  @276:
    /*@281*/ if (this.d != 3) goto @293;
  @284:
    /*@287*/ this.b(p0, 0);
    /*@290*/ goto @322;
  @293:
    /*@297*/ if (this.c() == 0) goto @322;
  @300:
    /*@310*/ this.a(p0.i, p0.j, p0);
    /*@315*/ if (v3 == -1) goto @322;
  @318:
    /*@319*/ this.h();
  @322:
    /*@329*/ b.a.getClass();
    /*@330*/ if (v2 == 0) goto @360;
  @333:
    /*@345*/ if (b.a.a[v2].c != 2) goto @360;
  @348:
    /*@357*/ b.a.a[v2].c = 0;
  @360:
    /*@360*/ return;
  }

  public final boolean c() {
    /*@4*/ if (this.g() <= 0) goto @9;
  @7:
    /*@8*/ return 1;
  @9:
    /*@10*/ return 0;
  }

  public final void a(b p0, int p1) {
    /*@6*/ if (this.a[0] > 0) goto @10;
  @9:
    /*@9*/ return;
  @10:
    /*@12*/ v4 = this;
    /*@19*/ v3 = this.a[0];
    /*@21*/ if (p0 != null) goto @28;
  @24:
    /*@25*/ { _phi_37_0 = -1; goto @37; }
  @28:
    /*@30*/ v4 = p0;
    _phi_37_0 = p0.a[0];
  @37: [stack=1: _phi_37_0]
    /*@37*/ v4 = _phi_37_0;
    /*@46*/ b.a.getClass();
    /*@47*/ if (v3 != 0) goto @92;
  @50:
    /*@55*/ if (this.b(0) != 0) goto @92;
  @58:
    /*@64*/ if (b.a.f != 0) goto @92;
  @67:
    /*@68*/ if (p0 == null) goto @92;
  @71:
    /*@76*/ b.a.f = 100;
    /*@89*/ b.a.a(f.a(142), this);
  @92:
    /*@101*/ this.a[0] = (this.a[0] - p1);
    /*@107*/ if (this.d == 3) goto @118;
  @110:
    /*@115*/ if (this.c != 1) goto @122;
  @118:
    /*@119*/ this.h();
  @122:
    /*@128*/ if (this.a[0] > 0) goto @857;
  @131:
    /*@136*/ if (this.d == 3) goto @217;
  @139:
    /*@144*/ if (this.d != 2) goto @217;
  @147:
    /*@158*/ b.a.c[v3] = (b.a.c[v3] - 1);
    /*@163*/ b.a.c(this);
    /*@172*/ this.a[2] = 1;
    /*@174*/ this.b();
    /*@180*/ this.f(1, v3);
    /*@188*/ this.g(f.d(2));
    /*@209*/ this.o = (e.b[this.k][this.m][0] / 2);
    /*@214*/ this.c = 4;
  @217:
    /*@224*/ b.a.getClass();
    /*@225*/ if (v3 != 0) goto @268;
  @228:
    /*@233*/ if (this.d != 2) goto @252;
  @236:
    /*@248*/ b.a.i[4] = ((short) (b.a.i[4] + 1));
    /*@249*/ goto @353;
  @252:
    /*@264*/ b.a.i[5] = ((short) (b.a.i[5] + 1));
    /*@265*/ goto @353;
  @268:
    /*@273*/ if (this.d != 2) goto @316;
  @276:
    /*@284*/ b.a.getClass();
    /*@285*/ if (v4 != 0) goto @301;
  @288:
    /*@300*/ b.a.i[2] = ((short) (b.a.i[2] + 1));
  @301:
    /*@310*/ b.a.a[v3].e(this);
    /*@313*/ goto @353;
  @316:
    /*@324*/ b.a.getClass();
    /*@325*/ if (v4 != 0) goto @341;
  @328:
    /*@340*/ b.a.i[3] = ((short) (b.a.i[3] + 1));
  @341:
    /*@350*/ b.a.a[v3].c(this);
  @353:
    /*@378*/ if (b.a.a(b.a.d.i, b.a.d.j) != this) goto @385;
  @381:
    /*@382*/ { _phi_386_0 = 1; goto @386; }
  @385:
    _phi_386_0 = 0;
  @386: [stack=1: _phi_386_0]
    /*@386*/ p0 = _phi_386_0;
    /*@392*/ if (this.d != 2) goto @582;
  @395:
    /*@403*/ if (this.a[14] == -1) goto @430;
  @406:
    /*@427*/ b.a.a(1, 0, this.a[14], this.a[15], 0, 0);
  @430:
    /*@437*/ b.a.getClass();
    /*@438*/ if (v3 != 0) goto @460;
  @441:
    /*@459*/ b.a.H[this.a[12]] = ((byte) (b.a.H[this.a[12]] - 1));
  @460:
    /*@465*/ b.a.b(v3, -1);
    /*@476*/ if (this.a[23] == -1) goto @505;
  @479:
    /*@502*/ b.a.a(7168, 10, this.a[23], this.a[24], -1);
  @505:
    /*@512*/ b.a.getClass();
    /*@517*/ if (this.c(0) == 0) goto @546;
  @520:
    /*@543*/ b.a.a(this.i, this.j, e.k[this.a[12]], 0);
  @546:
    /*@548*/ this.b = 1;
    /*@556*/ if (this.e() != 2) goto @725;
  @559:
    /*@576*/ b.a((this.e >> 8), (this.f >> 8), 0, 1, 1);
    /*@579*/ goto @725;
  @582:
    /*@591*/ p1 = e.a(this.a[4]);
    /*@593*/ v4 = 0;
  @595:
    /*@599*/ if (v4 >= p1.length) goto @647;
  @602:
    /*@611*/ v5 = (this.i + p1[v4]);
    /*@624*/ var t1 = (this.j + p1[(v4 + 1)]);
    /*@625*/ v6 = t1;
    /*@638*/ b.a((t1 * 48), (v5 * 48), 0, 0, 0);
    /*@641*/ v4 += 3;
    /*@644*/ goto @595;
  @647:
    /*@648*/ this.e();
    /*@654*/ b.a.c();
    /*@664*/ if (this.a[4] != 1) goto @725;
  @667:
    /*@676*/ if (b.a.a(3, 1, v3) == null) goto @683;
  @679:
    /*@680*/ { _phi_684_0 = 1; goto @684; }
  @683:
    _phi_684_0 = 0;
  @684: [stack=1: _phi_684_0]
    /*@684*/ v4 = _phi_684_0;
    /*@695*/ b.a.a[v3] = v4;
    /*@702*/ if (b.a.a == 0) goto @725;
  @705:
    /*@711*/ if (b.a.a != 0) goto @725;
  @714:
    /*@716*/ if (v4 != 0) goto @725;
  @719:
    /*@722*/ b.a.k();
  @725:
    /*@726*/ if (p0 == 0) goto @741;
  @729:
    /*@732*/ b.a.i();
    /*@738*/ b.a.j();
  @741:
    /*@744*/ b.a.d();
    /*@754*/ if (this.a[1] == -1) goto @1086;
  @757:
    /*@767*/ b.a.d.a(this.i);
    /*@780*/ b.a.d.b(this.j);
    /*@786*/ b.a.j();
    /*@792*/ b.a.e();
    /*@799*/ b.a.j = null;
    /*@808*/ b.a.a.removeAllElements();
    /*@820*/ var t2 = new short[3];
    /*@823*/ t2[0] = 0;
    /*@833*/ t2[1] = ((short) this.a[1]);
    /*@837*/ t2[2] = 0;
    /*@838*/ b.a.a.addElement(t2);
    /*@845*/ b.a.d = 0;
    /*@853*/ b.a.g = 40;
    /*@856*/ return;
  @857:
    /*@864*/ this.a[1] = 50;
    /*@872*/ this.a[2] = 100;
    /*@878*/ if (this.d != 2) goto @955;
  @881:
    /*@887*/ if (this.a[3] != 0) goto @986;
  @890:
    /*@894*/ if (this.c() == 0) goto @986;
  @897:
    /*@903*/ if (this.a[0] == null) goto @939;
  @906:
    /*@915*/ if (this.a[0].c() == 0) goto @939;
  @918:
    /*@923*/ if (p0.d != 2) goto @986;
  @926:
    /*@936*/ if (this.a[0].d != 3) goto @986;
  @939:
    /*@949*/ this.a(p0.i, p0.j, p0);
    /*@952*/ goto @986;
  @955:
    /*@960*/ if (this.d != 3) goto @986;
  @963:
    /*@970*/ b.a.getClass();
    /*@971*/ if (v3 == 0) goto @986;
  @974:
    /*@983*/ b.a.a[v3].b(p0);
  @986:
    /*@993*/ b.a.getClass();
    /*@994*/ if (v3 == 0) goto @1086;
  @997:
    /*@1002*/ if (this.d(0) == 0) goto @1086;
  @1005:
    /*@1006*/ if (p0 == null) goto @1086;
  @1009:
    /*@1014*/ if (this.c != 3) goto @1033;
  @1017:
    /*@1018*/ this.c();
    /*@1028*/ this.a[19] = -1;
    /*@1030*/ this.b();
  @1033:
    /*@1070*/ var t3 = b.a.a(this.i, this.j, 0, e.a(p0.i, p0.j, this.i, this.j), 48, null);
    /*@1071*/ p0 = t3;
    /*@1072*/ if (t3 == null) goto @1086;
  @1075:
    /*@1083*/ this.b(p0[0], p0[1], 0);
  @1086:
    /*@1086*/ return;
  }

  public final int e() {
    /*@5*/ if (this.d != 3) goto @10;
  @8:
    /*@9*/ return 3;
  @10:
    /*@21*/ return e.l[this.a[12]];
  }

  public final boolean d(int p0) {
    /*@5*/ if (this.d != 2) goto @21;
  @8:
    /*@16*/ if (this.a[12] != p0) goto @21;
  @19:
    /*@20*/ return 1;
  @21:
    /*@22*/ return 0;
  }

  public final boolean d() {
    /*@6*/ if (this.a[2] != 0) goto @11;
  @9:
    /*@10*/ return 1;
  @11:
    /*@12*/ return 0;
  }

  public final boolean a(boolean p0) {
    /*@1*/ v2 = 0;
    /*@9*/ if (this.a[12] != 0) goto @16;
  @12:
    /*@13*/ { _phi_17_0 = 1; goto @17; }
  @16:
    _phi_17_0 = 0;
  @17: [stack=1: _phi_17_0]
    /*@17*/ v3 = _phi_17_0;
    /*@26*/ if (this.a[19] == -1) goto @33;
  @29:
    /*@30*/ { _phi_34_0 = 1; goto @34; }
  @33:
    _phi_34_0 = 0;
  @34: [stack=1: _phi_34_0]
    /*@34*/ v4 = _phi_34_0;
    /*@44*/ v5 = this;
    /*@52*/ v5 = b.a.b[this.a[0]];
    /*@55*/ v6 = 0;
  @57:
    /*@62*/ if (v6 >= v5.length) goto @211;
  @65:
    /*@71*/ v7 = v5[v6];
    /*@73*/ if (v5[v6] == null) goto @205;
  @76:
    /*@79*/ if (v7 == this) goto @205;
  @82:
    /*@87*/ if (v7.d() == 0) goto @205;
  @90:
    /*@97*/ if (v7.a(this, 2) == 0) goto @205;
  @100:
    /*@108*/ if (b.a.b(v7) != 0) goto @205;
  @111:
    /*@119*/ if (v7.a[12] != 0) goto @126;
  @122:
    /*@123*/ { _phi_127_0 = 1; goto @127; }
  @126:
    _phi_127_0 = 0;
  @127: [stack=1: _phi_127_0]
    /*@127*/ v8 = _phi_127_0;
    /*@138*/ if (v7.a[19] == -1) goto @145;
  @141:
    /*@142*/ { _phi_146_0 = 1; goto @146; }
  @145:
    _phi_146_0 = 0;
  @146: [stack=1: _phi_146_0]
    /*@146*/ v9 = _phi_146_0;
    /*@149*/ if (p0 == 0) goto @170;
  @152:
    /*@167*/ if (v7.a[12] != this.a[12]) goto @205;
  @170:
    /*@173*/ if (v3 != v8) goto @205;
  @176:
    /*@177*/ if (v3 == 0) goto @187;
  @180:
    /*@184*/ if (v4 != v9) goto @205;
  @187:
    /*@195*/ b.a.a(v7);
    /*@202*/ v7.a(p0);
    /*@204*/ v2 = 1;
  @205:
    /*@205*/ v6 += 1;
    /*@208*/ goto @57;
  @211:
    /*@212*/ return v2;
  }

  private void h() {
    /*@8*/ v1 = this;
    /*@15*/ v1 = b.a.b[this.a[0]];
    /*@17*/ v2 = 0;
  @18:
    /*@21*/ if (v2 >= v1.length) goto @99;
  @24:
    /*@28*/ v3 = v1[v2];
    /*@29*/ if (v1[v2] == null) goto @93;
  @32:
    /*@34*/ if (v3 == this) goto @93;
  @37:
    /*@43*/ if (v3.a(this, 2) == 0) goto @93;
  @46:
    /*@50*/ if (v3.c() == 0) goto @93;
  @53:
    /*@57*/ if (v3.d() == 0) goto @93;
  @60:
    /*@64*/ if (v3.e() == 0) goto @93;
  @67:
    /*@71*/ var t1 = v3.a();
    /*@72*/ v4 = t1;
    /*@74*/ if (t1 == null) goto @93;
  @77:
    /*@90*/ v3.a(v4.i, v4.j, v4);
  @93:
    /*@93*/ v2 += 1;
    /*@96*/ goto @18;
  @99:
    /*@99*/ return;
  }

  public final void a(int p0, int p1, boolean p2) {
    /*@5*/ if (this.d != 2) goto @16;
  @8:
    /*@12*/ if (this.d() != 0) goto @16;
  @15:
    /*@15*/ return;
  @16:
    /*@17*/ this.c();
    /*@27*/ this.a[19] = -1;
    /*@29*/ if (p2 != 0) goto @39;
  @32:
    /*@38*/ this.a[2] = 0;
  @39:
    /*@51*/ v4 = b.a.a(508, 2, p0, p1);
    /*@61*/ v5 = b.a.a(p0, p1);
    /*@70*/ if (this.a[12] != 0) goto @84;
  @73:
    /*@81*/ if (b.a.d(p0, p1) != 0) goto @136;
  @84:
    /*@86*/ if (v5 == null) goto @248;
  @89:
    /*@92*/ v7 = v5;
    /*@95*/ v6 = this;
    /*@100*/ if (this.g() <= 0) goto @132;
  @103:
    /*@107*/ v7 = v7;
    /*@110*/ v6 = v6;
    /*@115*/ v6 = v7;
    /*@125*/ if (v6.c(v7.a[0]) != 0) goto @132;
  @128:
    /*@129*/ { _phi_133_0 = 1; goto @133; }
  @132:
    _phi_133_0 = 0;
  @133: [stack=1: _phi_133_0]
    /*@133*/ if (_phi_133_0 == 0) goto @248;
  @136:
    /*@141*/ this.a(p0, p1, v5);
    /*@145*/ if (p2 == 0) goto @290;
  @148:
    /*@155*/ b.a.getClass();
    /*@160*/ if (this.b(0) == 0) goto @290;
  @163:
    /*@173*/ this = b.a.a(2, 1, p0, p1);
    /*@176*/ if (v5 != null) goto @183;
  @179:
    /*@180*/ if (this != 0) goto @231;
  @183:
    /*@185*/ if (v5 == null) goto @202;
  @188:
    /*@194*/ if (v5.d != 2) goto @202;
  @197:
    /*@199*/ if (v4 != 0) goto @231;
  @202:
    /*@204*/ if (v5 == null) goto @242;
  @207:
    /*@213*/ if (v5.d != 3) goto @242;
  @216:
    /*@217*/ if (this == 0) goto @242;
  @220:
    /*@228*/ if (b.a.a(p0, p1) == 0) goto @242;
  @231:
    /*@236*/ b.a.a(1, 4);
    /*@239*/ goto @290;
  @242:
    /*@244*/ b.g(p0, p1);
    /*@247*/ return;
  @248:
    /*@252*/ this.b(p0, p1, 1);
    /*@256*/ if (p2 == 0) goto @266;
  @259:
    /*@265*/ this.a[3] = 1;
  @266:
    /*@267*/ if (p2 == 0) goto @290;
  @270:
    /*@277*/ b.a.getClass();
    /*@282*/ if (this.b(0) == 0) goto @290;
  @285:
    /*@287*/ b.g(p0, p1);
  @290:
    /*@290*/ return;
  }

  private static void g(int p0, int p1) {
    /*@9*/ b.a.b(b.a.b);
    /*@20*/ b.a.b.c(p0, p1);
    /*@30*/ b.a.b.g(0);
    /*@42*/ b.a.a(b.a.b);
    /*@45*/ return;
  }

  public final void b() {
    /*@2*/ this.c = 1;
    /*@11*/ if (this.a[1] == null) goto @18;
  @14:
    /*@15*/ { _phi_19_0 = 1; goto @19; }
  @18:
    _phi_19_0 = 0;
  @19: [stack=1: _phi_19_0]
    /*@19*/ v1 = _phi_19_0;
    /*@26*/ this.a[0] = null;
    /*@29*/ this.g = 0;
    /*@34*/ this.h = 0;
    /*@38*/ this.d();
    /*@42*/ v2 = 0;
    /*@44*/ if (v1 != 0) goto @287;
  @47:
    /*@53*/ if (this.a[3] == 0) goto @63;
  @56:
    /*@62*/ this.a[3] = 0;
  @63:
    /*@67*/ if (this.g() == 0) goto @143;
  @70:
    /*@71*/ v2 = 1;
    /*@80*/ if (this.a[16] == -1) goto @105;
  @83:
    /*@99*/ this.a(this.a[16], this.a[17], null);
    /*@102*/ goto @287;
  @105:
    /*@124*/ var t1 = b.a.a(this.i, this.j, 1, -1, 48, null);
    /*@125*/ v1 = t1;
    /*@126*/ if (t1 == null) goto @140;
  @129:
    /*@137*/ this.b(v1[0], v1[1], 0);
  @140:
    /*@140*/ goto @287;
  @143:
    /*@151*/ if (this.a[16] == -1) goto @279;
  @154:
    /*@158*/ if (this.d() != 0) goto @168;
  @161:
    /*@162*/ this.c();
    /*@165*/ goto @287;
  @168:
    /*@194*/ v5 = e.j[this.a[12]];
    /*@196*/ v4 = this.a[17];
    /*@198*/ v3 = this.a[16];
    /*@200*/ v1 = this;
    /*@216*/ if (e.a(this.i, v1.j, v3, v4, v5) == 0) goto @287;
  @219:
    /*@245*/ v3 = e.b(this.i, this.j, this.a[16], this.a[17]);
    /*@247*/ v1 = this;
    /*@255*/ this.a[18] = ((byte) v3);
    /*@257*/ v1.d();
    /*@264*/ if (this.g() != 0) goto @271;
  @267:
    /*@268*/ this.j();
  @271:
    /*@273*/ this.c = 3;
    /*@276*/ goto @287;
  @279:
    /*@286*/ this.a[3] = 30;
  @287:
    /*@288*/ if (v2 != 0) goto @333;
  @291:
    /*@302*/ this.a[14] = ((byte) this.i);
    /*@314*/ this.a[15] = ((byte) this.j);
    /*@330*/ b.a.a(1, 0, this.i, this.j, 1, 0);
  @333:
    /*@343*/ if (this.a[0] >= this.b()) goto @354;
  @346:
    /*@353*/ this.a[2] = 100;
  @354:
    /*@354*/ return;
  }

  public final void b(int p0, int p1, boolean p2) {
    /*@5*/ if (this.c == 1) goto @12;
  @8:
    /*@9*/ this.b();
  @12:
    /*@20*/ v4 = this;
    /*@33*/ if (b.a.a[this.a[0]].size() > 15) goto @45;
  @36:
    /*@42*/ { _phi_51_0 = b.a.d; goto @51; }
  @45:
    _phi_51_0 = b.a.e;
  @51: [stack=1: _phi_51_0]
    /*@51*/ v4 = _phi_51_0;
    /*@54*/ if (p2 == 0) goto @67;
  @57:
    /*@64*/ { _phi_68_0 = b.a.a(this); goto @68; }
  @67:
    _phi_68_0 = -1;
  @68: [stack=1: _phi_68_0]
    /*@68*/ p2 = _phi_68_0;
    /*@72*/ if (p2 != -1) { _phi_79_0 = p0; goto @79; }
    _phi_75_0 = p0;
  @75: [stack=1: _phi_75_0]
    /*@76*/ { _phi_93_0 = _phi_75_0; _phi_93_1 = 0; goto @93; }
  @79: [stack=1: _phi_79_0]
    _phi_93_0 = _phi_79_0;
    _phi_93_1 = v4[this.a[13]][(p2 * 2)];
  @93: [stack=2: _phi_93_0, _phi_93_1]
    /*@94*/ p0 = (_phi_93_0 + _phi_93_1);
    /*@98*/ if (p2 != -1) { _phi_105_0 = p1; goto @105; }
    _phi_101_0 = p1;
  @101: [stack=1: _phi_101_0]
    /*@102*/ { _phi_121_0 = _phi_101_0; _phi_121_1 = 0; goto @121; }
  @105: [stack=1: _phi_105_0]
    _phi_121_0 = _phi_105_0;
    _phi_121_1 = v4[this.a[13]][((p2 * 2) + 1)];
  @121: [stack=2: _phi_121_0, _phi_121_1]
    /*@122*/ p1 = (_phi_121_0 + _phi_121_1);
    /*@133*/ v4 = p1;
    /*@135*/ p2 = p0;
    /*@136*/ p1 = this.j;
    /*@137*/ p0 = this.i;
    /*@147*/ if (b.a.b(p2, v4) != 0) goto @181;
  @150:
    /*@164*/ var t1 = b.a.a(p2, v4, 0, -1, 48, null);
    /*@165*/ v5 = t1;
    /*@167*/ if (t1 == null) goto @181;
  @170:
    /*@174*/ p2 = v5[0];
    /*@179*/ v4 = v5[1];
  @181:
    /*@188*/ v5 = ((p1 * 48) << 8);
    /*@197*/ p0 = ((p0 * 48) << 8);
    /*@206*/ p1 = ((v4 * 48) << 8);
    /*@214*/ v6 = ((p2 * 48) << 8);
    /*@220*/ p1 = (p1 - v5);
    /*@225*/ v6 = (v6 - p0);
    /*@247*/ var t2 = (f.d(java.lang.Math.max(java.lang.Math.abs(p1), java.lang.Math.abs(v6)), 36864) >> 8);
    /*@248*/ v7 = t2;
    /*@250*/ if (t2 <= 0) goto @408;
  @253:
    /*@259*/ v8 = new int[(v7 * 2)];
    /*@265*/ p1 = (p1 / v7);
    /*@271*/ v6 = (v6 / v7);
    /*@275*/ v5 = v5;
    /*@278*/ p0 = p0;
    /*@280*/ v9 = 0;
  @282:
    /*@290*/ if (v9 >= ((v7 * 2) - 2)) goto @386;
  @293:
    /*@297*/ v5 = (v5 + p1);
    /*@303*/ var t3 = (p0 + v6);
    /*@304*/ p0 = t3;
    /*@308*/ v10 = e.b(t3);
    /*@315*/ v11 = e.c(v5);
    /*@327*/ if (b.a.b(v10, v11) != 0) goto @364;
  @330:
    /*@346*/ var t4 = b.a.a(v10, v11, 0, -1, 500, null);
    /*@347*/ v12 = t4;
    /*@349*/ if (t4 == null) goto @364;
  @352:
    /*@356*/ v10 = v12[0];
    /*@362*/ v11 = v12[1];
  @364:
    /*@370*/ v8[v9] = v10;
    /*@379*/ v8[(v9 + 1)] = v11;
    /*@380*/ v9 += 2;
    /*@383*/ goto @282;
  @386:
    /*@394*/ v8[(v8.length - 2)] = p2;
    /*@404*/ v8[(v8.length - 1)] = v4;
    /*@405*/ goto @422;
  @408:
    /*@411*/ var t5 = new int[2];
    /*@414*/ t5[0] = p2;
    /*@419*/ t5[1] = v4;
    /*@420*/ v8 = t5;
  @422:
    /*@424*/ p0 = v8;
    /*@431*/ this.a[0] = null;
    /*@438*/ this.a[1] = p0;
    /*@446*/ this.a[11] = 0;
    /*@465*/ b.a.a(this, this.i, this.j, p0[0], p0[1]);
    /*@468*/ return;
  }

  public final void a(int p0, int p1, b p2) {
    /*@1*/ if (p2 == null) goto @32;
  @4:
    /*@9*/ if (p2.d != 3) goto @32;
  @12:
    /*@21*/ var t1 = b.a.a(this, p2, 0);
    /*@22*/ v4 = t1;
    /*@26*/ p0 = t1[0];
    /*@31*/ p1 = v4[1];
  @32:
    /*@40*/ this.a[16] = ((byte) p0);
    /*@49*/ this.a[17] = ((byte) p1);
    /*@51*/ if (p2 == null) goto @61;
  @54:
    /*@60*/ this.a[0] = p2;
  @61:
    /*@69*/ if (b.a.c(p0, p1) == 0) goto @94;
  @72:
    /*@93*/ this.a[19] = ((byte) f.a(e.v, b.a.a(p0, p1)));
  @94:
    /*@95*/ v4 = null;
    /*@98*/ if (p2 == null) goto @139;
  @101:
    /*@113*/ if (e.j[this.a[12]] <= 1) goto @139;
  @116:
    /*@121*/ if (this.a(p2) == 0) goto @125;
  @124:
    /*@124*/ return;
  @125:
    /*@128*/ var t2 = new int[2];
    /*@131*/ t2[0] = p0;
    /*@135*/ t2[1] = p1;
    /*@136*/ { _phi_339_0 = t2; goto @339; }
  @139:
    /*@140*/ if (p2 == null) goto @163;
  @143:
    /*@148*/ if (p2.d != 3) goto @163;
  @151:
    /*@160*/ { _phi_339_0 = b.a.a(this, p2, 1); goto @339; }
  @163:
    /*@166*/ v5 = p1;
    /*@168*/ v4 = p0;
    /*@170*/ p2 = this;
    /*@173*/ v6 = 2147483647;
    /*@176*/ v7 = -1;
    /*@179*/ v8 = -1;
    /*@185*/ v9 = (v4 - 1);
  @187:
    /*@193*/ if (v9 > (v4 + 1)) goto @316;
  @196:
    /*@200*/ v10 = (v5 - 1);
  @202:
    /*@208*/ if (v10 > (v5 + 1)) goto @310;
  @211:
    /*@220*/ if (v9 != p2.a[14]) goto @235;
  @223:
    /*@232*/ if (v10 == p2.a[15]) goto @263;
  @235:
    /*@245*/ if (b.a.b(v9, v10) == 0) goto @304;
  @248:
    /*@260*/ if (b.a.a(1, 0, v9, v10) != 0) goto @304;
  @263:
    /*@284*/ var t3 = (java.lang.Math.abs((p2.i - v9)) + java.lang.Math.abs((p2.j - v10)));
    /*@285*/ v11 = t3;
    /*@289*/ if (t3 >= v6) goto @304;
  @292:
    /*@294*/ v6 = v11;
    /*@298*/ v7 = v9;
    /*@302*/ v8 = v10;
  @304:
    /*@304*/ v10 += 1;
    /*@307*/ goto @202;
  @310:
    /*@310*/ v9 += 1;
    /*@313*/ goto @187;
  @316:
    /*@319*/ if (v7 != -1) goto @326;
  @322:
    /*@323*/ { _phi_339_0 = null; goto @339; }
  @326:
    /*@329*/ var t4 = new int[2];
    /*@333*/ t4[0] = v7;
    /*@338*/ t4[1] = v8;
    _phi_339_0 = t4;
  @339: [stack=1: _phi_339_0]
    /*@340*/ v4 = _phi_339_0;
    /*@342*/ if (_phi_339_0 == null) goto @375;
  @345:
    /*@350*/ if (v4[0] == -1) goto @375;
  @353:
    /*@358*/ if (v4[1] == -1) goto @375;
  @361:
    /*@371*/ this.b(v4[0], v4[1], 0);
    /*@374*/ return;
  @375:
    /*@383*/ if (this.a[14] != -1) goto @423;
  @386:
    /*@399*/ var t5 = b.a.a(p0, p1, 1, -1, 48, null);
    /*@400*/ p0 = t5;
    /*@401*/ if (t5 == null) goto @418;
  @404:
    /*@412*/ this.b(p0[0], p0[1], 0);
    /*@415*/ goto @427;
  @418:
    /*@419*/ this.i();
    /*@422*/ return;
  @423:
    /*@424*/ this.i();
  @427:
    /*@427*/ return;
  }

  private void i() {
    /*@7*/ if (this.a[12] != 0) goto @16;
  @10:
    /*@12*/ this.b(0);
    /*@15*/ return;
  @16:
    /*@17*/ this.c();
    /*@21*/ this.b();
    /*@24*/ return;
  }

  public final void b(b p0, int p1) {
    /*@1*/ if (p1 != 0) goto @22;
  @4:
    /*@9*/ if (this.d != 2) goto @22;
  @12:
    /*@21*/ this.a[3] = this.d();
  @22:
    /*@23*/ if (p0 == null) goto @50;
  @26:
    /*@32*/ if (p0.a[0] != 0) goto @50;
  @35:
    /*@40*/ if (p0.d != 2) goto @67;
  @43:
    /*@47*/ if (p0.d() != 0) goto @67;
  @50:
    /*@55*/ if (this.d != 2) goto @66;
  @58:
    /*@59*/ this.c();
    /*@63*/ this.b();
  @66:
    /*@66*/ return;
  @67:
    /*@68*/ if (p1 != 0) goto @166;
  @71:
    /*@76*/ if (this.d != 2) goto @97;
  @79:
    /*@96*/ this.a[25] = e.h[this.a[12]];
  @97:
    /*@98*/ if (p0 == null) goto @122;
  @101:
    /*@107*/ if (p0.a[0] != 0) goto @122;
  @110:
    /*@115*/ if (this.d != 2) goto @122;
  @118:
    /*@119*/ this.j();
  @122:
    /*@127*/ if (this.d == 3) goto @161;
  @130:
    /*@142*/ if (e.j[this.a[12]] <= 1) goto @166;
  @145:
    /*@150*/ if (this.d(3) != 0) goto @166;
  @153:
    /*@158*/ if (this.e() == 2) goto @166;
  @161:
    /*@163*/ this.a(p0);
  @166:
    /*@168*/ if (p1 != 1) goto @661;
  @171:
    /*@176*/ if (this.d != 2) goto @193;
  @179:
    /*@190*/ { _phi_194_0 = e.i[this.a[12]]; goto @194; }
  @193:
    _phi_194_0 = 1;
  @194: [stack=1: _phi_194_0]
    /*@194*/ v3 = _phi_194_0;
    /*@199*/ v4 = this.g();
    /*@206*/ if (this.d != 2) goto @223;
  @209:
    /*@220*/ { _phi_224_0 = e.g[this.a[12]]; goto @224; }
  @223:
    _phi_224_0 = 2;
  @224: [stack=1: _phi_224_0]
    /*@224*/ v5 = _phi_224_0;
    /*@228*/ v6 = v4;
    /*@235*/ if (this.d != 2) goto @341;
  @238:
    /*@239*/ v7 = 0;
    /*@252*/ if (e.b[this.a[12]] == null) goto @325;
  @255:
    /*@260*/ if (p0.d != 2) goto @299;
  @263:
    /*@267*/ v7 = p0.e();
    /*@286*/ if (f.b(e.b[this.a[12]], v7) == -1) goto @293;
  @289:
    /*@290*/ { _phi_294_0 = 1; goto @294; }
  @293:
    _phi_294_0 = 0;
  @294: [stack=1: _phi_294_0]
    /*@294*/ v7 = _phi_294_0;
    /*@296*/ goto @325;
  @299:
    /*@315*/ if (f.b(e.b[this.a[12]], 3) == -1) goto @322;
  @318:
    /*@319*/ { _phi_323_0 = 1; goto @323; }
  @322:
    _phi_323_0 = 0;
  @323: [stack=1: _phi_323_0]
    /*@323*/ v7 = _phi_323_0;
  @325:
    /*@327*/ if (v7 == 0) goto @341;
  @330:
    /*@339*/ v6 = ((v6 * 300) / 100);
  @341:
    /*@344*/ v7 = v5;
    /*@346*/ if (v5 <= 0) goto @359;
  @349:
    /*@357*/ v6 = (v6 + f.c(v7));
  @359:
    /*@360*/ if (v3 <= 0) goto @487;
  @363:
    /*@364*/ v7 = 0;
  @366:
    /*@371*/ if (v7 >= f.h) goto @487;
  @374:
    /*@380*/ if (this.c(v7) != 0) goto @481;
  @383:
    /*@392*/ v5 = b.a.b[v7];
    /*@395*/ v8 = 0;
  @397:
    /*@402*/ if (v8 >= v5.length) goto @481;
  @405:
    /*@411*/ v9 = v5[v8];
    /*@413*/ if (v5[v8] == null) goto @475;
  @416:
    /*@419*/ if (v9 == p0) goto @475;
  @422:
    /*@427*/ if (v9.d() == 0) goto @475;
  @430:
    /*@437*/ if (v9.a[0] != 0) goto @475;
  @440:
    /*@447*/ if (v9.a(p0, v3) == 0) goto @475;
  @450:
    /*@456*/ v10 = this.b(v9);
    /*@472*/ v9.a(this, (v4 / java.lang.Math.max(1, (v10 << 1))));
  @475:
    /*@475*/ v8 += 1;
    /*@478*/ goto @397;
  @481:
    /*@481*/ v7 += 1;
    /*@484*/ goto @366;
  @487:
    /*@491*/ p0.a(this, v6);
    /*@499*/ if (this.d != 2) goto @515;
  @502:
    /*@507*/ if (this.e() != 2) goto @515;
  @510:
    /*@512*/ this.a(p0);
  @515:
    /*@520*/ if (this.d == 3) goto @542;
  @523:
    /*@528*/ if (this.e() == 2) goto @542;
  @531:
    /*@539*/ if (this.a[12] != 3) goto @661;
  @542:
    /*@549*/ v7 = (p0.j * 48);
    /*@558*/ v5 = (p0.i * 48);
    /*@565*/ if (p0.d != 3) goto @606;
  @568:
    /*@574*/ if (p0.b().length <= 3) goto @583;
  @577:
    /*@577*/ v7 += 48;
    /*@580*/ v5 += 48;
  @583:
    /*@591*/ v7 = (v7 + f.c(24));
    /*@601*/ v5 = (v5 + f.c(24));
    /*@603*/ goto @626;
  @606:
    /*@614*/ v7 = (v7 + f.c(12));
    /*@624*/ v5 = (v5 + f.c(12));
  @626:
    /*@631*/ if (this.e() != 2) goto @638;
  @634:
    /*@635*/ { _phi_639_0 = 1; goto @639; }
  @638:
    _phi_639_0 = 0;
  @639: [stack=1: _phi_639_0]
    /*@639*/ v8 = _phi_639_0;
    /*@650*/ if (v8 == 0) { _phi_657_0 = v7; _phi_657_1 = v5; _phi_657_2 = v8; _phi_657_3 = 0; goto @657; }
    _phi_653_0 = v7;
    _phi_653_1 = v5;
    _phi_653_2 = v8;
    _phi_653_3 = 0;
  @653: [stack=4: _phi_653_0, _phi_653_1, _phi_653_2, _phi_653_3]
    /*@654*/ { _phi_658_0 = _phi_653_0; _phi_658_1 = _phi_653_1; _phi_658_2 = _phi_653_2; _phi_658_3 = _phi_653_3; _phi_658_4 = 0; goto @658; }
  @657: [stack=4: _phi_657_0, _phi_657_1, _phi_657_2, _phi_657_3]
    _phi_658_0 = _phi_657_0;
    _phi_658_1 = _phi_657_1;
    _phi_658_2 = _phi_657_2;
    _phi_658_3 = _phi_657_3;
    _phi_658_4 = 1;
  @658: [stack=5: _phi_658_0, _phi_658_1, _phi_658_2, _phi_658_3, _phi_658_4]
    /*@658*/ b.a(_phi_658_0, _phi_658_1, _phi_658_2, _phi_658_3, _phi_658_4);
  @661:
    /*@666*/ if (this.d == 3) goto @679;
  @669:
    /*@676*/ if (this.a[25] != 0) goto @689;
  @679:
    /*@680*/ if (p1 != 0) goto @689;
  @683:
    /*@686*/ this.b(p0, 1);
  @689:
    /*@689*/ return;
  }

  private void a(b p0) {
    /*@5*/ if (this.d != 2) goto @18;
  @8:
    /*@15*/ { _phi_37_0 = this.a[18]; goto @37; }
  @18:
    _phi_37_0 = e.b(this.i, this.j, p0.i, p0.j);
  @37: [stack=1: _phi_37_0]
    /*@37*/ p0 = _phi_37_0;
    /*@45*/ v2 = e.f[(p0 * 2)];
    /*@55*/ v3 = e.f[((p0 * 2) + 1)];
    /*@61*/ if (this.d != 3) goto @149;
  @64:
    /*@68*/ var t1 = this.b();
    /*@69*/ v6 = t1;
    /*@73*/ if (t1.length != 3) goto @100;
  @76:
    /*@83*/ p0 = (this.j * 48);
    /*@91*/ v4 = (this.i * 48);
    /*@95*/ v7 = 25;
    /*@97*/ goto @125;
  @100:
    /*@109*/ p0 = ((this.j + 1) * 48);
    /*@119*/ v4 = ((this.i + 1) * 48);
    /*@123*/ v7 = 49;
  @125:
    /*@128*/ v5 = 23040;
    /*@136*/ p0 = (p0 + (v3 * v7));
    /*@144*/ v4 = (v4 + (v2 * v7));
    /*@146*/ goto @312;
  @149:
    /*@151*/ v9 = p0;
    /*@154*/ v8 = this;
    /*@159*/ v10 = this.e();
    /*@163*/ if (v9 != 0) goto @170;
  @166:
    /*@167*/ { _phi_192_0 = 0; goto @192; }
  @170:
    /*@173*/ if (v9 != 4) goto @180;
  @176:
    /*@177*/ { _phi_192_0 = 1; goto @192; }
  @180:
    /*@184*/ if (v9 != 6) goto @191;
  @187:
    /*@188*/ { _phi_192_0 = 2; goto @192; }
  @191:
    _phi_192_0 = 3;
  @192: [stack=1: _phi_192_0]
    /*@192*/ v11 = _phi_192_0;
    /*@197*/ if (v10 != 2) goto @206;
  @200:
    /*@203*/ { _phi_221_0 = e.B; goto @221; }
  @206:
    /*@209*/ if (v10 != 1) goto @218;
  @212:
    /*@215*/ { _phi_221_0 = e.D; goto @221; }
  @218:
    _phi_221_0 = e.C;
  @221: [stack=1: _phi_221_0]
    /*@222*/ v12 = _phi_221_0;
    /*@229*/ v13 = _phi_221_0[(v11 * 3)];
    /*@240*/ v8 = v12[((v11 * 3) + 1)];
    /*@251*/ v14 = v12[((v11 * 3) + 2)];
    /*@256*/ var t2 = new byte[3];
    /*@261*/ t2[0] = ((byte) v13);
    /*@267*/ t2[1] = ((byte) v8);
    /*@273*/ t2[2] = ((byte) v14);
    /*@274*/ v6 = t2;
    /*@288*/ p0 = ((this.e >> 8) + v6[0]);
    /*@301*/ v4 = ((this.f >> 8) + v6[1]);
    /*@310*/ v5 = (v6[2] << 8);
  @312:
    /*@318*/ if (this.d(7) == 0) goto @326;
  @321:
    /*@323*/ { _phi_327_0 = 8; goto @327; }
  @326:
    _phi_327_0 = 3;
  @327: [stack=1: _phi_327_0]
    /*@327*/ v6 = _phi_327_0;
    /*@330*/ v7 = 0;
  @332:
    /*@336*/ if (v7 >= v6) goto @516;
  @339:
    /*@352*/ v8 = (((v3 << 1) << 8) + f.c(128));
    /*@367*/ v9 = (((v2 << 1) << 8) + f.c(128));
    /*@375*/ v10 = f.c(128);
    /*@383*/ if (this.d(7) == 0) goto @393;
  @386:
    /*@390*/ { _phi_394_0 = f.d(2); goto @394; }
  @393:
    _phi_394_0 = 0;
  @394: [stack=1: _phi_394_0]
    /*@394*/ v11 = _phi_394_0;
    /*@423*/ v14 = v11;
    /*@425*/ v8 = 2;
    /*@427*/ v13 = v5;
    /*@429*/ v12 = v10;
    /*@431*/ v11 = v9;
    /*@433*/ v10 = v8;
    /*@435*/ v9 = (v4 + f.c(2));
    /*@437*/ v8 = (p0 + f.c(2));
    /*@442*/ var t3 = new b;
    /*@448*/ t3.<init>(5, v8, v9);
    /*@452*/ v8 = t3;
    /*@458*/ t3.f(20, v14);
    /*@464*/ v8.g(2);
    /*@471*/ v8.g = v10;
    /*@478*/ v8.h = v11;
    /*@489*/ v8.a[1] = v12;
    /*@498*/ v8.a[0] = v13;
    /*@502*/ v8.b = 1;
    /*@507*/ b.a.a(v8);
    /*@510*/ v7 += 1;
    /*@513*/ goto @332;
  @516:
    /*@516*/ return;
  }

  private byte[] b() {
    /*@9*/ return e.a(this.a[4]);
  }

  public final boolean e() {
    /*@5*/ if (this.d != 2) goto @59;
  @8:
    /*@13*/ if (this.d(0) == 0) goto @27;
  @16:
    /*@24*/ if (this.a[19] == -1) goto @46;
  @27:
    /*@32*/ if (this.d(0) != 0) goto @57;
  @35:
    /*@43*/ if (this.a[16] != -1) goto @57;
  @46:
    /*@52*/ if (this.a[3] != 0) goto @57;
  @55:
    /*@56*/ return 1;
  @57:
    /*@58*/ return 0;
  @59:
    /*@60*/ return 1;
  }

  public final boolean b(boolean p0) {
    /*@1*/ if (p0 != 0) goto @23;
  @4:
    /*@10*/ if (this.d == 6) goto @21;
  @13:
    /*@18*/ if (this.d != 5) goto @23;
  @21:
    /*@22*/ return 1;
  @23:
    /*@28*/ if (this.d != 3) goto @136;
  @31:
    /*@54*/ p0 = e.a((this.e >> 8), (this.f >> 8), e.d, e.e);
    /*@64*/ v2 = e.a(this.a[4]);
    /*@69*/ this = this.f();
    /*@73*/ if (v2.length != 3) goto @105;
  @76:
    /*@104*/ return b.a.c((p0[0] - (e.d / 2)), (p0[1] - this), e.d, (this + e.e));
  @105:
    /*@135*/ return b.a.c((p0[0] - e.d), (p0[1] - this), (2 * e.d), (this + (2 * e.e)));
  @136:
    /*@165*/ p0 = e.a(((this.e >> 8) + 24), ((this.f >> 8) + 24), e.d, e.e);
    /*@230*/ return b.a.c((p0[0] + e.a[this.k][0]), (p0[1] + e.a[this.k][1]), e.a[this.k][0][0].a, e.a[this.k][0][0].b);
  }

  public final int f() {
    /*@10*/ return e.A[this.a[4]];
  }

  public final void c() {
    /*@8*/ if (this.a[16] == -1) goto @34;
  @11:
    /*@18*/ this.a[16] = -1;
    /*@26*/ this.a[17] = -1;
    /*@33*/ this.a[0] = null;
  @34:
    /*@34*/ return;
  }

  public final void e(int p0, int p1) {
    /*@7*/ this.a[4] = ((byte) p0);
    /*@15*/ this.a[5] = ((byte) p1);
    /*@36*/ this.a[18] = ((byte) e.b(this.i, this.j, p0, p1));
    /*@38*/ this.d();
    /*@47*/ v3 = this.a[0];
    /*@54*/ this.a[4] = 0;
    /*@61*/ this.a[5] = 0;
    /*@75*/ if (this.a[10] > ((v3.length / 2) - 2)) goto @187;
  @78:
    /*@87*/ v4 = (this.a[10] + 1);
    /*@95*/ v5 = v3[(v4 * 2)];
    /*@105*/ v3 = v3[((v4 * 2) + 1)];
    /*@119*/ var t1 = e.a(this.i, this.j, p0, p1);
    /*@120*/ v4 = t1;
    /*@130*/ if (t1 != e.a(p0, p1, v5, v3)) goto @187;
  @133:
    /*@137*/ if (v4 == 6) goto @146;
  @140:
    /*@143*/ if (v4 != 2) goto @154;
  @146:
    /*@152*/ this.a[4] = 1;
    /*@153*/ return;
  @154:
    /*@156*/ if (v4 == 0) goto @165;
  @159:
    /*@162*/ if (v4 != 4) goto @173;
  @165:
    /*@171*/ this.a[5] = 1;
    /*@172*/ return;
  @173:
    /*@179*/ this.a[4] = 1;
    /*@186*/ this.a[5] = 1;
  @187:
    /*@187*/ return;
  }

  public final boolean f() {
    /*@7*/ v1 = this.a[0];
    /*@8*/ if (this.a[0] == null) goto @62;
  @11:
    /*@16*/ if (v1.d != 2) goto @62;
  @19:
    /*@30*/ if (this.a[16] != v1.i) goto @47;
  @33:
    /*@44*/ if (this.a[17] == v1.j) goto @62;
  @47:
    /*@57*/ this.a(v1.i, v1.j, v1);
    /*@61*/ return 0;
  @62:
    /*@63*/ return 1;
  }

  private boolean g() {
    /*@17*/ if (b.a.a(1, 0, this.i, this.j, 0) == 0) goto @50;
  @20:
    /*@31*/ if (this.i != this.a[14]) goto @48;
  @34:
    /*@45*/ if (this.j == this.a[15]) goto @50;
  @48:
    /*@49*/ return 1;
  @50:
    /*@51*/ return 0;
  }

  public final boolean a(b p0) {
    /*@1*/ if (p0 == null) goto @76;
  @4:
    /*@20*/ if (this.a(p0, e.j[this.a[12]]) == 0) goto @76;
  @23:
    /*@27*/ if (this.g() == 0) goto @70;
  @30:
    /*@49*/ var t1 = b.a.a(this.i, this.j, 1, -1, 48, null);
    /*@50*/ p0 = t1;
    /*@51*/ if (t1 == null) goto @67;
  @54:
    /*@62*/ this.b(p0[0], p0[1], 0);
    /*@66*/ return 1;
  @67:
    /*@67*/ goto @76;
  @70:
    /*@71*/ this.b();
    /*@75*/ return 1;
  @76:
    /*@77*/ return 0;
  }

  public final void d() {
    /*@5*/ if (this.c != 2) goto @12;
  @8:
    /*@9*/ { _phi_13_0 = 1; goto @13; }
  @12:
    _phi_13_0 = 0;
  @13: [stack=1: _phi_13_0]
    /*@13*/ v1 = _phi_13_0;
    /*@15*/ v2 = -1;
    /*@23*/ switch (this.a[18]) { 0->@92, 1->@119, 2->@78, 3->@119, 4->@107, 5->@119, 6->@64, default->@119 }
  @64:
    /*@65*/ if (v1 == 0) goto @73;
  @68:
    /*@69*/ v2 = 4;
    /*@70*/ goto @119;
  @73:
    /*@74*/ v2 = 0;
    /*@75*/ goto @119;
  @78:
    /*@79*/ if (v1 == 0) goto @87;
  @82:
    /*@83*/ v2 = 5;
    /*@84*/ goto @119;
  @87:
    /*@88*/ v2 = 1;
    /*@89*/ goto @119;
  @92:
    /*@93*/ if (v1 == 0) goto @102;
  @96:
    /*@98*/ v2 = 6;
    /*@99*/ goto @119;
  @102:
    /*@103*/ v2 = 2;
    /*@104*/ goto @119;
  @107:
    /*@108*/ if (v1 == 0) goto @117;
  @111:
    /*@113*/ v2 = 7;
    /*@114*/ goto @119;
  @117:
    /*@118*/ v2 = 3;
  @119:
    /*@121*/ if (v2 == -1) goto @137;
  @124:
    /*@129*/ if (v2 == this.m) goto @137;
  @132:
    /*@134*/ this.g(v2);
  @137:
    /*@137*/ return;
  }

  private void j() {
    /*@1*/ v1 = -1;
    /*@9*/ switch (this.a[18]) { 0->@64, 1->@73, 2->@58, 3->@73, 4->@70, 5->@73, 6->@52, default->@73 }
  @52:
    /*@54*/ v1 = 8;
    /*@55*/ goto @73;
  @58:
    /*@60*/ v1 = 9;
    /*@61*/ goto @73;
  @64:
    /*@66*/ v1 = 10;
    /*@67*/ goto @73;
  @70:
    /*@72*/ v1 = 11;
  @73:
    /*@75*/ if (v1 == -1) goto @83;
  @78:
    /*@80*/ this.g(v1);
  @83:
    /*@83*/ return;
  }

  public static void a(javax.microedition.lcdui.Graphics p0, int p1, int p2, int p3, int p4) {
    /*@0*/ p1 -= 6;
    /*@11*/ e.c[0].a(p0, p1, p2);
    /*@22*/ if (p4 != 16711680) { _phi_29_0 = p0; _phi_29_1 = e.c; goto @29; }
    _phi_25_0 = p0;
    _phi_25_1 = e.c;
  @25: [stack=2: _phi_25_0, _phi_25_1]
    /*@26*/ { _phi_30_0 = _phi_25_0; _phi_30_1 = _phi_25_1; _phi_30_2 = 1; goto @30; }
  @29: [stack=2: _phi_29_0, _phi_29_1]
    _phi_30_0 = _phi_29_0;
    _phi_30_1 = _phi_29_1;
    _phi_30_2 = 2;
  @30: [stack=3: _phi_30_0, _phi_30_1, _phi_30_2]
    /*@46*/ f.a(_phi_30_0, _phi_30_1[_phi_30_2], p1, p2, (p1 + java.lang.Math.max(1, ((p3 * 12) / 100))));
    /*@49*/ return;
  }

  public final void e() {
    /*@4*/ if (this.b() == 0) goto @364;
  @7:
    /*@9*/ v1 = this;
    /*@15*/ v1 = this.a[0];
    /*@22*/ this.a[0] = 1;
    /*@28*/ if (this.d != 3) goto @364;
  @31:
    /*@42*/ b.a.d[v1] = (b.a.d[v1] - 1);
    /*@60*/ b.a.G[this.a[4]] = ((byte) (b.a.G[this.a[4]] - 1));
    /*@70*/ v2 = e.a(this.a[4]);
    /*@72*/ v3 = 0;
  @73:
    /*@76*/ if (v3 >= v2.length) goto @202;
  @79:
    /*@87*/ v4 = (this.i + v2[v3]);
    /*@99*/ v5 = (this.j + v2[(v3 + 1)]);
    /*@112*/ b.a.a(1, 0, v4, v5, 0, 0);
    /*@129*/ b.a.a(512, 9, v4, v5, 0, 0);
    /*@150*/ b.a.a(v4, v5, e.E[f.d(e.E.length)]);
    /*@160*/ b.a.getClass();
    /*@165*/ if (this.c(0) == 0) goto @196;
  @168:
    /*@172*/ if (this.c == 0) goto @196;
  @175:
    /*@193*/ b.a.a(v4, v5, e.p[this.a[4]], 0);
  @196:
    /*@196*/ v3 += 3;
    /*@199*/ goto @73;
  @202:
    /*@209*/ if (this.a[4] != 1) goto @224;
  @212:
    /*@218*/ b.a.c(v1, -10);
    /*@221*/ goto @243;
  @224:
    /*@231*/ if (this.a[4] != 2) goto @243;
  @234:
    /*@240*/ b.a.c(v1, -5);
  @243:
    /*@250*/ if (this != b.a.a) goto @259;
  @253:
    /*@256*/ b.a.l();
  @259:
    /*@266*/ v3 = this.a[0];
    /*@267*/ if (this.a[0] == null) goto @364;
  @270:
    /*@271*/ v4 = 0;
  @273:
    /*@277*/ if (v4 >= v3.length) goto @364;
  @280:
    /*@284*/ v5 = v3[v4];
    /*@292*/ v2 = e.r[v5];
    /*@299*/ v6 = v3[(v4 + 1)];
    /*@307*/ v5 = e.a[v5];
    /*@310*/ v7 = 0;
  @312:
    /*@315*/ if (v7 >= 3) goto @335;
  @318:
    /*@328*/ v5[v7] = ((short) (v5[v7] * v6));
    /*@329*/ v7 += 1;
    /*@332*/ goto @312;
  @335:
    /*@341*/ b.a.a(v1, v5);
    /*@345*/ if (v2 != 0) goto @358;
  @348:
    /*@355*/ b.a.b(v1, (-v6));
  @358:
    /*@358*/ v4 += 2;
    /*@361*/ goto @273;
  @364:
    /*@368*/ b.a.b(this);
    /*@371*/ return;
  }

  private int h() {
    /*@13*/ return (this.a(10) + this.b(10));
  }

  private int i() {
    /*@9*/ return (this.e + this.f);
  }

  public final int a(b p0) {
    /*@4*/ v2 = this.h();
    /*@9*/ this = this.i();
    /*@14*/ v3 = p0.h();
    /*@19*/ p0 = p0.i();
    /*@22*/ if (v2 != v3) goto @32;
  @25:
    /*@27*/ if (this != p0) goto @32;
  @30:
    /*@31*/ return 0;
  @32:
    /*@34*/ if (v3 < v2) goto @47;
  @37:
    /*@39*/ if (v3 != v2) goto @49;
  @42:
    /*@44*/ if (p0 >= this) goto @49;
  @47:
    /*@48*/ return 1;
  @49:
    /*@50*/ return -1;
  }

  public final void f(int p0, int p1) {
    /*@2*/ this.k = p0;
    /*@7*/ this.l = p1;
    /*@12*/ this.g(0);
    /*@15*/ return;
  }

  private void g(int p0) {
    /*@2*/ this.m = p0;
    /*@7*/ this.n = 0;
    /*@26*/ this.o = e.b[this.k][this.m][0];
    /*@31*/ this.c = 1;
    /*@34*/ return;
  }

  public final void f() {
    /*@4*/ if (this.k < 0) goto @132;
  @7:
    /*@8*/ v1 = 0;
    /*@17*/ this.o = (this.o - 1);
    /*@20*/ if ((this.o - 1) > 0) goto @35;
  @23:
    /*@30*/ this.n = (this.n + 1);
    /*@34*/ v1 = 1;
  @35:
    /*@37*/ v2 = this;
    /*@55*/ if (this.n < e.a[v2.k][v2.m].length) goto @62;
  @58:
    /*@59*/ { _phi_63_0 = 1; goto @63; }
  @62:
    _phi_63_0 = 0;
  @63: [stack=1: _phi_63_0]
    /*@63*/ if (_phi_63_0 == 0) goto @106;
  @66:
    /*@80*/ if (e.f[this.k][this.m] != 1) goto @91;
  @83:
    /*@85*/ this.n = 0;
    /*@88*/ goto @106;
  @91:
    /*@98*/ this.n = (this.n - 1);
    /*@103*/ this.c = 0;
  @106:
    /*@107*/ if (v1 == 0) goto @132;
  @110:
    /*@129*/ this.o = e.b[this.k][this.m][this.n];
  @132:
    /*@132*/ return;
  }

  public final void a(javax.microedition.lcdui.Graphics p0, int[] p1, int p2, int p3, int p4) {
    /*@4*/ if (this.k < 0) goto @140;
  @7:
    /*@36*/ p2 = e.a[this.k][p2][e.a[this.k][this.m][this.n]];
    /*@55*/ v6 = e.b[this.k][this.m][this.n];
    /*@67*/ v7 = e.a[this.k][0];
    /*@72*/ if (v6 != 2) goto @85;
  @75:
    /*@83*/ v7 = (-(p2.a + v7));
  @85:
    /*@90*/ p3 = (p3 + v7);
    /*@105*/ p4 = (p4 + e.a[this.k][1]);
    /*@123*/ p3 = v6;
    /*@125*/ p2 = (p1[1] + p4);
    /*@126*/ p1 = (p1[0] + p3);
    /*@127*/ p0 = p0;
    /*@129*/ this = p2;
    /*@137*/ p2.a(p0, p1, p2, p3, 20);
  @140:
    /*@140*/ return;
  }

}
