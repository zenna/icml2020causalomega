
function test()
  x = uniform(-100, 100)
  y = uniform(-100, 100)
  op, γ = softeqgamma()
  ==ᵧ = lift(op)

  p1 = x ==ₛ 0.0
  p2 = y ==ᵧ 0.0
  rand((p1, p2), p1 & p2, cb = updatescales([p1, p2], γ, 10))
end

# 1. Plot two densities
