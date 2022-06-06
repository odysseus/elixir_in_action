# Defines a module which largely acts as a namespace
defmodule Geometry do
  # The nested module can be accessed via Geometry.Area
  # It could also directly be defined as
  # defmodule Geometry.Area and they would act the same

  @moduledoc """
  Contains various geometric mathematical functions
  """
  defmodule Area do
    @moduledoc """
    Contains functions for computing the areas of different geometric shapes
    """

    # We can import modules to use their functions directly:
    # import :math
    # This would allow us to use pow instead of :math.pow
    # :math is an Erlang library so instead we are going to alias
    # the name to make it more Elixirian
    alias :math, as: Math

    @doc """
    Computes the area of a rectangle
    """
    @spec rectangle(number, number) :: number
    def rectangle(length, width) do
      length * width
    end

    @doc """
    Overloads the rectangle method to compute the area given only one
    side length. Note that this is equivalent to Area.square
    """
    @spec rectangle(number) :: number
    def rectangle(side) do
      square(a)
    end

    @doc """
    Computes the area of a square
    """
    @spec square(number) :: number
    def square(side) do
      # The ** operator does exponentiation on later versions Elixir
      side ** 2
    end

    @doc """
    Computes the area of a circle given a radius length
    """
    @spec circle_radius(number) :: number
    def circle_radius(radius) do
      # We use our aliased version of :math here
      Math.pi() * Math.pow(radius, 2)
    end

    @doc """
    Returns the number divided by two. Solely to demonstrate the definition
    and use of a private function (defp) within a module
    """
    @spec halve(number) :: number
    defp halve(number) do
      number / 2
    end

    @doc """
    Computes the area of a circle given its diameter
    """
    @spec circle_diameter(number) :: number
    def circle_diameter(diameter) do
      # This uses a pipeline instead of nested statements
      # This is equivalent to circle_radius(halve(diameter))
      halve(diameter)
      |> circle_radius
    end
  end
end

# Usage in iex:
# $ iex geometry.ex
# iex(1)> Geometry.Area.circle(4)
# 50.26548245743669
