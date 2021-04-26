locals{
  project = "web-infrastructure"
  name = "${local.project}-nginx"

  tags = {
    Project = "local.project"

  }
}

