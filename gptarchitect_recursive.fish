function gptarchitect_recursive
    # Generate the full tree of subsystems as a JSON structure
    set system_prompt "$argv"
    set json_prompt "Based on the following system description, generate a detailed tree of subsystems and their nested subsystems in JSON format, each node in the tree should be its own subsystem which may or may not have child subsystems, and there should be no other content in this tree other than the substem keys. Only respond with the JSON object: $system_prompt"
    set subsystem_tree (g "$json_prompt")

    # Print the JSON subsystem tree to the screen
    h1 "Project Tree Structure (JSON):"
    echo $subsystem_tree | jq

    # Create a list to track subsystems for the main orchestration script
    set subsystem_list

    # Function to implement the subsystem as a FastAPI app
    function implement_subsystem
        set subsystem_name "$argv[1]"
        set description "$argv[2]"

        # Create the folder for the subsystem
        mkdir -p $subsystem_name
        cd $subsystem_name

        # Implement this subsystem as a FastAPI app via gptcreate
        h2 "Implementing FastAPI subsystem: $subsystem_name"
        gptcreate "Design and implement a FastAPI app for the subsystem $subsystem_name. The subsystem should have at least one endpoint that handles relevant operations for the system described as: $description"

        # Add the subsystem name to the list for orchestration
        set subsystem_list $subsystem_list $subsystem_name

        cd ..
    end

    # Recursively process the JSON tree
    function process_json_tree
        set json_data "$argv[1]"
        set parent_description "$argv[2]"

        # Loop through the JSON tree, expecting each key to be a subsystem name
        for key in (echo "$json_data" | jq -r 'keys[]')
            set subsystem_name $key
            set subsystem_description (echo "$json_data" | jq -r --arg key "$subsystem_name" '.[$key]')

            # Implement the subsystem as a FastAPI app
            implement_subsystem "$subsystem_name" "$subsystem_description"

            # Check if the current subsystem has nested subsystems
            set nested_subsystems (echo "$json_data" | jq -r --arg key "$subsystem_name" '.[$key] | select(type == "object") | keys[]?')

            if test -n "$nested_subsystems"
                mkdir -p $subsystem_name
                cd $subsystem_name
                process_json_tree "$subsystem_description" "$subsystem_description"
                cd ..
            end
        end
    end

    # Generate the main project folder name based on the system description
    set project_folder (g respond with a single folder name in snake_case format for this project $system_prompt. respond with the folder name only and nothing else)
    mkdir -p $project_folder
    cd $project_folder

    # Process the JSON tree and implement the subsystems as FastAPIs
    process_json_tree "$subsystem_tree" "$system_prompt"

    # Generate the main orchestrator content using GPT
    set orchestrator_prompt "Create a FastAPI orchestrator that calls the following subsystems via API. Each subsystem is a FastAPI app located at http://localhost:8000/{subsystem_name}, and each subsystem has an endpoint at the root ('/'). The orchestrator should have an endpoint for each subsystem that makes a request to the respective subsystem's API and returns its response. The subsystems are: $subsystem_list. Please ensure to only respond with the code."
    set main_orchestrator_content (g "$orchestrator_prompt" here is the repository for context:  (walk_and_cat_source))

    # Write the orchestrator content to the main_orchestrator.py file
    echo "$main_orchestrator_content" > "main_orchestrator.py"
    echo "Main FastAPI orchestrator created at $project_folder/main_orchestrator.py."

    echo "Architecture complete"
end
