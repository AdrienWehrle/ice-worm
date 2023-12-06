# ------------------------ 

[GlobalParams]
  gravity = '0 0 -9.81'
  integrate_p_by_parts = true
[]

[Mesh]
  type = FileMesh
  file = /home/adrien/COEBELI/projects/mastodon/meshes/test_bed.e
  # displacements = 'disp_x disp_y disp_z'
  second_order = true
[]


[Variables]
  [velocity_x]
    order = SECOND
    family = LAGRANGE
    block = 'eleblock1 eleblock2 eleblock3'
  []
  [velocity_y]
    order = SECOND
    family = LAGRANGE
    block = 'eleblock1 eleblock2 eleblock3'
  []
  [velocity_z]
    order = SECOND
    family = LAGRANGE
    block = 'eleblock1 eleblock2 eleblock3'
  []
  [pressure]
    order = FIRST
    family = LAGRANGE
    block = 'eleblock1 eleblock2 eleblock3'
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
    use_displaced_mesh = true
    block = 'eleblock1 eleblock2 eleblock3'
  []
  [x_momentum_space]
    type = INSMomentumLaplaceForm
    variable = velocity_x
    u = velocity_x
    v = velocity_y
    w = velocity_z
    pressure = pressure
    component = 0
    use_displaced_mesh = true
    block = 'eleblock1 eleblock2 eleblock3'
  []
  [y_momentum_space]
    type = INSMomentumLaplaceForm
    variable = velocity_y
    u = velocity_x
    v = velocity_y
    w = velocity_z
    pressure = pressure
    component = 1
    use_displaced_mesh = true
    block = 'eleblock1 eleblock2 eleblock3'
  []
  [z_momentum_space]
    type = INSMomentumLaplaceForm
    variable = velocity_z
    u = velocity_x
    v = velocity_y
    w = velocity_z
    pressure = pressure
    component = 2
    use_displaced_mesh = true
    block = 'eleblock1 eleblock2 eleblock3'
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
  # [bottom_boundary_x]
  #   type = DirichletBC
  #   variable = velocity_x
  #   boundary = 'bottom'
  #   value = 0.
  # []
  # [bottom_boundary_y]
  #   type = DirichletBC
  #   variable = velocity_y
  #   boundary = 'bottom'
  #   value = 0.
  # []
  # [bottom_boundary_z]
  #   type = DirichletBC
  #   variable = velocity_z
  #   boundary = 'bottom'
  #   value = 0.
  # []
  [sediment_boundary_x]
    type = DirichletBC
    variable = velocity_x
    boundary = 'sediment'
    value = 0.
  []
  [sediment_boundary_y]
    type = DirichletBC
    variable = velocity_y
    boundary = 'sediment'
    value = 0.
  []
  [sediment_boundary_z]
    type = DirichletBC
    variable = velocity_z
    boundary = 'sediment'
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
    value = 0. # 0.00001 # 2.7e-4 # 1 m.h-1 # 0.0000002
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
    block = 'eleblock1'
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
    pressure = pressure
  []
  [base]
    type = SedimentMaterial
    block = 'eleblock2 eleblock3'
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
    pressure = pressure
  []
[]

[Executioner]
  type = Transient
  petsc_options = '-ksp_snes_ew'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist'
  solve_type = 'NEWTON'
  # nl_rel_tol = 1e-7
  nl_rel_tol = 1e-4
  # nl_abs_tol = 1e-12
  nl_abs_tol = 1e-4
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
