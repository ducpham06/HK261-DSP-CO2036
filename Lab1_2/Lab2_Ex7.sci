clf();
n1 = 0:3;
x1 = [0, 1, 3, -2];
n2 = -1:2;
x2 = [0, 1, 2, 3];

n_min = min(min(n1), min(n2));
n_max = max(max(n1), max(n2));
n = n_min:n_max; // n = -1:3

x1_ext = zeros(1, length(n));
x2_ext = zeros(1, length(n));

for k = 1:length(n1)
    idx = find(n == n1(k));
    x1_ext(idx) = x1(k);
end

for k = 1:length(n2)
    idx = find(n == n2(k));
    x2_ext(idx) = x2(k);
end

y = x1_ext .* x2_ext;

// 1. Đồ thị x1(n)
subplot(3, 1, 1);
plot2d3(n, x1_ext, style=5);
plot(n, x1_ext, 'r.');
xtitle("x1(n)", "n", "x1(n)");
a1 = gca();
a1.data_bounds = [-2, -3; 4, 4]; // Mở rộng x từ -2 đến 4, y từ -3 đến 4
xgrid();

// 2. Đồ thị x2(n)
subplot(3, 1, 2);
plot2d3(n, x2_ext, style=5);
plot(n, x2_ext, 'b.');
xtitle("x2(n)", "n", "x2(n)");
a2 = gca();
a2.data_bounds = [-2, -1; 4, 4]; // Mở rộng x từ -2 đến 4, y từ -1 đến 4
xgrid();

// 3. Đồ thị y(n)
subplot(3, 1, 3);
plot2d3(n, y, style=5);
plot(n, y, 'm.');
xtitle("y(n) = x1(n) * x2(n)", "n", "y(n)");
a3 = gca();
a3.data_bounds = [-2, -1; 4, 11]; // Mở rộng y lên 11 để chứa đỉnh giá trị 9
xgrid();
