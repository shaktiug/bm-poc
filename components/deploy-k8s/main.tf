

module "deploy-k8s" {
    source = "../../modules/k8s-resources"
    env = var.env
    values = var.values
}