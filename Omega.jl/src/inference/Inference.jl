"Inference Algorithms"
module Inference

using Base.Threads

using Spec
using Random
using Lens
using ..IDS
using ..Omega: RandVar, applytrackerr, indomainₛ, logerr,
               UTuple, Ω, applynotrackerr, SimpleΩ, LinearΩ,
               update, cond, randtuple, nelem,
               gradient, linearize, unlinearize, err, indomainₛ, indomain, apl
import ..Omega
using Omega.Space: tagrng
import Omega.Space: defΩ, defΩProj

using ..Gradient: value, gradient

using ProgressMeter
import Flux
import ForwardDiff
using Callbacks
using Lens
import UnicodePlots
using DocStringExtensions: SIGNATURES

"Lens called at every iteration of MCMC algorithm"
abstract type Loop end

"Optimization Algorithm"
abstract type OptimAlgorithm end

"Sampling Algorithm"
abstract type SamplingAlgorithm end

"Is the inference algorithm approximate?"
function isapproximate end

"Default probability space type to use"
function defΩ end

include("inftraits.jl") # Traits for inference procedures

include("transforms.jl")# Transformations from [0, 1] to R, etc
include("callbacks.jl") # Common Inference Functions

# Sampling
include("rand.jl")      # Sampling
include("autorand.jl")  # Automatically choose sampler

include("rs.jl")        # Rejection Sampling
include("ssmh.jl")      # Single Site Metropolis Hastings
# include("hmc.jl")       # Hamiltonian Monte Carlo
include("hmcfast.jl")   # Faster Hamiltonian Monte Carlo
# include("hmcfastg.jl")   # Faster Hamiltonian Monte Carlo
include("replica.jl")   # Replica Exchange
# include("dynamichmc.jl")# Dynamic Hamiltonion Monte Carlo
include("fail.jl")      # Fail (throw exception) on unsatisfied conditions

# Optimization
include("argmax.jl")     # NLopt based optimization
include("nlopt.jl")     # NLopt based optimization

export  isapproximate,

        RejectionSample,
        SSMH,
        HMC,
        # SGHMC,
        HMCFAST,
        Replica,

        RejectionSampleAlg,
        SSMHAlg,
        HMCAlg,
        # SGHMCAlg,
        HMCFASTAlg,
        RelandscapeAlg,
        Relandscape,
        NUTS,
        NUTSAlg,
        FailUnsat,

        defalg,
        defcb,

        plotrv,
        plotscalar,
        default_cbs,
        default_cbs_tpl,
        default_cbs,

        # Lenses
        Loop,
        SSMHLoop,
        HMCFASTLoop,

        autorand

end
