variable "version" {
  type = string
  default = "latest"
}

source "docker" "gitlab_runner" {
  image = "public.ecr.aws/lts/ubuntu:focal"
  commit = true
  changes = [
    "USER gitlab",
    "WORKDIR /home/gitlab",
    "EXPOSE 22",
    "LABEL version=${var.version}",
    "ENTRYPOINT gitlab-runner"
  ]
  run_command = [
    "-d", "-i", "-t",
    "--entrypoint=/bin/bash",
    "--name=gitlab-runner-test",
    "{{ .Image }}"
  ]
}

build {
  name = "runner"
  sources = ["source.docker.gitlab_runner"]
}
