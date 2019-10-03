module ContourDynamics

using StaticArrays
using PyPlot

mutable struct Node{T}
    x::SVector{2,T}
    u::SVector{2,T}
    next::Node{T}
    Node{T}(x::T, y::T) where T = (
        node = new();
        node.x = (x, y);
        node.u = (T(0.0), T(0.0));
        node.next = node;
    )
    Node{T}(x::T, y::T, next::Node{T}) where T = (
        node.x = (x, y);
        node.u = (T(0.0), T(0.0));
        node.next = next;
    )
end

mutable struct Contour{T}
    Δω::T
    head::Node{T}
    tail::Node{T}
end

struct Flow{T}
    contours::Array{Contour{T},1}
    ϵ::T
end

function Contour{T}(Δω::T, node::Node{T}) where T
    node.next = node
    return Contour{T}(Δω, node, node)
end

include("core.jl")
include("helpers.jl")

end # module
