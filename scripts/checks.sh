nix flake show --json --no-warn-dirty > flake.json
checks=$(jq -r '.checks."x86_64-linux" | keys | join("\n")' < flake.json)

for ele in `echo -e $checks`
do
    nix build .#checks.x86_64-linux.$ele --no-link --no-warn-dirty 
done

rm flake.json
