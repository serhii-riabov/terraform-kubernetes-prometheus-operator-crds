# Prometheus Operator CRDs Terraform module
Terraform module which creates [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator) CRDs in Kubernetes cluster

## Usage
### Basic
```hcl
module "prometheus_operator_crds" {
  source  = "serhii-riabov/prometheus-operator-crds/kubernetes"

  crds_version = "0.71.2"
}
```

### Advanced
```hcl
module "prometheus_operator_crds" {
  source  = "serhii-riabov/prometheus-operator-crds/kubernetes"

  # Version of CRDs to deploy
  crds_version = "0.71.2"

  # Alternative URL to get source manifests from.
  # %s, %s, %s will be replaced with CRDs version, variant, and CRD name respectively.
  # Example: https://www.example.com/0.71.2/crd-full/monitoring.coreos.com_prometheuses.yaml
  crd_dl_url = "https://www.example.com/%s/crd%s/monitoring.coreos.com_%s.yaml"

  # Deploy only CRDs from the supplied list
  crds_list = [
    "alertmanagerconfigs",
    "alertmanagers",
    "podmonitors",
    "probes",
    "prometheusagents",
    "prometheuses",
    "prometheusrules",
    "scrapeconfigs",
    "servicemonitors",
    "thanosrulers"
  ]

  # Deploy additional API versions of CRDs. E.g. alertmanagerconfigs/v1beta1.
  # Corresponds to the prometheus-operator-crd-full directory at the Prometheus Operator repo
  full_crds = true 

  # Force override fields manager conflicts. May be useful when importing existing CRDs.
  force_override_conflicts = true
}
```
## Importing existing CRDs
It is possible to bring existing Prometheus Operator CRDs under Terraform management to avoid resource recreation. Before proceeding with the import, make sure you are using matching versions of CRDs. Starting with Terraform v1.5.0 and later it is possible to do this in a declarative way. Below is the code example.  
Setting the `force_override_confilicts` variable to `true` will allow overriding conflicts if CRDs were deployed outside of Terraform in the first place.  

```hcl
# Version >= v0.39.0
import {
  to = module.crds.kubernetes_manifest.crd["alertmanagers"]
  id = "apiVersion=apiextensions.k8s.io/v1,kind=CustomResourceDefinition,name=alertmanagers.monitoring.coreos.com"
}

import {
  to = module.crds.kubernetes_manifest.crd["podmonitors"]
  id = "apiVersion=apiextensions.k8s.io/v1,kind=CustomResourceDefinition,name=podmonitors.monitoring.coreos.com"
}

import {
  to = module.crds.kubernetes_manifest.crd["prometheuses"]
  id = "apiVersion=apiextensions.k8s.io/v1,kind=CustomResourceDefinition,name=prometheuses.monitoring.coreos.com"
}

import {
  to = module.crds.kubernetes_manifest.crd["prometheusrules"]
  id = "apiVersion=apiextensions.k8s.io/v1,kind=CustomResourceDefinition,name=prometheusrules.monitoring.coreos.com"
}

import {
  to = module.crds.kubernetes_manifest.crd["servicemonitors"]
  id = "apiVersion=apiextensions.k8s.io/v1,kind=CustomResourceDefinition,name=servicemonitors.monitoring.coreos.com"
}

import {
  to = module.crds.kubernetes_manifest.crd["thanosrulers"]
  id = "apiVersion=apiextensions.k8s.io/v1,kind=CustomResourceDefinition,name=thanosrulers.monitoring.coreos.com"
}

# Version >= v0.41.0
import {
  to = module.crds.kubernetes_manifest.crd["probes"]
  id = "apiVersion=apiextensions.k8s.io/v1,kind=CustomResourceDefinition,name=probes.monitoring.coreos.com"
}

# Version >= v0.43.0
import {
  to = module.crds.kubernetes_manifest.crd["alertmanagerconfigs"]
  id = "apiVersion=apiextensions.k8s.io/v1,kind=CustomResourceDefinition,name=alertmanagerconfigs.monitoring.coreos.com"
}

# Version >= v0.64.0
import {
  to = module.crds.kubernetes_manifest.crd["prometheusagents"]
  id = "apiVersion=apiextensions.k8s.io/v1,kind=CustomResourceDefinition,name=prometheusagents.monitoring.coreos.com"
}

# Version >= v0.65.0
import {
  to = module.crds.kubernetes_manifest.crd["scrapeconfigs"]
  id = "apiVersion=apiextensions.k8s.io/v1,kind=CustomResourceDefinition,name=scrapeconfigs.monitoring.coreos.com"
}
```

## Notes
Kubernetes >=1.17.0
