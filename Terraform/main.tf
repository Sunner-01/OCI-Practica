resource "oci_identity_compartment" "practica" {
  compartment_id = var.tenancy_ocid
  name           = "oci-practica-terraform"
  description    = "Infraestructura de practica Terraform"
}
resource "oci_core_vcn" "practica" {
  compartment_id = oci_identity_compartment.practica.id
  cidr_blocks    = ["10.23.0.0/20"]
  display_name   = "vcn-practica"
}
resource "oci_core_internet_gateway" "practica" {
  compartment_id = oci_identity_compartment.practica.id
  vcn_id         = oci_core_vcn.practica.id
  display_name   = "ig-practica"
  enabled        = true
}
resource "oci_core_default_route_table" "practica" {
  compartment_id             = oci_identity_compartment.practica.id
  manage_default_resource_id = oci_core_vcn.practica.default_route_table_id
  display_name               = "rutas-practica"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.practica.id
  }
}
resource "oci_core_security_list" "practica" {
  compartment_id = oci_identity_compartment.practica.id
  vcn_id         = oci_core_vcn.practica.id
  display_name   = "seguridad-practica"
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}
resource "oci_core_subnet" "publica" {
  compartment_id             = oci_identity_compartment.practica.id
  vcn_id                     = oci_core_vcn.practica.id
  cidr_block                 = "10.23.11.0/24"
  display_name               = "subred-publica-practica"
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_default_route_table.practica.id
  security_list_ids          = [oci_core_security_list.practica.id]
}

data "oci_core_images" "ubuntu" {
  compartment_id   = var.tenancy_ocid
  operating_system = "Canonical Ubuntu"
  shape            = var.instance_shape
  state            = "AVAILABLE"
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"
}

resource "oci_core_instance" "practica" {
  compartment_id      = oci_identity_compartment.practica.id
  availability_domain = var.availability_domain
  display_name        = "vm-practica-terraform"
  shape               = var.instance_shape
  shape_config {
    ocpus         = 1
    memory_in_gbs = 6
  }
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images[0].id
  }
  create_vnic_details {
    subnet_id        = oci_core_subnet.publica.id
    assign_public_ip = true
  }
  metadata = {
    ssh_authorized_keys = trimspace(var.ssh_public_key)
  }
}
