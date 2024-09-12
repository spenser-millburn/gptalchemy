function autorun
    # Gather project structure and file contents
    set project_context (walk_and_cat_source)

    # Set up a GPT prompt to analyze the project and determine the appropriate run command
    set run_prompt "Based on the following project files and content, please suggest a command to run the project: $project_context.
    Only respond with the exact command to run the project. In addition: $argv "

    # Get the run command using GPT
    set run_command (g "$run_prompt")

    e $run_command
    # e $run_command | clip

    set response
    if test (count $argv) -gt 0
        if test $argv[1] = "y"
            set response "y"
        else
            set response "n"
        end
    else
        read --prompt-str "Do you want to run this command? (y/n): " response
    end

    if test "$response" = "y"
        echo "Running the application..."
        eval $run_command
    end
end
