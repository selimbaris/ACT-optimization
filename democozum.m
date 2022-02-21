clc;
clear;
close all;

%% Problem tanımı

model=modelolusturma();

MaliyetFonksiyonu=@(tur) TurUzunlugu(tur,model);

nVar=model.n;

%% Karınca Koloni Optimizasyonu Parametreleri

MaxIt=3;         % Maksimum İterasyon Sayısı

nKarinca=70;        % Karınca Sayısı (Nüfus Büyüklüğü)

Q=0.9;

tau0=10*Q/(nVar*mean(model.D(:)));      % İlk Feromon

alpha=1;            % Feromon Üstel Ağırlığı
beta=5.3;           % Sezgisel Üstel Ağırlık

rho=0.1;            % Buharlaşma oranı


%% Başlatma

eta=1./model.D;                 % Sezgisel Bilgi Matrisi

tau=tau0*ones(nVar,nVar);       % Feromon Matrisi

BestMaliyet=zeros(MaxIt,1);    % En iyi Maaliyet Değerlerini Tutacak Dizi

% Empty Ant
empty_ant.Tur=[];
empty_ant.Maliyet=[];

% Karınca Kolonisi Matrisi
Karinca=repmat(empty_ant,nKarinca,1);

% En İyi Karınca
BestSol.Maliyet=inf;

%% KKS Ana DÖngü

for it=1:MaxIt

    % Karınca Hareketi
    for k=1:nKarinca

        Karinca(k).Tur=randi([1 nVar]); %% Random sayı döndürme 

        for l=2:nVar
            
            i=Karinca(k).Tur(end);
            
            P=tau(i,:).^alpha.*eta(i,:).^beta;
            
            P(Karinca(k).Tur)=0;
            
            P=P/sum(P);
            
            j=ruletcarkisecimi(P);
            
            Karinca(k).Tur=[Karinca(k).Tur j];
            
            
            
            
        end

        Karinca(k).Maliyet=MaliyetFonksiyonu(Karinca(k).Tur);
        
        if Karinca(k).Maliyet<BestSol.Maliyet
            BestSol=Karinca(k);
        end
        
    end

    % Feromon Güncelleme

    for k=1:nKarinca
        
        tur=Karinca(k).Tur;
        
        tur=[tur tur(1)]; %#ok
        
        for l=1:nVar
            
            i=tur(l);
            j=tur(l+1);
            
            tau(i,j)=tau(i,j)+Q/Karinca(k).Maliyet;
            
        end
        
    end


    % Buharlaşma
    tau=(1-rho)*tau;
    
    % Mağazadaki En İyi Maliyet
    BestMaliyet(it)=BestSol.Maliyet;

    % Yineleme Bilgilerini Göster
    disp(['Iterasyon ' num2str(it) ': Best Maliyet = ' num2str(BestMaliyet(it))]);

    % Deneme Çözümü
    figure(1);
    denemecozumu(BestSol.Tur,model);
    pause(0.01);
    
end

%% Sonuçlar
yol=char(num2str(BestSol.Tur));
yol=strrep(yol,'   ','-');
yol=strrep(yol,'  ','-');
yol=[yol,'-',num2str(BestSol.Tur(1,1))];
disp(yol)

figure;
plot(BestMaliyet,'LineWidth',2);
xlabel('Iterasyon');
ylabel('Best Maliyet');
grid on;



















