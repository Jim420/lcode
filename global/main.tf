provider "aws" {
  region = "us-east-1"
  profile = "default"
  shared_credentials_file="/Users/15073/.aws/credentials"
}

module "my_network" {
  environment ="test"
  project= "lims"
  creation_time = timestamp()
  source = "../mod/network"
  vpc_cidr = "10.0.0.0/16"
}

module "security_groups" {
  environment ="test"
  project= "lims"
  creation_time = timestamp()
  source = "../mod/security_groups"
  vpc_id = "${module.my_network.vpc_id}"

}

module "pub_servers" {
  source = "../mod/pub_servers"
  environment ="test"
  project= "lims"
  creation_time = timestamp()
  vpc_id = "${module.my_network.vpc_id}"
  public_subnet_id	="${module.my_network.public_subnets[0]}"
  public_security_group_id ="${module.security_groups.public_sg}"
  private_subnet_id	="${module.my_network.private_subnets[0]}"
  private_security_group_id ="${module.security_groups.private_sg}"
# security_group_ids 	= ["${module.securityGroupModule.sg_22}", "$ {module.securityGroupModule.sg_80}"]
}