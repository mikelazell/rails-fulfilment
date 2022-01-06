variable "tf_state_s3_bucket_name" {
  description = "Name of the s3 bucket for TF state storage"
  type        = string
  default     = "s3-tfstate-core-euwest2"
}

variable "tf_state_dynamo_db_table_name" {
  description = "Name of the dynamodb table for TF state storage"
  type        = string
  default     = "core-terraform-state"
}