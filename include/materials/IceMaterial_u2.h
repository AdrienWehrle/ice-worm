#pragma once

#include "ADMaterial.h"

/**
 * Material objects inherit from Material and override computeQpProperties.
 *
 * Their job is to declare properties for use by other objects in the
 * calculation such as Kernels and BoundaryConditions.
 */
class IceMaterial_u2 : public ADMaterial
{
public:
  static InputParameters validParams();

  IceMaterial_u2(const InputParameters & parameters);

protected:
  /// Necessary override. This is where the values of the properties are computed.
  virtual void computeQpProperties() override;
  
  /// The density of the fluid (rho)
  ADMaterialProperty<ADReal> & _density; 

  /// The viscosity of the fluid (mu)
  ADMaterialProperty<ADReal> & _viscosity;

  /// Ice damaging
  // MaterialProperty<ADReal> & _damage;
  
  // Velocity gradients
  const VariableGradient & _grad_velocity_x;
  const VariableGradient & _grad_velocity_y;
  const VariableGradient & _grad_velocity_z;
  const VariableValue & _pressure;

  // Glen parameters
  const ADReal & _AGlen;
  const ADReal & _nGlen;
  const ADReal & _rho;
  const ADReal & _II_eps_min;

  // Damage law parameters
  // const ADReal & _r;
  // const ADReal & _B;
  // const ADReal & _sig_th;
  // const ADReal & _alpha;

};
