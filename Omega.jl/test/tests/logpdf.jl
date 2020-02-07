using Omega
using Test

# Option 1.
# get rid of lowercase and extend Normal to allow random variables as arguments
# Make ciid change Distributions objeect into something we can use
# Random variable is anything on which X(ω) is defined

# f(x::Int) = x + 1
# f(x::Float64) = x + 2
# f(x::AbstractFloat) = x + 3

# f(3)

# Choice of different algorithm
# some property wihch seems to be applicable to many type
# size(vector), size(Array), size(set)
# then there are some implicit requirements. hidden invariants
# x(w), should be pure.  

# Expressiveness
# Speed
# Interopaability
# Syntax (aesthetics)
# Tooling
# Correctness
# Deployment

# Julia doesn't enforce any kind of uniformity in code
# That means when you go to a project you don't know what the main types are,
# or what functions exist
# It's very hard to use an julia module that is not externally documented
# julia philosophy is that no one has authority on the meaning of a verb
# kind of.  Because it will prevent me from giving my own definition
# so it's a little inconsitent, on the one hand I'm free to
# it errors because of the specificity ruling

function test()
  a = 1 ~ Normal(0, 1)
  function f(ω)
    x = 2 ~ Normal(a, 2)(ω)
    y = 3 ~ Normal(0, 3)(ω)
    z = x + y + a
  end
  f_ = 3.0
  a_posterior = a | 4 ~ Normal(f, 1) ==ᵣ f_
  a_ = 2.0
  x_ = 2.0
  y_ = 3.0
  ω = SimpleΩ(Dict(1 => a_, 2 => x_, 3 => y_))
  l = logpdf(ω, a_posterior)
  lt = logpdf(Normal(0, 1), a_) + logpdf(Normal(a_, 2), x_) + logpdf(Normal(0, 3), y_) +
         logpdf(Normal(x_ + y_ + a_), f_)
  @test l == lt
end