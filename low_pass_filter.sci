// ===== WAV PROCESSING =====
wav_file = "F:\\achmadrzm\\!!KAMPUS\\4. SEMESTER 4\\Pemrosesan Sinyal\\project_akhir\\raw_record.wav";

wav_info = wavread(wav_file, "info");

wav_info_string = [
    'WAV encoding code: ',
    'WAV number of channels: ',
    'WAV sampling frequency (in Hz): ',
    'WAV average bytes per second: ',
    'WAV block alignment: ',
    'WAV bits per sample (per channel): ',
    'WAV bytes per sample (per channel): ',
    'WAV length of sound data (per channel): '];

for i = 1:8
    disp(wav_info_string(i) + string(wav_info(i)));
end

y = wavread(wav_file);
text = 'Number of data of wav file';
disp(text + " " + string(size(y)));


// ===== FFT PROCESSING =====
pi = %pi;
i = %i;
e = %e;

NUM_OF_SAMPLING = wav_info(3);
num_data = size(y, 2);
samples = 0 : (1/NUM_OF_SAMPLING) : (num_data-1)/NUM_OF_SAMPLING;

X = fft(y(1,:));
x_ifft = ifft(X)*-1;
half_size = num_data/2;

Half_X = zeros(1, half_size);
Half_n_frequencies = zeros(1, half_size);
for i = 1:half_size
   Half_X(i) = X(i)*2;
   Half_n_frequencies(i) = i * (NUM_OF_SAMPLING / num_data);
end


// ===== FIR LOW PASS FILTER PROCESSING =====
fc = 250;
fs = 2000;
M = 4;
w = (2 * %pi) * (fc / fs);
disp(w, 'Digital cutoff frequency in radians/cycles/samples');
wc = w / %pi;
disp(wc, 'Normalized digital cutoff frequency in cycles/samples');
[wft, wfm, fr] = wfir('lp', M + 1, [wc / 2, 0], 're', [0, 0]);
disp(wft, 'Impulse Response of LPF FIR Filter: h[n]=');

filtered_signal_fir = filter(wft, 1, y(1,:));

X_fir = fft(filtered_signal_fir);
Half_X_fir = zeros(1, half_size);
for i = 1:half_size
   Half_X_fir(i) = X_fir(i)*2;
end


// ===== PLOT =====
clf;
subplot(2,2,1), plot2d(samples, y(1,:)); 
title('Time Domain Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,2,2), plot2d(Half_n_frequencies, abs(Half_X)); 
title('Frequency Domain Signal (Single-Sided)');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

subplot(2,2,3);
plot2d(Half_n_frequencies, abs(Half_X_fir));
title('FFT of Filtered Signal with FIR LPF');
xlabel('Frequency (Hz)');
ylabel('Amplitude');


// ===== INTO TIME DOMAIN =====
subplot(2,2,4);
plot2d(samples, filtered_signal_fir);
title('Filtered Signal with FIR LPF');
xlabel('Time (s)');
ylabel('Amplitude');


// ===== FILTERED SIGNAL TO AUDIO WAV FILE =====
output_wav_file = "F:\\achmadrzm\\!!KAMPUS\\4. SEMESTER 4\\Pemrosesan Sinyal\\project_akhir\\processed_record.wav";
wavwrite(filtered_signal_fir, NUM_OF_SAMPLING, 16, output_wav_file);
disp("Filtered audio saved to " + output_wav_file);
