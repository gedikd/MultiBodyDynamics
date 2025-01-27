clc;
clear;
close all;

% Kullanıcıdan Euler açılarını (roll, pitch, yaw) derece olarak al
roll = input('Roll açısını (x ekseni etrafında) derece olarak girin: ');
pitch = input('Pitch açısını (y ekseni etrafında) derece olarak girin: ');
yaw = input('Yaw açısını (z ekseni etrafında) derece olarak girin: ');

% Kullanıcıdan translation (yer değiştirme) vektörünü al
tx = input('X yönündeki yer değiştirme miktarını girin: ');
ty = input('Y yönündeki yer değiştirme miktarını girin: ');
tz = input('Z yönündeki yer değiştirme miktarını girin: ');

% Translation vektörünü tanımla
T_final = [tx, ty, tz];

% Dereceleri radyana çevir
roll = deg2rad(roll);
pitch = deg2rad(pitch);
yaw = deg2rad(yaw);

% Dikdörtgen prizmanın köşe noktalarını tanımla (orijinal pozisyon)
L = 2; W = 0.5; H = 0.5; % Prizmanın boyutları (uzunluk, genişlik, yükseklik)
vertices = [-L, -W, -H;
            L, -W, -H;
            L, W, -H;
            -L, W, -H;
            -L, -W, H;
            L, -W, H;
            L, W, H;
            -L, W, H];

% Prizmanın yüzlerini tanımla
faces = [1, 2, 6, 5;  % Alt yüzey
         2, 3, 7, 6;  % Sağ yüzey
         3, 4, 8, 7;  % Üst yüzey
         4, 1, 5, 8;  % Sol yüzey
         1, 2, 3, 4;  % Alt taban
         5, 6, 7, 8]; % Üst taban

% Animasyon için adımlar
num_steps = 100; % Animasyon adım sayısı
T_step = T_final / num_steps; % Translation adımları

% Başlangıç pozisyonunu çiz
figure;
hold on;
patch('Vertices', vertices, 'Faces', faces, ...
      'FaceColor', 'blue', 'FaceAlpha', 0.3, 'EdgeColor', 'black');
grid on;
axis equal;
xlabel('X Ekseni');
ylabel('Y Ekseni');
zlabel('Z Ekseni');
view(3); % 3D görünüm
title('Cisim Rotasyon ve Translation Animasyonu');

% Animasyon: Adım adım döndürme ve öteleme
current_vertices = vertices;
for step = 1:num_steps
    % Adım adım Euler açılarından rotasyon matrisleri hesapla
    current_roll = roll * (step / num_steps);
    current_pitch = pitch * (step / num_steps);
    current_yaw = yaw * (step / num_steps);

    % Rotasyon matrislerini oluştur
    Rx = [1, 0, 0;
          0, cos(current_roll), -sin(current_roll);
          0, sin(current_roll), cos(current_roll)];
    Ry = [cos(current_pitch), 0, sin(current_pitch);
          0, 1, 0;
         -sin(current_pitch), 0, cos(current_pitch)];
    Rz = [cos(current_yaw), -sin(current_yaw), 0;
          sin(current_yaw), cos(current_yaw), 0;
          0, 0, 1];
    
    % Toplam rotasyon matrisi
    R = Rz * Ry * Rx;
    
    % Rotasyonu uygula
    rotated_vertices = (R * current_vertices')';
    
    % Translation uygula (kademeli)
    translated_vertices = rotated_vertices + step * T_step;
    
    % Güncel pozisyonu çiz
    h = patch('Vertices', translated_vertices, 'Faces', faces, ...
              'FaceColor', 'red', 'FaceAlpha', 0.5, 'EdgeColor', 'black');
    
    % Çizim güncelle ve kısa bir bekleme
    drawnow;
    pause(0.02);
    
    % Bir önceki frame'i sil
    delete(h);
end

% Son pozisyonu çiz
patch('Vertices', translated_vertices, 'Faces', faces, ...
      'FaceColor', 'green', 'FaceAlpha', 0.7, 'EdgeColor', 'black');
legend({'Orijinal Pozisyon', 'Son Pozisyon'}, 'Location', 'best');
hold off;
