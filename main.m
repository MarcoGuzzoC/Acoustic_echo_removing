close all;
clear all;
clc;

%% Génération des signaux
N = 1024;

x=rand(N,1);

h = [1;0.3;-0.1;0.2];

d = filter(h,1,x);


plot(x)
hold on
plot(d)
legend("Signal d'entrée x","Signal filtré d")
xlim([0;N+5])
title("Représentation temporelle du signal d'entrée et du signal désiré")
xlabel("temps [n]")
ylabel("Amplitude")

%% Mise en oeuvre LMS

close all;
clc;

P = 5;
mu = 0.05;

[W,y,e] = algolms(x,d,P,mu);

figure()
plot(d,"blue","LineWidth",1.1)
hold on 
plot(y,"green","LineWidth",1.1)
hold on 
plot(e,"red","LineWidth",1.1)
legend("Signal désiré","Signal de sortie","Erreur")
xlabel("Temps [n]")
ylabel("Amplitude")
xlim([0;N+5])
title("Représentation temporelle du signal de sortie et du signal désiré et de l'erreur")

figure()
subplot(221)
plot(ones(N,1)*h(1))
hold on
plot(W(1,:))
xlabel("Temps [n]")
ylabel("Amplitude")
xlim([0;N+5])
legend("Coeff idéal","Coeff obtenu")
title("Evolution de h1")

subplot(222)
plot(ones(N,1)*h(2))
hold on
plot(W(2,:))
xlabel("Temps [n]")
ylabel("Amplitude")
xlim([0;N+5])
legend("Coeff idéal","Coeff obtenu")
title("Evolution de h2")

subplot(223)
plot(ones(N,1)*h(3))
hold on
plot(W(3,:))
xlabel("Temps [n]")
ylabel("Amplitude")
xlim([0;N+5])
legend("Coeff idéal","Coeff obtenu")
title("Evolution de h3")

subplot(224)
plot(ones(N,1)*h(4))
hold on
plot(W(4,:))
xlabel("Temps [n]")
ylabel("Amplitude")
xlim([0;N+5])
legend("Coeff idéal","Coeff obtenu")
title("Evolution de h4")

figure()
plot(ones(N,1)*0)
hold on
plot(W(5,:))
xlabel("Temps [n]")
ylabel("Amplitude")
xlim([0;N+5])
legend("Coeff idéal","Coeff obtenu")
title("Evolution de h5")


%% Test de l'algo LMS

clc;
close all;

N=1024;
mu = 0.01;
x = randn(N,1);
noise = 0.1*randn(N,1);

h1 = fir1(4,(0.5));
d = filter(h1,1,x)+noise;
[w,y,e] = algolms(x,d,5,mu);
h2 = fir1(9,(0.5));
d = filter(h2,1,x)+noise;
[w,y,e2] = algolms(x,d,10,mu);
h3 = fir1(19,(0.5));
d = filter(h3,1,x)+noise;
[w,y,e3] = algolms(x,d,20,mu);

figure()
subplot(311)
plot(e)
ylim([-1.5,1.5])
xlim([0;N+5])
title("P = 5")
xlabel("Temps [n]")
ylabel("Amplitude")
subplot(312)
plot(e2)
xlim([0;N+5])
ylim([-1.5,1.5])
title("P = 10")
xlabel("Temps [n]")
ylabel("Amplitude")
subplot(313)
plot(e3)
ylim([-1.5,1.5])
xlim([0;N+5])
title("P = 20")
xlabel("Temps [n]")
ylabel("Amplitude")
sgtitle("Erreurs pour différents ordres de filtre, mu=0.01")



h1 = fir1(9,(0.5));
d = filter(h1,1,x)+noise;
[w,y,e] = algolms(x,d,10,mu);
h2 = fir1(9,(0.5));
d = filter(h2,1,x)+noise;
[w,y,e2] = algolms(x,d,10,5*mu);
h3 = fir1(9,(0.5));
d = filter(h3,1,x)+noise;
[w,y,e3] = algolms(x,d,10,10*mu);

figure()
subplot(311)
plot(e)
ylim([-1.5,1.5])
xlim([0;N+5])
title("mu=0.01")
xlabel("Temps [n]")
ylabel("Amplitude")
subplot(312)
plot(e2)
xlim([0;N+5])
ylim([-1.5,1.5])
title("mu = 0.05")
xlabel("Temps [n]")
ylabel("Amplitude")
subplot(313)
plot(e3)
ylim([-1.5,1.5])
xlim([0;N+5])
title("mu = 0.1")
xlabel("Temps [n]")
ylabel("Amplitude")
sgtitle("Erreurs pour différents mu, P=10")



%% Signal audio avec une voix

clc;
close all;

mu = 0.01;


[x,Fs]=audioread("Voix1.wav");
%sound(x,Fs)
h_salle = importdata("Rep.dat");

s = filter(h_salle,1,x);
%sound(s,Fs)


noise = 0.1*randn(length(x),1);
s2 = s + noise;



figure()
subplot(211)
hold on
plot(x)
plot(s)
hold off
xlim([0 length(x)+5])
xlabel("Temps [n]")
ylabel("Amplitude")
legend("Signal vocal d'entrée","Signal filtré")
subplot(212)

hold on
plot(x)
plot(s2)
hold off
xlim([0 length(x)+5])
xlabel("Temps [n]")
ylabel("Amplitude")
legend("Signal vocal d'entrée","Signal filtré bruité")

sgtitle("Comparaison du signal de la voix d'entrée de la voix filtrée et de la voix filtrée bruité")

[~, y_lms, sortie] = algolms(s2, x, 200, mu);

figure()
subplot(211)
plot(x)
title("Signal d'origine")
xlabel("Temps [n]")
ylabel("Amplitude")
ylim([-1 1])
xlim([0 length(x)+5])
subplot(212)
plot(sortie)
ylim([-1 1])
xlim([0 length(x)+5])
title("Signal d'erreur du LMS")
xlabel("Temps [n]")
ylabel("Amplitude")
sgtitle("Comparaison du signal d'entrée et le signal d'erreur renvoyé par le LMS")

%% Signal Audio avec deux voix
clc;
close all;


load farspeech
load nearspeech
h_salle = importdata("Rep.dat");

x_filt = filter(h_salle, 1, x);

dialogue = v + x_filt;
P1 = 1000;
P2 = 500;
mu1 = 0.1;
mu2 = 0.01;
[~, y, sortie] = algolms(x, dialogue, P1, mu1);

figure()
subplot(311)
plot(y)
xlim([0 length(x)+5])
xlabel("Temps [n]")
ylabel("Amplitude")
title("Signal d'entrée (en A)")
subplot(312)
plot(dialogue)
xlim([0 length(x)+5])
xlabel("Temps [n]")
ylabel("Amplitude")
title("Signal de référence (Entrée en B)")
subplot(313)
plot(sortie)
xlim([0 length(x)+5])
xlabel("Temps [n]")
ylabel("Amplitude")
title("Signal d'erreur (Renvoyé dans la salle A)")
sgtitle("Comparaison des différents signaux mis en jeu, P=1000;mu=0.1")

[~, y, sortie] = algolms(x, dialogue, P2, mu1);

figure()
subplot(311)
plot(y)
xlim([0 length(x)+5])
xlabel("Temps [n]")
ylabel("Amplitude")
title("Signal d'entrée (en A)")
subplot(312)
plot(dialogue)
xlim([0 length(x)+5])
xlabel("Temps [n]")
ylabel("Amplitude")
title("Signal de référence (Entrée en B)")
subplot(313)
plot(sortie)
xlim([0 length(x)+5])
xlabel("Temps [n]")
ylabel("Amplitude")
title("Signal d'erreur (Renvoyé dans la salle A)")
sgtitle("Comparaison des différents signaux mis en jeu, P=500;mu=0.1")

[~, y, sortie] = algolms(x, dialogue, P1, mu2);

figure()
subplot(311)
plot(y)
xlim([0 length(x)+5])
xlabel("Temps [n]")
ylabel("Amplitude")
title("Signal d'entrée (en A)")
subplot(312)
plot(dialogue)
xlim([0 length(x)+5])
xlabel("Temps [n]")
ylabel("Amplitude")
title("Signal de référence (Entrée en B)")
subplot(313)
plot(sortie)
xlim([0 length(x)+5])
xlabel("Temps [n]")
ylabel("Amplitude")
title("Signal d'erreur (Renvoyé dans la salle A)")
sgtitle("Comparaison des différents signaux mis en jeu, P=1000;mu=0.01")

[~, y, sortie] = algolms(x, dialogue, P2, mu2);

figure()
subplot(311)
plot(y)
xlim([0 length(x)+5])
xlabel("Temps [n]")
ylabel("Amplitude")
title("Signal d'entrée (en A)")
subplot(312)
plot(dialogue)
xlim([0 length(x)+5])
xlabel("Temps [n]")
ylabel("Amplitude")
title("Signal de référence (Entrée en B)")
subplot(313)
plot(sortie)
xlim([0 length(x)+5])
xlabel("Temps [n]")
ylabel("Amplitude")
title("Signal d'erreur (Renvoyé dans la salle A)")
sgtitle("Comparaison des différents signaux mis en jeu, P=500;mu=0.01")
