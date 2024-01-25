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

<<<<<<< HEAD
  // params.addParam<Real>("II_eps_min", 6.17e-6, "Finite strain rate parameter"); // a-1
  params.addParam<Real>("II_eps_min", 5.98e-6, "Finite strain rate parameter"); // a-1
=======
  params.addParam<Real>("II_eps_min", 6.17e-6, "Finite strain rate parameter"); // a-1
>>>>>>> 0cc4ee79c3f712d717b7dd0eb216d6d2283c81c1
  
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

<<<<<<< HEAD
  // Finite strain rate parameter included to avoid infinite viscosity at low stresses
  if (II_eps < _II_eps_min)
    II_eps = _II_eps_min;
  
  // Compute viscosity 
  _viscosity[_qp] = (0.5 * ApGlen * pow(II_eps, -(1.-1./_nGlen)/2.)); // MPay

  // Initial condition on viscosity (~10^12 Pas)
  if (_t <= 0.001)
    _viscosity[_qp] = 0.03;
  
  // Constant density
  _density[_qp] = _rho;
     
=======
  // if (II_eps < _II_eps_min)
  //   II_eps = _II_eps_min;
  
  // Compute viscosity
  
  //_viscosity[_qp] = (0.5 * ApGlen * pow(II_eps, -(1.-1./_nGlen)/2.)) * 1e6; // MPa a
  
  _viscosity[_qp] = (0.5 * ApGlen * pow(II_eps, -(1.-1./_nGlen)/2.)); // MPay

  // if (_t <= 864000) // * 3
  //   _viscosity[_qp] = 10e12;
  
  
  // std::cout << _pressure[_qp] << "  VISCOSITY  " << _viscosity[_qp] << " " << II_eps << std::endl;   // ~ 10^12 Pa s = 0.03 MPa a

  // std::cout << _t << std::endl;
  
  // Constant density
  _density[_qp] = _rho;

   // Compute stresses

   // // renaming for convenience
   // Real eta = _viscosity[_qp];
   // Real sig_m = _pressure[_qp];
   
   // Real sxx = 2 * eta * u_x + sig_m;
   // Real syy = 2 * eta * v_y + sig_m;
   // Real szz = 2 * eta * w_z + sig_m;
   
   // Real sxy = eta * (u_y + v_x);
   // Real sxz = eta * (u_z + w_x);
   // Real syz = eta * (v_z + w_y);
   
   // Real sxx_dev = 2 * eta * u_x;
   // Real syy_dev = 2 * eta * v_y;
   // Real szz_dev = 2 * eta * w_z;

   // // left term
   // Real lt = (sxx+syy) / 2;
   // // right term containing root
   // Real rt = std::sqrt(pow((sxx-syy) / 2, 2) + sxy*sxy); 
   // Real s1 = lt + rt;

   // // von Mises stress (second invariant)
   // Real sig_e = std::sqrt(3./2. * (sxx_dev*sxx_dev + syy_dev*syy_dev + 2*sxy*sxy));

   // // access damage at previous timestep
   // // Real damage_old = damage_old[_qp];
   // Real damage_old = 0.2;
   
   // // stress measure
   // Real Xi = _alpha * sig_e;

   // // compute damage
   // Real damage_dt = _B * std::pow((Xi/(1.-damage_old)) - _sig_thr);
    
   // // update damage  
   // _damage[_qp] += _dt * damage_dt;

   //std::cout << _dt << "   ";
  // std::cout << _viscosity[_qp] << "   ";
  
>>>>>>> 0cc4ee79c3f712d717b7dd0eb216d6d2283c81c1
}
