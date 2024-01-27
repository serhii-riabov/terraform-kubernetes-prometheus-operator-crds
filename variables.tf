variable "crds_version" {
  description = "Version of the Prometheus Operator release, e.g. 0.71.2"
  type        = string

  validation {
    condition = tonumber(
      "${element(split(".", var.crds_version), 0)}.${element(split(".", var.crds_version), 1)}"
    ) >= 0.39
    error_message = "Only Prometheus Operator versions >= 0.39.0 are supported."
  }
}

variable "crd_dl_url" {
  description = "Template string of the URL to download CRDs"
  type        = string
  default     = "https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v%s/example/prometheus-operator-crd%s/monitoring.coreos.com_%s.yaml"
}

variable "crds_list" {
  description = "List of CRDs to deploy. If not set, all CRDs will be deployed."
  type        = set(string)
  default     = []
}

variable "full_crds" {
  description = "Whether to deploy full versions of CRDs. Has effect starting from version >=0.57.0."
  type        = bool
  default     = false
}

variable "force_override_conflicts" {
  description = "Force override fields manager conflicts. May be useful when importing existing CRDs."
  type        = bool
  default     = false
}
