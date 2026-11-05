variable "aws_region" {
  description = "AWS region in which this example configuration is planned."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.aws_region)) > 0
    error_message = "aws_region cannot be empty."
  }
}

variable "environment" {
  description = "Environment label used for resource tagging."
  type        = string
  nullable    = false

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be dev, test, or prod."
  }
}

variable "project_name" {
  description = "Logical project identifier used for tagging."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.project_name)) > 0
    error_message = "project_name cannot be empty."
  }
}
