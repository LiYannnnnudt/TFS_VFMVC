clear all; clc;

% --------------- data ----------------- %

warning('off','last')

addpath(genpath('./'));
datadir = '../TFS_VFMVC/';  %%path
dataname={'YALE'};  %%dataname
prop = 0.5;
numdataset = length(dataname); %  dataset number
numname = {strcat('_Per',num2str(prop),'sub1')};  %%for missing ratio
metric = {'ACC','nmi','Purity','Fscore','Precision','Recall','AR','Entropy'};


datafile = [datadir, cell2mat(dataname),'/',cell2mat(dataname) ,cell2mat(numname),'.mat'];
load(datafile);


resultdir2 = 'totalResults/';
if (~exist('totalResults', 'file'))
    mkdir('totalResults');
    addpath(genpath('totalResults/'));
end

p = length(sub_NormDataM);%The number of the client

%--------- parameters ---------%
c = length(unique(Y));
maxIter = 50;
anchor_traverse = 5; % R

alpha_all = [0.001,0.01,0.1,1,10];
lamuda_all=[0.01,0.1,1,10];

ResBest = zeros(1,8);

numanchor = c;
for i = 1:length(alpha_all)
    alpha = alpha_all(i);
    for j = 1:length(lamuda_all)
        lamuda = lamuda_all(j);
        disp([char(dataname),'-', num2str(prop),'-anchornumber_k=',num2str(numanchor),'-alpha=', num2str(alpha),'-lamuda=', num2str(lamuda)]);

        for fold = 1:10
            tic
            [Obj{i,j},Uout{i,j}]= algo_Fedmulti(sub_NormDataM,Y,numanchor,alpha,lamuda,c,sub_flagM);
            U = Uout{i,j};
            [~,label1] = max(U);

            timefold(fold) = toc;
            res(fold, : ) = Clustering8Measure(label1', Y);
        end

        meantime = mean(timefold);
        tempResMean = mean(res);
        tempResBest = tempResMean;
        tempResStd = std(res);
        meanACC(i, j) = tempResMean(1);
        meanNMI(i, j) = tempResMean(2);
        meanPurity(i, j) = tempResMean(3);
        meanFscore(i, j) = tempResMean(4);

        stdACC(i, j) = tempResStd(1);
        stdNMI(i, j) = tempResStd(2);
        stdPurity(i, j) = tempResStd(3);
        stdFscore(i, j) = tempResStd(4);
        for tempIndex = 1 : 8
            if tempResBest(tempIndex) > ResBest(tempIndex)

                ResBest(tempIndex) = tempResMean(tempIndex);
                ResStd(tempIndex) = tempResStd(tempIndex);
            end
        end
        %result = [ACC nmi Purity Fscore Precision Recall AR Entropy]
    end
end

% figure
% objplo = Obj{4,1};
% plot(objplo);
% xlabel = 'Number of iterations';
% ylabel = 'Objective value';
% ACCbest = max(max(cell2mat(anchorACC)));
save([resultdir2, char(dataname), char(numname), 'ACC_', num2str(ResBest(1)), '_result_Main4.mat']);

