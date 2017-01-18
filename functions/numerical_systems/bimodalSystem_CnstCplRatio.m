function [ f ] = bimodalSystem_CnstCplRatio( ...
    Es, EsTau, Ew, EwTau, rho, n, ...
    kappa_s, kappa_w, mu_s, mu_w, epsi_ss, epsi_ww, epsi_sw, epsi_ws, ...
    beta, J_p, eta, ...
    tau_r, S_in, V, Z_QD, n_bg, ...
    tau_sp, T_2, A, hbar_omega, epsi_tilda, J, ...
    feed_phase, feed_ampli, tau_fb, ...
    feed_phaseMatrix, feed_ampliMatrix, ...
    epsi0, hbar, e0, ...
    alpha_par )
%Dimensional, human-friendly, bimodal, phase-amplitude coupled system
%of differential equations. The matrix inputs determine the relative
%coupling values for feed_phase, feed_ampli and tau_fb in the following
%manner:
%   value * [ss, sw; ws, ww]
%
%   Input:
%     Es, EsTau, Ew, EwTau, rho, n, ...
%     kappa_s, kappa_w, mu_s, mu_w, epsi_ss, epsi_ww, epsi_sw, epsi_ws, ...
%     beta, J_p, eta, ...
%     tau_r, S_in, V, Z_QD, n_bg, ...
%     tau_sp, T_2, A, hbar_omega, epsi_tilda, J, ...
%     feed_phase, feed_ampli, tau_fb, ...
%     feed_phaseMatrix, feed_ampliMatrix, ...
%     epsi0, hbar, e0, ...
%     alpha_par
%
%   Output:
%       [real(EsDot);imag(EsDot);real(EwDot);imag(EwDot);rhoDot;nDot]

%% Calculate, organize useful vals
epsi_bg = n_bg^2;

% Set coupling ratios
feed_phase = feed_phase*feed_phaseMatrix;
feed_ampli = feed_ampli*feed_ampliMatrix;

% Organize
css = feed_phase(1,1);
csw = feed_phase(1,2);
cws = feed_phase(2,1);
cww = feed_phase(2,2);

kss = feed_ampli(1,1);
ksw = feed_ampli(1,2);
kws = feed_ampli(2,1);
kww = feed_ampli(2,2);

gs = ((norm(mu_s)^2)*T_2/(2*hbar^2)) ...
    * ( ...
    1 ...
    + epsi_ss*epsi_tilda*Es.*conj(Es) ...
    + epsi_sw*epsi_tilda*Ew.*conj(Ew) ...
    ).^(-1);

gw = ((norm(mu_w)^2)*T_2/(2*hbar^2)) ...
    * ( ...
    1 ...
    + epsi_ws*epsi_tilda*Es.*conj(Es) ...
    + epsi_ww*epsi_tilda*Ew.*conj(Ew) ...
    ).^(-1);

%% Differential Eqns

EsDot = (1 - 1.0i*alpha_par) ...
    *( ...
    ( (hbar_omega/(epsi0*epsi_bg)) * (2*Z_QD/V) ...
    * gs ...
    .* (2*rho-1) ...
    .* Es ) ...
    - kappa_s * Es ... 
    ) ...
    + kappa_s * exp(1.0i*css) * kss * EsTau ...
    + kappa_s * exp(1.0i*csw) * ksw * EwTau ...
    + beta * hbar_omega / (epsi0*epsi_bg) ...
    * (2*Z_QD/V) * (rho/tau_sp).*(Es./(Es.*conj(Es)) ...
    );

EwDot = (1 - 1.0i*alpha_par) ...
    *( ...
    ( (hbar_omega/(epsi0*epsi_bg)) * (2*Z_QD/V) ...
    * gw ...
    .* (2*rho-1) ...
    .* Ew ) ...
    - kappa_w * Ew ... 
    ) ...
    + kappa_w * exp(1.0i*cww) * kww * EwTau ...
    + kappa_w * exp(1.0i*cws) * kws * EsTau ...
    + beta * hbar_omega / (epsi0*epsi_bg) ...
    * (2*Z_QD/V) * (rho/tau_sp).*(Ew./(Ew.*conj(Ew)) ...
    );

rhoDot = ( ...
    - gs.*(2*rho-1).*(Es.*conj(Es)) ...
    - gw.*(2*rho-1).*(Ew.*conj(Ew)) ...
    - rho/tau_sp ...
    + S_in * n.*(1-rho) ...
    );

nDot = ( ...
    eta / (e0*A) * (J-J_p) ...
    - S_in*(2*Z_QD/A)*n.*(1-rho) ...
    - n/tau_r ...
    );

f = cat(1,real(EsDot),imag(EsDot),real(EwDot),imag(EwDot),rhoDot,nDot);

end
