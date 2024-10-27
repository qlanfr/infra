provider "kubernetes" {
  config_path = "~/.kube/config"
}

#sql
resource "kubernetes_deployment" "mysql" {
  metadata {
    name = "mysql"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mysql"
      }
    }
    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }
      spec {
        container {
          image = "mysql:5.7"
          name  = "mysql-container"
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "password"
          }
          port {
            container_port = 3306
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mysql_service" {
  metadata {
    name = "mysql-service"
  }
  spec {
    selector = {
      app = "mysql"
    }
    port {
      port        = 3306
      target_port = 3306
    }
    type = "ClusterIP"
  }
}

#fast
resource "kubernetes_deployment" "fastapi_server" {
  metadata {
    name = "fastapi-server"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "fastapi-server"
      }
    }
    template {
      metadata {
        labels = {
          app = "fastapi-server"
        }
      }
      spec {
        container {
          image = "my-fastapi-app:latest"  
          name  = "fastapi-container"
	  image_pull_policy = "Never"
          env {
            name  = "MYSQL_HOST"
            value = "mysql-service"
          }
          env {
            name  = "MYSQL_USER"
            value = "root"
          }
          env {
            name  = "MYSQL_PASSWORD"
            value = "password"
          }
          env {
            name  = "MYSQL_DB"
            value = "pro-db"
          }
          port {
            container_port = 8000
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "fastapi_service" {
  metadata {
    name = "fastapi-service"
  }
  spec {
    selector = {
      app = "fastapi-server"
    }
    port {
      port        = 80
      target_port = 8000
    }
    type = "NodePort"
  }
}
