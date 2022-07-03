data "local_file" "tf_state_source" {
  filename = "./backend.tpl"
}

data "template_file" "tf_state_template" {
  template = data.local_file.tf_state_source.content

  vars = {
    BUCKET = aws_s3_bucket.tf_bucket.bucket
    KEY    = var.s3_backend_key
    REGION = var.region
  }
}

resource "local_file" "tf_state_file" {
  content  = data.template_file.tf_state_template.rendered
  filename = "backend.tf"
}
