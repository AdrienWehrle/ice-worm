# ------------------------ 

# https://github.com/idaholab/moose/discussions/25256

[GlobalParams]
  gravity = '0 0 -9.81'
  integrate_p_by_parts = true
[]

<<<<<<< HEAD
=======
# [Mesh]
#   type = GeneratedMesh
#   dim = 3
#   xmin = 0
#   xmax = 10000.0
#   ymin = 0
#   ymax = 3000.0
#   zmin = 0
#   zmax = 1000.0
#   nx = 12
#   ny = 5
#   nz = 10
#   elem_type = HEX20
#   # elem_type = QUAD9
#   # displacements = 'velocity_x velocity_y velocity_z'
# []

# [Mesh]
#   type = GeneratedMesh
#   dim = 3
#   xmin = 0
#   xmax = 3.0
#   ymin = 0
#   ymax = 1.0
#   zmin = 0
#   zmax = 3.0
#   nx = 5
#   ny = 5
#   nz = 5
#   elem_type = HEX20
#   # displacements = 'velocity_x velocity_y velocity_z'
# []

>>>>>>> 1e794af8c06a6fad51903ef184721e2ff8c6c14e
[Mesh]
  type = FileMesh
  # file = /home/guschti/projects/mastodon/meshes/simple_channel_straight_surface_slope.e
  file = /home/adrien/COEBELI/projects/mastodon/meshes/simple_channel_straight_surface_slope.e
  # file = /home/adrien/COEBELI/projects/mastodon/meshes/channel_10k_1und_ushape.e
<<<<<<< HEAD
  # displacements = 'disp_x disp_y disp_z'
=======
  displacements = 'disp_x disp_y disp_z'
>>>>>>> 1e794af8c06a6fad51903ef184721e2ff8c6c14e
  second_order = true
[]


[Variables]
  [velocity_x]
    order = SECOND
    family = LAGRANGE
  []
  [velocity_y]
    order = SECOND
    family = LAGRANGE
  []
  [velocity_z]
    order = SECOND
    family = LAGRANGE
  []
  [pressure]
    order = FIRST
    family = LAGRANGE
  []
[]

[Kernels]
  [mass]
    type = INSMass
    variable = pressure
    u = velocity_x
    v = velocity_y
    w = velocity_z
    pressure = pressure
<<<<<<< HEAD
    use_displaced_mesh = true
=======
    # use_displaced_mesh = true
>>>>>>> 1e794af8c06a6fad51903ef184721e2ff8c6c14e
  []
  [x_momentum_space]
    type = INSMomentumLaplaceForm
    variable = velocity_x
    u = velocity_x
    v = velocity_y
    w = velocity_z
    pressure = pressure
    component = 0
<<<<<<< HEAD
    use_displaced_mesh = true
=======
    # use_displaced_mesh = true
>>>>>>> 1e794af8c06a6fad51903ef184721e2ff8c6c14e
  []
  [y_momentum_space]
    type = INSMomentumLaplaceForm
    variable = velocity_y
    u = velocity_x
    v = velocity_y
    w = velocity_z
    pressure = pressure
    component = 1
<<<<<<< HEAD
    use_displaced_mesh = true
=======
    # use_displaced_mesh = true
>>>>>>> 1e794af8c06a6fad51903ef184721e2ff8c6c14e
  []
  [z_momentum_space]
    type = INSMomentumLaplaceForm
    variable = velocity_z
    u = velocity_x
    v = velocity_y
    w = velocity_z
    pressure = pressure
    component = 2
<<<<<<< HEAD
    use_displaced_mesh = true
=======
    # use_displaced_mesh = true
>>>>>>> 1e794af8c06a6fad51903ef184721e2ff8c6c14e
  []
[]

[BCs]
  [Pressure]
    [downstream_pressure]  
    boundary = downstream
    function = ocean_pressure
    displacements = 'velocity_x velocity_y velocity_z'
    []
  []
  [bottom_boundary_x]
    type = DirichletBC
    variable = velocity_x
    boundary = 'bottom'
    value = 0.
  []
  [bottom_boundary_y]
    type = DirichletBC
    variable = velocity_y
    boundary = 'bottom'
    value = 0.
  []
  [bottom_boundary_z]
    type = DirichletBC
    variable = velocity_z
    boundary = 'bottom'
    value = 0.
  []
  [left_boundary_x]
    type = DirichletBC
    variable = velocity_x
    boundary = 'left'
    value = 0.
  []
  [left_boundary_y]
    type = DirichletBC
    variable = velocity_y
    boundary = 'left'
    value = 0.
  []
  [left_boundary_z]
    type = DirichletBC
    variable = velocity_z
    boundary = 'left'
    value = 0.
  []
  [right_boundary_x]
    type = DirichletBC
    variable = velocity_x
    boundary = 'right'
    value = 0.
  []
  [right_boundary_y]
    type = DirichletBC
    variable = velocity_y
    boundary = 'right'
    value = 0.
  []
  [right_boundary_z]
    type = DirichletBC
    variable = velocity_z
    boundary = 'right'
    value = 0.
  []
  # [downstream_boundary_x]
  #   type = DirichletBC
  #   variable = velocity_x
  #   boundary = 'downstream'
  #   value = -0.0000002 # 2.7e-4 # 1 m.h-1
  # []
  [downstream_boundary_y]
    type = DirichletBC
    variable = velocity_y
    boundary = 'downstream'
    value = 0.
  []
  [downstream_boundary_z]
    type = DirichletBC
    variable = velocity_z
    boundary = 'downstream'
    value = 0.
  []
  [upstream_boundary_x]
    type = DirichletBC
    variable = velocity_x
    boundary = 'upstream'
    value = 0.00001 # 2.7e-4 # 1 m.h-1 # 0.0000002
  []
  [upstream_boundary_y]
    type = DirichletBC
    variable = velocity_y
    boundary = 'upstream'
    value = 0.
  []
  [upstream_boundary_z]
    type = DirichletBC
    variable = velocity_z
    boundary = 'upstream'
    value = 0.
  []
        
  # [Periodic]
  #   [all]
  #     variable = 'velocity_x velocity_y velocity_z'
  #     auto_direction = 'x'
  #   []
  # []
  
 # [in_flux_boundary_x]
 #   type = DirichletBC
 #   # type = FunctionDirichletBC
 #   variable = velocity_x
 #   boundary = 'upstream'
 #   # function = 'inlet_func'
 #   value = 100.
 # []
 # [in_flux_boundary_y]
#    type = DirichletBC
#    variable = velocity_y
#    boundary = 'left'
#    value = 0.
#  []
#  [in_flux_boundary_z]
#    type = DirichletBC
#    variable = velocity_z
#    boundary = 'left'
#    value = 0.
#  []

[]

[Materials]
  [ice]
    type = IceMaterial
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
    pressure = pressure
  []
  
[]

# [Preconditioning]
#   [SMP_PJFNK]
#     type = SMP
#     full = true
#     solve_type = NEWTON
#   []
# []

# [Executioner]
#   type = Transient
#   # petsc_options_iname = '-ksp_gmres_restart -pc_type -sub_pc_type -sub_pc_factor_levels'
#   # petsc_options_value = '300                bjacobi  ilu          4'
#   petsc_options_iname = '-pc_type -pc_factor_shift -pc_factor_mat_solver_package'
#   petsc_options_value = 'lu        NONZERO mumps'
#   line_search = none

#   l_tol = 1e-6
#   nl_max_its = 15
#   nl_rel_tol = 1e-3
#   nl_abs_tol = 1e-3

#   start_time = 0.0
#   dt = 1000
#   end_time = 2000.0

#   # [TimeIntegrator]
#   #   type = NewmarkBeta
#   #   beta = 0.4225
#   #   gamma = 0.5
#   # []

#   #  [TimeStepper]
#   #   type = IterationAdaptiveDT
#   #   dt = 1.0
#   #   optimal_iterations = 10
#   #   time_t = '0.0 5.0'
#   #   time_dt = '1.0 5.0'
#   # []
# []


[Contact]
  [bottom_interface]
    primary = "bottom"
<<<<<<< HEAD
    secondary = "bottom"
=======
    secondary = "top"
>>>>>>> 1e794af8c06a6fad51903ef184721e2ff8c6c14e
    model = coulomb
    formulation = penalty
    normalize_penalty = true
    friction_coefficient = 0.5
    penalty = 8e6
    tangential_tolerance = 0.005
  []
[]

[Executioner]
  type = Transient
  petsc_options = '-ksp_snes_ew'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist'
  solve_type = 'NEWTON'
  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-12
  dt = 86400 # one day in seconds
  end_time = 864000 # 10 days in seconds
  timestep_tolerance = 1e-6
  automatic_scaling = true
  [TimeIntegrator]
    type = NewmarkBeta
    beta = 0.25
    gamma = 0.5
    inactive_tsteps = 2
  []
[]

[Outputs]
  interval = 1
  execute_on = timestep_end
  exodus = true
  [console]
    type=Console
    output_linear = true
  []
[]

[Functions]
  [ocean_pressure]
    type = ParsedFunction
    value = '8829*(1000-z)'   
  []
[]


#[Adaptivity]
#   marker = error_frac
#   max_h_level = 3
#   [Indicators]
#     [temperature_jump]
#       type = GradientJumpIndicator
#       variable = pressure
#       scale_by_flux_faces = true
#     []
#   []
#   [Markers]
#     [error_frac]
#       type = ErrorFractionMarker
#       coarsen = 0.15
#       indicator = temperature_jump
#       refine = 0.7
#     []
#   []
# []
