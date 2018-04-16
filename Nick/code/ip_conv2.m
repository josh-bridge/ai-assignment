function outimage = ip_conv2(inimage,kernel)

[ir,ic] = size(inimage);
[kr,kc] = size(kernel);
outimage = zeros(ir,ic);
okr = (kr-1)/2;
okc = (kc-1)/2;
for i=okr+1:ir-okr
    for j=okc+1:ic-okc
        out = 0;
        for m=-okr:okr
            for n=-okc:okc
                out = out + inimage(i+m,j+n)*kernel(okr+m+1,okc+n+1);
            end
        end
        outimage(i,j) = out;
    end
end