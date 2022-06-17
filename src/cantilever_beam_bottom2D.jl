
#
#     \----------------
#     \               |
#     \       Ω       |
#     \               |
#     \----------------
#                     ↓
#                      F
#
function Cantilever_beam_bottom2D(nx::Int64,ny::Int64,etype=:truss2D;   
                                  Lx=1.0, Ly=1.0, force=1.0, A=1E-4, Ex=1E9,
                                  thickness=0.1)


    @assert etype==:truss2D || etype==:solid2D "Cantilever_beam_bottom2D::etype must be truss2D or solid2D"

    # Generate the mesh
    if etype==:truss2D
        bmesh = Bmesh_truss_2D(Lx,nx,Ly,ny)
    elseif etype==:solid2D
        bmesh = Bmesh_solid_2D(Lx,nx,Ly,ny,0.1)
    end
     
    # Essential boundary conditions
    nebc = 2*(ny+1)
    ebc = Array{Float64}(undef,nebc,2)
    node = 1
    pos = 0
    for i=1:(ny+1)
        pos += 1
        ebc[pos,:] = [node 1 0.0]
        pos += 1
        ebc[pos,:] = [node 2 0.0]
        node += (nx+1)
    end
    
    # Generate the load information
    no_forca = nx+1
    nbc = [no_forca 2 -force]
    
    # Vamos definir Ex e A "fixos" -> valores muito "chutados"
    mat = [Material(Ex=Ex)]
    geom = [Geometry(A=A, thickness=thickness)]

    # Gera a malha e devolve um tipo Mesh2D
    Mesh2D(bmesh,mat,geom,ebc,nbc)

end