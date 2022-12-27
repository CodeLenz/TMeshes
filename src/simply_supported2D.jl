
#
#      ----------------
#      |              |
#      |      Ω       |
#      |              |
#    > ----------------<
#      𝝙      ↓      𝝙
#             F
#
function Simply_supported2D(nx::Int64,ny::Int64,etype=:truss2D;   
                          Lx=1.0, Ly=1.0, force=1.0, A=1E-4 ,Ex=1E9,
                          νxy=0.0,
                          density=7850.0,thickness=0.1,
                          limit_stress=1E6,
                          options = Dict{Symbol,Matrix{Float64}}())



    # Nx has to be even, since the load is exactly at the (bottom) center
    @assert iseven(nx) "Simply_Supported2D::nx must be even"

    @assert nx > 3 "Simply_Supported2D::nx must be >3 due to loading"

    @assert etype==:truss2D || etype==:solid2D "Simply_Supported2D::etype must be truss2D or solid2D"

    # Generate the mesh
    if etype==:truss2D
       bmesh = Bmesh_truss_2D(Lx,nx,Ly,ny)
    elseif etype==:solid2D
       bmesh = Bmesh_solid_2D(Lx,nx,Ly,ny)
    end

    # Generate the supports
    #=
    hebc = [1 1;  
           1 2 ;
           2 1 ;
           2 2 ;
           nx 1 ;
           nx 2 ;
          nx+1 1;
          nx+1 2 ]
          =#
   hebc = [1 1 ;  
          1 2 ;
          nx+1 1 ;
          nx+1 2 ]
   

    # Generate the load information
    no_central_forca = (nx/2)
    nbc = [no_central_forca-1 2 -force/4 ;
           no_central_forca 2  -force/2 ;
           no_central_forca+1 2 -force/4  ]

    # Vamos definir Ex e A "fixos" -> valores muito "chutados"
    mat = [Material(Ex=Ex,density=density,νxy=νxy,limit_stress=limit_stress)]
    geom = [Geometry(A=A, thickness=thickness)]

   # Se o elemento for de elasticidade ligamos o IS_TOPO
   if etype==:solid2D
      options[:IS_TOPO]=ones(1,1)
   end

    # Gera a malha e devolve um tipo Mesh2D
    Mesh2D(bmesh,mat,geom,hebc,nbc,options=options)

end
