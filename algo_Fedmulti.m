function [obj,U]= algo_Fedmulti(subData,Y,numanchor,alpha,lamuda,k,ind_p)
% X: di * n
% G: m * n
flag = 1;
iter = 0;
obj = [];
maxIter=50;

% alpha = 0.01;%1/nv * ones(nv,1); % alpha initialization

Num_client = length(subData);
nv=length(subData{1}); % view num
num=length(Y); % sample num

Z = initfcm(numanchor, num);
for p = 1:Num_client
    sub_Z{p} = Z;
end
while flag
     iter = iter + 1;
    obj_p =0;       
    H = cell(p,nv);   % di * m
    T = cell(p,nv);
    for p = 1:Num_client
        X = subData{p};
        num = size(X{1}, 2);
        ind = ind_p{p};
        Z = sub_Z{p};
        missingindex = constructA(ind);

        for i = 1:nv     % initialization
            di = size(X{i},1);
            H{p,i} = zeros(di,numanchor);
            T{p,i} = eye(numanchor,numanchor);
            Mtmp = eye(num);
            Mtmp(:,(ind(:,i)==1)') = [];
            M{p,i} = Mtmp;
        end
      
        %% For p-th sub_Data, Complete the MultiView Clustering
        % optimize anchor H
        parfor i=1:nv
            C = X{i}*Z'*T{p,i}';
            [U0,~,V] = svd(C,'econ');
            H{p,i} = U0*V';
        end

         % optimize permutation T
        for i=1:nv
            C = H{p,i}'*X{i}*Z';
            T{p,i} = solveT(C');
        end



        % optimize consensus bipartite graph Z
        temp=zeros(numanchor,num);
        temp2=0;

        for j=1:nv
            Et{j} = ones(size(M{p,j},2),numanchor);
            temp=temp+ (1+alpha)*T{p,j}'*H{p,j}'*X{j}-0.5*alpha*Et{j}'*M{p,j}';
            temp2 = temp2+ (1-ind(:,j)');
        end
        temp2= temp2 + lamuda;

        temp=temp./temp2;
        for lie=1:num
            Z(:, lie) = EProjSimplex_new(temp(:,lie));
        end

        clear temp temp2  Et
        miss_idx(p) = sum(sum(1-ind_p{p}));
        sub_Z{p} = Z;

   end
    
    %% glbal optimization :membership matrice
    Ztmp =zeros(numanchor,num);
    num_of_all_data = sum(Num_client);
    weight_per_subset = miss_idx ./ sum(miss_idx);
    
    for subset_index = 1:Num_client
        Ztmp =Ztmp + weight_per_subset(subset_index).*sub_Z{subset_index};
    end
    
    for subset_index = 1:Num_client        
        sub_Z{subset_index} = Ztmp;
    end


          %% obj
       
            for p = 1:Num_client
                X = subData{p};  Zt = sub_Z{p};              
                objt1 = 0 ; objt2 = 0 ;
                for i =1:nv
                    v=[];ut=[];xm=[];
                    v = H{p,i}*T{p,i};
                    ut = Zt;ut(:,ind(:,i)==1)=[];
                    xm = X{i};xm(:,ind(:,i)==1)=[];
                    for j =1:sum(1-ind(:,i))
                        objt1 = objt1 + pdist2(xm(:,j)',(v*ut(:,j))');
                        for ij =1:numanchor
                            objt2 = objt2 + ut(ij,j)*pdist2((xm(:,j))',(v(:,ij))');
                        end
                    end
                end
                obj_p = obj_p + objt1 +alpha*objt2+ lamuda*norm(Z,'fro')^2;
            end
            obj(iter)  = obj_p;
    %% convergence
    if (iter>1) && (abs((obj(iter-1)-obj(iter))/(obj(iter-1)))<1e-5 || iter>maxIter || obj(iter) < 1e-10)
        flag=0;
    end

end

U = Z; 
% [U,~,~] = mySVD(Z',k);
% % % % or
% [U1,~,~]=svd(Z','econ');
% U1 = U1(:,1:k);


end
