n = -1:1;
x = [1, 3, -2];
x_rev = [x(3), x(2), x(1)];
xe = 0.5 * (x + x_rev);
xo = 0.5 * (x - x_rev);

clf();

// 1. Tín hiệu gốc x(n)
subplot(3, 1, 1);
plot2d3(n, x);
plot(n, x, 'r.'); // Vẽ dấu chấm tròn đỏ ở đầu mút
title('Original Signal x(n)');
xlabel('n'); ylabel('x(n)');
a1 = gca();
a1.data_bounds = [-2, -3; 2, 4]; // Mở rộng khung trục x: [-2, 2], trục y: [-3, 4]
xgrid(color('gray'));

// 2. Thành phần chẵn xe(n)
subplot(3, 1, 2);
plot2d3(n, xe);
plot(n, xe, 'b.'); // Đầu mút tròn xanh dương
title('Even Component x_e(n)');
xlabel('n'); ylabel('x_e(n)');
a2 = gca();
a2.data_bounds = [-2, -2; 2, 4];
xgrid(color('gray'));

// 3. Thành phần lẻ xo(n)
subplot(3, 1, 3);
plot2d3(n, xo);
plot(n, xo, 'm.'); // Đầu mút tròn hồng tím - hiển thị rõ điểm xo(0) = 0
title('Odd Component x_o(n)');
xlabel('n'); ylabel('x_o(n)');
a3 = gca();
a3.data_bounds = [-2, -3; 2, 3];
xgrid(color('gray'));
