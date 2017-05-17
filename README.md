# DistQuads

[![Build Status](https://travis-ci.org/pkofod/DistQuads.jl.svg?branch=master)](https://travis-ci.org/pkofod/DistQuads.jl)

[![Coverage Status](https://coveralls.io/repos/pkofod/DistQuads.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/pkofod/DistQuads.jl?branch=master)

[![codecov.io](http://codecov.io/github/pkofod/DistQuads.jl/coverage.svg?branch=master)](http://codecov.io/github/pkofod/DistQuads.jl?branch=master)

# What

Evaluating the expected value of functions of random variables requires numerical
integration. There are many ways to do this, but a very popular approach is to
transform the integral evaluation into a weighed sum of function evaluations at
N values, often called nodes, useing so-called Gaussian quadrature.

This package builds on top of the Distributions.jl package, and it provides a simple
interface to generate Guassian quadrature weights and nodes for numerical integration
as explained above. The theory is well-developed, and a Julia implementation is
certainly more than possible, but currently this package uses RCall to make calls
to the statmod library.

Note, that `using DistQuads` will start an R process in the background,
due to a `library(statmod)` call via RCall.
