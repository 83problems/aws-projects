terraform {
  backend "s3" {
    bucket = "${BUCKET}"
    key    = "${KEY}"
    region = "${REGION}"
    encrypt = true
    dynamodb_table = "tf_state_lock"
  }
}
