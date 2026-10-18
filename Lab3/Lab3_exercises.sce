// ============================================================
// DSP Lab 3 - Additional exercises (Proakis 1.2 - 1.16, 2.26 - 2.35)
// Pham Minh Duc - 2414106
// Run from the folder containing Lab3.sci
// ============================================================
exec("Lab3.sci", -1);

// ==== Bai 1.2
// Tim chu ky co ban bang thuc nghiem: N nho nhat sao cho x(n + N) = x(n)
n = 0:999;
names = ["cos(0.01*pi*n)", "cos(30*pi*n/105)", "cos(3*pi*n)", "sin(3*n)", "sin(62*pi*n/10)"];
X = [cos(0.01*%pi*n); cos(30*%pi*n/105); cos(3*%pi*n); sin(3*n); sin(62*%pi*n/10)];
Nmax = 500;
for i = 1:5
    Np = -1;
    for N = 1:Nmax
        if max(abs(X(i, 1+N:500+N) - X(i, 1:500))) < 1e-9 then
            Np = N; break;
        end
    end
    if Np > 0 then
        mprintf("(%s) %-18s : tuan hoan, N = %d\n", ascii(96+i), names(i), Np);
    else
        mprintf("(%s) %-18s : khong tim thay chu ky N <= %d\n", ascii(96+i), names(i), Nmax);
    end
end
figure();
for i = 1:5
    subplot(5, 1, i);
    plot2d3(0:49, X(i, 1:50), style=2);
    xtitle("(" + ascii(96+i) + ") " + names(i), "n", "");
end

// ==== Bai 1.4
// So sanh chu ky tim bang thuc nghiem voi cong thuc Np = N / GCD(k, N)
n = 0:99;
for N = [7 16]
    Np_exp = zeros(1, N); Np_th = zeros(1, N);
    for k = 0:N-1
        s = exp(%i*2*%pi*k*n/N);
        for P = 1:N
            if max(abs(s(1+P:50+P) - s(1:50))) < 1e-9 then
                Np_exp(k+1) = P; break;
            end
        end
        Np_th(k+1) = N / double(gcd(int32([k, N])));
    end
    mprintf("N = %d\n", N);
    disp([0:N-1; Np_exp; Np_th]);       // hang 1: k, hang 2: thuc nghiem, hang 3: cong thuc
    figure();
    plot2d3(0:N-1, Np_exp, style=2);
    xtitle("Chu ky co ban Np cua s_k(n), N = " + string(N), "k", "Np");
end

// ==== Bai 1.7
Fs = 8000; Ts = 1/Fs;
n = 0:15;  t = 0:Ts/50:15*Ts;          // luoi thoi gian min de ve tin hieu tuong tu
pairs = [5000 3000; 9000 1000];        // tan so goc va tan so bi chong pho
figure();
for i = 1:2
    F = pairs(i, 1); Fa = pairs(i, 2);
    xn  = cos(2*%pi*F*n*Ts);           // mau cua tin hieu F
    xan = cos(2*%pi*Fa*n*Ts);          // mau cua tin hieu Fa
    mprintf("F = %d Hz: max|x_F(n) - x_Fa(n)| voi Fa = %d Hz: %g\n", F, Fa, max(abs(xn - xan)));
    subplot(2, 1, i);
    plot2d(t, cos(2*%pi*F*t), style=2);
    plot2d(t, cos(2*%pi*Fa*t), style=5);
    plot2d(n*Ts, xn, style=-9);        // cac diem mau
    xtitle("F = " + string(F/1000) + " kHz (xanh) va " + string(Fa/1000) + ..
           " kHz (do), Fs = 8 kHz", "t (s)", "");
end

// ==== Bai 1.11
T = 5e-3; Tp = 1e-3;                   // chu ky lay mau cua A/D va D/A
N = 400; n = 0:N-1;
x = 3*cos(100*%pi*n*T) + 2*sin(250*%pi*n*T);       // A/D: x(n) = xa(nT)
x_th = 3*cos(%pi/2*n) - 2*sin(3*%pi/4*n);
mprintf("max|x(n) - [3cos(pi n/2) - 2sin(3pi n/4)]| = %g\n", max(abs(x - x_th)));
// Pho cua x(n): tim cac tan so so f (chu ky/mau) co bien do lon
Xk = abs(fft(x))/N*2;
k = find(Xk(1:N/2) > 0.5) - 1;
f = k/N;
mprintf("Tan so so f = %s chu ky/mau\n", strcat(string(f), ", "));
mprintf("Tan so ngo ra D/A F = f/T'' = %s Hz\n", strcat(string(f/Tp), ", "));
mprintf("Bien do tuong ung: %s\n", strcat(string(Xk(k+1)), ", "));
// Ngo ra sau bo loc: ya(t) = 3cos(500 pi t) - 2sin(750 pi t)
t = 0:Tp/50:40*Tp;
ya = 3*cos(500*%pi*t) - 2*sin(750*%pi*t);
figure();
subplot(2, 1, 1); plot2d3(0:39, x(1:40), style=2); xtitle("x(n)", "n", "x(n)");
subplot(2, 1, 2);
plot2d(t, ya, style=5);
plot2d((0:39)*Tp, x(1:40), style=-9);  // cac mau x(n) dat tai t = nT''
xtitle("ya(t) = 3cos(500 pi t) - 2sin(750 pi t) va cac mau x(n) tai t = nT''", "t (s)", "");

// ==== Bai 1.15
// (a) Fs = 5 kHz, F0 = 0.5, 2, 3, 4.5 kHz
Fs = 5000; n = 0:99;
F0 = [500 2000 3000 4500];
figure();
for i = 1:4
    subplot(4, 1, i);
    plot2d3(n, sin(2*%pi*F0(i)/Fs*n), style=2);
    xtitle("F0 = " + string(F0(i)/1000) + " kHz, f0 = " + string(F0(i)/Fs), "n", "x(n)");
end
// Kiem tra chong pho: x(n) voi F0 = 3 kHz bang -x(n) voi F0 = 2 kHz
x2 = sin(2*%pi*2000/Fs*n);  x3 = sin(2*%pi*3000/Fs*n);
x05 = sin(2*%pi*500/Fs*n);  x45 = sin(2*%pi*4500/Fs*n);
mprintf("max|x_3k + x_2k|     = %g\n", max(abs(x3 + x2)));
mprintf("max|x_4.5k + x_0.5k| = %g\n", max(abs(x45 + x05)));

// (b) F0 = 2 kHz, Fs = 50 kHz, y(n) = x(2n)
F0 = 2000; Fs = 50000; n = 0:99;
x = sin(2*%pi*F0/Fs*n);
y = x(1:2:$);                        // cac mau chan x(0), x(2), ...
ny = 0:length(y)-1;
mprintf("max|y(n) - sin(2*pi*0.08*n)| = %g\n", max(abs(y - sin(2*%pi*0.08*ny))));
figure();
subplot(2, 1, 1); plot2d3(n, x, style=2);  xtitle("x(n), f0 = 0.04", "n", "x(n)");
subplot(2, 1, 2); plot2d3(ny, y, style=5); xtitle("y(n) = x(2n), f = 0.08", "n", "y(n)");

// ==== Bai 1.16
f0 = 1/50; N = 200; n = 0:N-1;
x  = sin(2*%pi*f0*n);
Px = sum(x.^2)/N;
L  = [64 128 256];
for i = 1:3
    D  = 2/(L(i) - 1);                      // buoc luong tu
    xt = -1 + D*floor((x + 1)/D);           // (a) truncation
    xr = -1 + D*round((x + 1)/D);           // (b) rounding
    et = xt - x;  er = xr - x;
    SQNR_t  = 10*log10(Px/(sum(et.^2)/N));
    SQNR_r  = 10*log10(Px/(sum(er.^2)/N));
    SQNR_th = 1.76 + 6.02*log2(L(i));       // cong thuc (1.4.32)
    mprintf("L = %3d: truncation %.2f dB, rounding %.2f dB, ly thuyet %.2f dB\n", ..
            L(i), SQNR_t, SQNR_r, SQNR_th);
    figure();
    subplot(3, 2, 1); plot2d3(n, x, style=2);  xtitle("x(n)", "n", "");
    subplot(3, 2, 3); plot2d3(n, xt, style=5); xtitle("x_q(n) truncation, L = " + string(L(i)), "n", "");
    subplot(3, 2, 5); plot2d3(n, et, style=1); xtitle("e(n) truncation", "n", "");
    subplot(3, 2, 2); plot2d3(n, x, style=2);  xtitle("x(n)", "n", "");
    subplot(3, 2, 4); plot2d3(n, xr, style=5); xtitle("x_q(n) rounding, L = " + string(L(i)), "n", "");
    subplot(3, 2, 6); plot2d3(n, er, style=1); xtitle("e(n) rounding", "n", "");
end

// ==== Bai 2.26
// Dap ung ngo vao bang khong voi y(-1) = 1, y(-2) = 2
ym1 = 1; ym2 = 2;
N = 10; n = 0:N-1;
y = zeros(1, N);
yprev = [ym2, ym1];                    // [y(n-2), y(n-1)]
for i = 1:N
    y(i) = 3*yprev(2) + 4*yprev(1);    // y(n) = 3y(n-1) + 4y(n-2)
    yprev = [yprev(2), y(i)];
end
y_cf = 16/5*(ym1 + ym2)*4.^n + (4*ym2 - ym1)/5*(-1).^n;
disp("   n   y(n) de quy   y(n) cong thuc");
disp([n', y', y_cf']);
mprintf("Sai so lon nhat: %g\n", max(abs(y - y_cf)));
figure();
plot2d3(n, y, style=2);
xtitle("Bai 2.26: y_zi(n) voi y(-1) = 1, y(-2) = 2", "n", "y(n)");

// ==== Bai 2.27
N = 20; n = 0:N-1;
x  = 2.^n;
y  = filter(1, [1, -5/6, 1/6], x);    // dap ung toan phan, he nghi ban dau
yp = 8/5*2.^n;                        // nghiem rieng
yh = y - yp;                          // phan con lai la nghiem thuan nhat
y_cf = 8/5*2.^n - (1/2).^n + 2/5*(1/3).^n;
disp("   n   y(n)   y_p(n)   y(n) - y_p(n)");
disp([n(1:8)', y(1:8)', yp(1:8)', yh(1:8)']);
mprintf("y(n)/2^n tai n = %d: %.6f (ly thuyet K = 1.6)\n", N-1, y(N)/2^(N-1));
mprintf("Sai so tuong doi so voi nghiem toan phan: %g\n", max(abs(y - y_cf)./abs(y)));
figure();
subplot(2, 1, 1); plot2d3(n, y./2.^n, style=2); xtitle("y(n) / 2^n  ->  K = 8/5", "n", "");
subplot(2, 1, 2); plot2d3(n, yh, style=5);      xtitle("y(n) - y_p(n)", "n", "");

// ==== Bai 2.28
a1 = -0.9; ym1 = 0;
N = 60; n = 0:N-1;
x = ones(1, N);                       // x(n) = u(n)
y = zeros(1, N); yprev = ym1;
for i = 1:N
    y(i) = -a1*yprev + x(i);          // y(n) = -a1*y(n-1) + x(n)
    yprev = y(i);
end
yss = 1/(1 + a1)*ones(1, N);
ytr = (-a1).^(n+1)*(ym1 - 1/(1 + a1));
mprintf("max|y - (yss + ytr)| = %g\n", max(abs(y - yss - ytr)));
figure();
subplot(3, 1, 1); plot2d3(n, y, style=1);   xtitle("y(n)", "n", "");
subplot(3, 1, 2); plot2d3(n, yss, style=2); xtitle("Dap ung xac lap y_ss(n)", "n", "");
subplot(3, 1, 3); plot2d3(n, ytr, style=5); xtitle("Dap ung qua do y_tr(n)", "n", "");

// ==== Bai 2.29
a = 0.8;
NM = [4 7; 7 4];                      // hai truong hop N <= M va N > M
for c = 1:2
    N = NM(c, 1); M = NM(c, 2);
    h1 = a.^(0:N-1);                  // a^n [u(n) - u(n-N)]
    h2 = ones(1, M);                  // u(n) - u(n-M)
    [h, horigin] = convolution(h1, 1, h2, 1);
    n = 0:N+M-2;
    h_cf = zeros(1, length(n));
    for i = 1:length(n)
        k1 = max(0, n(i) - M + 1); k2 = min(n(i), N - 1);
        h_cf(i) = (a^k1 - a^(k2+1))/(1 - a);
    end
    mprintf("N = %d, M = %d: horigin = %d, sai so = %g\n", N, M, horigin, max(abs(h - h_cf)));
    disp(h);
end

// ==== Bai 2.30
N = 10; n = 0:N-1;
x = 4.^n;
y = filter([1, 2], [1, -3, -4], x);   // he nghi ban dau
y_cf = 6/5*n.*4.^n + 26/25*4.^n - 1/25*(-1).^n;
disp("   n   y(n) filter   y(n) cong thuc");
disp([n', y', y_cf']);
mprintf("Sai so tuong doi: %g\n", max(abs(y - y_cf)./abs(y)));
figure();
plot2d3(n, y, style=2);
xtitle("Bai 2.30: y(n) voi x(n) = 4^n u(n)", "n", "y(n)");

// ==== Bai 2.31
N = 10; n = 0:N-1;
d = [1, zeros(1, N-1)];               // delta(n)
h = filter([1, 2], [1, -3, -4], d);
h_cf = 6/5*4.^n - 1/5*(-1).^n;
disp("   n   h(n) filter   h(n) cong thuc");
disp([n', h', h_cf']);
mprintf("Sai so tuong doi: %g\n", max(abs(h - h_cf)./abs(h)));
figure();
plot2d3(n, h, style=2);
xtitle("Bai 2.31: dap ung xung h(n)", "n", "h(n)");

// ==== Bai 2.32
// x(n) = 1, -2 <= n <= 4 (xorigin = 3); h(n) = 2, -1 <= n <= 2 (horigin = 2)
[y, yorigin] = convolution(ones(1, 7), 3, 2*ones(1, 4), 2);
L1 = 1 - yorigin; L2 = L1 + length(y) - 1;
disp(y);
mprintf("yorigin = %d, L1 = %d, L2 = %d\n", yorigin, L1, L2);

// ==== Bai 2.33
N = 15; n = 0:N-1;
d = [1, zeros(1, N-1)];               // delta(n)
u = ones(1, N);                       // u(n)
// (a)
ha = filter(1, [1, -0.6, 0.08], d);
sa = filter(1, [1, -0.6, 0.08], u);
ha_cf = 2*0.4.^n - 0.2.^n;
sa_cf = 25/12 - 4/3*0.4.^n + 1/4*0.2.^n;
// (b)
hb = filter([2, 0, -1], [1, -0.7, 0.1], d);
sb = filter([2, 0, -1], [1, -0.7, 0.1], u);
hb_cf = -10*d - 10/3*0.5.^n + 46/3*0.2.^n;
sb_cf = 5/2 + 10/3*0.5.^n - 23/6*0.2.^n;
mprintf("(a) sai so h: %g, sai so s: %g\n", max(abs(ha - ha_cf)), max(abs(sa - sa_cf)));
mprintf("(b) sai so h: %g, sai so s: %g\n", max(abs(hb - hb_cf)), max(abs(sb - sb_cf)));
disp("hb(0..4) ="); disp(hb(1:5));
disp("sb(0..4) ="); disp(sb(1:5));
figure();
subplot(2, 2, 1); plot2d3(n, ha, style=2); xtitle("(a) h(n)", "n", "");
subplot(2, 2, 3); plot2d3(n, sa, style=5); xtitle("(a) s(n)", "n", "");
subplot(2, 2, 2); plot2d3(n, hb, style=2); xtitle("(b) h(n)", "n", "");
subplot(2, 2, 4); plot2d3(n, sb, style=5); xtitle("(b) s(n)", "n", "");

// ==== Bai 2.34
h = 0.5.^(0:4);                       // h(n) = (1/2)^n, 0 <= n <= 4
y = [1, 2, 2.5, 3, 3, 3, 2, 1, 0];    // y(n), 0 <= n <= 8
x = filter(1, h, y);                  // giai chap: X(z) = Y(z) / H(z)
disp("x(n), 0 <= n <= 8:"); disp(x);
disp("x(n) * 128:");        disp(x*128);
[yc, ycorigin] = convolution(x, 1, h, 1);     // kiem tra lai y = x * h
mprintf("max|(x*h)(n) - y(n)|, 0 <= n <= 8: %g\n", max(abs(yc(1:9) - y)));

// ==== Bai 2.35
L = 20;                               // so mau dung de bieu dien cac tin hieu dai vo han
n = 0:L-1;
h1 = [1/2, 1/4, 1/2];
h2 = n + 1;  h3 = n + 1;              // (n + 1)u(n), cat ngan con L mau
h4 = [0, 0, 1];                       // delta(n - 2)
[h34, o34] = convolution(h3, 1, h4, 1);
g = h2 - h34(1:L);                    // h2(n) - h3(n)*h4(n)
[h, horigin] = convolution(h1, 1, g, 1);
h = h(1:L);                           // chi giu cac mau chinh xac, 0 <= n <= L-1
disp("h(n), 0 <= n <= 7:"); disp(h(1:8));
// (c) x(n) = delta(n+2) + 3delta(n-1) - 4delta(n-3), n = -2..3 (xorigin = 3)
x = [1, 0, 0, 3, 0, -4];
[y, yorigin] = convolution(x, 3, h, 1);
disp("y(n), -2 <= n <= 8:"); disp(y(1:11));
mprintf("yorigin = %d\n", yorigin);
