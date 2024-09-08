
1. Network configuration
2. x86_64 
3. Mount and move
4. Full disk encryption



Notes:

- If you include a path that depends on the flake, then the file/folder that path refers to will be pulled into the nix store. For example I had a `${rootPath}` variable that was set from the flake, this made a symlinked file not really symlinked and in fact pulled into the nixstore. So I changed it into an absolute path.



