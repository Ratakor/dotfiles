_: let
  inherit (builtins) readDir attrNames attrValues mapAttrs filter;
in {
  /**
  Given a directory, return a list of all files within it.

  # Inputs

  `dir`
  : The path to list

  # Type

  ```
  listFiles :: Path -> [Path]
  ```
  */
  listFiles = dir:
    readDir dir
    |> attrNames
    |> map (file: dir + /${file});

  /**
  Given a directory, return a list of all directories within it.

  # Inputs

  `dir`
  : The path to list

  # Type

  ```
  listDirs :: Path -> [Path]
  ```
  */
  listDirs = dir:
    readDir dir
    |> mapAttrs (
      name: kind:
        if kind == "directory"
        then dir + /${name}
        else null
    )
    |> attrValues
    |> filter (x: x != null);
}
