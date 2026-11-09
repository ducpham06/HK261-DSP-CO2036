// ============================================================
// Lab 4 - Exercise 5: Image Processing Demo
// ============================================================
clc; clear;

try
    cd(get_absolute_file_path("bai5_image.sce"));
end
if ~isdir("images") then mkdir("images"); end

function hst = compute_hist(img)
    hst = zeros(1, 256);
    for g = 0:255
        hst(g + 1) = sum(img == g);
    end
endfunction

function show_img(img, ttl)
    Matplot(min(max(round(img), 0), 255) + 1);
    a = gca();
    a.isoview = "on";
    a.axes_visible = ["off", "off", "off"];
    xtitle(ttl);
endfunction

// 1. Tao anh muc xam kiem thu 128x128, do tuong phan thap (60..200)
M = 128; N = 128;
[X, Y] = meshgrid(1:N, 1:M);
img_orig = round(110 + 30*sin(X/15) + 20*cos(Y/20));
circle_mask = ((X - 64).^2 + (Y - 64).^2) < 25^2;
img_orig(circle_mask) = img_orig(circle_mask) + 40;
img_orig = max(0, min(255, img_orig));

// Ky thuat 1: Histogram anh goc
hist_orig = compute_hist(img_orig);

// Ky thuat 2: Can bang histogram qua ham phan phoi tich luy (CDF)
cdf = cumsum(hist_orig);
cdf_min = min(cdf(cdf > 0));
T = round((cdf - cdf_min) / (M*N - cdf_min) * 255);
T = max(T, 0);
img_eq = matrix(T(img_orig(:) + 1), M, N);
hist_eq = compute_hist(img_eq);

mprintf("Dai muc xam anh goc:       [%d, %d]\n", min(img_orig), max(img_orig));
mprintf("Dai muc xam sau can bang:  [%d, %d]\n", min(img_eq), max(img_eq));

// Ky thuat 3: Lam mo bang bo loc trung binh 5x5
h_blur = ones(5, 5) / 25;
img_blurred = conv2(img_orig, h_blur, "same") ./ conv2(ones(M, N), h_blur, "same");

// Ky thuat 4: Thuy van so LSB (dau "+")
watermark = zeros(M, N);
watermark(60:68, 30:98) = 1;
watermark(30:98, 60:68) = 1;
img_watermarked = 2 * floor(img_orig / 2) + watermark;
watermark_extracted = pmodulo(img_watermarked, 2);

n_err = sum(watermark_extracted <> watermark);
mse = mean((img_watermarked - img_orig).^2);
psnr = 10 * log10(255^2 / mse);
mprintf("So bit thuy van trich xuat sai: %d\n", n_err);
mprintf("PSNR anh da nhung thuy van: %.2f dB\n", psnr);

fig = figure();
fig.figure_size = [1200, 650];
fig.background = 8;
try
    cmap = gray(256);
catch
    cmap = graycolormap(256);
end
fig.color_map = cmap;
fig.background = 256;

subplot(2, 4, 1); show_img(img_orig, "1. Anh goc");
subplot(2, 4, 2);
plot2d3(0:255, hist_orig, style=2);
xtitle("2. Histogram anh goc", "Muc xam", "So diem anh");
subplot(2, 4, 3); show_img(img_eq, "3. Can bang histogram");
subplot(2, 4, 4);
plot2d3(0:255, hist_eq, style=2);
xtitle("4. Histogram sau can bang", "Muc xam", "So diem anh");
subplot(2, 4, 5); show_img(img_blurred, "5. Lam mo (mean 5x5)");
subplot(2, 4, 6); show_img(img_watermarked, "6. Anh da nhung LSB");
subplot(2, 4, 7); show_img(abs(img_watermarked - img_orig)*255, "7. Sai khac (x255)");
subplot(2, 4, 8); show_img(watermark_extracted*255, "8. Thuy van trich xuat");

xs2png(fig, "images/image_plot.png");
