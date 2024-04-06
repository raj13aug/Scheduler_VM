variable "name" {
  description = "Name of a Google Cloud Project"
  default     = "cloudroot7-demo"
}

variable "id" {
  description = "ID of a Google Cloud Project. Can be omitted and will be generated automatically"
  default     = "mytesting-400910"
}

variable "project_id" {
  type        = string
  description = "project id"
  default     = "mytesting-400910"
}

variable "region" {
  type        = string
  description = "Region of policy "
  default     = "us-central1"
}



variable "uptime_schedule" {
  type        = map(string)
  description = "Key/value pairs to define the uptime schedule: start and stop are cron expressions, time_zone is an IANA time zone name"
  default = {
    start     = "0 6 * * *"
    stop      = "0 0 * * *"
    time_zone = "Asia/Kolkata"
  }
}
