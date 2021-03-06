function [DataAlign,corrCoeff,delay] = MccAlignment(s)

tmpSTF=s;
corrCoeff=zeros(size(tmpSTF,1),size(tmpSTF,1));delay=corrCoeff;

for y = 1 : size(tmpSTF,1)
    for x = 1 : size(tmpSTF,1)
        
    
        
       
        
    c_tmp = xcorr(tmpSTF(y,:),tmpSTF(x,:),'coeff');   
    
    tm1 = c_tmp((c_tmp==max(c_tmp)));
    tm2 = c_tmp((c_tmp==min(c_tmp)));   
    
    TM = [tm1(1) tm2(1)];
    
    
    cstore=find(abs(TM)==max(abs(TM)));
    
    delay(y,x) = find(TM(cstore)==c_tmp);
    
    corrCoeff(y,x) = TM(cstore);clear tm cstore

    clear c_tmp
    end
end


for id = 1 : size(corrCoeff,1)
    
   DT = delay(1,1) - mean(delay(id,:)) ;
    
    % align the data
    if DT > 0
    datatmp = zeros(size(s(id,:)));
    datatmp(DT+1:end)=s(id,1:end-DT);
    
    elseif DT < 0
    dt = abs(DT);    
    datatmp = zeros(size(s(id,:)));
    datatmp(1:end-dt)=s(id,dt+1:end);
    
    elseif DT==0 
    datatmp = s(id,:);
    end
    
   DataAlign(id,:) = datatmp; clear datatmp
    
    
end


delay=delay-delay(1,1);