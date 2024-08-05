

module "deploy-k8s" {
    source = "../../modules/k8s-resources"
    env = var.env
    values = var.values
}


module "grafana_prometheus_monitoring" {  #prometheus-grafana basic monitoring
    source = "git::https://github.com/DNXLabs/terraform-aws-eks-grafana-prometheus.git"

    enabled = true
}