function dockerize
    # Get the current working directory
    set cwd (pwd)

    # Store the user-supplied prompt for Dockerization
    set docker_prompt "I want to dockerize this project. Please create a Dockerfile and a docker-compose.yml for the root of the repository. The project context will be provided."

    # Fetch the current state of the project by walking and concatenating the file contents
    set project_context (walk_and_cat)

    # Combine the project context and the Dockerization prompt
    set full_docker_prompt "$docker_prompt. Here is the project context: $project_context"

    # Generate Dockerfile using GPT
    set dockerfile_desc "Please generate a Dockerfile for this project based on the provided context. The Dockerfile should be simple and efficient, use best practices, and specify necessary dependencies and build steps. respond with onnly the Dockerfile content and nothing more"
    g "$full_docker_prompt" "$dockerfile_desc" > Dockerfile
    # cat Dockerfile

    # Generate docker-compose.yml using GPT
    set compose_desc "Please generate a docker-compose.yml file for this project based on the provided context. It should define services, volumes, and networks if needed, and make sure to expose the correct ports. Respond with only the docker compose file and nothing more"
    g "$full_docker_prompt" "$compose_desc" > docker-compose.yml
    h1 DOCKERIZATION COMPLETE

    # cat docker-compose.yml
    # docker-compose build
    # docker-compose up -d


    # Update the README to reflect the Dockerization process
    # walk_and_cat_source | g please update the README to include instructions for running the project in Docker > README.md
    # mdview README.md
#
    remove_code_blocks
    cd $cwd
end
