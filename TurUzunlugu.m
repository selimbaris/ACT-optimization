
function L=TurUzunlugu(tur,model)

    n=numel(tur);

    tur=[tur tur(1)];
    
    L=0;
    for i=1:n
        L=L+model.D(tur(i),tur(i+1));
    end

end