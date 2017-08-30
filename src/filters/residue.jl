#= Copyright (c) 2017 Dave Crist

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
=#

# residue.jl
using Polynomials
using StatsBase
function residue(pn::Poly, pd::Poly)
    # calculate degree and roots of denominator
    degn = degree(pn)
    degd = degree(pd)

    # Check if numerator degree >= denominator degree
    # If degn >= degd, divide out polynomial GCD, and continue with remainder
    if degn >= degd
        pq, pr = divrem(pn, pd)
    else
        pq=Poly(0); pr=copy(pn)
    end

    # get roots, and counts of repeated roots as keys and values of a
    # map or dictionary object
    rootsd = sort(roots(pd))
    # rootsd_map = countmap(rootsd_all)

    # Loop over denominator roots
    # rD = 'current' root of denominator we're dealing with
    # rL = root for looping over other roots
    # abc_polys are the polynomials multiplying A, B, C, etc.
    # in the form
    # (Numerator-Poly) = A*abc_poly[1] + B*abc_poly[2] + C*abc_poly[3] + ...
    abc_polys = [] #[Poly(0) for idx = 1:length(rootsd)]
    for rD = unique(rootsd)
        # Account for all other-valued roots
        abc_poly = prod( [Poly([-rL,1]) for rL in rootsd if rL!=rD] )            
        push!(abc_polys, abc_poly)

        # Account for repeated roots equal to rD
        rD_reps = sum( rootsd .== rD)
        # the denominator has rD_reps occurrences of this root
        for rep = 2:rD_reps # start at 2 to ignore non-repeated roots
            abc_poly *= Poly([-rD,1])
            push!(abc_polys, abc_poly)
        end
    end

    # This *should* set up a nice set of linear equations for 
    # coefficients of NumCoef * x^pow = (A+B+C+...) * x^pow

end # residue function