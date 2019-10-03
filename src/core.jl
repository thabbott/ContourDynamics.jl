function calc_uv!(flow::Flow{T}) where T
    for contour = flow.contours
        curr = contour.head
        while true
            calc_uv!(flow, curr)
            curr = curr.next
            if curr == contour.head break; end
        end
    end
end

function calc_uv!(flow::Flow{T}, node::Node{T}) where T
    node.u = (T(0.0), T(0.0))
    for contour = flow.contours
        curr = contour.head
        while true
            node.u += contour.Δω * G(node, curr, flow.ϵ)
            curr = curr.next
            if curr == contour.head break; end
        end
    end
end

function G(node::Node{T}, other::Node{T}, ϵ) where T
    d1 = max(ϵ, log(sqrt(sum((node.x - other.x).^T(2.0)))))
    d2 = max(ϵ, log(sqrt(sum((node.x - other.next.x).^T(2.0)))))
    return T(1.0/pi) * (d1 + d2) * (other.next.x - other.x)
end

function step!(flow::Flow{T}, Δt) where T
    for contour = flow.contours
        curr = contour.head
        while true
            curr.x += Δt * curr.u
            curr = curr.next
            if curr == contour.head break; end
        end
    end
end
