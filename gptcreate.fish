function gptcreate

    set cwd (pwd)
    set base_prompt "$argv"
    set proj_folder (g respond with a single folder name in snake case format for this project $base_prompt. respond with the folder name only and nothing else)

    #Set up  
    h1 Creating New Project: ./$proj_folder
    mkdir -p  $proj_folder 
    cd $proj_folder
    #Prompt the plan
    # --------------------------------------------------------------------------------------------------------
    h1 "PLANNING"
    # --------------------------------------------------------------------------------------------------------
    set overview (g $base_prompt)

    set code_language "This application should be implemented in Python. Not in fish shell.  "

    set json_structure "A list of dictionaries, each with a filename as the key and a description as the value."
    
    set json_prompt "please create a json array describing each of the files required, as well as the critical methods
    and their method signatures/return types.
    The key should be the file path and the value should be a description of the implementation without going into extreme detail.
    The structure of this file should be $json_structure."

    set typer_wrapper_prompt "This project should be implemented as a typer cli wrapper that is separate from the business logic file(s).
    please do not respond with any code yet"

    set relative_only_prompt "Please make all file paths relative to the current working directory"


    set json (g from $code_language. $overview . $json_prompt  . $typer_wrapper_prompt . $relative_only_prompt)
    e JSON:

    set json_file_name files.json
    e $json | tee $json_file_name | jq
    set json_file_path (full_path $json_file_name )
    e json file path :: $json_file_path


    # --------------------------------------------------------------------------------------------------------
    h1 "PLAN VALIDATION"
    #--------------------------------------------------------------------------------------------------------
    echo $json | g please summarize this plan for an architecture and confirm its viable > PLAN_VALIDATION.md
    mdview PLAN_VALIDATION.md
#
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
        g "I would like you to please implement the following $file_content_desc and only respond with the file content. For context, here is the entire current repo (walk_and_cat_source)" > $file_name
    end

    remove_code_blocks

    # --------------------------------------------------------------------------------------------------------
    h1 "IMPLEMENTATION REVIEW"
    # --------------------------------------------------------------------------------------------------------
    walk_and_cat_source | g please identify any problems > REVIEWME.md
    mdview REVIEWME.md
    if gptguard "(cat REVIEWME.md)"
      h1 Fixing Issues 
      gptmodify (cat REVIEWME.md)
    else
      h1 No Problems 
    end

    #   --------------------------------------------------------------------------------------------------------
    h1 "DOCUMENTATION"
    #  --------------------------------------------------------------------------------------------------------
    walk_and_cat_source | g please wriite a nicely formatted, but minimal and to the point markdown README file, respond with the content of this file only > README.md
    mdview ./README.md
    create_python_requirements_txt
    dockerize
    # autorun
    cd $cwd
end
