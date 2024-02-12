# This input file tests outflow boundary conditions for the incompressible NS equations.

# ------------------------ 

# slope of the bottom boundary (in degrees)
bed_slope = 2

# change coordinate system to add a slope
gravity_x = ${fparse
  	      cos((90 - bed_slope) / 180 * pi) * 9.81 * 1e-6
              } 
gravity_z = ${fparse
	      - cos(bed_slope / 180 * pi) * 9.81 * 1e-6
              } 

width = 2
inlet_amplitude = 1
# ------------------------

[GlobalParams]
  gravity = '${gravity_x} 0. ${gravity_z}'
  # integrate_p_by_parts = true
[]

[Mesh]
  type = GeneratedMesh
  dim = 3
  xmin = 0
  xmax = 6
  ymin = 0
  ymax = '${width}'
  zmin = 0
  zmax = 1
  nx = 30
  ny = 10
  nz = 5
  elem_type = HEX20
  
[]


[Variables]
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
  [p]
    order = FIRST
    family = LAGRANGE
  []
[]

[Kernels]
  [mass]
    type = INSMass
    variable = p
    u = vel_x
    v = vel_y
    w = vel_z
    pressure = p
  []
  [x_momentum_space]
    type = INSMomentumLaplaceForm
    variable = vel_x
    u = vel_x
    v = vel_y
    w = vel_z
    pressure = p
    component = 0
  []
  [y_momentum_space]
    type = INSMomentumLaplaceForm
    variable = vel_y
    u = vel_x
    v = vel_y
    w = vel_z
    pressure = p
    component = 1
  []
  [z_momentum_space]
    type = INSMomentumLaplaceForm
    variable = vel_z
    u = vel_x
    v = vel_y
    w = vel_z
    pressure = p
    component = 2
  []
[]

[BCs]

  [Periodic]
    [up_down]
      primary = left
      secondary = right
      translation = '6 0 0'
      variable = 'vel_x vel_y vel_z'
    []
  []
  [x_no_slip]
    type = DirichletBC
    variable = vel_x
    boundary = 'back top bottom'
    value = 0.0
  []
  [y_no_slip]
    type = DirichletBC
    variable = vel_y
    boundary = 'back top bottom'
    value = 0.0
  []
  [z_no_slip]
    type = DirichletBC
    variable = vel_z
    boundary = 'back top bottom'
    value = 0.0
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
    type = GenericConstantMaterial
    block = 0
    prop_names = 'rho mu'
    # prop_values = '917. 1e-3'
    prop_values = '917. 0.3'
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
  type = Steady
  petsc_options_iname = '-ksp_gmres_restart -pc_type -sub_pc_type -sub_pc_factor_levels'
  petsc_options_value = '300                bjacobi  ilu          4'
  line_search = none
  nl_rel_tol = 1e-12
  nl_max_its = 6
  l_tol = 1e-6
  l_max_its = 300
[]

[Outputs]
  [out]
    type = Exodus
  []
[]

[Functions]
  [inlet_func]
    type = ParsedFunction
    expression = '((-4 * ((y / ${width}) - 0.5)^2 + 1) * ${inlet_amplitude}) * z'
  []
[]
