function remove_code_blocks
    for file in (find . -type f)
        # Remove code block formatting from the first line if it exists
        sed -i '1s/^```[a-zA-Z]*//g' $file
        sed -i '1s/^```//g' $file
        
        # Remove code block formatting from the last line if it exists
        sed -i '$s/^```[a-zA-Z]*//g' $file
        sed -i '$s/^```//g' $file
    end
end
