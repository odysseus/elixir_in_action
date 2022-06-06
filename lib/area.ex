# Defines a module which largely acts as a namespace
defmodule Area do
  # Area of a rectangle
  def rectangle(length, width) do
    length * width
  end

  # This one is overloaded and would otherwise be identical to square
  def rectangle(a) do
    square(a)
  end

  # Area of a square
  def square(side) do
    :math.pow(side, 2)
  end

  # Area of a circle by its radius
  def circle_radius(radius) do
    :math.pi * :math.pow(radius, 2)
  end

  # Area of a circle by its diameter
  def circle_diameter(diameter) do
    # This uses a pipeline instead of nested statements
    # This is equivalent to circle_radius(diameter / 2)
    diameter / 2
    |> circle_radius
  end
end

# Usage in iex:
# $ iex area.ex
# iex(1)> Area.circle(4)
# 50.26548245743669
