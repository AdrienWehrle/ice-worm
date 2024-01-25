# ------------------------ 

[GlobalParams]
  gravity = '0 0 -9.81'
  integrate_p_by_parts = true
[]

# [Mesh]
#   type = FileMesh
#   file = /home/adrien/COEBELI/projects/mastodon/meshes/test_bed.e
#   # displacements = 'disp_x disp_y disp_z'
#   second_order = true
# []

[Mesh]
  
  [channel]      
    type = FileMesh
    file = /home/adrien/COEBELI/projects/mastodon/meshes/test_bed.e
    # displacements = 'disp_x disp_y disp_z'
    second_order = true
  []

  [deactivated]      
    type = FileMeshGenerator
    file = /home/adrien/COEBELI/projects/mastodon/meshes/disabled_element.e
  []

  [combined]
    type = CombinerGenerator
    inputs = 'channel deactivated'
  []

  [final_mesh]
    type = SubdomainBoundingBoxGenerator
    input = combined
    block_id = 255
    block_name = deactivated
    bottom_left = '-60 19950 -10'
    top_right = '60 20100 60'
  []

  final_generator = final_mesh

[]


[Variables]
  [pressure]
    order = FIRST
    family = LAGRANGE
    block = 'eleblock1 eleblock2 eleblock3 eledeactivatedblock1'
  []
  [velocity_x]
    order = SECOND
    family = LAGRANGE
    block = 'eleblock1 eleblock2 eleblock3 eledeactivatedblock1'
  []
  [velocity_y]
    order = SECOND
    family = LAGRANGE
    block = 'eleblock1 eleblock2 eleblock3 eledeactivatedblock1'
  []
  [velocity_z]
    order = SECOND
    family = LAGRANGE
    block = 'eleblock1 eleblock2 eleblock3 eledeactivatedblock1'
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
    block = 'eleblock1 eleblock2 eleblock3 eledeactivatedblock1'
  []
  [x_momentum_space]
    type = INSMomentumLaplaceForm
    variable = velocity_x
    u = velocity_x
    v = velocity_y
    w = velocity_z
    pressure = pressure
    component = 0
    block = 'eleblock1 eleblock2 eleblock3 eledeactivatedblock1'
  []
  [y_momentum_space]
    type = INSMomentumLaplaceForm
    variable = velocity_y
    u = velocity_x
    v = velocity_y
    w = velocity_z
    pressure = pressure
    component = 1
    block = 'eleblock1 eleblock2 eleblock3 eledeactivatedblock1'
  []
  [z_momentum_space]
    type = INSMomentumLaplaceForm
    variable = velocity_z
    u = velocity_x
    v = velocity_y
    w = velocity_z
    pressure = pressure
    component = 2
    block = 'eleblock1 eleblock2 eleblock3 eledeactivatedblock1'
  []
[]

[BCs]

  [Pressure]
    [downstream_pressure]  
    boundary = downstream
    function = ocean_pressure
    displacements = 'velocity_x velocity_y velocity_z'
    []
    # [sediment_downstream_pressure]  
    # boundary = downstream_sediment
    # function = ocean_pressure
    # displacements = 'velocity_x velocity_y velocity_z'
    # []
  []

  # ice domain
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
    value = 2.7e-5 # 0.1 m.h-1 # 0.00001 # 2.7e-4 # 1 m.h-1 # 0.0000002
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

  # sediment layer
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
  [downstream_sediment_boundary_x]
    type = DirichletBC
    variable = velocity_x
    boundary = 'downstream_sediment'
    value = 0.
  []
  [downstream_sediment_boundary_y]
    type = DirichletBC
    variable = velocity_y
    boundary = 'downstream_sediment'
    value = 0.
  []
  [downstream_sediment_boundary_z]
    type = DirichletBC
    variable = velocity_z
    boundary = 'downstream_sediment'
    value = 0.
  []

  # deactivated element
  [upstream_deactivated_boundary_x]
    type = DirichletBC
    variable = velocity_x
    boundary = 'upstream_deactivated'
    value = 0.
  []
  [upstream_deactivated_boundary_y]
    type = DirichletBC
    variable = velocity_y
    boundary = 'upstream_deactivated'
    value = 0.
  []
  [upstream_deactivated_boundary_z]
    type = DirichletBC
    variable = velocity_z
    boundary = 'upstream_deactivated'
    value = 0.
  []
  [downstream_deactivated_boundary_x]
    type = DirichletBC
    variable = velocity_x
    boundary = 'downstream_deactivated'
    value = 0.
  []
  [downstream_deactivated_boundary_y]
    type = DirichletBC
    variable = velocity_y
    boundary = 'downstream_deactivated'
    value = 0.
  []
  [downstream_deactivated_boundary_z]
    type = DirichletBC
    variable = velocity_z
    boundary = 'downstream_deactivated'
    value = 0.
  []
  [right_deactivated_boundary_x]
    type = DirichletBC
    variable = velocity_x
    boundary = 'right_deactivated'
    value = 0.
  []
  [right_deactivated_boundary_y]
    type = DirichletBC
    variable = velocity_y
    boundary = 'right_deactivated'
    value = 0.
  []
  [right_deactivated_boundary_z]
    type = DirichletBC
    variable = velocity_z
    boundary = 'right_deactivated'
    value = 0.
  []
  [left_deactivated_boundary_x]
    type = DirichletBC
    variable = velocity_x
    boundary = 'left_deactivated'
    value = 0.
  []
  [left_deactivated_boundary_y]
    type = DirichletBC
    variable = velocity_y
    boundary = 'left_deactivated'
    value = 0.
  []
  [left_deactivated_boundary_z]
    type = DirichletBC
    variable = velocity_z
    boundary = 'left_deactivated'
    value = 0.
  []
  [bottom_deactivated_boundary_x]
    type = DirichletBC
    variable = velocity_x
    boundary = 'bottom_deactivated'
    value = 0.
  []
  [bottom_deactivated_boundary_y]
    type = DirichletBC
    variable = velocity_y
    boundary = 'bottom_deactivated'
    value = 0.
  []
  [bottom_deactivated_boundary_z]
    type = DirichletBC
    variable = velocity_z
    boundary = 'bottom_deactivated'
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
    block = 'eleblock1 eleblock2 eledeactivatedblock1'
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
    pressure = pressure
  []
  [base]
    type = SedimentMaterial
    block = 'eleblock3'
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
    pressure = pressure
  []
[]

# [Controls]
#   [inertia_switch]
#     type = TimePeriod
#     start_time = 0.0
#     end_time = 1728000
#     # disable_objects = 'Kernel::x_momentum_space Kernel::y_momentum_space Kernel::z_momentum_space'
#     # disable_objects = 'Kernel::mass'
#     set_sync_times = true
#     execute_on = 'timestep_begin timestep_end'
#   []
# []

[Preconditioning]
  [andy]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  petsc_options = '-ksp_snes_ew'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist'
  solve_type = 'NEWTON'
  # nl_rel_tol = 1e-7
  nl_rel_tol = 1e-2
  # nl_abs_tol = 1e-12
  nl_abs_tol = 1e-2
  dt = 864000 # one day in seconds
  end_time = 8640000 # 10 days in seconds
  timestep_tolerance = 1e-6
  automatic_scaling = true
  [TimeIntegrator]
    type = NewmarkBeta
    beta = 0.25
    gamma = 0.5
    inactive_tsteps = 2
  []
  # [TimeStepper]
  #   type = IterationAdaptiveDT
  #   dt = 864000
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
    value = '1028 * 9.81 * (2212.97-z) / 1e6'   
  []
  [weight]
    type = ParsedFunction
    value = '917 * 9.81 * (2212.97-z) / 1e6'
  []
  
[]

[ICs]
  [pressure_weight]
    type = FunctionIC
    variable = 'pressure'
    function = weight
  []
[]
