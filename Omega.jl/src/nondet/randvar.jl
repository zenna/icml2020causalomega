"Random Variable: a function `Ω -> T` on a probability space"
abstract type RandVar <: NonDetVar end

MaybeRV{T} = Union{T, RandVar} where T

id(rv::RandVar) = rv.id

"Parameters of a random variable"
function params(rv::RandVar) end

"Name of a random variable"
name(rv) = rv

# 1.3 supports abstract fields for function call overload
if VERSION >= v"1.3"
  (rv::RandVar)(ω::Ω) = apl(rv, ω)
end

"""Is `x` a constant random variable, i.e. x(ω) = c ∀ ω ∈ Ω?

Determining constancy is intractable (and likely undecidable) in general.
if `isconstant(x)` is true then `x` is constant, but if `isconstant(x)` is false,
`x` may still be constant, but we have failed to determine it.

```jldoctest
x1 = constant(0.3)
isconstant(x1)
true

x2 = ciid(ω -> 0.3)
isconstant(x2)
true

x3 = ciid(ω -> rand(ω))
isconstant(x3)
false

# False Negative
x3 = ciid(ω -> rand(ω) > 0.5 ? 0.3 : 0.3)
isconstant(x3)
false
```
"""
function isconstant(x::RandVar, ΩT = defΩ(x))
  # This implementation assumes that ΩT is lazy, more general solution would wrap
  # ω of any type and intercept rand(ω) 
  ω = ΩT()
  x(ω)
  isempty(ω)
end

isconstant(x) = true

# Printing #
Base.show(io::IO, rv::RandVar) =
  print(io, "$(id(rv)):$(name(rv))($(join(map(name, params(rv)), ", ")))::$(elemtype(rv))")
