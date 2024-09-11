function walk_and_cat_source
    set path .
    if test (count $argv) -gt 0
        set path $argv[1]
    end

    for file in (find $path -type f)
        if file $file | grep -qE 'Python|C\+\+|Java|JavaScript|Ruby|Perl|PHP|HTML|CSS|Shell|Dockerfile|docker-compose\.yml'
            echo $file
            cat $file
        end
    end
end
