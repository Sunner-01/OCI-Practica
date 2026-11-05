output "compartment_ocid" {
  description = "OCID del compartimento creado"
  value       = oci_identity_compartment.practica.id
}
output "instance_ocid" {
  description = "OCID de la VM creada"
  value       = oci_core_instance.practica.id
}
output "public_ip" {
  description = "IP publica de la VM"
  value       = oci_core_instance.practica.public_ip
}
