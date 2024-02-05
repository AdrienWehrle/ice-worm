# ------------------------ 

[GlobalParams]
  gravity = '0 0 -9.81'
  integrate_p_by_parts = true
[]

[Mesh]
  type = FileMesh
  file = /home/guschti/projects/mastodon/meshes/mesh_ac_lowerres_flat.e
  # file = /home/guschti/projects/mastodon/meshes/mesh_ac_lowerres.e
  # displacements = 'disp_x disp_y disp_z'
  second_order = true
[]


[Variables]
  [pressure]
    order = FIRST
    family = LAGRANGE
    block = 'eleblock1 eleblock2 eleblock3'
  []
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
[]

[Kernels]
  [mass]
    type = INSMass
    variable = pressure
    u = velocity_x
    v = velocity_y
    w = velocity_z
    pressure = pressure
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
    block = 'eleblock1 eleblock2 eleblock3'
  []
[]

[BCs]
  [Pressure]
    [downstream_pressure]  
    boundary = downstream
    function = ocean_pressure
    displacements = 'velocity_x' # velocity_y velocity_z'
    []
    [sediment_downstream_pressure]  
    boundary = downstream_sediment
    function = ocean_pressure
    displacements = 'velocity_x' # velocity_y velocity_z'
    []
  []
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
  [left_sediment_boundary_x]
    type = DirichletBC
    variable = velocity_x
    boundary = 'left_sediment'
    value = 0.
  []
  [left_sediment_boundary_y]
    type = DirichletBC
    variable = velocity_y
    boundary = 'left_sediment'
    value = 0.
  []
  [left_sediment_boundary_z]
    type = DirichletBC
    variable = velocity_z
    boundary = 'left_sediment'
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
  [right_sediment_boundary_x]
    type = DirichletBC
    variable = velocity_x
    boundary = 'right_sediment'
    value = 0.
  []
  [right_sediment_boundary_y]
    type = DirichletBC
    variable = velocity_y
    boundary = 'right_sediment'
    value = 0.
  []
  [right_sediment_boundary_z]
    type = DirichletBC
    variable = velocity_z
    boundary = 'right_sediment'
    value = 0.
  []
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
    value = 0.
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
  [upstream_sediment_boundary_x]
    type = DirichletBC
    variable = velocity_x
    boundary = 'upstream_sediment'
    value = 0.
  []
  [upstream_sediment_boundary_y]
    type = DirichletBC
    variable = velocity_y
    boundary = 'upstream_sediment'
    value = 0.
  []
  [upstream_sediment_boundary_z]
    type = DirichletBC
    variable = velocity_z
    boundary = 'upstream_sediment'
    value = 0.
  []
  # [downstream_sediment_boundary_x]
  #   type = DirichletBC
  #   variable = velocity_x
  #   boundary = 'downstream_sediment'
  #   value = 0.
  # []
  # [downstream_sediment_boundary_y]
  #   type = DirichletBC
  #   variable = velocity_y
  #   boundary = 'downstream_sediment'
  #   value = 0.
  # []
  # [downstream_sediment_boundary_z]
  #   type = DirichletBC
  #   variable = velocity_z
  #   boundary = 'downstream_sediment'
  #   value = 0.
# []
  # [downstream__boundary_x]
  #   type = DirichletBC
  #   variable = velocity_x
  #   boundary = 'downstream'
  #   value = 0.
  # []
  # [downstream__boundary_y]
  #   type = DirichletBC
  #   variable = velocity_y
  #   boundary = 'downstream'
  #   value = 0.
  # []
  # [downstream__boundary_z]
  #   type = DirichletBC
  #   variable = velocity_z
  #   boundary = 'downstream'
  #   value = 0.
  # []
[]

[Materials]
  [ice]
    type = IceMaterial_u2
    block = 'eleblock1 eleblock2'
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
    pressure = pressure
  []
  [base]
    type = SedimentMaterial_u2
    block = 'eleblock3'
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
    pressure = pressure
    FrictionCoefficient=0.1
  []
[]

# [Preconditioning]
#   [andy]
#     type = SMP
#     full = true
#   []
# []

# [Preconditioning]
#   active = basic
#   [mumps_is_best_for_parallel_jobs]
#     type = SMP
#     full = true
#     petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
#     petsc_options_value = ' lu       mumps'
#   []
#   [basic]
#     type = SMP
#     full = true
#     petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
#     petsc_options_value = 'gmres      asm      lu           NONZERO                   2             '
#   []
# []

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
  dt = 0.001 # in y, 0.001y ~= 9h
  end_time = 0.005 # in year, 0.005y ~= 44h
  # dt = 864000 # one day in seconds
  # end_time = 8640000 # 10 days in seconds
  timestep_tolerance = 1e-6
  automatic_scaling = true

  [TimeIntegrator]
    type = NewmarkBeta
    beta = 0.25
    gamma = 0.5
    # inactive_tsteps = 2
  []
  # [TimeStepper]
  #   type = IterationAdaptiveDT
  #   dt = 0.001 # in y, 0.001y ~= 9h
  #   optimal_iterations = 10
  # []
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
    value = 'if(z < 0, -1028 * 9.81 * z * 1e-6, 0)'
  []
  [weight]
    type = ParsedFunction
    value = '917 * 9.81 * (100-z)  * 1e-6'
  []

  [velocity_depth]
    type = ParsedFunction
    value = '1000 * (1 - ((100 - z) / 1500))'

  []
[]

[Debug]
  show_var_residual_norms = true
[]

[ICs]
  [pressure_weight]
    type = FunctionIC
    variable = 'pressure'
    function = weight
  []
  # [velocity_x_IC]
  #   type = FunctionIC
  #   variable = 'velocity_x'
  #   function = velocity_depth
  # []
[]
