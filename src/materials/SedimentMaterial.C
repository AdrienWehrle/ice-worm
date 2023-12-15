#include "SedimentMaterial.h"

registerMooseObject("MastodonApp", SedimentMaterial);

InputParameters
SedimentMaterial::validParams()
{
  InputParameters params = Material::validParams();

  // Get velocity gradients to compute viscosity based on the effective strain rate
  params.addRequiredCoupledVar("velocity_x", "Velocity in x dimension");
  params.addRequiredCoupledVar("velocity_y", "Velocity in y dimension");
  params.addRequiredCoupledVar("velocity_z", "Velocity in z dimension");
  params.addRequiredCoupledVar("pressure", "Mean stress");
  
  // Solid properties
  // https://tc.copernicus.org/articles/14/261/2020/
  params.addParam<Real>("density", 1850., "Sediment density"); // kgm-3
  params.addParam<Real>("II_eps_min", 6.17e-6, "Finite strain rate parameter"); // a-1
  
  // Friction properties
  params.addParam<Real>("FrictionCoefficient", 1.0, "Sediment friction coefficient");
  
  return params;
}

SedimentMaterial::SedimentMaterial(const InputParameters & parameters)
  : Material(parameters),
  
    // Sediment density
    _rho(getParam<Real>("density")),

    // Friction properties
    _FrictionCoefficient(getParam<Real>("FrictionCoefficient")),

    // Velocity gradients
    _grad_velocity_x(coupledGradient("velocity_x")),
    _grad_velocity_y(coupledGradient("velocity_y")),
    _grad_velocity_z(coupledGradient("velocity_z")),

    // Finite strain rate parameter
    _II_eps_min(getParam<Real>("II_eps_min")),
    
    // Mean stress
    _pressure(coupledValue("pressure")),

    // Sediment properties created by this object
    _viscosity(declareProperty<Real>("mu")),
    _density(declareProperty<Real>("rho"))
{
}

void
SedimentMaterial::computeQpProperties()
{

  // Constant density
  _density[_qp] = _rho;

  // Get current velocity gradients at quadrature point
  Real u_x = _grad_velocity_x[_qp](0);
  Real u_y = _grad_velocity_x[_qp](1);
  Real u_z = _grad_velocity_x[_qp](2);
  
  Real v_x = _grad_velocity_y[_qp](0);
  Real v_y = _grad_velocity_y[_qp](1);
  Real v_z = _grad_velocity_y[_qp](2);

  Real w_x = _grad_velocity_z[_qp](0);
  Real w_y = _grad_velocity_z[_qp](1);
  Real w_z = _grad_velocity_z[_qp](2);

  Real eps_xy = 0.5 * (u_y + v_x);                                                            
  Real eps_xz = 0.5 * (u_z + w_x);
  Real eps_yz = 0.5 * (v_z + w_y); 

  // Get pressure
  Real sig_m = _pressure[_qp];
  
  // Compute effective strain rate
  // Real II_eps = 0.5*( u_x*u_x + v_y*v_y + w_z*w_z +
  // 		      2. * (eps_xy*eps_xy + eps_xz*eps_xz + eps_yz*eps_yz) );

  Real eta = _viscosity[_qp];
  
  Real sxx = 2 * eta * u_x + sig_m;
  Real syy = 2 * eta * v_y + sig_m;
  Real szz = 2 * eta * w_z + sig_m;
  
  Real sxy = eta * (u_y + v_x);
  Real sxz = eta * (u_z + w_x);
  Real syz = eta * (v_z + w_y);
  
  Real sxx_dev = 2 * eta * u_x;
  Real syy_dev = 2 * eta * v_y;
  Real szz_dev = 2 * eta * w_z;
  
  // left term
  Real lt = (sxx+syy) / 2;
  // right term containing root
  Real rt = std::sqrt(pow((sxx-syy) / 2, 2) + sxy*sxy); 
  Real s1 = lt + rt;
  
  // von Mises stress (second invariant)
  Real sig_e = std::sqrt(3./2. * (sxx_dev*sxx_dev + syy_dev*syy_dev + 2*sxy*sxy));
  
  // Compute viscosity
  _viscosity[_qp] = (_FrictionCoefficient * sig_m) / std::abs(sig_e); // Pa s

  if (_t == 864000)
    _viscosity[_qp] = 1e4 * 1e6 * 3.15576e7 / 1e6; // Pa s
  
  std::cout << "VISCOSITY  " <<  _viscosity[_qp] << std::endl;
  
}
