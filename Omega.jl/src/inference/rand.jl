"Default inference algorithm"
defalg(args...) = FailUnsat

"Default callbacks"
defcb(args...) = donothing

"Single sample form from `x`"
function Base.rand(x::RandVar;
                   alg::SamplingAlgorithm = defalg(x),
                   ΩT = defΩ(alg),
                   kwargs...)
  first(rand(Random.GLOBAL_RNG, x, 1, alg; ΩT = ΩT, kwargs...))
end

function Base.rand(rng::AbstractRNG,
                   x::RandVar;
                   alg::SamplingAlgorithm = defalg(x),
                   ΩT::Type{OT} = defΩ(alg),
                   kwargs...) where {OT <: Ω}
  first(rand(rng, x, 1, alg; ΩT = ΩT, kwargs...))
end


function Base.rand(rng::AbstractRNG,
                   x::RandVar,
                   n::Integer,
                   alg::SamplingAlgorithm;
                   ΩT::Type{OT} = defΩ(alg),
                   kwargs...) where {OT <: Ω}
  logdensity = Omega.mem(logerr(indomainₛ(x)))
  ωsamples = rand(rng, ΩT, logdensity, n, alg; kwargs...) 
  map(ω -> applynotrackerr(Omega.mem(x), ω), ωsamples)
end


function Base.rand(x::RandVar,
                   n::Integer;
                   alg::SamplingAlgorithm = defalg(x),
                   ΩT::Type{OT} = defΩ(alg),
                   kwargs...) where {OT <: Ω}
  rand(Random.GLOBAL_RNG, x, n, alg; ΩT = ΩT, kwargs...)
end

function Base.rand(rng::AbstractRNG,
                   x::RandVar,
                   n::Integer;
                   alg::SamplingAlgorithm = defalg(x),
                   ΩT::Type{OT} = defΩ(alg),
                   kwargs...) where {OT <: Ω}
  rand(rng, x, n, alg; ΩT = ΩT, kwargs...)
end

function Base.rand(x::RandVar,
                   n::Integer,
                   alg::SamplingAlgorithm;
                   ΩT::Type{OT} = defΩ(alg),
                   kwargs...) where {OT <: Ω}
  rand(Random.GLOBAL_RNG, x, n, alg; ΩT = ΩT, kwargs...)
end

# Condition (deprecate this?) x | y

Base.rand(x::RandVar, y::RandVar, n; kwargs...) = rand(Random.GLOBAL_RNG, cond(x, y), n; kwargs...)
Base.rand(x::RandVar, y::RandVar; kwargs...) = rand(Random.GLOBAL_RNG, cond(x, y); kwargs...)
Base.rand(rng::AbstractRNG, x::RandVar, y::RandVar, n; kwargs...) = rand(rng, cond(x, y), n; kwargs...)
Base.rand(rng::AbstractRNG, x::RandVar, y::RandVar; kwargs...) = rand(rng, cond(x, y); kwargs...)

# Return Tuple

Base.rand(x::UTuple{RandVar}, n::Integer; kwargs...) = rand(randtuple(x), n; kwargs...)
Base.rand(x::UTuple{RandVar}; kwargs...) = rand(randtuple(x); kwargs...)

Base.rand(x::UTuple{RandVar}, y::RandVar, n::Integer; kwargs...) = rand(randtuple(x), y, n; kwargs...)
Base.rand(x::UTuple{RandVar}, y::RandVar; kwargs...) = rand(randtuple(x), y; kwargs...)

# Return Ω object

"Returns Ω object, .e.g `x = normal(0, 1); rand(Ω, x > 0)`"
function ld(rng::AbstractRNG,
            ΩT::Type{OT},
            x::RandVar,
            n::Integer,
            alg::IsSoft{ALG};
            kwargs...) where {ALG, OT <: Ω}
  logdensity = Omega.mem(logerr(indomainₛ(x)))
  ωsamples = rand(rng, ΩT, logdensity, n, ALG(); kwargs...) 
end

function ld(rng::AbstractRNG,
            ΩT::Type{OT},
            x::RandVar,
            n::Integer,
            alg::IsHard{ALG};
            kwargs...) where {ALG, OT <: Ω}
  pred = Omega.indomain(x)
  ωsamples = rand(rng, ΩT, pred, n, ALG())
end

function ld(rng::AbstractRNG,
            ΩT::Type{OT},
            x::RandVar,
            n::Integer,
            alg::T;
            kwargs...) where {T, OT <: Ω}
  ld(rng, ΩT, x, n, softhard(T); kwargs...)
end

"Returns Ω object, e.g. `x = normal(0, 1); rand(Ω, cond(x, x >ₛ 2.0), 10)`"
Base.rand(rng::AbstractRNG, ::Type{Ω}, x::RandVar, n::Integer; alg::SamplingAlgorithm = defalg(x), kwargs...) =
  ld(rng, x, defΩ(alg), n, alg; kwargs...)
  
Base.rand(::Type{Ω}, x::RandVar, n::Integer; alg::SamplingAlgorithm = defalg(x), kwargs...) =
  ld(Random.GLOBAL_RNG, defΩ(alg), x, n, alg; kwargs...)

