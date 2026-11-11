// Exercise 3.20 - pole-zero plot of x1(n) = r^n sin(w0 n) u(n)
clear; clc;

r  = 0.8;            // 0 < r < 1
w0 = 50 * %pi/180;   // 50 degrees

z   = poly(0, "z");
num = r*sin(w0) * z;                    // zero at z = 0
den = z^2 - 2*r*cos(w0)*z + r^2;        // poles at r*exp(+-j*w0)
X1  = syslin("d", num, den);

// Print the computed poles/zeros for confirmation
disp("Poles:");  disp(roots(den));
disp("|poles|:"); disp(abs(roots(den)));
disp("angle (deg):"); disp(atan(imag(roots(den)), real(roots(den))) * 180/%pi);
disp("Zeros:");  disp(roots(num));

// Plot
f = scf(0); clf(f);
plzr(X1);                               // poles (x), zeros (o), unit circle
xarc(-r, r, 2*r, 2*r, 0, 360*64);       // ROC boundary |z| = r
e = gce(); e.line_style = 2; e.foreground = color("blue");
title("Bai 3.20: x_1(n) = r^n sin(w_0 n) u(n),  r = 0.8,  w_0 = 50 deg");

mkdir("images");
xs2png(f, "images/bai3_20_plzr.png");
