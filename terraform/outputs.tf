output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name}"
}

output "estimated_monthly_cost" {
  description = "Estimated monthly cost of all AWS resources"
  value       = var.run_infracost ? format("$%s", trimspace(try(data.local_file.infracost_monthly_cost[0].content, "0"))) : "Infracost no se ejecutó. Usa -var='run_infracost=true' para activarlo"
}

output "eks_cluster_cost" {
  description = "Costo mensual estimado del clúster EKS"
  value       = var.run_infracost ? format("$%s", trimspace(try(data.local_file.infracost_project_cost[0].content, "0"))) : "Infracost no se ejecutó"
}

output "infracost_command" {
  description = "Comando para ejecutar Infracost manualmente"
  value       = "Para obtener un desglose completo de costos, ejecuta: infracost breakdown --path=."
}