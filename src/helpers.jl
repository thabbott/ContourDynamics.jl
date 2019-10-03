function push!(flow::Flow{T}, contour::Contour{T}) where T
    Base.push!(flow.contours, contour)
end

function push!(contour::Contour{T}, node::Node{T}) where T
    node.next = contour.head
    contour.tail.next = node
    contour.tail = node
end

function empty_flow(;T = Float64, ϵ = 1e-16)
    return Flow{T}(Array{Contour{T},1}(undef, 0), T(ϵ))
end

function add_circular_vortex!(
    flow::Flow{T}, Δω::T, x0::T, y0::T, r::T, η::T, m::T; N = 100) where T
    contour = Contour{T}(Δω, Node{T}(x0 + r + η, y0))
    for i = 1:N-1
        push!(contour, Node{T}(
            x0 + (r + η * cos(T(2.0*pi*m*i/N))) * cos(T(2.0*pi*i/N)),
            y0 + (r + η * cos(T(2.0*pi*m*i/N))) * sin(T(2.0*pi*i/N))
        ))
    end
    push!(flow, contour)
end

function plot(flow::Flow{T}, fname) where T
    PyPlot.figure(figsize = (10, 10))
    for contour in flow.contours
        x = Array{T,1}(undef,0)
        y = Array{T,1}(undef,0)
        curr = contour.head
        i = 1
        while true
            Base.push!(x, curr.x[1])
            Base.push!(y, curr.x[2])
            i += 1
            curr = curr.next
            if curr == contour.head break; end
        end
        PyPlot.plot(x, y, color = "black", lw = 2.0)
    end
    PyPlot.axis("equal")
    PyPlot.savefig(fname)
end
