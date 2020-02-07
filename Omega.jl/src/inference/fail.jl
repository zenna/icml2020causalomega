"FailUnsat on condition"
struct FailUnsatAlg <: SamplingAlgorithm end

softhard(::Type{FailUnsatAlg}) = IsHard{FailUnsatAlg}()

const FailUnsat = FailUnsatAlg()

isapproximate(::FailUnsatAlg) = false

"`n` samples from `x`"
function Base.rand(rng::AbstractRNG,
                   ΩT::Type{OT},
                   pred::RandVar,
                   n::Integer,
                   alg::FailUnsatAlg) where {OT <: Ω}
  ωsamples = ΩT[]
  ωsamples = Vector{ΩT}(undef, n)
  accepted = 0
  for i = 1:n
    ω = ΩT()
    issat = apl(pred, Omega.Space.tagrng(ω, rng))
    !issat && error("Condition unsatisfied. Use appropriate infrence alg.")
    @inbounds ωsamples[i] = ω
    lens(Loop, (ω = ω, accepted = accepted, p = float(issat), i = i))
  end
  ωsamples
end
    
function Base.rand(rng::AbstractRNG,
                   x::RandVar,
                   n::Integer,
                   alg::FailUnsatAlg;
                   ΩT::Type{OT} = defΩ(alg)) where {OT <: Ω}
  pred = Omega.indomain(x)
  ωsamples = rand(rng, ΩT, pred, n, alg)
  map(ω -> apl(x, ω), ωsamples)
end