locals {
  # From which version each CRD is available
  avail_from = {
    alertmanagers       = 0.39
    podmonitors         = 0.39
    prometheuses        = 0.39
    prometheusrules     = 0.39
    servicemonitors     = 0.39
    thanosrulers        = 0.39
    probes              = 0.41
    alertmanagerconfigs = 0.43
    prometheusagents    = 0.64
    scrapeconfigs       = 0.65
  }

  # Version of Prometheus Operator to compare
  ver = tonumber("${element(split(".", var.crds_version), 0)}.${element(split(".", var.crds_version), 1)}")

  # Additional versions of CRDs are avaliable starting from v0.57.0
  full_crd_avail = (local.ver >= 0.57) ? true : false

  # Select URL part depending on CRDs variant
  crd_variant = var.full_crds && local.full_crd_avail ? "-full" : ""

  # Generating list of CRDs to deploy
  crds_list = length(var.crds_list) == 0 ? [for crd, ver in local.avail_from : crd if local.ver >= ver] : var.crds_list

  # Raw YAML manifests from files
  manifests_yaml = { for k, v in data.http.crd_manifest : k => v.response_body }

  # Removing status section
  t = { for k, v in local.manifests_yaml : k =>
    replace(v, "/(?s)\nstatus:\n  acceptedNames:.*/", "\n")
  }

  # Removing creationTimestamp field and converting to HCL
  manifests_hcl = { for k, v in local.t : k =>
    yamldecode(replace(v, "creationTimestamp: null", ""))
  }
}

# Downloading manifests
data "http" "crd_manifest" {
  for_each = local.crds_list

  url = format(var.crd_dl_url, var.crds_version, local.crd_variant, each.value)
  retry {
    attempts = 2
  }
}

# Creating CRDs
resource "kubernetes_manifest" "crd" {
  for_each = local.manifests_hcl

  manifest = each.value
  field_manager {
    force_conflicts = var.force_override_conflicts
  }
}
