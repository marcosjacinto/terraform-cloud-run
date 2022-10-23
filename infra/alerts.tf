resource "google_monitoring_notification_channel" "monitoring_email" {
  display_name = "Monitoring E-mail"
  type         = "email"
  labels = {
    email_address = var.monitoring_email
  }
}


resource "google_monitoring_alert_policy" "service_alert" {
  display_name = "${var.docker_image}-log-alert"
  combiner     = "OR"
  conditions {
    display_name = "${var.docker_image}-errors"
    condition_matched_log {
      filter = "resource.type=\"cloud_run_revision\" resource.labels.service_name=\"${var.docker_image}\" resource.labels.project_id=\"${var.project_id}\" AND severity>=WARNING"
    }
  }

  alert_strategy {
    auto_close = "604800s"
    notification_rate_limit {
      period = "3600s"
    }
  }

  notification_channels = [google_monitoring_notification_channel.monitoring_email.name]
}

