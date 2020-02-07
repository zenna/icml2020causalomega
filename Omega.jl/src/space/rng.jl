tagrng(ω, rng::AbstractRNG) = tag(ω, (rng = rng,))
rng(ω::Ω) = Random.GLOBAL_RNG
rng(ω::TaggedΩ) = haskey(ω.tags, :rng) ? ω.tags.rng : Random.GLOBAL_RNG

function combinetags(::Type{Val{:rng}}, a, b)
  # @assert false
  a
end