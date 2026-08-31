%% array_equivalent_S.m
% Calculate the array equivalent S-parameter and equivalent VSWR from multi-port active S-parameters (magnitude in dB)
%
% Methodology (assuming uniform amplitude excitation, identical |a_i|):
%   |Gamma_active,i|^2 = 10^(S_i_dB/10)
%   |Gamma_array|^2    = mean_i( |Gamma_active,i|^2 )      % Power-domain averaging; cannot be averaged directly in the dB domain
%   S_array_dB         = 10*log10( |Gamma_array|^2 )
%   VSWR_array         = (1+|Gamma_array|) / (1-|Gamma_array|)
%
% Additionally, identify the "worst-case port" (maximum Active S-parameter, closest to mismatch) at each frequency point.
% This is utilized to detect scenarios where overall matching is acceptable, but individual ports exhibit scan blindness or localized mismatch.
%
% Input file: 'Active S Parameter Plot 1.csv' located in the same directory as this script.
%   Column 1: Freq [GHz]
%   Column 2 onwards: dB(ActiveS(i:1)) for each port
clear; clc; close all;

%% ---------- 1. Load Data ----------
csv_file = 'Active S Parameter Plot 1.csv';
T = readtable(csv_file, 'VariableNamingRule', 'preserve');
freq   = T{:,1};                 % [GHz], Nfreq x 1
S_dB   = T{:,2:end};             % Nfreq x Nport, Active S-parameter (dB) for each port
Nfreq  = size(S_dB,1);
Nport  = size(S_dB,2);
port_names = T.Properties.VariableNames(2:end);   % Used for reporting the name of the worst-case port

%% ---------- 2. Calculate Array Equivalent S-parameters (Power-Domain Averaging, Uniform Excitation) ----------
Gamma2_i   = 10.^(S_dB/10);           % Reflected power ratio for each port |Gamma_i|^2, Nfreq x Nport
Gamma2_arr = mean(Gamma2_i, 2);       % Under uniform excitation, |Gamma_array|^2 = (1/N) * sum_i |Gamma_i|^2
S_array_dB = 10*log10(Gamma2_arr);              % Array equivalent S-parameter (dB)
Gamma_arr  = sqrt(Gamma2_arr);                    % Magnitude of the array equivalent reflection coefficient
VSWR_array = (1 + Gamma_arr) ./ (1 - Gamma_arr);  % Array equivalent VSWR

%% ---------- 3. Identify the Worst-Case Port at Each Frequency ----------
[S_worst_dB, worst_idx] = max(S_dB, [], 2);   % The maximum value in the dB domain corresponds to the worst case (closest to 0 dB)
worst_port_name = port_names(worst_idx)';     % Nfreq x 1 cell array, port names

%% ---------- 4. Evaluation Criteria (Thresholds can be modified as needed) ----------
% Standard criterion: Overall array VSWR <= 2 <=> S_array <= -9.542 dB
VSWR_limit = 2;
S_limit_dB = 20*log10((VSWR_limit-1)/(VSWR_limit+1));   % = -9.542 dB

pass_flag = S_array_dB <= S_limit_dB;
pass_str  = repmat("FAIL", Nfreq, 1);
pass_str(pass_flag) = "PASS";

%% ---------- 5. Summarize and Export Results Table ----------
ResultTable = table(freq, S_array_dB, VSWR_array, S_worst_dB, worst_port_name, pass_str, ...
    'VariableNames', {'Freq_GHz','S_array_dB','VSWR_array','Worst_ActiveS_dB','Worst_Port','Judge'});
disp(ResultTable);
writetable(ResultTable, 'Array_Equivalent_S_Result.csv');

fprintf('\nEvaluation Threshold: VSWR <= %.2f  <=>  S_array <= %.3f dB\n', VSWR_limit, S_limit_dB);
fprintf('Results have been saved to Array_Equivalent_S_Result.csv\n');

%% ---------- 6. Plotting ----------
figure('Name','Array Equivalent S / VSWR');

subplot(2,1,1);
plot(freq, S_array_dB, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 4); hold on;
plot(freq, S_worst_dB, 'r--s', 'LineWidth', 1.2, 'MarkerSize', 4);
yline(S_limit_dB, 'k:', sprintf('VSWR=%.0f Limit (%.2f dB)', VSWR_limit, S_limit_dB), ...
    'LabelHorizontalAlignment','left');
xlabel('Frequency (GHz)');
ylabel('S (dB)');
legend('Array Equivalent S_{array}', 'Worst-Case Port Active S', 'Location', 'best');
title('Array Equivalent Reflection S_{array} and Worst-Case Port Active S');
grid on;

subplot(2,1,2);
plot(freq, VSWR_array, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 4); hold on;
yline(VSWR_limit, 'k:', sprintf('VSWR = %.0f Limit', VSWR_limit));
xlabel('Frequency (GHz)');
ylabel('VSWR');
title('Array Equivalent VSWR');
grid on;
