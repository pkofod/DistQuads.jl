module DistQuads # DistQuads

using Reexport,
      FastGaussQuadrature
@reexport using Distributions
export DistQuad, E, mean, var
import Base: mean, var

type DistQuad{D}
    x
    w
    d::D
end
nodes(dq::DistQuad) = dq.x
weights(dq::DistQuad) = dq.w
distribution(dq::DistQuad) = dq.d

DistQuad(d; N = 32) = DistQuad(d, N)
function DistQuad(d::Distributions.Beta, N)
    gj = gaussjacobi(N, d.α-1, d.β-1)
    n = (1.-gj[1])./2
    DistQuad(n, gj[2], d)
end

function DistQuad(d::Distributions.Exponential, N)
    gl = gausslaguerre(N)
    w = gl[2]
    n = gl[1]./d.θ
    DistQuad(n, w, d)
end

function DistQuad(d::Distributions.Gamma, N)
    gl = gausslaguerre(N, d.α-1)
    n = gl[1].*d.θ
    w = gl[2]./gamma(d.α)
    DistQuad(n, w, d)
end

function _DistQuad_Normal_kernel(d, N)
    gh = gausshermite(N)
    w = gh[2]./sqrt(pi)
    n = gh[1].*sqrt(2).*d.σ.+d.μ
    n, w
end
function DistQuad(d::Distributions.Normal, N)
    n, w = _DistQuad_Normal_kernel(d, N)
    DistQuad(n, w, d)
end

function DistQuad(d::Distributions.LogNormal, N)
    n, w = _DistQuad_Normal_kernel(d, N)
    DistQuad(exp.(n), w, d)
end


E(f, dq::DistQuad) = dot(f.(nodes(dq)), weights(dq))
E(f, d) = E(f, DistQuad(d))

mean(dq::DistQuad) = E(identity, dq)
var(dq::DistQuad) = E(x->(x-mean(dq))^2, dq)

end # module
