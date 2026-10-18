// ============================================================
// DSP Lab 3 - Discrete-time signal manipulation
// Pham Minh Duc - 2414106
// Convention: xorigin is the (1-based) index of n = 0 in xn,
//             so sample xn(i) is located at n = i - xorigin.
// ============================================================

// Helper: stem plot with margins so edge samples and the zero line are visible
function stemplot(n, x, s)
    ymin = min(0, min(x)); ymax = max(0, max(x));
    pad = 0.1*max(1, ymax - ymin);
    plot2d3(n, x, style=s, rect=[min(n) - 1, ymin - pad, max(n) + 1, ymax + pad]);
endfunction

function [yn, yorigin] = delay(xn, xorigin, k)
    yn = xn;
    yorigin = xorigin - k;
    nx = (1:length(xn)) - xorigin;
    ny = nx + k;
    figure();
    subplot(2, 1, 1);
    stemplot(nx, xn, 2);
    xtitle("Original Signal x(n)", "n", "x(n)");
    subplot(2, 1, 2);
    stemplot(ny, yn, 5);
    xtitle("Delayed Signal y(n) = x(n - " + string(k) + ")", "n", "y(n)");
endfunction

function [yn, yorigin] = advance(xn, xorigin, k)
    yn = xn;
    yorigin = xorigin + k;
    nx = (1:length(xn)) - xorigin;
    ny = nx - k;
    figure();
    subplot(2, 1, 1);
    stemplot(nx, xn, 2);
    xtitle("Original Signal x(n)", "n", "x(n)");
    subplot(2, 1, 2);
    stemplot(ny, yn, 5);
    xtitle("Advanced Signal y(n) = x(n + " + string(k) + ")", "n", "y(n)");
endfunction

function [yn, yorigin] = fold(xn, xorigin)
    yn = xn($:-1:1);
    nx = (1:length(xn)) - xorigin;
    ny = -nx($:-1:1);
    yorigin = length(xn) + 1 - xorigin;
    figure();
    subplot(2, 1, 1);
    stemplot(nx, xn, 2);
    xtitle("Original Signal x(n)", "n", "x(n)");
    subplot(2, 1, 2);
    stemplot(ny, yn, 5);
    xtitle("Folded Signal y(n) = x(-n)", "n", "y(n)");
endfunction

function [yn, yorigin] = add(x1n, x1origin, x2n, x2origin)
    n1 = (1:length(x1n)) - x1origin;
    n2 = (1:length(x2n)) - x2origin;
    n_min = min(min(n1), min(n2));
    n_max = max(max(n1), max(n2));
    ny = n_min:n_max;
    yorigin = 1 - n_min;
    y1 = zeros(1, length(ny));
    y2 = zeros(1, length(ny));
    idx1 = (n1(1) - n_min + 1):(n1($) - n_min + 1);
    idx2 = (n2(1) - n_min + 1):(n2($) - n_min + 1);
    y1(idx1) = x1n;
    y2(idx2) = x2n;
    yn = y1 + y2;
    figure();
    subplot(3, 1, 1);
    stemplot(n1, x1n, 2);
    xtitle("Signal x1(n)", "n", "x1(n)");
    subplot(3, 1, 2);
    stemplot(n2, x2n, 3);
    xtitle("Signal x2(n)", "n", "x2(n)");
    subplot(3, 1, 3);
    stemplot(ny, yn, 5);
    xtitle("Sum Signal y(n) = x1(n) + x2(n)", "n", "y(n)");
endfunction

function [yn, yorigin] = multi(x1n, x1origin, x2n, x2origin)
    n1 = (1:length(x1n)) - x1origin;
    n2 = (1:length(x2n)) - x2origin;
    n_min = min(min(n1), min(n2));
    n_max = max(max(n1), max(n2));
    ny = n_min:n_max;
    yorigin = 1 - n_min;
    y1 = zeros(1, length(ny));
    y2 = zeros(1, length(ny));
    idx1 = (n1(1) - n_min + 1):(n1($) - n_min + 1);
    idx2 = (n2(1) - n_min + 1):(n2($) - n_min + 1);
    y1(idx1) = x1n;
    y2(idx2) = x2n;
    yn = y1 .* y2;
    figure();
    subplot(3, 1, 1);
    stemplot(n1, x1n, 2);
    xtitle("Signal x1(n)", "n", "x1(n)");
    subplot(3, 1, 2);
    stemplot(n2, x2n, 3);
    xtitle("Signal x2(n)", "n", "x2(n)");
    subplot(3, 1, 3);
    stemplot(ny, yn, 5);
    xtitle("Multiplication Signal y(n) = x1(n) . x2(n)", "n", "y(n)");
endfunction

function [yn, yorigin] = convolution(xn, xorigin, hn, horigin)
    yn = convol(xn, hn);
    n1_start = 1 - xorigin;
    n2_start = 1 - horigin;
    ny_start = n1_start + n2_start;
    yorigin = 1 - ny_start;
    nx = (1:length(xn)) - xorigin;
    nh = (1:length(hn)) - horigin;
    ny = ny_start:(ny_start + length(yn) - 1);
    figure();
    subplot(3, 1, 1);
    stemplot(nx, xn, 2);
    xtitle("Input Signal x(n)", "n", "x(n)");
    subplot(3, 1, 2);
    stemplot(nh, hn, 3);
    xtitle("Impulse Response h(n)", "n", "h(n)");
    subplot(3, 1, 3);
    stemplot(ny, yn, 5);
    xtitle("Convolution Output y(n) = x(n) * h(n)", "n", "y(n)");
endfunction
