using Printf
using Profile
include("ContourDynamics.jl")

# Construct a flow containing a circular vortex patch
# with wavenumber 5 perturbation
flow = ContourDynamics.empty_flow()
ContourDynamics.add_circular_vortex!(
    flow, 1.0, 0.0, 0.0, 1.0, 0.1, 10.0; N = 1000
)

# Set time stepping parameters
Δt = 0.01
nstep = 1000

# Iterate once to force pre-compilation
ContourDynamics.calc_uv!(flow)
ContourDynamics.step!(flow, Δt)

# Profile
start_time = time_ns()
for n = 1:nstep
    @printf("%d\n", n)
    ContourDynamics.calc_uv!(flow)
    ContourDynamics.step!(flow, Δt)
end
end_time = time_ns()
@printf("Average time per iteration: %d ms\n",
    1e-6 * (end_time - start_time) / nstep
)
ContourDynamics.plot(flow, "test.pdf")
