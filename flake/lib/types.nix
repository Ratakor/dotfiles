{ ... }:
{
  /**
    Return the values of an enum created with lib.types.enum.
  */
  enumValues = enum: enum.functor.payload.values;

  /**
    Return the inner type of a nullable type created with lib.types.nullOr.
  */
  unwrapNullOr = nullOr: nullOr.functor.payload.elemType;
}
