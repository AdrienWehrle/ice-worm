#pragma once

#include "Material.h"

/**
 * Material objects inherit from Material and override computeQpProperties.
 *
 * Their job is to declare properties for use by other objects in the
 * calculation such as Kernels and BoundaryConditions.
 */
class IceMaterial_u2 : public Material
{
public:
  static InputParameters validParams();

  IceMaterial_u2(const InputParameters & parameters);

protected:
  /// Necessary override. This is where the values of the properties are computed.
  virtual void computeQpProperties() override;
  
  /// The density of the fluid (rho)
  MaterialProperty<Real> & _density; 

  /// The viscosity of the fluid (mu)
  MaterialProperty<Real> & _viscosity;

  /// Ice damaging
  // MaterialProperty<Real> & _damage;
  
  // Velocity gradients
  const VariableGradient & _grad_velocity_x;
  const VariableGradient & _grad_velocity_y;
  const VariableGradient & _grad_velocity_z;
  const VariableValue & _pressure;

  // Glen parameters
  const Real & _AGlen;
  const Real & _nGlen;
  const Real & _rho;
  const Real & _II_eps_min;

  // Damage law parameters
  // const Real & _r;
  // const Real & _B;
  // const Real & _sig_th;
  // const Real & _alpha;

};
