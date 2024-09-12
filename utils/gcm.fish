function gcm
    set diff (git diff)
    set stat (git status)

    if not git config --get user.email > /dev/null
        git config --global user.email "you@example.com"
        git config --global user.name "Your Name"
    end

    git commit -am (g "diff : $diff , status: $stat. please write a 5 word commit message")
end
