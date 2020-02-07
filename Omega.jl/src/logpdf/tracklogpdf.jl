
"Logpdf of `ω` wrt `x"
function logpdf(x, ω::Ω, logpdf_ = 1.0)
  ω_ = taglogpdf(ω, logpdf_)
  fx = apl(x, ω_)
  (fx = fx, logpdf_ = val(ω_.tags.logpdf_))
end

"Tag `ω` with logpdf" 
taglogpdf(ω, logpdf) = tag(ω, (logpdf = Box(logpdf),))

function combinetags(::Type{Val{:logpdf}}, a, b)
  @assert false "Current;y not sure when combing logpdfs will occur, but it will"
end

function testlogpdf()
  x = normal(0, 1)
  y = normal(x, 1)
  ω = rand(defΩ())
  y(ω)
  logpdf((x, y)ᵣ, ω)
end