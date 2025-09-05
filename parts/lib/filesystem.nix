_: let
  inherit (builtins) readDir attrNames;
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
}
