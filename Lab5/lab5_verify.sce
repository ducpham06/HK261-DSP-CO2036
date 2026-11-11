// Lab 5 - Verification of analytical results with Scilab
// Bai 2 (convolution), Bai 5 (h, y_zi, y_zs), Bai 3.14 (causal inverse z-transform)
clear; clc;
mkdir("images");

// Solves sum_k a(k) y(n-k) = sum_k b(k) x(n-k) recursively.
// yi = [y(-1) y(-2) ...] holds the initial conditions.
function y = sai_phan(b, a, x, yi)
    b = b / a(1); a = a / a(1);
    N = length(x); y = zeros(1, N);
    for k = 1:N
        v = 0;
        for i = 1:length(b)
            if k-i+1 >= 1 then v = v + b(i)*x(k-i+1); end
        end
        for i = 2:length(a)
            if k-i+1 >= 1 then
                v = v - a(i)*y(k-i+1);
            else
                v = v - a(i)*yi(i-k);
            end
        end
        y(k) = v;
    end
endfunction

// Maximum relative error between numerical (u) and analytical (v) results
function e = sai_so(u, v)
    e = max(abs(u - v)) / max(1, max(abs(v)));
endfunction

// ============================================================
// Bai 2: convolution via convol vs. closed form
// ============================================================
n = 0:14; N = length(n);

y2a = convol([1 2 3 4 5], [1 1 1]);

y2b  = convol((1/5).^n, 2.^n);  y2b = y2b(1:N);
y2ba = (10/9)*2.^n - (1/9)*(1/5).^n;

x2c = 2.^n;  x2c(1) = 0;                    // 2^n u(n-1)
y2c  = convol(n, x2c);  y2c = y2c(1:N);
y2ca = 2.^(n+1) - 2*n - 2;

mprintf("===== Bai 2 =====\n");
mprintf("2a: x1*x2 = %s\n", strcat(string(y2a), " "));
mprintf("2b: relative error = %.2e\n", sai_so(y2b, y2ba));
mprintf("2c: relative error = %.2e\n", sai_so(y2c, y2ca));
mprintf("2c: first samples  = %s\n", strcat(string(y2c(1:7)), " "));

f = scf(1); clf(f);
subplot(3,1,1); plot2d3(0:6, y2a); title("Bai 2a: x_1(n)*x_2(n)");
subplot(3,1,2); plot2d3(n, y2b); plot2d(n, y2ba, -9);
title("Bai 2b: convol (stems) vs. closed form (circles)");
subplot(3,1,3); plot2d3(n, y2c); plot2d(n, y2ca, -9);
title("Bai 2c: convol (stems) vs. closed form (circles)");
xs2png(f, "images/bai2_scilab.png");

// ============================================================
// Bai 5: y(n) = 2y(n-1) - 3y(n-2) + x(n) + x(n-1)
// ============================================================
n = 0:12; N = length(n);
d  = [1 zeros(1, N-1)];
th = atan(sqrt(2)); r = sqrt(3);
b5 = [1 1]; a5 = [1 -2 3];

h5   = sai_phan(b5, a5, d, [0 0]);
h5a  = r.^n .* (cos(th*n) + sqrt(2)*sin(th*n));
yzi  = sai_phan(b5, a5, zeros(1, N), [1 1]);          // y(-1) = y(-2) = 1
yzia = -r.^n .* (cos(th*n) + 2*sqrt(2)*sin(th*n));
yzs  = sai_phan(b5, a5, 2.^n, [0 0]);                 // x(n) = 2^n u(n)
yzsa = 2.^(n+1) - r.^n .* (cos(th*n) - sqrt(2)*sin(th*n));

mprintf("\n===== Bai 5 =====\n");
mprintf("h(n)    : error = %.2e | %s\n", sai_so(h5, h5a),   strcat(string(h5(1:6)), " "));
mprintf("y_zi(n) : error = %.2e | %s\n", sai_so(yzi, yzia), strcat(string(yzi(1:6)), " "));
mprintf("y_zs(n) : error = %.2e | %s\n", sai_so(yzs, yzsa), strcat(string(yzs(1:6)), " "));

f = scf(2); clf(f);
subplot(3,1,1); plot2d3(n, h5);  plot2d(n, h5a, -9);  title("Bai 5b: h(n)");
subplot(3,1,2); plot2d3(n, yzi); plot2d(n, yzia, -9); title("Bai 5c: y_zi(n)");
subplot(3,1,3); plot2d3(n, yzs); plot2d(n, yzsa, -9); title("Bai 5d: y_zs(n)");
xs2png(f, "images/bai5_scilab.png");

// ============================================================
// Bai 3.14: causal x(n) = impulse response of X(z) = B(z^-1)/A(z^-1)
// ============================================================
n = 0:19; N = length(n);
d  = [1 zeros(1, N-1)];
q  = 1/sqrt(2); aa = 0.6;                             // aa: value of a used in (j)
xc = zeros(1, N); xc(7:N) = 1; xc(8:N) = xc(8:N) + 1; // u(n-6) + u(n-7)

B = list([1 3], [1], [0 0 0 0 0 0 1 1], [1 0 2], [1 6 1]/4, ..
         [2 -1.5], [1 2 1], convol([1 0.5], [1 0.25])/4, [1 -0.5], [1 -aa]);
A = list([1 3 2], [1 -1 0.5], [1 -1], [1 0 1], convol([1 -2 2], [1 -0.5]), ..
         [1 -1.5 0.5], [1 4 4], convol([1 -0.5], [1 -1 0.5]), [1 0.5], [-aa 1]);
XA = list(2*(-1).^n - (-2).^n, ..
          q.^n .* (cos(%pi*n/4) + sin(%pi*n/4)), ..
          xc, ..
          2*d - cos(%pi*n/2), ..
          (17/20)*0.5.^n + sqrt(2).^n .* (-0.6*cos(%pi*n/4) + 2.3*sin(%pi*n/4)), ..
          1 + 0.5.^n, ..
          d/4 + (n+3)/4 .* (-2).^n, ..
          0.75*0.5.^n + q.^n .* (-0.5*cos(%pi*n/4) + (7/8)*sin(%pi*n/4)), ..
          -d + 2*(-0.5).^n, ..
          -aa*d + (aa^2 - 1)*aa.^(-n-1));
nhan = ["a" "b" "c" "d" "e" "f" "g" "h" "i" "j"];

mprintf("\n===== Bai 3.14 (N = %d samples) =====\n", N);
for i = 1:10
    xs = sai_phan(B(i), A(i), d, zeros(1, length(A(i))));
    mprintf("(%s): error = %.2e | %s\n", nhan(i), sai_so(xs, XA(i)), ..
            strcat(string(round(1000*xs(1:5))/1000), " "));
end
