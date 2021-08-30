% -------------------------------------------------------------------------
%
%		Program Matlab : init_EV_dcm.m
%       
%		Initialisation (Matlab)
%		for an
%       E lectric
%       V ehicule using a PM 
%       DC machine 
%       M achine
%
% -------------------------------------------------------------------------
%		Created by W.Lhomme and A. Bouscayrol  :              28 June 2005
%       Last update R. German, C. Mayet, A. Bouscayrol      : 10 May 2017
% -------------------------------------------------------------------------
%       Université Lille 1 Science & Technology (France)
%       L2EP Lille
% -------------------------------------------------------------------------

clc; clear all; close all;

%% VEHICLE PARAMETERS

% *************************************************************************
%                        Battery parameters (BATp)                        
% *************************************************************************

    BATp.V_batt = 400;            % Battery Voltage considered constant (V)
    
% *************************************************************************
%                         Chopper parameters (CHp)                        
% *************************************************************************

    CHp.eff = 95/100;             % Chopper efficiency considered constant
    
% *************************************************************************
%                     Electric Machine parameters (EMp)                   
% *************************************************************************

    % --- DCM Parameters ---
    % --- DCM by separately excited of 32 kW ---

        % --- Description ---
    
    EMp.U_arm_nom = 400;          % Nominal voltage of the armature (V)
    EMp.I_arm_nom = 162;          % Nominal Current of the armature (A)
    EMp.N_nom = 2840;             % Nominal speed (tr/min)
    EMp.N_max = 6000;             % Maximal speed (tr/min)
    EMp.W_nom = pi/30*EMp.N_nom;  % Nominal speed (rad/s)
    EMp.P_nom = 65e3;             % Nominal power (W)
    EMp.J = 0.12;                 % Rotor Inertia (kg.m^2)
    EMp.M = 155;                  % Machine mass (kg)

   	    % --- Armature winding ---
    
    EMp.R_arm = 0.35;             % Armature resistance (Ohm)
    EMp.L_arm = 6.5e-3;           % Armature inductance (H)

    EMp.K_arm = 1/EMp.R_arm;      % Gain of the armature transfer function
    EMp.T_arm = EMp.L_arm/EMp.R_arm; % Time constant of the armature transfer function (s)

	    % --- Electro-Mechanical conversion ---	
        
    EMp.K_em = (EMp.U_arm_nom-EMp.R_arm*EMp.I_arm_nom)/(EMp.W_nom); % Torque Coefficient via the excitation Flux

% *************************************************************************
%                  Mechanical Transmission parameters (MTp)               
% *************************************************************************

   	    % --- Gearbox (reductor) ---
    
    MTp.Gear_eff = 80/100;        % Gearbox efficiency considered constant
    MTp.K_gear = 5;               % Gearbox ratio

   	    % --- Wheel ---
    
    MTp.D_wheel = 0.52;           % Wheel diameter (m)
    MTp.R_wheel = MTp.D_wheel/2;  % MT.D_wheel
    MTp.J_wheel = 4.3;            % Wheel inertia (kg.m^2)
    
% *************************************************************************
%                         Chassis parameters (CHAp)                       
% *************************************************************************

    CHAp.M_eq = 1.4e3;            % Equivalent mass (shaft + chassis+ 2 passengers)
    CHAp.K_eq = 1/CHAp.M_eq;      % Velocity gain

% *************************************************************************
%                    Environment - Road parameters (RDp)                  
% *************************************************************************

        % --- Mechanical source parameters ---

    RDp.wheelbase = 2.4;          % Wheelbase (m)
    RDp.w_ev = 1.6;               % EV width (m)
    RDp.g = 9.81;                 % gravity (m/s^2)
    RDp.A = 2;                    % Frontal aera (m^2)
    RDp.Cx = 0.35;                % Drag coefficient
    RDp.ro = 1.223;               % Density of the air with 20°C under 1013 mbar (kg/m^3)
    RDp.Kaero = RDp.ro*RDp.Cx*RDp.A/2; % Constant for the resistance force to aerodynamics
    RDp.F_sec = 50;               % Static friction force (N)

%% CONTROL PARAMETERS

% -------------------------------------------------------------------------
%		Maximal Control Structure :
%       - all variable are considered ideal
%       - all sensors are considered ideal
%       - synthesis carried out uninterrupted
% -------------------------------------------------------------------------

% *************************************************************************
%                         Chassis inversion (CHAi)                        
% *************************************************************************

    CHAi.tr_des = 0.1;            % Closed-loop response time (s)
    
% --- CHOOSE YOUR CONTROLLER ---
% --- 1 - Proportional
% --- 2 - Proportional Integral
% --- 3 - Integral Proportional

    CHAi.co = 1;                  % Put the number corresponding to the controller

% --- CALCULATION of CONTROLLERS ---
% --- qsi=1     wn*tr = 4.744
% --- qsi=0.7	wn*tr = 3

    CHAi.qsi = 1;                 % Damping factor
    CHAi.wn = 4.744/CHAi.tr_des;  % Natural angular frequency (1/s)

        % --- Proportional controller (Pc) ---
        
    CHAi.Pc.Kp = 3/(CHAp.K_eq*CHAi.tr_des);             % Proportional gain

        % --- Proportional Integral controller (PIc) ---
        
    CHAi.PIc.Kp = (2*CHAi.qsi*CHAi.wn)/CHAp.K_eq;       % Proportional gain
    CHAi.PIc.Ki = (CHAi.wn^2)/CHAp.K_eq;                % Integral gain

        % --- Integral Proportional controller (IPc) ---
        
    CHAi.IPc.Kp = (2*CHAi.qsi*CHAi.wn)/CHAp.K_eq;       % Proportional gain
    CHAi.IPc.Ki = (CHAi.wn^2)/(CHAp.K_eq*CHAi.IPc.Kp);  % Integral gain

% *************************************************************************
%                  Mechanical Transmission inversion (MTi)                
% *************************************************************************

    MTi.kD = 0.5;                 % Distribution criterion between right and left wheel
    MTi.kW = 0.5;                 % Weighting criterion
    
% *************************************************************************
%                     Electric Machine inversion (EMi)                   
% *************************************************************************

    EMi.tr_des = 10e-3;           % Closed-loop response time (s)
    
% --- CHOOSE YOUR CONTROLLER ---
% --- 1 - Proportional
% --- 2 - Proportional Integral with poles placement
% --- 2 - Proportional Integral with poles compensation
% --- 4 - Integral Proportional

    EMi.co = 1;                   % Put the number corresponding to the controller

% --- CALCULATION of CONTROLLERS ---
% --- qsi=1     wn*tr = 4.744
% --- qsi=0.7	wn*tr = 3

    EMi.qsi = 1;                  % Damping factor
    EMi.wn = 4.744/EMi.tr_des;    % Natural angular frequency (1/s)

        % --- Proportional controller (Pc) ---
        
    EMi.Pc.Kp = ((3*EMp.T_arm/EMi.tr_des)-1)/EMp.K_arm; % Proportional gain

        % --- Proportional Integral controller (PIc) ---
        % --- with poles placement (pp)
        
    EMi.PIc.pp.Kp = ((2*EMi.qsi*EMi.wn*EMp.T_arm)-1)/EMp.K_arm; % Proportional gain
    EMi.PIc.pp.Ki = (EMp.T_arm*EMi.wn^2)/EMp.K_arm;     % Integral gain
    
        % --- Proportional Integral controller (PIc) ---
        % --- with poles compensation (pc)
        
    EMi.PIc.pc.Kp = (3*EMp.T_arm)/(EMp.K_arm*EMi.tr_des); % Proportional gain
    EMi.PIc.pc.Ki = EMi.PIc.pc.Kp/EMp.T_arm;           % Integral gain
    
        % --- Integral Proportional controller (IPc) ---
        
    EMi.IPc.Kp = ((2*EMi.qsi*EMi.wn*EMp.T_arm)-1)/EMp.K_arm; % Proportional gain
    EMi.IPc.Ki = (EMp.T_arm*EMi.wn^2)/(EMp.K_arm*EMi.IPc.Kp);  % Integral gain
    
        
    
% *************************************************************************
%                            ECE cycle (CYCL)
% *************************************************************************

        % --- The columns are time (in s) and velocity (in m/s) ---

CYCL.ECE = [  0  0.00
      10  0.00
      11  0.00
      12  1.04
      13  2.08
      14  3.13
      15  4.17
      16  4.17
      17  4.17
      18  4.17
      19  4.17
      20  4.17
      21  4.17
      22  4.17
      23  4.17
      24  3.47
      25  2.78
      26  1.85
      27  0.93
      28  0.00
      48  0.00
      49  0.00
      50  0.83
      51  1.67
      52  2.50
      53  3.33
      54  4.17
      55  4.17
      56  4.17
      57  5.11
      58  6.06
      59  7.00
      60  7.94
      61  8.89
      62  8.89
      63  8.89
      64  8.89
      65  8.89
      66  8.89
      67  8.89
      68  8.89
      69  8.89
      70  8.89
      71  8.89
      72  8.89
      73  8.89
      74  8.89
      76  8.89
      77  8.89
      78  8.89
      79  8.89
      80  8.89
      81  8.89
      82  8.89
      83  8.89
      84  8.89
      85  8.89
      86  8.13
      87  7.36
      88  6.60
      89  5.83
      90  5.07
      91  4.31
      92  3.54
      93  2.78
      94  1.85
      95  0.93
      96  0.00
      116 0.00
     117  0.00
     118  0.83
     119  1.67
     120  2.50
     121  3.33
     122  4.17
     123  4.17
     124  4.17
     125  4.78
     126  5.40
     127  6.02
     128  6.64
     129  7.25
     130  7.87
     131  8.49
     132  9.10
     133  9.72
     134  9.72
     135  9.72
     136 10.24
     137 10.76
     138 11.28
     139 11.81
     140 12.33
     141 12.85
     142 13.37
     143 13.89
     144 13.89
     145 13.89
     146 13.89
     147 13.89
     148 13.89
     149 13.89
     150 13.89
     151 13.89
     152 13.89
     153 13.89
     154 13.89
     155 13.89
     156 13.37
     157 12.85
     158 12.33
     159 11.81
     160 11.28
     161 10.76
     162 10.24
     163  9.72
     164  9.72
     165  9.72
     166  9.72
     167  9.72
     168  9.72
     169  9.72
     170  9.72
     171  9.72
     172  9.72
     173  9.72
     174  9.72
     175  9.72
     176  9.72
     177  9.31
     178  8.89
     179  8.02
     180  7.14
     181  6.27
     182  5.40
     183  4.52
     184  3.65
     185  2.78
     186  1.85
     187  0.93
     188  0.00
     195  0.00 ];
 
CYCL.time_ECE = CYCL.ECE(:,1);
CYCL.time_ECE = CYCL.time_ECE';
CYCL.velocity_ECE = CYCL.ECE(:,2);
CYCL.velocity_ECE = CYCL.velocity_ECE';

% *************************************************************************
% 			 	     Simulation parameters (SIM)
% *************************************************************************

        % --- Global simulation ---
    SIM.t_min = 0;                        % Simulation beginning
    SIM.t_simul = max(CYCL.time_ECE);     % Simulation end

% *****************************************************************
% 				   Display of initialization end 
% *****************************************************************

disp(' ');
disp('****** Initialisation EV_dcm ******');
disp('******     finished          ******');
disp(' ');