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

function uniquetol_dict(itr,tol=1e-6)
    ut_vals_dict = Dict()
    ut_idxs_dict = Dict()
    if length(itr) == 0
        return ut_vals_dict, ut_idxs_dict
    end

    _itr = copy(itr)
    while(length(_itr) > 0)
        idxs = find(abs.(itr - _itr[1]) .< tol)
        utval = mean(itr[idxs])
        ut_vals_dict[ utval ] = itr[idxs]
        ut_idxs_dict[ utval ] =     idxs
        deleteat!(_itr,find(abs.(_itr - _itr[1]) .< tol))
    end
    
    return ut_vals_dict, ut_idxs_dict
end

function uniquetol_list(itr::Array{T,1},tol=1e-6) where {T<:Real}
    preal = sortperm(real(itr))     # buffer for permutation idxs of reals
    dreal = diff(real(itr[preal]))  # buffer for differences of reals

    out = [ ];
    pri1=1;
    for pri2 = 1:length(preal)
        # look for tol-large gap in reals
        if pri2==length(preal) || dreal[pri2] > tol
            push!(out, Array{T,1}(itr[preal[pri1:pri2]]))
            pri1=pri2+1;
        end # real tol check
    end # pri2, tol-large gap in reals
    return out
end


function uniquetol_list(itr::Array{T,1},tol=1e-6) where {T<:Complex}
    preal = sortperm(real(itr))     # buffer for permutation idxs of reals
    dreal = diff(real(itr[preal]))  # buffer for differences of reals

    pimag = Array{Int}(size(preal))     # buffer for permutation idxs of imags
    dimag = Array{Float64}(size(dreal)) # buffer for differences of imags

    out = [ ];
    pri1=1;
    for pri2 = 1:length(preal)
        # look for tol-wide gap in reals
        if pri2==length(preal) || dreal[pri2] > tol
            pridxs = preal[pri1:pri2]
            sortperm!( pimag[1:length(pridxs)], imag(itr[pridxs]) )
            dimag[1:(length(pridxs)-1)] = diff(imag(itr[preal[pridxs]]))

            pii1=1;
            for pii2 = 1:length(pridxs)
                if pii2==length(pridxs) || dimag[pii2] > tol
                    push!(out, Array{T,1}(itr[pridxs[pii1:pii2]]))
                    pii1=pii2+1;
                end # imag tol check
            end # pii2, tol-large gap in imags

            pri1=pri2+1;
        end # real tol check
    end # pri2, tol-large gap in reals
    return out
end

# residue.jl
using Polynomials
function residue(pn::Poly, pd::Poly, root_tol=1e-6)
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

    # get roots, and find roots that are numerically close
    # rootsd = roots of denominator polynomial
    rootsd = roots(pd)
    # rd_ut_idxs = groups of idxs in to rootsd, 
    #     that represent numerically close roots
    rd_ut_vals, rd_ut_idxs = uniquetol_dict(rootsd,1e-6)

    # Loop over denominator roots, in groups, determined by uniquetol_map
    # uniquetol_map is used to find roots that are numerically close but uneqal
    # abc_polys are the polynomials multiplying A, B, C, etc.
    # in the form
    # (Numerator-Poly) = A*abc_poly[1] + B*abc_poly[2] + C*abc_poly[3] + ...
    abc_polys = []

    for rdidxs = values(rd_ut_idxs)
        # @show rdidxs
        # Account for all other-valued roots
        other_roots = rootsd[setdiff( 1:length(rootsd), rdidxs)]
        abc_poly = prod( [Poly([-rL,1]) for rL in other_roots] )
        # print("rD=$(rootsd[rdidxs[1]]) , (normal): $abc_poly\n")
        push!(abc_polys, abc_poly)

        # Account for repeated roots numerically close to to rD
        for repidx = 2:length(rdidxs) # start at 2 to ignore non-repeated roots
            rD = rootsd[rdidxs[repidx]]
            abc_poly *= Poly([-rD,1])
            push!(abc_polys, abc_poly)
        end
    end

    # With abc_polys, set up a nice set of linear equations for 
    # coefficients of NumeratorCoef_i * x^pow = (A+B+C+...) * x^pow

    A = [ p[pidx] for pidx=0:(degree(pd)-1), p in abc_polys ]
    b = coeffs(pr)

    return A \ b, rootsd

end # residue function


