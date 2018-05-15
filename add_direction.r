new_coords = function(phi, theta, angle, max_dist){

k_1 = 6371000*2*pi / 360
k_2 = k_1*cos(phi)


d_phi = sign(cos(angle)) * sqrt( max_dist^2 / (k_1^2*(1+tan(angle*pi/180)^2 )) )
d_theta = sign(sin(angle)) * abs(k_1/k_2 * tan(angle * pi/180) * d_phi)


theta_new = theta + d_theta 
phi_new = phi + d_phi


return( c(theta_new, phi_new))
}