#include "IceMaterial_u2.h"

registerMooseObject("MastodonApp", IceMaterial_u2);

InputParameters
IceMaterial_u2::validParams()
{
  InputParameters params = Material::validParams();

  // Get velocity gradients to compute viscosity based on the effective strain rate
  params.addRequiredCoupledVar("velocity_x", "Velocity in x dimension");
  params.addRequiredCoupledVar("velocity_y", "Velocity in y dimension");
  params.addRequiredCoupledVar("velocity_z", "Velocity in z dimension");
  params.addRequiredCoupledVar("pressure", "Mean stress");
  
  // Fluid properties
  params.addParam<Real>("AGlen", 75., "Fluidity parameter in Glen's flow law"); // MPa-3a-1

  params.addParam<Real>("nGlen", 3.,"Glen exponent"); // 
  params.addParam<Real>("density", 917., "Ice density"); // kgm-3
  // params.addParam<Real>("damage", 0., "Ice damaging");

  params.addParam<Real>("II_eps_min", 5.98e-6, "Finite strain rate parameter"); // a-1
  
  // Damage law parameters
  params.addParam<Real>("r", 0.43, "Damage law exponent");
  params.addParam<Real>("B", 1., "Damage rate");  
  params.addParam<Real>("sig_th", 0., "Damage threshold stress");
  params.addParam<Real>("alpha", 1., "Linear combination parameter on von Mises stresses");
  
  return params;
}

IceMaterial_u2::IceMaterial_u2(const InputParameters & parameters)
  : Material(parameters),

    // Glen parameters
    _AGlen(getParam<Real>("AGlen")),
    _nGlen(getParam<Real>("nGlen")),
    
    // Ice density
    _rho(getParam<Real>("density")),
    
    // Velocity gradients
    _grad_velocity_x(coupledGradient("velocity_x")),
    _grad_velocity_y(coupledGradient("velocity_y")),
    _grad_velocity_z(coupledGradient("velocity_z")),

    _II_eps_min(getParam<Real>("II_eps_min")),

    // Mean stress
    _pressure(coupledValue("pressure")),

    // Damage law parameters
    // _r(getParam<Real>("r")),
    // _B(getParam<Real>("B")),
    // _sig_th(getParam<Real>("sig_th")),
    // _alpha(getParam<Real>("alpha")),

    // Ice properties created by this object
    _viscosity(declareProperty<Real>("mu")),
    _density(declareProperty<Real>("rho"))
    // _damage(declareProperty<Real>("damage"))
{
}

void
IceMaterial_u2::computeQpProperties()
{

  // Wrap term with Glen's fluidity parameter for clarity
  Real ApGlen  = pow(_AGlen, -1./ _nGlen);

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

  // Compute effective strain rate (3D)
  Real II_eps = 0.5*( u_x*u_x + v_y*v_y + w_z*w_z +
		      2. * (eps_xy*eps_xy + eps_xz*eps_xz + eps_yz*eps_yz) );

  // Finite strain rate parameter included to avoid infinite viscosity at low stresses
  if (II_eps < _II_eps_min)
    II_eps = _II_eps_min;
  
  // Compute viscosity 
  _viscosity[_qp] = (0.5 * ApGlen * pow(II_eps, -(1.-1./_nGlen)/2.)); // MPa a

  // // Initial condition on viscosity (~10^12 Pas)
  if (_t <= _dt)
    _viscosity[_qp] = 0.317; //  MPa a = ~ 10e12 Pa s

  if (_t > _dt)
      std::cout << _viscosity[_qp] << "  " << _pressure[_qp] << "  " << II_eps << std::endl;
  
  // Constant density
  _density[_qp] = _rho;
     
}
