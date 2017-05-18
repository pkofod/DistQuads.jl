module DistQuads # DistQuads

using RCall,
      Reexport
@reexport using Distributions
export DistQuad, E, mean, var
import Base: mean, var
# FIXME Should install statmod via build!
R"library(statmod)"

type DistQuad
    x
    w
    d
end
nodes(dq::DistQuad) = dq.x
weights(dq::DistQuad) = dq.w
distribution(dq::DistQuad) = dq.d

DistQuad(d; N = 32) = DistQuad(d, N)
function DistQuad(d::Distributions.Beta, N)
    R"nodesweight<-gauss.quad.prob($N, dist=\"beta\", alpha=$(d.α), beta=$(d.β))"
    nw = @rget nodesweight
    DistQuad(nw[:nodes], nw[:weights], d)
end

function DistQuad(d::Distributions.Gamma, N)
    R"nodesweight<-gauss.quad.prob($N, dist=\"gamma\", alpha=$(d.α), beta=$(d.θ))"
    nw = @rget nodesweight
    DistQuad(nw[:nodes], nw[:weights], d)
end

function DistQuad(d::Distributions.Normal, N)
    R"nodesweight<-gauss.quad.prob($N, dist=\"normal\", mu=$(d.μ), sigma=$(d.σ))"
    nw = @rget nodesweight
    DistQuad(nw[:nodes], nw[:weights], d)
end

function DistQuad(d::Distributions.LogNormal, N)
    R"nodesweight<-gauss.quad.prob($N, dist=\"normal\", mu=$(d.μ), sigma=$(d.σ))"
    nw = @rget nodesweight
    DistQuad(exp.(nw[:nodes]), nw[:weights], d)
end


E(f, dq::DistQuad) = dot(f.(nodes(dq)), weights(dq))
E(f, d) = E(f, DistQuad(d))

mean(dq::DistQuad) = E(identity, dq)
var(dq::DistQuad) = E(x->(x-mean(dq))^2, dq)

end # module
