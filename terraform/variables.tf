variable "db_username" {
  default = "root"
}

variable "db_password" {
  default = "ThW-KPK-b8r-8r3-Aws"
}

variable "ami_id" {
  description = "Amazon Machine Image ID"
  default     = "ami-02b7d5b1e55a7b5f1" # Amazon Linux 2023 AMI (freeTier)
}

variable "key_name" {
  description = "EC2 Key Pair name"
  default     = "my-ec2-key"
}
