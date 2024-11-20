provider "kubernetes" {
  host                   = var.kubernetes_host
  cluster_ca_certificate = base64decode(var.kubernetes_ca_certificate)
  token                  = var.kubernetes_token
}

resource "kubernetes_deployment" "blue" {
  metadata {
    name = "blue-app"
  }
  spec {
   t replicas = 3
    selector {
      match_labels = {
        app = "blue"
      }
    }
    template {
      metadata {
        labels = {
          app = "blue"
        }
      }
      spec {
        container {
          name  = "blue-app-container"
          image = "my-app:blue-version"
          ports {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "green" {
  metadata {
    name = "green-app"
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "green"
      }
    }
    template {
      metadata {
        labels = {
          app = "green"
        }
      }
      spec {
        container {
          name  = "green-app-container"
          image = "my-app:green-version"
          ports {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "loadbalancer" {
  metadata {
    name = "my-app-lb"
  }
  spec {
    selector = {
      app = "blue"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}