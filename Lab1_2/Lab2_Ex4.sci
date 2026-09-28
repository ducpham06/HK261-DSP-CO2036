n = -5:5;
ur = n .* bool2s(n >= 0);
plot2d3(n, ur);
title('Unit Ramp Signal u_r(n)');
xlabel('n'); ylabel('Amplitude');
