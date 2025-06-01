% MATLAB 程式: HW6_Complete_Analysis_Chinese_Comment.m
clear all;               % 清除工作空間中的所有變數
close all;               % 關閉所有已開啟的圖形視窗

% --- 載入並準備原始訊號 ---
ecg = load('ecg_hfn.dat'); % 載入ECG數據
fs_orig = 1000;            % 原始取樣頻率 = 1000 Hz
slen_orig = length(ecg);   % 原始訊號長度
t_orig = (0:slen_orig-1) / fs_orig; % 原始訊號的時間軸向量

% 繪製原始ECG訊號
figure; % 開啟新的圖形視窗
plot(t_orig, ecg);
axis tight; % 將座標軸範圍緊縮至數據範圍
xlabel('時間 (秒)');
ylabel('ECG 振幅');
title(['原始ECG訊號 (fs = ', num2str(fs_orig), ' Hz)']);

% --- 1. 手動下取樣 (每隔5點取1點) ---
% 實現 x_d[n] = x[5n]
downsample_factor = 5; % 下取樣因子
ecg_manual_downsampled = ecg(1:downsample_factor:end); % 執行直接下取樣
fs_downsampled = fs_orig / downsample_factor; % 新的取樣頻率 = 1000 Hz / 5 = 200 Hz
slen_manual_down = length(ecg_manual_downsampled); % 手動下取樣後訊號長度
t_manual_down = (0:slen_manual_down-1) / fs_downsampled; % 手動下取樣後的時間軸

% 繪製手動下取樣的訊號
figure;
plot(t_manual_down, ecg_manual_downsampled);
axis tight;
xlabel('時間 (秒)');
ylabel('ECG 振幅');
title(['手動下取樣ECG (每隔5點取1點, fs = ', num2str(fs_downsampled), ' Hz)']);

% --- 2. 使用 MATLAB 的 resample 函數進行下取樣 ---
% Y = resample(X, P, Q) 將 X 以 P/Q 倍的原始取樣率重新取樣
P = 1;
Q = downsample_factor; % 目標是下取樣5倍
ecg_resampled = resample(ecg, P, Q); % 使用resample函數
slen_resampled = length(ecg_resampled); % resample後訊號長度
% resample 函數會自動調整長度，新的取樣率為 fs_orig * P / Q
t_resampled = (0:slen_resampled-1) / fs_downsampled; % resample後的時間軸

% 繪製使用resample函數下取樣的訊號
figure;
plot(t_resampled, ecg_resampled);
axis tight;
xlabel('時間 (秒)');
ylabel('ECG 振幅');
title(['使用 resample() 下取樣的ECG訊號 (fs = ', num2str(fs_downsampled), ' Hz)']);

% --- 7. 時域比較 (視覺化) ---
figure;
subplot(3,1,1); % 將圖形視窗分割成3列1行，此為第1個子圖
plot(t_orig, ecg);
axis tight;
title('原始ECG訊號');
ylabel('振幅');

subplot(3,1,2); % 第2個子圖
plot(t_manual_down, ecg_manual_downsampled);
axis tight;
title('手動下取樣ECG');
ylabel('振幅');

subplot(3,1,3); % 第3個子圖
plot(t_resampled, ecg_resampled);
axis tight;
title('使用 resample() 下取樣的ECG');
ylabel('振幅');
xlabel('時間 (秒)');
sgtitle('時域比較 (完整訊號)'); % 整張圖的總標題

% --- 7. 頻域比較 (視覺化 - 完整訊號) ---
figure;
subplot(3,1,1);
plot_fft(ecg, fs_orig, '原始ECG的頻率響應');

subplot(3,1,2);
plot_fft(ecg_manual_downsampled, fs_downsampled, '手動下取樣ECG的頻率響應');

subplot(3,1,3);
plot_fft(ecg_resampled, fs_downsampled, '使用 resample() 下取樣ECG的頻率響應');
sgtitle('頻域比較 (完整訊號)'); % 整張圖的總標題

% --- 新增：獨立展示三個頻域訊號圖表 ---
figure; % 原始訊號頻譜
plot_fft(ecg, fs_orig, ['原始ECG訊號的頻率響應 (fs = ', num2str(fs_orig), ' Hz)']);

figure; % 手動下取樣訊號頻譜
plot_fft(ecg_manual_downsampled, fs_downsampled, ['手動下取樣ECG的頻率響應 (fs = ', num2str(fs_downsampled), ' Hz)']);

figure; % Resample後訊號頻譜
plot_fft(ecg_resampled, fs_downsampled, ['使用 resample() 下取樣ECG的頻率響應 (fs = ', num2str(fs_downsampled), ' Hz)']);
% --- 新增結束 ---


% --- 量化分析 ---
disp('--- 量化分析 ---');

% !!! 使用者操作需求 !!!
% 定義用於雜訊片段分析的時間區間。
% 請仔細觀察您繪製出的原始ECG圖，找到一段相對平坦、
% 主要由雜訊構成的等電位線區段。
% 例如，在 T 波結束到下一個 P 波開始之間。
noise_segment_start_time = 2.755; % 秒 - 此為範例值，請務必調整!
noise_segment_end_time = 2.955;   % 秒 - 此為範例值, 請務必調整!
% !!! 使用者操作需求結束 !!!

% 提取雜訊片段
% 原始訊號
idx_start_orig_noise = find(t_orig >= noise_segment_start_time, 1, 'first');
idx_end_orig_noise = find(t_orig <= noise_segment_end_time, 1, 'last');
segment_orig_noise = []; % 初始化為空，以防找不到片段
t_segment_orig_noise = [];
if ~isempty(idx_start_orig_noise) && ~isempty(idx_end_orig_noise) && idx_start_orig_noise < idx_end_orig_noise
    segment_orig_noise = ecg(idx_start_orig_noise:idx_end_orig_noise);
    t_segment_orig_noise = t_orig(idx_start_orig_noise:idx_end_orig_noise);
end

% 手動下取樣訊號
idx_start_manual_noise = find(t_manual_down >= noise_segment_start_time, 1, 'first');
idx_end_manual_noise = find(t_manual_down <= noise_segment_end_time, 1, 'last');
segment_manual_noise = [];
t_segment_manual_noise = [];
if ~isempty(idx_start_manual_noise) && ~isempty(idx_end_manual_noise) && idx_start_manual_noise < idx_end_manual_noise
    segment_manual_noise = ecg_manual_downsampled(idx_start_manual_noise:idx_end_manual_noise);
    t_segment_manual_noise = t_manual_down(idx_start_manual_noise:idx_end_manual_noise);
end

% Resample 後訊號
idx_start_resampled_noise = find(t_resampled >= noise_segment_start_time, 1, 'first');
idx_end_resampled_noise = find(t_resampled <= noise_segment_end_time, 1, 'last');
segment_resampled_noise = [];
t_segment_resampled_noise = [];
if ~isempty(idx_start_resampled_noise) && ~isempty(idx_end_resampled_noise) && idx_start_resampled_noise < idx_end_resampled_noise
    segment_resampled_noise = ecg_resampled(idx_start_resampled_noise:idx_end_resampled_noise);
    t_segment_resampled_noise = t_resampled(idx_start_resampled_noise:idx_end_resampled_noise);
end

% 繪製選定的雜訊片段以供確認
figure;
if ~isempty(segment_orig_noise)
    subplot(3,1,1); plot(t_segment_orig_noise, segment_orig_noise); title(['原始訊號雜訊片段 (',num2str(noise_segment_start_time),'s 至 ',num2str(noise_segment_end_time),'s)']); ylabel('振幅'); axis tight;
else
    disp('警告: 原始訊號的雜訊片段為空。請檢查時間定義。');
end
if ~isempty(segment_manual_noise)
    subplot(3,1,2); plot(t_segment_manual_noise, segment_manual_noise); title('手動下取樣雜訊片段'); ylabel('振幅'); axis tight;
else
    disp('警告: 手動下取樣的雜訊片段為空。請檢查時間定義。');
end
if ~isempty(segment_resampled_noise)
    subplot(3,1,3); plot(t_segment_resampled_noise, segment_resampled_noise); title('Resample後雜訊片段'); ylabel('振幅'); axis tight;
else
    disp('警告: Resample後的雜訊片段為空。請檢查時間定義。');
end
xlabel('時間 (秒)');
sgtitle('用於量化分析的選定雜訊片段');

% (1) 量化時域分析: 雜訊的峰對峰值
disp(' '); % 印出空行，方便閱讀
disp('1. 量化時域分析 (雜訊片段的峰對峰值):');
if ~isempty(segment_orig_noise)
    peak_to_peak_orig_noise = max(segment_orig_noise) - min(segment_orig_noise);
    disp(['   原始訊號雜訊片段的峰對峰值: ', num2str(peak_to_peak_orig_noise)]);
else
    disp('   無法計算原始訊號雜訊片段的峰對峰值 (片段為空)。');
end
if ~isempty(segment_manual_noise)
    peak_to_peak_manual_noise = max(segment_manual_noise) - min(segment_manual_noise);
    disp(['   手動下取樣雜訊片段的峰對峰值: ', num2str(peak_to_peak_manual_noise)]);
else
    disp('   無法計算手動下取樣雜訊片段的峰對峰值 (片段為空)。');
end
if ~isempty(segment_resampled_noise)
    peak_to_peak_resampled_noise = max(segment_resampled_noise) - min(segment_resampled_noise);
    disp(['   Resample後雜訊片段的峰對峰值: ', num2str(peak_to_peak_resampled_noise)]);
else
    disp('   無法計算Resample後雜訊片段的峰對峰值 (片段為空)。');
end

% (2) 量化頻域分析: 特定頻帶內的雜訊能量/振幅
disp(' ');
disp('2. 量化頻域分析 (雜訊片段):');

% 繪製雜訊片段的FFT
figure;
if ~isempty(segment_orig_noise)
    subplot(3,1,1); plot_fft(segment_orig_noise, fs_orig, '原始雜訊片段的FFT');
end
if ~isempty(segment_manual_noise)
    subplot(3,1,2); plot_fft(segment_manual_noise, fs_downsampled, '手動下取樣雜訊片段的FFT');
end
if ~isempty(segment_resampled_noise)
    subplot(3,1,3); plot_fft(segment_resampled_noise, fs_downsampled, 'Resample後雜訊片段的FFT');
end
sgtitle('選定雜訊片段的頻域比較');

% 定義感興趣的分析頻帶 (例如 0 Hz 到新的 Nyquist 頻率: 100 Hz)
analysis_band = [1, fs_downsampled/2 - 1]; % 例如 1 Hz 到 99 Hz (避免直流和精確的Nyquist頻率影響能量計算)
                                          % fs_downsampled/2 是新的 Nyquist 頻率 (100 Hz)
disp(['   分析頻帶: [', num2str(analysis_band(1)), ', ', num2str(analysis_band(2)), '] Hz']);

if ~isempty(segment_orig_noise) % 分析原始片段在該頻帶內的能量作為參考
    [energy_orig_noise_band, ~, ~] = calculate_band_energy(segment_orig_noise, fs_orig, analysis_band);
    disp(['   頻帶內雜訊能量 (原始片段, 參考fs_orig): ', num2str(energy_orig_noise_band)]);
end
if ~isempty(segment_manual_noise)
    [energy_manual_noise_band, ~, ~] = calculate_band_energy(segment_manual_noise, fs_downsampled, analysis_band);
    disp(['   頻帶內雜訊能量 (手動下取樣片段): ', num2str(energy_manual_noise_band)]);
end
if ~isempty(segment_resampled_noise)
    [energy_resampled_noise_band, ~, ~] = calculate_band_energy(segment_resampled_noise, fs_downsampled, analysis_band);
    disp(['   頻帶內雜訊能量 (Resample片段): ', num2str(energy_resampled_noise_band)]);
end

% --- 量化特定高頻雜訊的混疊情況 ---
disp(' ');
disp('3. 量化特定高頻雜訊的混疊情況:');

% --- 針對 180 Hz 雜訊 (混疊至 20 Hz) ---
aliasing_freq1_orig = 180; % Hz
aliasing_freq1_new = 20;   % Hz
check_band1 = [max(1, aliasing_freq1_new - 2), aliasing_freq1_new + 2]; % 例如檢查 18-22 Hz
disp(['   檢查原始 ',num2str(aliasing_freq1_orig) ,' Hz 雜訊混疊至 ~', num2str(aliasing_freq1_new), ' Hz (頻帶: [', num2str(check_band1(1)), ', ', num2str(check_band1(2)), '] Hz):']);

if ~isempty(segment_manual_noise)
    [energy_manual_alias1, f_md_alias1, P1_md_alias1] = calculate_band_energy(segment_manual_noise, fs_downsampled, check_band1);
    disp(['     混疊頻帶1能量 (手動下取樣): ', num2str(energy_manual_alias1)]);
    if ~isempty(P1_md_alias1) && any(f_md_alias1 >= check_band1(1) & f_md_alias1 <= check_band1(2))
        peak_amp_md_alias1 = max(P1_md_alias1(f_md_alias1 >= check_band1(1) & f_md_alias1 <= check_band1(2)));
        disp(['     混疊頻帶1峰值振幅 (手動下取樣): ', num2str(peak_amp_md_alias1)]);
    end
end
if ~isempty(segment_resampled_noise)
    [energy_resampled_alias1, f_rs_alias1, P1_rs_alias1] = calculate_band_energy(segment_resampled_noise, fs_downsampled, check_band1);
    disp(['     混疊頻帶1能量 (Resample): ', num2str(energy_resampled_alias1)]);
    if ~isempty(P1_rs_alias1) && any(f_rs_alias1 >= check_band1(1) & f_rs_alias1 <= check_band1(2))
        peak_amp_rs_alias1 = max(P1_rs_alias1(f_rs_alias1 >= check_band1(1) & f_rs_alias1 <= check_band1(2)));
        disp(['     混疊頻帶1峰值振幅 (Resample): ', num2str(peak_amp_rs_alias1)]);
    end
end
disp(' ');

% --- 針對 300 Hz 雜訊 (混疊至 100 Hz) ---
aliasing_freq2_orig = 300; % Hz
aliasing_freq2_new = 100;  % Hz
check_band2 = [aliasing_freq2_new - 5, aliasing_freq2_new -1]; % 例如檢查 98-99 Hz (避免剛好在Nyquist點)
disp(['   檢查原始 ',num2str(aliasing_freq2_orig) ,' Hz 雜訊混疊至 ~', num2str(aliasing_freq2_new), ' Hz (頻帶: [', num2str(check_band2(1)), ', ', num2str(check_band2(2)), '] Hz):']);

if ~isempty(segment_manual_noise)
    [energy_manual_alias2, f_md_alias2, P1_md_alias2] = calculate_band_energy(segment_manual_noise, fs_downsampled, check_band2);
    disp(['     混疊頻帶2能量 (手動下取樣): ', num2str(energy_manual_alias2)]);
    if ~isempty(P1_md_alias2) && any(f_md_alias2 >= check_band2(1) & f_md_alias2 <= check_band2(2))
        peak_amp_md_alias2 = max(P1_md_alias2(f_md_alias2 >= check_band2(1) & f_md_alias2 <= check_band2(2)));
        disp(['     混疊頻帶2峰值振幅 (手動下取樣): ', num2str(peak_amp_md_alias2)]);
    end
end
if ~isempty(segment_resampled_noise)
    [energy_resampled_alias2, f_rs_alias2, P1_rs_alias2] = calculate_band_energy(segment_resampled_noise, fs_downsampled, check_band2);
    disp(['     混疊頻帶2能量 (Resample): ', num2str(energy_resampled_alias2)]);
     if ~isempty(P1_rs_alias2) && any(f_rs_alias2 >= check_band2(1) & f_rs_alias2 <= check_band2(2))
        peak_amp_rs_alias2 = max(P1_rs_alias2(f_rs_alias2 >= check_band2(1) & f_rs_alias2 <= check_band2(2)));
        disp(['     混疊頻帶2峰值振幅 (Resample): ', num2str(peak_amp_rs_alias2)]);
    end
end
disp(' ');

% --- 針對 459 Hz 雜訊 (混疊至 59 Hz) ---
aliasing_freq3_orig = 459; % Hz
aliasing_freq3_new = 59;   % Hz
check_band3 = [aliasing_freq3_new - 2, aliasing_freq3_new + 2]; % 例如檢查 57-61 Hz
disp(['   檢查原始 ',num2str(aliasing_freq3_orig) ,' Hz 雜訊混疊至 ~', num2str(aliasing_freq3_new), ' Hz (頻帶: [', num2str(check_band3(1)), ', ', num2str(check_band3(2)), '] Hz):']);

if ~isempty(segment_manual_noise)
    [energy_manual_alias3, f_md_alias3, P1_md_alias3] = calculate_band_energy(segment_manual_noise, fs_downsampled, check_band3);
    disp(['     混疊頻帶3能量 (手動下取樣): ', num2str(energy_manual_alias3)]);
    if ~isempty(P1_md_alias3) && any(f_md_alias3 >= check_band3(1) & f_md_alias3 <= check_band3(2))
        peak_amp_md_alias3 = max(P1_md_alias3(f_md_alias3 >= check_band3(1) & f_md_alias3 <= check_band3(2)));
        disp(['     混疊頻帶3峰值振幅 (手動下取樣): ', num2str(peak_amp_md_alias3)]);
    end
end
if ~isempty(segment_resampled_noise)
    [energy_resampled_alias3, f_rs_alias3, P1_rs_alias3] = calculate_band_energy(segment_resampled_noise, fs_downsampled, check_band3);
    disp(['     混疊頻帶3能量 (Resample): ', num2str(energy_resampled_alias3)]);
    if ~isempty(P1_rs_alias3) && any(f_rs_alias3 >= check_band3(1) & f_rs_alias3 <= check_band3(2))
        peak_amp_rs_alias3 = max(P1_rs_alias3(f_rs_alias3 >= check_band3(1) & f_rs_alias3 <= check_band3(2)));
        disp(['     混疊頻帶3峰值振幅 (Resample): ', num2str(peak_amp_rs_alias3)]);
    end
end
disp(' ');
disp(' ');
disp('處理完成。請檢視圖表和量化結果。');

% --- 輔助函數 ---
% 函數：計算並繪製FFT的單邊頻譜
function plot_fft(signal, fs, title_str)
    L = length(signal); % 訊號長度
    if L == 0 % 如果訊號為空，則不進行繪圖
        disp(['無法繪製 "', title_str, '" 的FFT，訊號為空。']);
        return;
    end
    Y = fft(signal); % 執行快速傅立葉轉換
    P2 = abs(Y/L); % 計算雙邊頻譜的振幅，並正規化
    P1 = P2(1:floor(L/2)+1); % 取出單邊頻譜部分 (floor確保與奇偶長度兼容)
    P1(2:end-1) = 2*P1(2:end-1); % 將除了直流和Nyquist頻率之外的振幅乘以2
    
    f = fs*(0:(L/2))/L; % 計算對應的頻率軸
    
    plot(f, P1); % 繪製頻譜圖
    title(title_str);
    xlabel('頻率 (Hz)');
    ylabel('|P1(f)|'); % Y軸標籤表示振幅
    axis tight; % 緊縮座標軸
    grid on; % 顯示格線
end

% 函數：計算特定頻帶內的能量
function [energy, f_band_segment, P1_band_segment] = calculate_band_energy(signal, fs, freq_band)
    L = length(signal); % 訊號長度
    energy = 0;         % 初始化能量為0
    f_band_segment = [];    % 初始化頻帶內的頻率點
    P1_band_segment = [];   % 初始化頻帶內的振幅點

    if L == 0 % 如果訊號為空，則返回
        disp('無法計算頻帶能量，訊號為空。');
        return;
    end
    
    Y = fft(signal); % 執行FFT
    P2 = abs(Y/L);   % 計算雙邊頻譜並正規化
    P1_full = P2(1:floor(L/2)+1); % 取出單邊頻譜
    P1_full(2:end-1) = 2*P1_full(2:end-1); % 調整振幅
    f_full = fs*(0:(L/2))/L; % 計算完整頻率軸

    % 找到所需頻帶的索引
    idx_band = find(f_full >= freq_band(1) & f_full <= freq_band(2));
    
    if ~isempty(idx_band) % 如果在頻帶內找到了頻率點
        P1_band_segment = P1_full(idx_band); % 提取該頻帶的振幅
        f_band_segment = f_full(idx_band);   % 提取該頻帶的頻率點
        energy = sum(P1_band_segment.^2); % 計算能量 (振幅平方和，與功率/能量成正比)
    else
        % 若頻帶內無數據點，可選擇性顯示警告，但為避免過多輸出，此處註解掉
        % disp(['警告: 在指定的頻帶 [', num2str(freq_band(1)), ',', num2str(freq_band(2)), '] Hz 內未找到頻率點以計算能量。']);
    end
end