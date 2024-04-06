data "google_project" "this_project" {
  project_id = var.project_id
}

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

resource "google_project_iam_custom_role" "start_stop" {
  role_id     = "instanceScheduler"
  title       = "Instance Scheduler"
  description = "Compute Engine System service account needs to be able to start/stop instances"
  permissions = ["compute.instances.start", "compute.instances.stop"]
}

resource "google_project_iam_member" "member" {
  project = var.project_id
  role    = google_project_iam_custom_role.start_stop.name
  member  = "serviceAccount:service-${data.google_project.this_project.number}@compute-system.iam.gserviceaccount.com"
}

resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
}