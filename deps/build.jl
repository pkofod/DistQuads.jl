using RCall
try
    r_libs = joinpath(dirname(@__FILE__), "r_libs")
    mkdir(r_libs)
    withenv("R_LIBS" => r_libs) do
        R"options(repos=structure(c(CRAN=\"https://cloud.r-project.org/\")))"
        R"""pkgTest <- function(x)
          {
            if (!require(x,character.only = TRUE, quiet = TRUE))
            {
              install.packages(x,dep=TRUE)
                if(!require(x,character.only = TRUE)) stop(\"Package not found\")
            }
          }"""
        R"pkgTest(\"statmod\")"
        R"did_it_work <- \"statmod\" %in% loadedNamespaces()"
        @assert @rget did_it_work
    end
catch m
    error("statmod was not installed, build.jl has failed to set up DistQuads.jl. Please report this to the issue tracker https://github.com/pkofod/DistQuads.jl/issues")
end
