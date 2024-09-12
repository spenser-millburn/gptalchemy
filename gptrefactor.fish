function gptrefactor
    # Get the current working directory
    set cwd (pwd)

    # Store the user-supplied refactor prompt
    set refactor_prompt "$argv"

    # Fetch the current state of the project by walking and concatenating the file contents
    set project_context (walk_and_cat_source)

    # Define the structure of the current files overview
    set json_structure "A list of dictionaries, each with a filename as the key and a description of the current file contents."
    set json_prompt "Please describe the current files in the project. The key should be the file path, and the value should be a brief description of the current contents. The structure of this file should be $json_structure"

    # Generate a file overview in JSON format
    set file_overview_json (g from "$project_context" . "$json_prompt")

    # echo $file_overview_json | tee file_overview.json | jq

    # Define the structure for refactor actions, now including directory creation
    set refactor_json_structure "A list of dictionaries, each with an 'operation' key specifying the action ('create', 'create_dir', 'move', 'delete', 'modify')."

    set move_create_keys "For 'create' operations, include 'file' and 'description' keys.
                          For 'move' operations, include 'source' and 'destination' keys.
                          For 'create_dir' operations, include a 'directory' key. 
                          For 'modify' operations, include 'file' and 'description' keys."

    set refactor_json_prompt "Please analyze the current files and generate a refactor plan. The structure should be $refactor_json_structure. $move_create_keys. The plan should reflect this refactor prompt: $refactor_prompt."

    set filter_no_changes "If no changes are required, please don't include the file in the output."

    # Generate the refactor plan
    set refactor_plan (g "$refactor_prompt" "$file_overview_json" "$refactor_json_prompt" "$filter_no_changes")
    
    # --------------------------------------------------------------------------------------------------------
    h1 "                                  REFACTOR PLAN                                                        "
    # --------------------------------------------------------------------------------------------------------
    echo $refactor_plan | tee refactor_plan.json | jq

    set refactor_plan_file refactor_plan.json

    # --------------------------------------------------------------------------------------------------------
    h1 "                                  APPLYING REFACTOR ACTIONS                                             "
    # --------------------------------------------------------------------------------------------------------

    # Process each action in the refactor plan
    for item in (cat $refactor_plan_file | jq -c '.[]')
        set operation (echo $item | jq -r '.operation')

        switch $operation
            case "create"
                set file_name (echo $item | jq -r '.file')
                set new_dir (dirname $file_name)

                # Create the directory if necessary
                if not test -d $new_dir
                    e "Creating directory $new_dir"
                    mkdir -p $new_dir
                end

                # Create the file with the provided content
                e "Creating file $file_name"
                echo $item | g (jq -r '.description') > $file_name
                continue

            case "create_dir"
                set directory (echo $item | jq -r '.directory')

                # Create the directory if necessary
                if not test -d $directory
                    e "Creating directory $directory"
                    mkdir -p $directory
                else
                    e "Directory $directory already exists"
                end
                continue

            case "move"
                set source_file (echo $item | jq -r '.source')
                set destination_file (echo $item | jq -r '.destination')
                set destination_dir (dirname $destination_file)

                # Create the destination directory if necessary
                if not test -d $destination_dir
                    e "Creating directory $destination_dir"
                    mkdir -p $destination_dir
                end

                e "Moving $source_file to $destination_file"
                mv $source_file $destination_file
                continue

            case "delete"
                set file_name (echo $item | jq -r '.file')

                if test -d $file_name
                    e "Deleting directory $file_name"
                    rm -r $file_name
                else
                    e "Deleting file $file_name"
                    rm $file_name
                end
                continue

            case "modify"
                set file_name (echo $item | jq -r '.file')
                set modification_desc (echo $item | jq -r '.description')

                e "Modifying $file_name based on description: $modification_desc"
                
                # Fetch the current content of the file
                set current_content (cat $file_name)

                # Use GPT to modify the file content
                g "$modification_desc" "Please modify this file. Here is the current content:" "$current_content" > $file_name
                e "Modification applied to $file_name"
                continue

            case "*"
                e "Unknown operation: $operation"
        end
    end

    # --------------------------------------------------------------------------------------------------------
    h1 "                                  REFACTOR REVIEW                                                      "
    # --------------------------------------------------------------------------------------------------------

    # Review the modified files and identify any issues with the changes
    walk_and_cat_source | g "Please review these modified files and identify any issues with the changes" > REFACTOR_REVIEW.md
    mdview REFACTOR_REVIEW.md

    # if gptguard are there any critical things to fix here. Only MAJOR problems. : (cat ./REFACTOR_REVIEW.md)
        # h1 Fixing Issues
        # gptmodify (cat ./REFACTOR_REVIEW.md)
    # else
      # h1 no issues to fix
    # end
#
    remove_code_blocks
    cd $cwd
end
