# ------------------------ 

# slope of the bottom boundary (in degrees)
bed_slope = 2

# change coordinate system to add a slope
gravity_x = ${fparse
  	      cos((90 - bed_slope) / 180 * pi) * 9.81
              } 
gravity_z = ${fparse
	      - cos(bed_slope / 180 * pi) * 9.81
              } 

# ------------------------

[GlobalParams]
  gravity = '${gravity_x} 0. ${gravity_z}'
  integrate_p_by_parts = true
[]

[Mesh]
  type = FileMesh
  file = /home/adrien/UZH/ice-worm/meshes/mesh_gold_lowerres.e
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

  [initialization_diffusion]
    type = FunctionDiffusion
    variable = 'velocity_x'
    function = '100 * exp(-10 * t)'
  []
[]

[BCs]
  [Periodic]
    [up_down]
      primary = downstream
      secondary = upstream
      translation = '-19700 0 0'
      variable = 'velocity_x velocity_y velocity_z'
    []
    [up_down_sediment]
      primary = downstream_sediment
      secondary = upstream_sediment
      translation = '-19700 0 0'
      variable = 'velocity_x velocity_y velocity_z'
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
[]

[Materials]
  [ice]
    type = IceMaterial_u2
    block = 'eleblock1 eleblock2 eleblock3'
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
    pressure = pressure
  []
[]

# [Preconditioning]
#   [andy]
#     type = SMP
#     full = true
#   []
# []

[Executioner]
  type = Transient
  petsc_options = '-ksp_snes_ew'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist'
  solve_type = 'NEWTON'
  dt = 0.05 # in y, 0.001y ~= 9h
  end_time = 1 # in year, 0.005y ~= 44h
  # dt = 864000 # one day in seconds
  # end_time = 8640000 # 10 days in seconds
  timestep_tolerance = 1e-3
  automatic_scaling = true

  nl_max_its = 100
  # nl_rel_step_tol = 1e-2
  nl_rel_tol = 1e-4
  nl_abs_tol = 1e-4
 
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
  [Adaptivity]
    interval = 1
    refine_fraction = 0.5
    coarsen_fraction = 0.3
    max_h_level = 10
    cycles_per_step = 2
  []

[]

[Functions]
  [ocean_pressure]
    type = ParsedFunction
    value = 'if(z < 0, -1028 * 9.81 * z * 1e-6, 0)'
  []
  [weight]
    type = ParsedFunction
    value = '917 * 9.81 * (434.9-z)  * 1e-6'
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
  #   type = ConstantIC
  #   variable = 'velocity_x'
  #   value = 500.
  # []
[]

