{ ... }:
{
  /**
    Return the values of an enum created with lib.types.enum.
  */
  enumValues = enum: enum.functor.payload.values;
}
