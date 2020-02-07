module LogPdf

import Distributions
using ..Omega
using ..Util: Box, val
export logpdf

include("tracklogpdf.jl")

function (T::Type{<:Distributions.Distribution})(ωπ::ΩProj, args...)
  get!(ωπ.ω.data, ωπ.id, rand(T(args...)))
end

function (T::Type{<:Distributions.Distribution})(tω::TaggedΩ, args...)
  if haskey(tω.tags, :logpdf)
  end
  T(proj(ω, (1,)), args...)
end

function apl(tω::TaggedΩ, bool)
  if !haskey(tω.tags, :donttrack) && haskey(tω.tags, :err)
    conjoinerror!(tω.tags.err, bool)
  end
end

end