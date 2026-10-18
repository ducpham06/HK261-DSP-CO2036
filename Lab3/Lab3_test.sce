// ============================================================
// DSP Lab 3 - Test cases for Exercises 1 - 6
// Pham Minh Duc - 2414106
// Run from the folder containing Lab3.sci
// ============================================================
exec("Lab3.sci", -1);

// ==== Bai 1
// y(n) = x(n - 1), x(n) = {1, -2, 3(goc), 6}
[yn, yorigin] = delay([1, -2, 3, 6], 3, 1);
mprintf("Bai 1 - delay:   yn = %s, yorigin = %d\n", sci2exp(yn), yorigin);
mprintf("     mong doi:   yn = [1,-2,3,6], yorigin = 2\n");

// ==== Bai 2
// y(n) = x(n + 1), x(n) = {1, -2, 3(goc), 6}
[yn, yorigin] = advance([1, -2, 3, 6], 3, 1);
mprintf("Bai 2 - advance: yn = %s, yorigin = %d\n", sci2exp(yn), yorigin);
mprintf("     mong doi:   yn = [1,-2,3,6], yorigin = 4\n");

// ==== Bai 3
// y(n) = x(-n), x(n) = {1, -2, 3(goc), 6}
[yn, yorigin] = fold([1, -2, 3, 6], 3);
mprintf("Bai 3 - fold:    yn = %s, yorigin = %d\n", sci2exp(yn), yorigin);
mprintf("     mong doi:   yn = [6,3,-2,1], yorigin = 2\n");

// ==== Bai 4
// x1(n) = {0(goc), 1, 3, -2}, x2(n) = {1, 1(goc), 2, 3}
[yn, yorigin] = add([0, 1, 3, -2], 1, [1, 1, 2, 3], 2);
mprintf("Bai 4 - add:     yn = %s, yorigin = %d\n", sci2exp(yn), yorigin);
mprintf("     mong doi:   yn = [1,1,3,6,-2], yorigin = 2\n");

// ==== Bai 5
// x1(n) = {0(goc), 1, 3, -2}, x2(n) = {1, 1(goc), 2, 3}
[yn, yorigin] = multi([0, 1, 3, -2], 1, [1, 1, 2, 3], 2);
mprintf("Bai 5 - multi:   yn = %s, yorigin = %d\n", sci2exp(yn), yorigin);
mprintf("     mong doi:   yn = [0,0,2,9,0], yorigin = 2\n");

// ==== Bai 6
// x(n) = 1, -2 <= n <= 4; h(n) = 2, -1 <= n <= 2 (Bai 2.32c)
[yn, yorigin] = convolution(ones(1, 7), 3, 2*ones(1, 4), 2);
mprintf("Bai 6 - convolution: yn = %s, yorigin = %d\n", sci2exp(yn), yorigin);
mprintf("         mong doi:   yn = [2,4,6,8,8,8,8,6,4,2], yorigin = 4\n");
