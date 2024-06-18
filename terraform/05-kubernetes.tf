resource "kubernetes_deployment" "nasa-potd-deployment" {
  metadata {
    name = "nasa-potd-app"
    labels = {
      app = "nasa-potd-app"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "nasa-potd-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "nasa-potd-app"
        }
      }

      spec {
        container {
          image = "891376988072.dkr.ecr.eu-west-2.amazonaws.com/nasa-potd:1.0"
          name  = "nasa-potd"

          port {
            container_port = 3000
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "200Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "400Mi"
            }
          }
        }  
      }
    }
  }
}

resource "kubernetes_service" "nasa-potd-service" {
  metadata {
    name = "nasa-potd-service"
  }

  spec {
    selector = {
      app = "nasa-potd-app"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}
