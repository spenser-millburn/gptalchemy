function gptarchitect
    # Generate the full list of subsystems as a JSON array with descriptions
    set system_prompt "$argv"
    set json_prompt "Based on the following system description, generate a flat list of subsystems in JSON format, where each element is a dictionary with 'name' and 'description' fields. Only respond with the JSON array: $system_prompt"
    set subsystem_list_json (g "$json_prompt")

    # Print the JSON subsystem list to the screen
    h1 "Subsystem List (JSON):"
    echo $subsystem_list_json | jq

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
        gptcreate "Design and implement a FastAPI app for the subsystem $subsystem_name. The subsystem should have at least one endpoint that handles relevant operations for the system described as: $description. Keep the folder structure flat and minimal."

        # Add the subsystem name to the list for orchestration
        set subsystem_list $subsystem_list $subsystem_name

        cd ..
    end

    # Process the flat JSON array of subsystems
    function process_subsystems
        set json_data "$argv[1]"
        set parent_description "$argv[2]"

        # Loop through the flat JSON array, expecting each element to be a subsystem object with 'name' and 'description'
        for subsystem in (echo "$json_data" | jq -c '.[]')
            set subsystem_name (echo "$subsystem" | jq -r '.name')
            set subsystem_description (echo "$subsystem" | jq -r '.description')

            # Implement the subsystem as a FastAPI app
            implement_subsystem "$subsystem_name" "$subsystem_description"
        end
    end

    # Generate the main project folder name based on the system description
    set project_folder (g "Respond with a single folder name in snake_case format for this project: $system_prompt. Respond with the folder name only and nothing else.")
    mkdir -p $project_folder
    cd $project_folder

    # Process the flat list and implement the subsystems as FastAPIs
    process_subsystems "$subsystem_list_json" "$system_prompt"

    # Generate the main orchestrator content using GPT
    set orchestrator_prompt "Create a FastAPI orchestrator that calls the following subsystems via API. Each subsystem is a FastAPI app located at http://localhost:8000/{subsystem_name}, and each subsystem has an endpoint at the root ('/'). The orchestrator should have an endpoint for each subsystem that makes a request to the respective subsystem's API and returns its response. The subsystems are: $subsystem_list. Please ensure to only respond with the code."
    g "$orchestrator_prompt" > "main_orchestrator.py"
    echo "Main FastAPI orchestrator created at $project_folder/main_orchestrator.py."
    echo "Architecture complete"
end

