#pragma once

#include "Material.h"
#include "RankTwoTensor.h"

/**
 * Material objects inherit from Material and override computeQpProperties.
 *
 * Their job is to declare properties for use by other objects in the
 * calculation such as Kernels and BoundaryConditions.
 */
class CustomDamage : public Material
{
public:
  static InputParameters validParams();

  CustomDamage(const InputParameters & parameters);

protected:
  /// Necessary override. This is where the values of the properties are computed.
  virtual void computeQpProperties() override;
  
  /// Ice damage
  MaterialProperty<Real> & _damage; 

  // Stresses
  libMesh::TypeTensor<double> & _von_mises;
  
  // Damage law parameters
  const Real & _r;
  const Real & _B;
  const Real & _sig_th;
  const Real & _alpha;
  
};
