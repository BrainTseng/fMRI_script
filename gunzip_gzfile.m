for n = 1:28
    if n < 10
        i = sprintf('0%d', n);
    else
        i = num2str(n);
    end
    filename = ['/Users/this_is_not_a_macbook/Desktop/conn_demo/sub-' i '/func/sub-' i '_task-rest_run-01_bold.nii'];
    if ~isfile(filename)
        gunzip([filename '.gz']);
    end
end