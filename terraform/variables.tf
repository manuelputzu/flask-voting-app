variable "ami_id" {}
variable "key_name" {}
variable "db_username" {}
variable "db_password" {}
variable "enable_backup_instance" {
  description = "Toggle to enable backup EC2 instance"
  type        = bool
  default     = true
}
variable "my_ip" {
  description = "Your IP address for SSH access"
  type        = string
}
