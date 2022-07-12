% ME 341 Project
% Sam Komonosky
% 3D Version
clc;
clear;
close all;

projectile_size = input('Select the projectile size\n1 = Small, 2 = Medium, 3 = Large\n');

switch projectile_size
    case 1 % Small
        D = 0.075; % diameter of projectile - m
        ms = 40;
    case 2 % Medium
        D = 0.15; % diameter of projectile - m
        ms = 40;
    case 3 % Large
        D = 0.5; % diameter of projectile - m
        ms = 40;
    otherwise
        D = 0.2;
        ms = 40;
end

projectile_mass = input('Select the mass of the projectile\n1 = Light, 2 = Medium, 3 = Heavy, 4 = Superheavy\n');

switch projectile_mass
    case 1 % Light
        m = 0.100; % mass of projectile - kg
    case 2 % Medium
        m = 0.750;
    case 3 % Heavy
        m = 2;
    case 4 % Superheavy
        m = 10;
    otherwise
        m = 0.500;
end

A = pi/4*D^2; % Area - m^2
r = 5; % radius of projectile (for calculations only)
CD = 0.47; % Drag Coefficient
e = 0.88; % coefficient of restitution
rho = 1.12; % air density - kg/m^3
g = 9.81; % gravity - m/s^s
dt = 0.001; % 1 ms

% initial conditions
difficulty = input('Enter the difficulty\n 1 = easy, 2 = medium, 3 = hard: ');
v = input('Enter the launch speed: '); %  initial speed - m/s
theta = input('Enter the vertical launch angle: '); % intial x-axis angle - degrees
fi = input('Enter the horizontal launch angle: ');  % intial z-axis angle - degrees
x1(1) = r; % initial x position
x2(1) = v*cosd(theta)*cosd(fi); % initial x velocity
y1(1) = r; % initial y position
y2(1) = v*cosd(theta)*sind(fi); % initial y velocity
z1(1) = r;  % initial z position
z2(1) = v*sind(theta);
ax(1) = 0; % initial x acceleration
ay(1) = 0; % initial y acceleration
az(1) = 0; % initial z acceleration
bounces = 0;
t(1) = 0;

% Magnets: cyan - attractor, black - repeller
m1 = [50 50 0];
m2 = [100 50 0];
m3 = [100 100 0];
m4 = [50 100 0];
mx1 = [m1(1) m2(1) m3(1) m4(1)];
my1 = [m1(2) m2(2) m3(2) m4(2)];
mz1 = [m1(3) m2(3) m3(3) m4(3)];
mag1 = fill3(mx1, my1, mz1, 'c');
hold on;
m5 = [50 150 50];
m6 = [100 150 50];
m7 = [100 150 100];
m8 = [50 150 100];
mx2 = [m5(1) m6(1) m7(1) m8(1)];
my2 = [m5(2) m6(2) m7(2) m8(2)];
mz2 = [m5(3) m6(3) m7(3) m8(3)];
mag2 = fill3(mx2, my2, mz2, 'k');
hold on;
m9 = [150 100 50];
m10 = [150 50 50];
m11 = [150 50 100];
m12 = [150 100 100];
mx3 = [m9(1) m10(1) m11(1) m12(1)];
my3 = [m9(2) m10(2) m11(2) m12(2)];
mz3 = [m9(3) m10(3) m11(3) m12(3)];
mag3 = fill3(mx3, my3, mz3, 'c');

switch difficulty
    case 1
        magnet_strength = 50;
    case 2
        magnet_strength = 100;
    case 3
        magnet_strength = 200;
    otherwise
        magnet_strength = 0;
end

% Get values for position and velocity
n = 1;
while min(z1) >= r/2  % stop before y value drops below zero
    ax(n+1) = -1/(2*m)*CD*rho*A*v*x2(n);
    ay(n+1) = -1/(2*m)*CD*rho*A*v*y2(n);
    az(n+1) = -1/(2*m)*CD*rho*A*v*z2(n) - g;
    
    x2(n+1) = x2(n) + ax(n)*dt;
    y2(n+1) = y2(n) + ay(n)*dt;
    z2(n+1) = z2(n) + az(n)*dt;
    
    v = sqrt(x2(n)^2 + y2(n)^2 + z2(n)^2);
    
    x1(n+1) = x1(n) + x2(n)*dt + 0.5*ax(n)*dt^2;
    y1(n+1) = y1(n) + y2(n)*dt + 0.5*ay(n)*dt^2;
    z1(n+1) = z1(n) + z2(n)*dt + 0.5*az(n)*dt^2;
    
    % magnet 1
    % Explanation:
    % Magnet exerts a force on the projectile, F = ma and m is constant,
    % so the acceleration of the projectile is modified
    if x1(n) >= m1(1) && x1(n) <= m2(1)
        if y1(n) >= m1(2) && y1(n) <= m3(2)
            az(n+1) = az(n+1) - magnet_strength * 1/z1(n);
        end
    end
    
    % magnet 2
    if x1(n) >= m5(1) && x1(n) <= m6(1)
        if z1(n) >= m5(3) && y1(n) <= m7(3)
            ay(n+1) = ay(n+1) - magnet_strength * 1/y1(n);
        end
    end
    
    % magnet 3
    if z1(n) >= m9(3) && z1(n) <= m11(3)
        if y1(n) >= m11(2) && y1(n) <= m9(2)
            ax(n+1) = ax(n+1) + magnet_strength * 1/x1(n);
        end
    end
    
    t(n+1) = t(n) + dt;
    
    % If the projectile hits a wall, it bounces off
    if x1(n+1) >= 150
        x2(n+1) = -x2(n+1)*e;
        bounces = bounces + 1;
        x1(n+1) = 150;
    end
    
    if y1(n+1) >= 150
        y2(n+1) = -x2(n+1)*e;
        bounces = bounces + 1;
        y1(n+1) = 150;
    end
    
    if z1(n+1) >= 150
        z2(n+1) = -x2(n+1)*e;
        bounces = bounces + 1;
        z1(n+1) = 150;
    end
    
    n = n + 1;
end


% Draw the target
% Yeah, so this is ugly - have to draw each surface separately
p1 = [120 100 0];
p2 = [140 100 0];
p3 = [140 120 0];
p4 = [120 120 0];
p5 = [120 100 20];
p6 = [140 100 20];
p7 = [140 120 20];
p8 = [120 120 20];

target_center = [(p1(1)+p2(1))/2 (p1(2)+p3(2))/2];

% Bottom Surface
tx1 = [p1(1) p2(1) p3(1) p4(1)];
ty1 = [p1(2) p2(2) p3(2) p4(2)];
tz1 = [p1(3) p2(3) p3(3) p4(3)];
t1 = fill3(tx1, ty1, tz1, 'r');
hold on;
% Front Surface
tx2 = [p1(1) p2(1) p6(1) p5(1)];
ty2 = [p1(2) p2(2) p6(2) p5(2)];
tz2 = [p1(3) p2(3) p6(3) p5(3)];
t2 = fill3(tx2, ty2, tz2, 'r');
% Right Surface
tx3 = [p2(1) p3(1) p7(1) p6(1)];
ty3 = [p2(2) p3(2) p7(2) p6(2)];
tz3 = [p2(3) p3(3) p7(3) p6(3)];
t3 = fill3(tx3, ty3, tz3, 'r');
% Back Surface
tx4 = [p4(1) p3(1) p7(1) p8(1)];
ty4 = [p4(2) p3(2) p7(2) p8(2)];
tz4 = [p4(3) p3(3) p7(3) p8(3)];
t4 = fill3(tx4, ty4, tz4, 'r');
% Left Surface
tx5 = [p1(1) p4(1) p8(1) p5(1)];
ty5 = [p1(2) p4(2) p8(2) p5(2)];
tz5 = [p1(3) p4(3) p8(3) p5(3)];
t5 = fill3(tx5, ty5, tz5, 'r');
% Top Surface
tx6 = [p5(1) p6(1) p7(1) p8(1)];
ty6 = [p5(2) p6(2) p7(2) p8(2)];
tz6 = [p5(3) p6(3) p7(3) p8(3)];
t6 = fill3(tx6, ty6, tz6, 'r');

% Set up graph
f = figure(1);
axis([0 150 0 150 0 150]);
xlabel('X distance');
ylabel('Y distance');
zlabel('Height');
title('Projectile Path');
grid on;
hold on;
hit = 0;

% Plot the projectile
for n=1:20:length(x1)
    k = plot3(x1(n), y1(n), z1(n), 'b.', 'MarkerSize', ms);
    plot3(x1(1:n), y1(1:n), z1(1:n), 'b--');
    pause(0.001);
    delete(k);
    % check if hit, if true -> 'destroy' target and break out of loop
    if z1(n) < p5(3)
        if x1(n) > p1(1)
            if y1(n) > p1(2) && y1(n) < p3(2)
                hit = 1;
                plot3(x1(n), y1(n), z1(n), 'b.', 'MarkerSize', ms);
                delete(t1);
                delete(t2);
                delete(t3);
                delete(t4);
                delete(t5);
                delete(t6);
                break;
            end
        end
    end
end

% plot final position if miss
if hit ~= 1
    plot3(x1(length(x1)), y1(length(y1)), z1(length(z1)), 'b.', 'MarkerSize', ms);
end

% Calculate position from target
final_pos = [x1(length(x1)) y1(length(y1))];
distance_from_target = sqrt((final_pos(1) - target_center(1))^2 + (final_pos(2) - target_center(2))^2);

% Calculate points
if hit == 1
    points = 100;
else
    points = 100 - distance_from_target;
    if points < 0
        points = 0;
    end
end

% Output
if hit == 1
    fprintf('Hit registered! + 100 points!\n');
    % you get bonus points if you hit the target after bouncing
    if bounces > 0
        fprintf('Bank shot! +%d points!\n', 20*bounces);
        points = points + 20 * bounces;
    end
else
    fprintf('Target missed!\n');
end
fprintf('You get %d points\n', round(points));

