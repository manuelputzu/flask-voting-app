variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "ami_id" {
  description = "Amazon Machine Image ID"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
}
