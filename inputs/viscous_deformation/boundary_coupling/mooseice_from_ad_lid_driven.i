# ------------------------ 

# slope of the bottom boundary (in degrees)
bed_slope = 5

# change coordinate system to add a slope
gravity_x = ${fparse
  	      cos((90 - bed_slope) / 180 * pi) * 9.81 * 1e-6
              } 
gravity_z = ${fparse
	      - cos(bed_slope / 180 * pi) * 9.81 * 1e-6
              } 

# geometry of the ice slab
length = 10000
width = 2000
thickness = 500

# inlet_amplitude = 1

# ------------------------

[GlobalParams]
  gravity = '${gravity_x} 0. ${gravity_z}'
  # integrate_p_by_parts = true
[]

[Mesh]
  type = GeneratedMesh
  dim = 3
  xmin = 0
  xmax = '${length}'
  ymin = 0
  ymax = '${width}'
  zmin = 0
  zmax = '${thickness}'
  nx = 30
  ny = 15
  nz = 5
  elem_type = HEX20
  
[]


[Variables]
  [velocity]
    order = SECOND
    family = LAGRANGE_VEC
  []
  [p]
    order = FIRST
    family = LAGRANGE
  []
[]

[AuxVariables]
  [vel_x]
    order = SECOND
    family = LAGRANGE
  []
  [vel_y]
    order = SECOND
    family = LAGRANGE
  []
  [vel_z]
    order = SECOND
    family = LAGRANGE
  []
[]

[AuxKernels]
  [vel_x]
    type = VectorVariableComponentAux
    variable = vel_x
    vector_variable = velocity
    component = 'x'
  []
  [vel_y]
    type = VectorVariableComponentAux
    variable = vel_y
    vector_variable = velocity
    component = 'y'
  []
  [vel_z]
    type = VectorVariableComponentAux
    variable = vel_z
    vector_variable = velocity
    component = 'z'
  []
[]

[Kernels]
  [mass]
    type = INSADMass
    variable = p
    u = vel_x
    v = vel_y
    w = vel_z
    pressure = p
  []
  # [momentum_time]
  #   type = INSADMomentumTimeDerivative
  #   variable = velocity
  # []
  [momentum_convection]
    type = INSADMomentumAdvection
    variable = velocity
  []

  # [momentum_viscous]
  #   type = INSADMomentumViscous
  #   variable = velocity
  # []

  [momentum_pressure]
    type = INSADMomentumPressure
    variable = velocity
    pressure = p
    integrate_p_by_parts = true
  []
[]

[BCs]

  [Periodic]
    [up_down]
      primary = left
      secondary = right
      translation = '${length} 0 0'
      variable = 'velocity'
    []
  []

  [no_slip]
    type = ADVectorFunctionDirichletBC
    variable = velocity
    boundary = 'back top bottom'
  []

  # [x_inlet]
  #   type = FunctionDirichletBC
  #   variable = vel_x
  #   boundary = 'left'
  #   function = 'inlet_func'
  # []
[]

[Materials]
  [const]
    type = ADGenericConstantMaterial
    block = 0
    prop_names = 'rho mu' 
    prop_values = '917. 3.'
  []
  # [ice]
  #   type = IceMaterial_u2
  #   block = 0
  #   velocity_x = "vel_x"
  #   velocity_y = "vel_y"
  #   velocity_z = "vel_z"
  #   pressure = "p"
  # []
[]

[Preconditioning]
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type = NEWTON
  []
[]

[Executioner]

  type = Steady
  petsc_options_iname = '-ksp_gmres_restart -pc_type -sub_pc_type -sub_pc_factor_levels'
  petsc_options_value = '300                bjacobi  ilu          4'
  line_search = none
  automatic_scaling = true
  
  # nl_rel_tol = 1e-12
  # nl_max_its = 6
  # l_tol = 1e-6
  # l_max_its = 300

  nl_rel_tol = 1e-4
  nl_max_its = 6
  l_tol = 1e-4
  l_max_its = 300
  
[]

[Outputs]
  [out]
    type = Exodus
  []
[]

[Functions]
  # [inlet_func]
  #   type = ParsedFunction
  #   expression = '((-4 * ((y / ${width}) - 0.5)^2 + 1) * ${inlet_amplitude}) * (z/${thickness})'
  # []
  [weight]
    type = ParsedFunction
    value = '917 * 9.81 * 1e-6 * (${thickness}-z)'
  []
[]

[ICs]
  [pressure_weight]
    type = FunctionIC
    variable = p
    function = weight
  []
  # [velocity_x_IC]
  #   type = ConstantIC
  #   variable = 'vel_x'
  #   value = 1.
  # []
[]
