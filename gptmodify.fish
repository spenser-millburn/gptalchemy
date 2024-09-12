function gptmodify
    # Get the current working directory
    set cwd (pwd)

    # Store the user-supplied modification prompt
    set modification_prompt "$argv"

    # Fetch the current state of the project by walking and concatenating the file contents
    set project_context (walk_and_cat_source)
    
    # Generate a description of the existing files using the project context
    set json_structure "A list of dictionaries, each with a filename as the key and a description of the current file contents."
    set json_prompt "Please describe the current files in the project. The key should be the file path, and the value should be a brief description of the current contents. The structure of this file should be $json_structure"
    
    set file_overview_json (g from "$project_context" . "$json_prompt")
    
    # echo $file_overview_json | tee file_overview.json | jq

    # Review the modification prompt and generate instructions for which files need to be changed
    set modification_json_structure "A list of dictionaries, each with a filename as the key and a description of the modifications needed to that file."
    set modification_json_prompt "Please analyze the current files and generate a list of modifications based on this prompt: $modification_prompt. The structure should be $modification_json_structure."

    set filter_no_modifications "If no modifications are required please dont include the modification in the output"

    set modification_plan (g "$modification_prompt" "$file_overview_json" "$modification_json_prompt" "$filter_no_modifications")
    # --------------------------------------------------------------------------------------------------------
    h1 "                                  MODIFICATION PLAN                                                   "
    # --------------------------------------------------------------------------------------------------------
    echo $modification_plan | tee modification_plan.json | jq

    set modification_plan_file modification_plan.json

    # --------------------------------------------------------------------------------------------------------
    h1 "                                  APPLYING MODIFICATIONS                                               "
    # --------------------------------------------------------------------------------------------------------

    set modification_content (cat $modification_plan_file | jq -c '.[]')
    for item in $modification_content
        set file_name (echo $item | jq -r 'keys[0]')
        set modification_desc (echo $item | jq -r '.[keys[0]]')

        e "Modifying $file_name based on: $modification_desc"
        g "$modification_desc" "please modify this file according to the description, here is the current file content:" (cat $file_name) > $file_name
    end

    # --------------------------------------------------------------------------------------------------------
    h1 "                                  MODIFICATION REVIEW                                                  "
    # --------------------------------------------------------------------------------------------------------

    walk_and_cat_source | g please review these modified files and identify any issues with the changes > MODIFICATION_REVIEW.md
    mdview MODIFICATION_REVIEW.md

    # e --------------------------------------------------------------------------------------------------------
    # e "                                  DOCUMENTATION UPDATE                                                 "
    # e --------------------------------------------------------------------------------------------------------

    # walk_and_cat_source | g please update the README to reflect recent modifications > README.md
    # mdview README.md

    remove_code_blocks
    cd $cwd
end
