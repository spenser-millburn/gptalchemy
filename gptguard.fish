function gptguard
    # Take user input as a prompt
    set prompt "$argv"

    # Set up a GPT prompt that expects a simple "true" or "false" response
    set guard_prompt "Please respond with 'true' or 'false' only based on this: $prompt"

    # Call GPT and capture the response
    set response (g "$guard_prompt")

    # Normalize the response to lowercase and trim any whitespace
    set response (string trim -- $response)
    set response (string lower $response)

    # Return true if the response is "true", else return false
    if test "$response" = "true"
        return 1
    else
        return 0
    end
end
