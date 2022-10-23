resource "google_monitoring_alert_policy" "service_alert" {
  display_name = "${var.docker_image}-log-metric-alert"
  combiner = "OR"
  conditions {
    display_name = "${var.cf_name}-errors"
    condition_matched_log {
      filter = "resource.type=cloud_run_revision\" resource.labels.service_name=${var.docker_image}\" resource.labels.project_id=${var.project} AND severity>=WARNING"
    }
  }

  alert_strategy {
    auto_close = "604800s"
    notification_rate_limit {
      period = "3600s"
    }
  }
}
