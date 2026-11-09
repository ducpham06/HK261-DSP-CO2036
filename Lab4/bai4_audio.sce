// ============================================================
// Lab 4 - Exercise 4: Audio Processing Demo
// ============================================================
clc; clear;

try
    cd(get_absolute_file_path("bai1_audio.sce"));
end
if ~isdir("images") then mkdir("images"); end

// 1. Tao tin hieu am thanh tong hop
Fs = 8000;
duration = 1.0;
t = 0:(1/Fs):(duration - 1/Fs);

f1 = 440; f2 = 880;
audio_clean = 0.5*sin(2*%pi*f1*t) + 0.3*sin(2*%pi*f2*t);
audio_noisy = audio_clean + 0.05*rand(t, "normal");

audio_noisy = 0.9 * audio_noisy / max(abs(audio_noisy));

// 2. Ghi vao tep WAV va doc lai
wavwrite(audio_noisy, Fs, 16, "demo_audio.wav");
[y_audio, Fs_read, nbits] = wavread("demo_audio.wav");
y_audio = y_audio(1, :);

mprintf("Doc tep thanh cong: Fs = %d Hz, %d bits, %d mau\n", ..
        Fs_read, nbits, length(y_audio));
mprintf("Sai so lon nhat do luong tu hoa 16 bit: %.2e\n", ..
        max(abs(y_audio - audio_noisy)));

// 3. Phan tich pho bien do bang FFT
N = length(y_audio);
Y = fft(y_audio);
f_axis = (0:(N/2 - 1)) * (Fs / N);
mag_spec = abs(Y(1:(N/2))) * (2 / N);

[mag_sorted, idx] = gsort(mag_spec, "g", "d");
f_peaks = gsort(f_axis(idx(1:2)), "g", "i");
mprintf("Hai dinh pho tim duoc: %.1f Hz va %.1f Hz\n", f_peaks(1), f_peaks(2));

// 4. Ve dang song va pho tan so
fig = figure();
fig.figure_size = [900, 700];
fig.background = 8;

subplot(2, 1, 1);
n_show = 200;
plot(t(1:n_show), audio_clean(1:n_show)*0.9/max(abs(audio_clean)), "k--");
plot(t(1:n_show), y_audio(1:n_show), "b-");
a = gca();
a.data_bounds = [0, -1; t(n_show), 1.6];
a.tight_limits = "on";
legend(["Tin hieu sach", "Tin hieu co nhieu (doc tu WAV)"], "in_upper_right");
xtitle("Dang song am thanh mien thoi gian (200 mau dau)", "Thoi gian (s)", "Bien do");

subplot(2, 1, 2);
plot(f_axis, mag_spec, "r-");
a = gca();
a.data_bounds = [0, 0; 1500, max(mag_spec)*1.15];
xtitle("Pho bien do FFT cua tin hieu am thanh", "Tan so (Hz)", "Bien do");

xs2png(fig, "images/audio_plot.png");

// 5. (Tuy chon) Spectrogram bang ham mapsound co san
try
    fig2 = figure();
    fig2.background = 8;
    mapsound(y_audio, 0.05, [0, 1500], Fs);
    xtitle("Spectrogram (mapsound)");
    xs2png(fig2, "images/audio_spectrogram.png");
catch
    mprintf("Bo qua spectrogram: %s\n", lasterror());
end

// 6. (Tuy chon) Phat am thanh qua loa - bo comment neu muon nghe
// playsnd(y_audio, Fs);
