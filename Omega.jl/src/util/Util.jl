"Utilities"
module Util

using Base: sym_in, merge_names, merge_types
using Spec

export applymany, ntranspose, Counter, reset!, increment!, UTuple, *ₛ

include("misc.jl")      # Miscellaneous
include("box.jl")       # A Box
include("specs.jl")     # Domain General specification tools
include("compat.jl")

end