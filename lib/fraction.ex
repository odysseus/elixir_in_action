
defmodule Fraction do
  defstruct num: nil, den: nil

  def new(a, b), do: %Fraction{num: a, den: b}
  def new({a, b}), do: %Fraction{num: a, den: b}
  def new([a, b]), do: %Fraction{num: a, den: b}
  def new(%{num: a, den: b}), do: %Fraction{num: a, den: b}

  def to_decimal(%Fraction{num: a, den: b}), do: a / b
  def to_decimal(_), do: :invalid_type

  def add(%Fraction{num: n1, den: d1}, %Fraction{num: n2, den: d2}) do
    new(n1 * d2 + n2 * d1, d1 * d2)
  end

  def simplify(frac), do: simplify(frac, 2)
  def simplify(frac, btest) when btest > frac.num or btest > frac.den, do: frac
  def simplify(frac, btest) do
    if rem(frac.num, btest) == 0 and rem(frac.den, btest) == 0 do
      simplify(
        Fraction.new(
          trunc(frac.num / btest),
          trunc(frac.den / btest)),
        btest)
    else
      simplify(frac, btest+1)
    end
  end
end
