defmodule Prime do
  use Bitwise, only_operators: true

  def is_prime?(n, _t) when n != 2 and rem(n, 2)== 0 do
    false
  end
  def is_prime?(n, t\\10) do
    {d, s} = decompose(n - 1)
    is_prime?(n, d, s, t)
  end
  def is_prime?(_n, _s, _d, 0), do: true
  def is_prime?(n, d, s, t) do
    if check_each_time(n, d, s) do
      is_prime?(n, d, s, t - 1)
    else
      false
    end
  end

  def decompose (n) do
    decompose(n, 0)
  end
  defp decompose(n, k) do
    case n&&&1 do
      0 -> decompose(n>>>1, k+1)
      1 -> {n, k}
    end
  end

  def check_each_time(n, d, s) do
    random_factor = Enum.random(2..n-1)
    x = Pow.pow_mod(random_factor, d, n)
    case x do
      1 -> true
      _ -> check_random_factor(n, s, x, 1)
    end
  end

  def check_random_factor(n, s, x, r) when r == s, do: n-1 == x
  def check_random_factor(n, s, x, r) do
    if x == n - 1 do
      true
    else
      check_random_factor(n, s, Pow.pow_mod(x, 2, n), r+1)
    end
  end
end

defmodule Pow do
  use Bitwise, only_operators: true
  require Integer
  def pow_mod(_m, 0, _q), do: 1
  def pow_mod(m, n, q) when rem(n, 2) == 1 do
    rem(m*pow_mod(m, n-1, q), q)
  end
  def pow_mod(m, n, q) do
    result = pow_mod(m, n>>>1,q)
    rem(result*result, q)
  end
end

defmodule LargestRightTruncatePrime do
  @a  [2, 3, 5, 7]
  @ak  [1, 3, 7, 9]
  def max_satisfy (n) do
    num_number = floor(:math.log10(n))
    ables = for i <- 1..num_number, a <- @a, ak <- @ak, do: calculate(i, a, ak)
    Enum.filter(ables, &(Prime.is_prime?(&1) and (&1 <= n))) |> Enum.take(-1)

  end
  def calculate(i,a, _ak) when i == 0, do: a
  def calculate(i,a, ak) do
    if Prime.is_prime? a do
      calculate(i - 1, a * 10 + ak, ak)
    end
    0
  end
  def is_satisfy(p, n) do
    Prime.is_prime?(p) and p <= n
  end
end


