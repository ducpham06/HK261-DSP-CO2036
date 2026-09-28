clf();

// 1. Tín hiệu liên tục
F0 = 50; T0 = 1 / F0;
t = 0 : 0.0001 : 5 * T0;
xa = 3 * sin(100 * %pi * t);

// 2. Lấy mẫu
Fs = 300; N_period = 6;
n = 0 : (5 * N_period - 1);
xn = 3 * sin(100 * %pi * n / Fs);

// 3. Lượng tử hóa
Delta = 0.1;
xq = floor(xn / Delta) * Delta;

// Hiển thị trên cùng một cửa sổ đồ họa
clf();
subplot(3, 1, 1);
plot(t, xa);
title('Continuous Signal x_a(t) = 3*sin(100*%pi*t)');
xlabel('t (seconds)'); ylabel('Amplitude');

subplot(3, 1, 2);
plot2d3(n, xn);
title('Sampled Discrete Signal x(n) (Fs = 300 Hz, N = 6)');
xlabel('n (samples)'); ylabel('Amplitude');

subplot(3, 1, 3);
plot2d3(n, xq);
title('Quantized Signal x_q(n) with Delta = 0.1 (Truncated)');
xlabel('n (samples)'); ylabel('Amplitude');
