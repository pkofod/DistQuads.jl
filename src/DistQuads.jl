module DistQuads # DistQuads

using Distributions,
      RCall
export DistQuad, E
# FIXME Should install statmod via build!
R"library(statmod)"

type DistQuad
    x
    w
end
nodes(dq::DistQuad) = dq.x
weights(dq::DistQuad) = dq.w

DistQuad(d) = DistQuad(d, 32)
function DistQuad(d::Distributions.Beta, N)
    R"nodesweight<-gauss.quad.prob($N, dist=\"beta\", alpha=$(d.α), beta=$(d.β))"
    nw = @rget nodesweight
    DistQuad(nw[:nodes], nw[:weights])
end

function DistQuad(d::Distributions.Gamma, N)
    R"nodesweight<-gauss.quad.prob($N, dist=\"gamma\", alpha=$(d.α), beta=$(d.Θ))"
    nw = @rget nodesweight
    DistQuad(nw[:nodes], nw[:weights])
end

function DistQuad(d::Distributions.Normal, N)
    R"nodesweight<-gauss.quad.prob($N, dist=\"normal\", mu=$(d.μ), sigma=$(d.σ))"
    nw = @rget nodesweight
    DistQuad(nw[:nodes], nw[:weights])
end

function DistQuad(d::Distributions.LogNormal, N)
    R"nodesweight<-gauss.quad.prob($N, dist=\"normal\", mu=$(d.μ), sigma=$(d.σ))"
    nw = @rget nodesweight
    DistQuad(exp.(nw[:nodes]), nw[:weights])
end


E(f, dq::DistQuad) = dot(f.(nodes(dq)), weights(dq))
E(f, d) = E(f, DistQuad(d))

end # module
