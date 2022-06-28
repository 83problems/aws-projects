resource "aws_dynamodb_table" "tf_state_lock" {
  name = "tf_state_lock"
  billing_mode = "PAY_PER_REQUEST"
  #read_capacity = 10
  #write_capacity = 10
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Terraform = true
    Name = "tf_state_lock"
  }
}
