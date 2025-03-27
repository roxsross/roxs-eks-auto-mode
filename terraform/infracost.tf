resource "null_resource" "infracost_output" {
  count = var.run_infracost ? 1 : 0
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<-EOT
      # Verificar si Infracost está instalado
      if ! command -v infracost &> /dev/null; then
        echo "Infracost no está instalado. Instalándolo..."
        curl -fsSL https://get.infracost.io | sh
      fi
      
      # Ejecutar Infracost y guardar el resultado en un archivo
      infracost breakdown --path=. --format=json --out-file=infracost-output.json
      
      # Extraer información más detallada y guardarla en archivos separados
      cat infracost-output.json | jq -r '.totalMonthlyCost' > infracost-monthly-cost.txt
      cat infracost-output.json | jq -r '.projects[0].breakdown.resources' > infracost-resources.json
      cat infracost-output.json | jq -r '.projects[0].breakdown.totalMonthlyCost' > infracost-project-cost.txt
      
      # Generar un informe HTML más detallado
      infracost output --path infracost-output.json --format html --out-file infracost-report.html
      echo "Informe detallado de costos generado en: $(pwd)/infracost-report.html"
    EOT
  }

  depends_on = [
    module.eks
  ]
}

# Leer los archivos de costo generados por Infracost
data "local_file" "infracost_monthly_cost" {
  count    = var.run_infracost ? 1 : 0
  filename = "${path.module}/infracost-monthly-cost.txt"
  depends_on = [null_resource.infracost_output]
}

data "local_file" "infracost_resources" {
  count    = var.run_infracost ? 1 : 0
  filename = "${path.module}/infracost-resources.json"
  depends_on = [null_resource.infracost_output]
}

data "local_file" "infracost_project_cost" {
  count    = var.run_infracost ? 1 : 0
  filename = "${path.module}/infracost-project-cost.txt"
  depends_on = [null_resource.infracost_output]
}
