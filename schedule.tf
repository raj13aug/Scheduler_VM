resource "google_compute_resource_policy" "uptime_schedule" {
  name        = "uptime-schedule"
  description = "Keep instances shut down during nighttime to save money"
  instance_schedule_policy {
    vm_start_schedule {
      schedule = var.uptime_schedule["start"]
    }
    vm_stop_schedule {
      schedule = var.uptime_schedule["stop"]
    }
    time_zone = var.uptime_schedule["time_zone"]
  }
}
