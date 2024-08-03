resource "helm_release" "entra-pod-identity" {
  name        = "${local.infra_prefix}-entra-pod-identity"
  
  repository  = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
  chart       = "application-gateway-kubernetes-ingress/ingress-azure"
  #chart       = "../../k8s/helm/keda/keda-2.14.2.tgz"
  version     = "1.2.0-rc3"
  verify      = false

  values = [
    "${file("../../k8s/helm/Microsoft-Entra-Pod-Identity/values.yaml")}"
  ]
  
  depends_on = [
    azurerm_kubernetes_cluster.my_aks
  ]
}