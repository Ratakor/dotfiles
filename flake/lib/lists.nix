# TODO: improve docs (desc, Inputs & Examples)
{ ... }:
let
  inherit (builtins) foldl';
in
{
  /**
    Fold with index starting from 0.

    # Inputs

    `f`
    : 1\. Function argument

    `init`
    : 2\. Function argument

    `xs`
    : 3\. Function argument

    # Type

    ```
    ifold0 :: (b -> Int -> a -> b) -> b -> [a] -> b
    ```
  */
  ifold0 =
    f: init: xs:
    (foldl'
      ({ i, acc }: x: {
        i = i + 1;
        acc = f acc i x;
      })
      {
        i = 0;
        acc = init;
      }
      xs
    ).acc;

  /**
    Fold with index starting from 1.

    # Inputs

    `f`
    : 1\. Function argument

    `init`
    : 2\. Function argument

    `xs`
    : 3\. Function argument

    # Type

    ```
    ifold1 :: (b -> Int -> a -> b) -> b -> [a] -> b
    ```
  */
  ifold1 =
    f: init: xs:
    (foldl'
      ({ i, acc }: x: {
        i = i + 1;
        acc = f acc i x;
      })
      {
        i = 1;
        acc = init;
      }
      xs
    ).acc;
}
