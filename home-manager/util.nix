lib: rec {

  # function: (item -> key,value), list -> {key1=value1, key2=value2 }
  mapListAttrs = fun: list: builtins.listToAttrs (map fun list);

  # Generic function to create symlinks for files in a source directory
  symlinkFiles = { sourceDir, targetDir }:
    let
      files = builtins.attrNames (builtins.readDir sourceDir);
      newPaths = mapListAttrs (file: {
        name = "${targetDir}/${file}";
        value = {
          source = lib.file.mkOutOfStoreSymlink "${sourceDir}/${file}";
        };
      }) files;
    in newPaths;

}
