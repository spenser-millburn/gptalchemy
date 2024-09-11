function walk_and_cat_docker
    for file in (find . -type f \( -name 'Dockerfile' -o -name 'docker-compose.yml' \))
        echo $file
        cat $file
    end
end
