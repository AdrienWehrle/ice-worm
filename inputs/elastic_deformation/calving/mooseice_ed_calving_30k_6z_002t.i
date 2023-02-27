# based on mastodon_cogmodel.i, Tinu

# ------------------------ 

# slope of the bottom boundary (in degrees)
bed_slope = 15 

# change coordinate system to add a slope
gravity_x = ${fparse
  	      cos((90 - bed_slope) / 180 * pi) * 9.81
              } 
gravity_z = ${fparse
	      cos(bed_slope / 180 * pi) * 9.81
              } 

# account for slope in BC on displacement  
# bed_factor_x = ${fparse
#              	 cos(bed_slope / 180 * pi)
#                 }
# bed_factor_z = ${fparse
# 	         sin(bed_slope / 180 * pi)
#                 }

# ------------------------

[Mesh]
  
  [channel]      
    type = FileMeshGenerator
    file = /home/guschti/projects/mastodon/meshes/channel_30k_3und.e
  []

  [deactivated]      
    type = FileMeshGenerator
    file = /home/guschti/projects/mastodon/meshes/channel_30k_3und_disabled_element.e
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

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [disp_x]
    order = FIRST
    family = LAGRANGE
    block = '1 255'
  []
  [disp_y]
    order = FIRST
    family = LAGRANGE
    block = '1 255'
  []
  [disp_z]
    order = FIRST
    family = LAGRANGE
    block = '1 255'
  []
[]

[AuxVariables]
  [vel_x]
    block = '1 255'
  []
  [accel_x]
    block = '1 255'
  []
  [vel_y]
    block = '1 255'
  []
  [accel_y]
    block = '1 255'
  []
  [vel_z]
    block = '1 255'
  []
  [accel_z]
    block = '1 255'
  []
  [stress_xx]
    order = CONSTANT
    family = MONOMIAL
    block = '1 255'
  []
  [stress_xy]
    order = CONSTANT
    family = MONOMIAL
    block = '1 255'
  []
  [stress_xz]
    order = CONSTANT
    family = MONOMIAL
    block = '1 255'
  []
  [stress_yx]
    order = CONSTANT
    family = MONOMIAL
    block = '1 255'
  []
  [stress_yy]
    order = CONSTANT
    family = MONOMIAL
    block = '1 255'
  []
  [stress_yz]
    order = CONSTANT
    family = MONOMIAL
    block = '1 255'
  []
  [stress_zx]
    order = CONSTANT
    family = MONOMIAL
    block = '1 255'
  []
  [stress_zy]
    order = CONSTANT
    family = MONOMIAL
    block = '1 255'
  []
  [stress_zz]
    order = CONSTANT
    family = MONOMIAL
    block = '1 255'
  []
  [calving_boolean]
  []
[]

[UserObjects]
  [calving_event]
    type = CoupledVarThresholdElementSubdomainModifier
    coupled_var = 'calving_boolean'
    block = 1
    criterion_type = ABOVE
    threshold = 0.
    subdomain_id = 255
    moving_boundary_name = downstream 
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
[]

[Functions]
  [weight]
    type = ParsedFunction
    value = '-8829*(1000-z)'    # initial stress that should result from the weight force
  []
  [upstream_dirichlet]
    type = ParsedFunction
    value = '0'
  []
  [ocean_pressure]
    type = ParsedFunction
    value = '8829*(1000-z)'   
  []
  [calving_criterion]
    type = ParsedFunction
    value = 'if((x>29300.)&(t>0.06), 1000., -1000.)'
  []
[]

[Kernels]
  [gravity_x]
    type = Gravity
    variable = disp_x
    value= ${gravity_x}
  []
  [gravity_y]
    type = Gravity
    variable = disp_y
    value = 0.
  []
  [gravity_z]
    type = Gravity
    variable = disp_z
    value = -${gravity_z}
  []
  [DynamicTensorMechanics]
    stiffness_damping_coefficient = 0.02
    mass_damping_coefficient = 0.02
    displacements = 'disp_x disp_y disp_z'
    static_initialization = true
  []
  [inertia_x]
    type = InertialForce
    variable = disp_x
    velocity = vel_x
    acceleration = accel_x
    beta = 0.25
    gamma = 0.5
  []
  [inertia_y]
    type = InertialForce
    variable = disp_y
    velocity = vel_y
    acceleration = accel_y
    beta = 0.25
    gamma = 0.5
  []
  [inertia_z]
    type = InertialForce
    variable = disp_z
    velocity = vel_z
    acceleration = accel_z
    beta = 0.25
    gamma = 0.5
  []
[]

[AuxKernels]
  [accel_x]
    type = NewmarkAccelAux
    variable = accel_x
    displacement = disp_x
    velocity = vel_x
    beta = 0.25
    execute_on = timestep_end
  []
  [vel_x]
    type = NewmarkVelAux
    variable = vel_x
    acceleration = accel_x
    gamma = 0.5
    execute_on = timestep_end
  []
  [accel_y]
    type = NewmarkAccelAux
    variable = accel_y
    displacement = disp_y
    velocity = vel_y
    beta = 0.25
    execute_on = timestep_end
  []
  [vel_y]
    type = NewmarkVelAux
    variable = vel_y
    acceleration = accel_y
    gamma = 0.5
    execute_on = timestep_end
  []
  [accel_z]
    type = NewmarkAccelAux
    variable = accel_z
    displacement = disp_z
    velocity = vel_z
    beta = 0.25
    execute_on = timestep_end
  []
  [vel_z]
    type = NewmarkVelAux
    variable = vel_z
    acceleration = accel_z
    gamma = 0.5
    execute_on = timestep_end
  []
  [stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  []
  [stress_xy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_i = 0
    index_j = 1
  []
  [stress_xz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xz
    index_i = 0
    index_j = 2
  []
  [stress_yx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yx
    index_i = 1
    index_j = 0
  []
  [stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
  []
  [stress_yz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yz
    index_i = 1
    index_j = 2
  []
  [stress_zx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zx
    index_i = 2
    index_j = 0
  []
  [stress_zy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zy
    index_i = 2
    index_j = 1
  []
  [stress_zz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zz
    index_i = 2
    index_j = 2
  []
  # [damage_index]
  #   type = MaterialRealAux
  #   variable = damage_index
  #   property = damage_index
  #   execute_on = timestep_end
  #   block = '1 255'
  # []
  [calving]
    type = FunctionAux
    variable = calving_boolean
    function = calving_criterion
    execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
  []
[]

[Materials]
  [ice_elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 8.7e9 #Pa
    poissons_ratio = 0.31
    block = '1 255'
  []
  [strain]
    type = ComputeIncrementalSmallStrain
    displacements = 'disp_x disp_y disp_z'
    block = '1 255'
  []
  [density]
    type = GenericConstantMaterial
    prop_names = density
    prop_values = 900 #kg/m3
    block = '1 255'
  []
  [stress]
    type = ComputeFiniteStrainElasticStress
    block = '1 255'
  []
  # [stress]
  #   type = ComputeDamageWithoutStressUpdate
  #   damage_model = damage
  #   block = '1 255'
  # []
  [strain_from_initial_stress]
    type = ComputeEigenstrainFromInitialStress
    initial_stress = '0 0 0  0 0 0  0 0 weight'
    eigenstrain_name = ini_stress
    block = '1 255'
  []
  [von_mises]
    type = RankTwoInvariant
    invariant = 'VonMisesStress'
    property_name = von_mises
    rank_two_tensor = stress
    outputs = exodus
    block = '1 255'
  []
  # [damage]
  #   type = CustomDamageMazars
  #   B = 0.01
  #   sig_th = 0.11
  #   alpha = 1.
  #   outputs = exodus
  #   output_properties = damage_index
  #   block = '1 255'
  # []
[]

[BCs]
  [upstream_dirichlet]
    type = DirichletBC                                               
    boundary = 'upstream'
    variable = disp_x
    value    = 0.0
  []  
  [Pressure]
    [downstream_pressure]  
    boundary = downstream
    function = ocean_pressure
    displacements = 'disp_x disp_y disp_z'
    []
  []
  [downstream_dirichlet]
    type = DirichletBC                                               
    boundary = 'downstream'
    variable = disp_x
    value    = 0.0
  []
  [anchor_bottom_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'bottom'
    value = 0.0
  []  
  [anchor_botom_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'bottom'
    value = 0.0
  []
  [anchor_bottom_z]
    type = DirichletBC
    variable = disp_z
    boundary = 'bottom'
    value = 0.0
  []

  [anchor_sides_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'left right'
    value = 0.0
  []
  [anchor_sides_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'left right'
    value = 0.
  []
  [anchor_sides_z]
    type = DirichletBC
    variable = disp_z
    boundary = 'left right'
    value = 0.0
  []

[]

[Controls]

  [inertia_switch]
    type = TimePeriod
    start_time = 0.0
    end_time = 0.03
    disable_objects = '*/inertia_x */inertia_y */inertia_z
                       */vel_x */vel_y */vel_z
                       */accel_x */accel_y */accel_z'
    set_sync_times = true
    execute_on = 'timestep_begin timestep_end'
  []
  
[]

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
  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-12
  dt = 0.02
  end_time = 50.
  timestep_tolerance = 1e-6
  automatic_scaling = true
  [TimeIntegrator]
    type = NewmarkBeta
    beta = 0.25
    gamma = 0.5
    inactive_tsteps = 2
  []
[]

[Problem]
  kernel_coverage_check = false
  material_coverage_check = false
[]

[Outputs]
  exodus = true
  perf_graph = true
[]
