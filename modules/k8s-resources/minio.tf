resource "helm_release" "minio-storage" {
    name        = "${local.infra_prefix}-minio-storage"
    
    repository  = "https://charts.min.io/"
    namespace   = "minio-operator"
    chart       = "minio/minio-operator"
    #version     = "1.2.0-rc3"
    verify      = false
}