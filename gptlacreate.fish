function gptlacreate

    set cwd (pwd)
    set base_prompt "$argv"
    set proj_folder (g respond with a single folder name in snake case format for this project $base_prompt. respond with the folder name only and nothing else)

    # Set up  
    h1 Creating New Project: ./$proj_folder
    mkdir -p  $proj_folder 
    cd $proj_folder
    # Prompt the plan
    # --------------------------------------------------------------------------------------------------------
    h1 "PLANNING"
    # --------------------------------------------------------------------------------------------------------
    set overview (g $base_prompt)

    # Determine the project's language dynamically
    set code_languages (g "Which programming languages should be used for the following project? Please respond with the languages only based on the following prompt: $overview")

    set json_structure "A list of dictionaries, each with a filename as the key and a description as the value."
    
    set json_prompt "Please create a json array describing each of the files required, as well as all methods and their method signatures/return types based on the language '$code_language'. The method signatures are critical as an AI agent will use them to interface multiple files together at generation. The key should be the file path and the value should be a description of the file contents without going into great detail. The structure of this file should be $json_structure."

    set relative_only_prompt "Please make all file paths relative to the current working directory."
    set typing_prompt "Ensure method signatures and variable types are properly specified for $code_language compatibility."

    set json (g from $code_language. $overview . $json_prompt  . $relative_only_prompt. $typing_prompt)
    e JSON:

    set json_file_name files.json
    e $json | tee $json_file_name | jq
    set json_file_path (full_path $json_file_name )
    e json file path :: $json_file_path

    # --------------------------------------------------------------------------------------------------------
    h1 "PLAN VALIDATION"
    #--------------------------------------------------------------------------------------------------------
    echo $json | g please summarize this plan for an architecture and confirm its viability > PLAN_VALIDATION.md
    mdview PLAN_VALIDATION.md

    # --------------------------------------------------------------------------------------------------------
    h1 "BUILDING"
    # --------------------------------------------------------------------------------------------------------
    set json_content (cat $json_file_path | jq -c '.[]')

    for item in $json_content
        set file_name (echo $item | jq -r 'keys[0]')
        set file_content_desc (echo $item | jq -r '.[keys[0]]')
        
        # Extract the directory from the file_name
        set dir_name (dirname $file_name)
        
        # Check if the directory exists, if not, create it
        if not test -d $dir_name
            mkdir -p $dir_name
        end
        
        e $file_name : $file_content_desc
        
        # Generate the file content using GPT
        g "Please implement the following file based on the description: $file_content_desc. Make sure the code is implemented in $code_languages unless it's a configuration or non-code file (e.g., requirements.txt). Do not include the plan in the code files" > $file_name
    end

    remove_code_blocks

    # --------------------------------------------------------------------------------------------------------
    h1 "IMPLEMENTATION REVIEW"
    # --------------------------------------------------------------------------------------------------------
    walk_and_cat_source | g please identify any problems > REVIEWME.md
    mdview REVIEWME.md

    # --------------------------------------------------------------------------------------------------------
    h1 "DOCUMENTATION"
    # --------------------------------------------------------------------------------------------------------
    walk_and_cat_source | g please write a nicely formatted, but minimal and to the point markdown README file, respond with the content of this file only > README.md
    mdview ./README.md
    # dockerize (if needed)
    # autorun (optional)
    if not test -d .git; git init; git add . ; end
    gcm
    cd $cwd
end
