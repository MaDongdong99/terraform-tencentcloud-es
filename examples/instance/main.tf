module "instance" {
  source = "../../modules/instance"

  create_instance = true
  instance_name = "tf-test-es-instance"
  password = "P@ssword!"

  license_type = "basic"
  basic_security_type = 2

  tags = {
    create: "terraform",
    env: "dev"
  }

  vpc_id = "vpc-j0sqtqk7"
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
      availability_zone = "ap-singapore-2"
      subnet_id = "subnet-p6xvdq6i"
    },
    {
      availability_zone = "ap-singapore-3"
      subnet_id = "subnet-0qoq4mg0"
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