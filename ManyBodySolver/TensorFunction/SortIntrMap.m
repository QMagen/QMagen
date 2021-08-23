function [ IntrMap ] = SortIntrMap( IntrMap )
% function [ IntrMap ] = SortIntrMap( IntrMap )
% Sort IntrMap according to IntrMap.JmpOut
% Yuan Gao@buaa 2021.04.06
% mail: 17231064@buaa.edu.cn
i = 1;
while i < length(IntrMap)
    if IntrMap(i).JmpOut > 0 && IntrMap(i+1).JmpOut > 0 && IntrMap(i).JmpOut > IntrMap(i+1).JmpOut
        T = IntrMap(i);
        IntrMap(i) = IntrMap(i+1);
        IntrMap(i+1) = T;
        i = 0;
    end
    i = i + 1;
end
i = 1;
while i < length(IntrMap)
    if IntrMap(i).JmpOut == IntrMap(i+1).JmpOut && IntrMap(i).JmpOut > 0 && IntrMap(i).JmpIn < IntrMap(i+1).JmpIn
        T = IntrMap(i);
        IntrMap(i) = IntrMap(i+1);
        IntrMap(i+1) = T;
        i = 0;
    end
    i = i + 1;
end

end

