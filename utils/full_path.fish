# Defined in /tmp/fish.NsSwnN/full_path.fish @ line 1
function full_path
readlink -f $argv[1]
end
