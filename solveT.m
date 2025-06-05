function x=solveT(T)
% T=[1,5,3;2,-1,-4;0,-3,6];

f=-T';
f=f(:)';
lb=zeros(size(T,1)*size(T,2),1);
up=ones(size(T,1)*size(T,2),1);
Aeq=zeros(size(T,1)+size(T,2),size(T,1)*size(T,2));
Aeq(1:size(T,1),:)=repmat(eye(size(T,1),size(T,1)),1,size(T,2));
for i=1:size(T,2)
    Aeq(size(T,1)+i,(i-1)*size(T,1)+1:i*size(T,1))=ones(1,size(T,1));
end
beq=ones(size(T,1)+size(T,2),1);
intc=[1:size(T,1)*size(T,2)];
options=optimoptions('intlinprog','Display','none');%目的：为了不输出优化信息
% [x,function_val]=intlinprog(f,intc,[],[],Aeq,beq,lb,up);
[x,function_val]=intlinprog(f,intc,[],[],Aeq,beq,lb,up,options);

% [x,function_val]=linprog(f,[],[],Aeq,beq,lb,up);
% options=optimoptions('linprog','Display','none');
% [x,function_val]=linprog(f,[],[],Aeq,beq,lb,up,options);
x=reshape(x,size(T,1),size(T,2));