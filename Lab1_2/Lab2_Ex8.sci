// Dữ liệu tín hiệu gốc
n = -2:1;
x = [1, -2, 3, 6];

// ============================================================
// Cặp 1: y1(n) = x(-n)
// ============================================================
n1 = -1:2;
y1 = [x(4), x(3), x(2), x(1)];

scf(1); clf();

// Tín hiệu gốc x(n)
subplot(2, 1, 1);
plot2d3(n, x);
plot(n, x, 'r.');
title('Original Signal x(n)');
xlabel('n'); ylabel('x(n)');
a1 = gca();
a1.data_bounds = [-3, -3; 2, 7];
xgrid(color('gray'));

// Tín hiệu đảo y1(n)
subplot(2, 1, 2);
plot2d3(n1, y1);
plot(n1, y1, 'b.');
title('Folding Signal y_1(n) = x(-n)');
xlabel('n'); ylabel('y_1(n)');
a2 = gca();
a2.data_bounds = [-2, -3; 3, 7];
xgrid(color('gray'));

// ============================================================
// Cặp 2: y2(n) = x(n+3)
// ============================================================
n2 = n - 3; // n2 = -5:-2
y2 = x;

scf(2); clf();

// Tín hiệu gốc x(n)
subplot(2, 1, 1);
plot2d3(n, x);
plot(n, x, 'r.');
title('Original Signal x(n)');
xlabel('n'); ylabel('x(n)');
a3 = gca();
a3.data_bounds = [-3, -3; 2, 7];
xgrid(color('gray'));

// Tín hiệu dịch sớm y2(n)
subplot(2, 1, 2);
plot2d3(n2, y2);
plot(n2, y2, 'b.');
title('Advanced Signal y_2(n) = x(n+3)');
xlabel('n'); ylabel('y_2(n)');
a4 = gca();
a4.data_bounds = [-6, -3; -1, 7];
xgrid(color('gray'));

// ============================================================
// Cặp 3: y3(n) = 2*x(-n-2)
// ============================================================
n3 = -3:0;
y3 = 2 * [x(4), x(3), x(2), x(1)];

scf(3); clf();

// Tín hiệu gốc x(n)
subplot(2, 1, 1);
plot2d3(n, x);
plot(n, x, 'r.');
title('Original Signal x(n)');
xlabel('n'); ylabel('x(n)');
a5 = gca();
a5.data_bounds = [-3, -3; 2, 7];
xgrid(color('gray'));

// Tín hiệu biến đổi y3(n)
subplot(2, 1, 2);
plot2d3(n3, y3);
plot(n3, y3, 'b.');
title('Scaled & Folded Signal y_3(n) = 2*x(-n-2)');
xlabel('n'); ylabel('y_3(n)');
a6 = gca();
a6.data_bounds = [-4, -5; 1, 14]; // Mở rộng y lên 14 để chứa đỉnh 12 và xuống -5 để chứa -4
xgrid(color('gray'));
