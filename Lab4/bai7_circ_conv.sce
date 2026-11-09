// ============================================================
// Lab 4 - Exercise 7: Circular Convolution & Energy
// ============================================================
clc; clear;

try
    cd(get_absolute_file_path("bai4_circ_conv.sce"));
end
if ~isdir("images") then mkdir("images"); end

function stem_plot(n, v, col, ttl, ylab)
    xmin = min(n) - 1; xmax = max(n) + 1;
    ymin = min([v, 0]) - 1.5; ymax = max([v, 0]) + 1.5;
    plot2d([xmin, xmax], [0, 0], style=1);
    plot2d3(n, v, style=col);
    e = gce(); e.children(1).thickness = 2;
    plot2d(n, v, style=-9);
    e = gce(); p = e.children(1);
    p.mark_size_unit = "point"; p.mark_size = 7;
    p.mark_foreground = col; p.mark_background = col;
    a = gca();
    a.data_bounds = [xmin, ymin; xmax, ymax];
    a.tight_limits = "on";
    ticks = xmin:xmax;
    a.x_ticks = tlist(["ticks", "locations", "labels"], ticks, string(ticks));
    a.sub_ticks = [0, 1];
    a.grid = [-1, 12];
    for i = 1:length(n)
        if v(i) >= 0 then dy = 0.3; else dy = -0.7; end
        xstring(n(i) + 0.1, v(i) + dy, string(v(i)));
    end
    xtitle(ttl, "n", ylab);
endfunction

function energy_plot(E, labels, ttl)
    bar(1:length(E), E, 0.5);
    a = gca();
    a.data_bounds = [0, 0; length(E) + 1, max(E) * 1.25];
    a.x_ticks = tlist(["ticks", "locations", "labels"], 1:length(E), labels);
    for i = 1:length(E)
        xstring(i - 0.1, E(i) + max(E) * 0.04, string(E(i)));
    end
    xtitle(ttl, "", "Nang luong");
endfunction

x = [1, 2, -3, 2, 1];
h = [1, 0, -1, -1, 1];
N = length(x);
M = length(h);

// 1. Folding & Shifting modulo N: y(n) = sum_{k=0}^{M-1} h(k) x((n-k) mod N)
y_circ_fold = zeros(1, N);
for n = 0:(N - 1)
    s = 0;
    for k = 0:(M - 1)
        s = s + h(k + 1) * x(pmodulo(n - k, N) + 1);
    end
    y_circ_fold(n + 1) = s;
end

// 2. Ma tran Circulant: C(r, c) = x((r - c) mod N), y = C*h
C_mat = zeros(N, N);
for r = 0:(N - 1)
    for c = 0:(N - 1)
        C_mat(r + 1, c + 1) = x(pmodulo(r - c, N) + 1);
    end
end
y_circ_matrix = (C_mat * h')';

// 3. Kiem chung bang DFT: y = IDFT( DFT(x) .* DFT(h) )
y_fft = real(ifft(fft(x) .* fft(h)));

// 4. Kiem chung quan he chong lan: y_circ(n) = sum_r y_lin(n + rN)
y_lin = convol(x, h);
y_alias = zeros(1, N);
for n = 0:(length(y_lin) - 1)
    y_alias(pmodulo(n, N) + 1) = y_alias(pmodulo(n, N) + 1) + y_lin(n + 1);
end

mprintf("Ma tran Circulant C:\n"); disp(C_mat);
mprintf("Folding & Shifting   : %s\n", strcat(string(y_circ_fold), "  "));
mprintf("Matrix (Circulant)   : %s\n", strcat(string(y_circ_matrix), "  "));
mprintf("IFFT(FFT(x).*FFT(h)) : %s\n", strcat(string(round(y_fft)), "  "));
mprintf("Tich chap tuyen tinh : %s\n", strcat(string(y_lin), "  "));
mprintf("Chong lan mod %d      : %s\n", N, strcat(string(y_alias), "  "));
mprintf("Sai lech lon nhat    : %g\n", ..
        max(abs([y_circ_fold - y_circ_matrix, y_circ_fold - y_fft, y_circ_fold - y_alias])));

// 5. Nang luong
Ex = sum(x.^2);
Eh = sum(h.^2);
Ey = sum(y_circ_fold.^2);
mprintf("Nang luong: Ex = %g, Eh = %g, Ey = %g\n", Ex, Eh, Ey);

// 6. Ve x(n), h(n), y(n) va nang luong tren cung 1 figure
fig = figure();
fig.figure_size = [900, 950];
fig.background = 8;

subplot(4, 1, 1); stem_plot(0:(N - 1), x, 2, "Tin hieu x(n) (mot chu ky, N = 5)", "x(n)");
subplot(4, 1, 2); stem_plot(0:(M - 1), h, 3, "Dap ung xung h(n)", "h(n)");
subplot(4, 1, 3); stem_plot(0:(N - 1), y_circ_fold, 5, "Tin hieu ra y(n) (tich chap vong N = 5)", "y(n)");
subplot(4, 1, 4); energy_plot([Ex, Eh, Ey], ["Ex", "Eh", "Ey"], "So sanh nang luong");

xs2png(fig, "images/circ_conv_plot.png");
