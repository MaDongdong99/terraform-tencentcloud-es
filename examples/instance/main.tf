locals {
  name = "tf-test-es"
  availability_zones = ["ap-singapore-2", "ap-singapore-3"]
  vpc_cidr = "10.0.0.0/16"
  subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]

  tags = { create: "terraform"}
}

module "network" {
  source  = "terraform-tencentcloud-modules/vpc/tencentcloud"
  version = "1.1.0"
  vpc_name         = local.name
  vpc_cidr         = "10.0.0.0/16"
  vpc_is_multicast = false
  tags             = local.tags

  availability_zones = local.availability_zones
  subnet_name        = local.name
  subnet_cidrs       = local.subnet_cidrs
  subnet_is_multicast = false
  subnet_tags        = local.tags
}

module "instance" {
  source = "../../modules/instance"

  create_instance = true
  instance_name = local.name
  password = "P@ssword!"

  license_type = "basic"
  basic_security_type = 2

  tags = local.tags

  vpc_id = module.network.vpc_id
  deploy_mode = 1 # Valid values are 0 and 1. 0 is single-AZ deployment, and 1 is multi-AZ deployment

  node_info_list = [
    {
      type      = "dedicatedMaster"
      node_num  = 3
      node_type = "ES.S1.MEDIUM8"
      encrypt   = false
      disk_size = 50
      disk_type = "CLOUD_SSD"
    },{
      type      = "hotData"
      node_num  = 2
      node_type = "ES.S1.MEDIUM8"
      encrypt   = false
      disk_size = 100
      disk_type = "CLOUD_SSD"
    }
  ]

  web_node_type_info = {
    node_num  = 1
    node_type = "ES.S1.MEDIUM4"
  }

  multi_zone_infos = [
    {
      availability_zone = local.availability_zones[0]
      subnet_id = module.network.subnet_id[0]
    },
    {
      availability_zone = local.availability_zones[1]
      subnet_id = module.network.subnet_id[1]
    }
  ]
  cos_backup = {
    is_auto_backup = true
  }

  indices = {
    normal1 = {
      index_type      = "normal"
      index_name      = "test-normal-index"
      index_meta_json = "{\"mappings\":{},\"settings\":{\"index.number_of_replicas\":1,\"index.number_of_shards\":1,\"index.refresh_interval\":\"30s\"}}"
    }
#    auto1 = {
#      index_type      = "auto" # not supported by 7.10.1
#      index_name      = "test-auto-index"
#      index_meta_json = "{\"mappings\":{},\"settings\":{\"index.number_of_replicas\":1,\"index.number_of_shards\":1,\"index.refresh_interval\":\"30s\"}}"
#    }
  }
}


output "all" {
  value = module.instance
}