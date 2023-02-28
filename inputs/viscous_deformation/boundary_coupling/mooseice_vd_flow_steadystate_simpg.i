[GlobalParams]
  gravity = '0 -9.81e-3 0'
  integrate_p_by_parts = true
[]

[Mesh]
  type = GeneratedMesh
  dim = 3
  xmin = 0
  xmax = 3.0
  ymin = 0
  ymax = 1.0
  zmin = 0
  zmax = 3.0
  nx = 5
  ny = 5
  nz = 5
  elem_type = HEX20
  # elem_type = QUAD9
  # displacements = 'velocity_x velocity_y velocity_z'
[]

# [Mesh]
#   type = FileMesh
#   file = /home/guschti/projects/mastodon/meshes/channel.e # /home/guschti/projects/mastodon/meshes/channel_10k_1und_ushape.e
#   # displacements = 'disp_x disp_y disp_z'
#   second_order=true
# []


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
    # use_displaced_mesh = true
  []
  [x_momentum_space]
    type = INSMomentumLaplaceForm
    variable = velocity_x
    u = velocity_x
    v = velocity_y
    w = velocity_z
    pressure = pressure
    component = 0
    # use_displaced_mesh = true
  []
  [y_momentum_space]
    type = INSMomentumLaplaceForm
    variable = velocity_y
    u = velocity_x
    v = velocity_y
    w = velocity_z
    pressure = pressure
    component = 1
    # use_displaced_mesh = true
  []
  [z_momentum_space]
    type = INSMomentumLaplaceForm
    variable = velocity_z
    u = velocity_x
    v = velocity_y
    w = velocity_z
    pressure = pressure
    component = 2
    # use_displaced_mesh = true
  []
[]

[BCs]
  [basal_boundary_x]
    type = DirichletBC
    variable = velocity_x
    boundary = 'bottom'
    value = 0.
  []
  [basal_boundary_y]
    type = DirichletBC
    variable = velocity_y
    boundary = 'bottom'
    value = 0.
  []
  [basal_boundary_z]
    type = DirichletBC
    variable = velocity_z
    boundary = 'bottom'
    value = 0.
  []
  
  # [Periodic]
  #   [all]
  #     variable = 'velocity_x velocity_y velocity_z'
  #     auto_direction = 'x'
  #   []
  # []
  
#  [in_flux_boundary_x]
#    type = DirichletBC
#    # type = FunctionDirichletBC
#    variable = velocity_x
#    boundary = 'left'
#    # function = 'inlet_func'
#    value = 0.
#  []
#  [in_flux_boundary_y]
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

[Preconditioning]
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type = NEWTON
  []
[]

[Executioner]
  type = Transient
  petsc_options_iname = '-ksp_gmres_restart -pc_type -sub_pc_type -sub_pc_factor_levels'
  petsc_options_value = '300                bjacobi  ilu          4'
  line_search = none

  l_tol = 1e-6
  nl_max_its = 15
  nl_rel_tol = 1e-3
  nl_abs_tol = 1e-3

  start_time = 0.0
  dt = 1.0
  end_time = 10000.0

  [TimeIntegrator]
    type = NewmarkBeta
    beta = 0.4225
    gamma = 0.5
  []

   [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1.0
    optimal_iterations = 10
    time_t = '0.0 5.0'
    time_dt = '1.0 5.0'
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

# [Functions]
#   [./inlet_func]
#     type = ParsedFunction
#     value = '-4 * (y - 0.5)^2 + 1'
#   [../]
# []


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
