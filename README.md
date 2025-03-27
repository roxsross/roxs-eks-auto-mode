
![JavaScript](https://img.shields.io/badge/-JavaScript-F7DF1E?style=for-the-badge&logo=JavaScript&logoColor=black)
![Node.js](https://img.shields.io/badge/-Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)
![HTML5](https://img.shields.io/badge/-HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-7B42BC?logo=terraform&logoColor=white&style=for-the-badge)
![VSCode](https://img.shields.io/badge/Visual_Studio_Code-0078D4?style=for-the-badge&logo=visual%20studio%20code&logoColor=white)
![kubernetes](https://img.shields.io/badge/kubernetes-326CE5?logo=kubernetes&logoColor=white&style=for-the-badge)
![Amazon](https://img.shields.io/badge/Amazon_AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Docker](https://img.shields.io/badge/docker-2496ED?logo=docker&logoColor=white&style=for-the-badge)
![python](https://img.shields.io/badge/python-3776AB?logo=python&logoColor=white&style=for-the-badge)
![golang](https://img.shields.io/badge/Go-00ADD8?style=for-the-badge&logo=go&logoColor=white)

---
![](https://github.com/roxsross/roxsross/blob/main/images/roxsross-banner-1.png)



# Configuración de EKS Auto Mode usando Terraform

## Descripción General
[Amazon EKS Auto Mode](https://aws.amazon.com/eks/auto-mode/) simplifica la gestión de clústeres de Kubernetes en AWS. Los beneficios clave incluyen:

🚀 **Gestión Simplificada**
- Aprovisionamiento de clúster con un solo clic
- Computación, almacenamiento y redes automatizados
- Integración perfecta con servicios de AWS

⚡ **Soporte de Cargas de Trabajo**
- Instancias Graviton para un rendimiento óptimo en relación al precio
- Aceleración GPU para cargas de trabajo de ML/AI
- Soporte de arquitectura mixta

🔧 **Características de Infraestructura**
- Autoescalado con Karpenter
- Configuración automatizada de balanceadores de carga
- Optimización de costos mediante la consolidación de nodos

> Este repositorio proporciona un template listo para producción para desplegar varias cargas de trabajo en EKS Auto Mode.

## Requisitos Previos

🛠️ **Herramientas Requeridas**
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

> **Nota**: Este proyecto actualmente proporciona comandos específicos para Linux en los ejemplos. La compatibilidad con Windows se añadirá en futuras actualizaciones.

## Inicio Rápido

1. **Clonar el Repositorio**:
```bash
# Obtener el código
git clone https://github.com/roxsross/aws-eks-auto-mode.git
cd aws-eks-auto-mode
```

2. **Desplegar el Clúster**:
```bash
# Navegar al directorio de Terraform
cd aws-eks-auto-mode/terraform

# Inicializar y aplicar Terraform
terraform init
terraform apply -auto-approve

# Configurar kubectl
$(terraform output -raw configure_kubectl)
```

## Arquitectura

### 🔄 NodePools
EKS Auto Mode aprovecha [Karpenter](https://karpenter.sh/docs/) para la gestión inteligente de nodos:

⚡ **Características de Autoescalado**
- Aprovisionamiento dinámico de nodos
- Escalado consciente de la carga de trabajo
- Optimización de recursos

📦 **NodePools Preconfigurados**
En estos ejemplos configuramos los siguientes Nodepools para usted:
- Nodos Graviton optimizados para ARM64


> 📘 **Nota**: Consulte [Template de NodePool](/nodepool-templates) para configuraciones detalladas.
   ```bash
kubectl apply -f nodepools/graviton-nodepool.yaml
```

### 🌐 Configuración del Balanceador de Carga
EKS Auto Mode automatiza la configuración del balanceador de carga con las mejores prácticas de AWS:

- 🔹 **Application Load Balancer (ALB)**
   - Configuración basada en IngressClass
   - [Documentación de AWS](https://docs.aws.amazon.com/eks/latest/userguide/auto-configure-alb.html)
   - Ejemplo: [2048 Game Ingress](/examples/2048/2048-ingress.yaml)


> **Importante**: Si no se especifican IDs de subred en IngressClassParams, AWS requiere etiquetas específicas en las subredes para el funcionamiento adecuado del balanceador de carga:
> - Subredes públicas: `kubernetes.io/role/elb: "1"`
> - Subredes privadas: `kubernetes.io/role/internal-elb: "1"`
> 
> Nuestro código de Terraform crea automáticamente estas etiquetas necesarias en las subredes, pero es posible que deba agregarlas manualmente si utiliza configuraciones de red personalizadas.

## Ejemplos

🚀 Comience con nuestras cargas de trabajo de ejemplo:

### Aplicaciones ARM64
🎮 [Ejecutando Cargas de Trabajo Graviton](examples/)
- Despliegues ARM64 rentables
- Rendimiento optimizado
- Ejemplo: aplicación del juego 2048
- Ejemplo: aplicación nginx
- Ejemplo: retail-store-sample

### Compatibilidad con Graviton

Para garantizar que las cargas de trabajo se ejecuten en nodos Graviton optimizados para ARM64, puede usar las siguientes configuraciones en sus manifiestos de Kubernetes:

#### Tolerations y NodeSelector
```yaml
tolerations:
   - key: "arm64"
      value: "true"
      effect: "NoSchedule"
nodeSelector:
   kubernetes.io/arch: arm64
```

Estas configuraciones aseguran que los pods se programen exclusivamente en nodos ARM64, maximizando el rendimiento y la eficiencia de costos.

### Estimación de costos con Infracost
Para obtener más información detallada sobre el costo estimado en tu output y hacer que la ejecución de Infracost sea opcional durante el proceso de `terraform apply`, necesitarás modificar tus archivos de Terraform. Te muestro cómo hacerlo:

#### Instrucciones de uso

1. **Sin estimación de costos:**
   ```bash
   terraform apply -auto-approve
   ```

2. **Con estimación de costos:**
   ```bash
   terraform apply -var="run_infracost=true" -auto-approve
   ```

3. **Ver solo la estimación sin aplicar cambios:**
   ```bash
   terraform plan -var="run_infracost=true" 
   ```


## Limpieza

🧹 Siga estos pasos para eliminar todos los recursos:

```bash
# Navegar al directorio de Terraform
cd terraform

# Inicializar y destruir la infraestructura
terraform init
terraform destroy --auto-approve
```

 ### _"DevOps es el arte de la colaboración y la automatización, donde la innovación y la confiabilidad se unen para crear un camino continuo hacia el éxito."_

🔥🔥🔥🔥

<img width="80%" src="https://roxsross-linktree.s3.amazonaws.com/295-full-website-banner-transparent-white.png"> 


### ✉️  &nbsp;Contactos 

Me puedes encontrar en:

[![site](https://img.shields.io/badge/Hashnode-2962FF?style=for-the-badge&logo=hashnode&logoColor=white&link=https://blog.295devops.com) ](https://blog.295devops.com)
[![Blog](https://img.shields.io/badge/dev.to-0A0A0A?style=for-the-badge&logo=devdotto&logoColor=white&link=https://dev.to/roxsross)](https://dev.to/roxsross)
![Twitter](https://img.shields.io/twitter/follow/roxsross?style=for-the-badge)
[![Linkedin Badge](https://img.shields.io/badge/-LinkedIn-blue?style=for-the-badge&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/roxsross/)](https://www.linkedin.com/in/roxsross/)
[![Instagram Badge](https://img.shields.io/badge/-Instagram-purple?style=for-the-badge&logo=instagram&logoColor=white&link=https://www.instagram.com/roxsross)](https://www.instagram.com/roxsross/)
[![Youtube Badge](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white&link=https://www.youtube.com/channel/UCa-FcaB75ZtqWd1YCWW6INQ)](https://www.youtube.com/channel/UCa-FcaB75ZtqWd1YCWW6INQ)


<samp>
"Para entender algo no debes entenderlo sino serlo"
<samp>




