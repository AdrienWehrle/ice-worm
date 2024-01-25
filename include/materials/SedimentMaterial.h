#pragma once

#include "Material.h"

/**
 * Material objects inherit from Material and override computeQpProperties.
 *
 * Their job is to declare properties for use by other objects in the
 * calculation such as Kernels and BoundaryConditions.
 */
class SedimentMaterial : public Material
{
public:
  static InputParameters validParams();

  SedimentMaterial(const InputParameters & parameters);

protected:
  /// Necessary override. This is where the values of the properties are computed.
  virtual void computeQpProperties() override;
  
  /// The density of the fluid (rho)
  MaterialProperty<Real> & _density; 

  /// The viscosity of the fluid (mu)
  MaterialProperty<Real> & _viscosity;

  // Velocity gradients
  const VariableGradient & _grad_velocity_x;
  const VariableGradient & _grad_velocity_y;
  const VariableGradient & _grad_velocity_z;
  const VariableValue & _pressure;

  // Effective strain rate
  const Real & _II_eps_min;
  
  // Friction properties
  const Real & _FrictionCoefficient;

  // New density
  const Real & _rho;
  
};
