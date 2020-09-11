locals {
  region = join("-", slice(split("-", var.zone), 0, 2))
}
