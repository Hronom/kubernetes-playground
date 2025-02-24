variable "environment" {
  type = string
}

variable "team_id" {
  type = string
}

variable "istio_istiod_min_replica_count" {
  type = number
}

variable "istio_istiod_max_replica_count" {
  type = number
}

variable "istio_gateway_ingress_main_min_replica_count" {
  type = number
}

variable "istio_gateway_ingress_main_max_replica_count" {
  type = number
}
