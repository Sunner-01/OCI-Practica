variable "tenancy_ocid" {
  description = "OCID de la tenencia de OCI. Se usará como compartimento padre."
  type        = string
}

variable "region" {
  description = "Región de OCI donde se crearán los recursos."
  type        = string
  default     = "sa-saopaulo-1"
}

variable "ssh_public_key" {
  description = "Contenido de la clave pública SSH para acceder a la VM."
  type        = string
  sensitive   = true
}

variable "instance_shape" {
  description = "Shape de la máquina virtual."
  type        = string
  default     = "VM.Standard.E5.Flex"
}
variable "availability_domain" {
  description = "Dominio de disponibilidad de la region elegida"
  type        = string
}
