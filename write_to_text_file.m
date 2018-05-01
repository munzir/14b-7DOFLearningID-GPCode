function  write_to_text_file( matrix,filename)
    fid = fopen(filename,'wt');
    for ii = 1:size(matrix,1)
        fprintf(fid,'%g\t',matrix(ii,:));
        fprintf(fid,'\n');
    end
    fclose(fid);
