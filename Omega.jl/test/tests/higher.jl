using Omega
using Test

x_is_parent = bernoulli(0.5, Bool)

function model_(ω)
  # EIther x is parent of y or y parent of x
  if x_is_parent(ω)
    x = normal(0, 1)
    y = normal(x, 1)
  else
    y = normal(0, 1)
    x = normal(y, 1)
  end
  (x = x, y = y)
end

model = ~model_

# x, y = model[1], model[2]
# y_do = replace(y, x => 100.0)
# rand(cond(x_is_parent, y_do = 105.0))