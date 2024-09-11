function g
    set input (string trim -c ' ' $argv)
    set output (sgpt "$input" --no-cache --model "gpt-4o" )
    echo (string trim -c ' ' $output) | xargs
end

