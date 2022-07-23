%% Binding energy for certain A
% 质量抛物线
clear; close all;
z1 = 30:46;
a1 = z1+50;
for i = 1:length(z1)
    b1(i,1) = bindingEnergy(z1(i),a1(i))/a1(i);
end
figure;
subplot(131);
plot(z1,b1,'.-');
xlabel('Z');
ylabel('Specific binding Energy (MeV)');
legend('N = 50');

z2 = 48:64;
a2 = z2+82;
for i = 1:length(z2)
    b2(i,1) = bindingEnergy(z2(i),a2(i))/a2(i);
end
subplot(132);
plot(z2,b2,'.-');
xlabel('Z');
ylabel('Specific binding Energy (MeV)');
legend('N = 82');

z3 = 70:86;
a3 = z3+126;
for i = 1:length(z3)
    b3(i,1) = bindingEnergy(z3(i),a3(i))/a3(i);
end
subplot(133);
plot(z3,b3,'.-');
xlabel('Z');
ylabel('Specific binding Energy (MeV)');
legend('N = 126');