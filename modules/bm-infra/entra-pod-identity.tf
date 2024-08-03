resource "helm_release" "entra-pod-identity" {
  name        = "${local.infra_prefix}-entra-pod-identity"
  
  #repository  = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
  #chart       = "application-gateway-kubernetes-ingress/ingress-azure"
  chart       = "../../k8s/helm/Microsoft-Entra-Pod-Identity/application-gateway-kubernetes-ingress-1.7.5-rc1/helm/ingress-azure/"
  #version     = "1.2.0-rc3"
  verify      = false

  values = [
    "${file("../../k8s/helm/Microsoft-Entra-Pod-Identity/values.yaml")}"
  ]
  
  depends_on = [
    azurerm_kubernetes_cluster.my_aks,
    azurerm_role_assignment.role_aad_contributor,
    azurerm_role_assignment.role_aad_reader
  ]
}