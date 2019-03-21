function y = remove_art(a)
    t1 = a(91:100);t2 = a(111:120);
    r1 = flip(t1);r2 = flip(t2);
    x1 = 1;x2 = 0;tt=1/10;
      for j=1:10 
          t1(j) = r1(j)*x1;
          t2(j) = r2(j)*x2;
          x1 = x1-tt;          
          x2 = x2+tt;
      end
    y = t1+t2;
end

