
locals {
  instance_id = var.create_instance ? concat(tencentcloud_elasticsearch_instance.instance.*.id, [""])[0] : var.instance_id
  instance_name = data.tencentcloud_elasticsearch_instances.foo.instance_list[0].instance_name

  elasticsearch_domain = data.tencentcloud_elasticsearch_instances.foo.instance_list[0].elasticsearch_domain
  elasticsearch_port= data.tencentcloud_elasticsearch_instances.foo.instance_list[0].elasticsearch_port
  elasticsearch_vip = data.tencentcloud_elasticsearch_instances.foo.instance_list[0].elasticsearch_vip
  kibana_url = data.tencentcloud_elasticsearch_instances.foo.instance_list[0].kibana_url
}
data "tencentcloud_elasticsearch_instances" "foo" {
  instance_id = local.instance_id
}


resource "tencentcloud_elasticsearch_instance" "instance" {
  count = var.create_instance ? 1 : 0
  instance_name       = var.instance_name
  availability_zone   = var.deploy_mode == 1 ? "-" : var.availability_zone
  version             = var.instance_version # "7.10.1"
  vpc_id              = var.vpc_id
  subnet_id           = var.deploy_mode == 1 ? "-" : var.subnet_id
  password            = var.password
  license_type        = var.license_type # "basic"
  basic_security_type = var.basic_security_type # 2
  deploy_mode         = var.deploy_mode # 1
  charge_type = var.charge_type
  charge_period = var.charge_type == "PREPAID" ? var.charge_period : null
  renew_flag = var.charge_type == "PREPAID" ? var.renew_flag : null


  dynamic "multi_zone_infos" {
    for_each = var.multi_zone_infos
    content {
      availability_zone = multi_zone_infos.value.availability_zone
      subnet_id         = multi_zone_infos.value.subnet_id
    }
  }

  web_node_type_info {
    node_num  = var.web_node_type_info.node_num # 1
    node_type = var.web_node_type_info.node_type # "ES.S1.MEDIUM4"
  }

  dynamic "node_info_list" {
    for_each = var.node_info_list
    content {
      type      = node_info_list.value.type # "dedicatedMaster" . Valid values are hotData, warmData and dedicatedMaster. The default value is 'hotData`.
      node_num  = node_info_list.value.node_num # 3
      node_type = node_info_list.value.node_type # "ES.S1.MEDIUM8"
      encrypt   = node_info_list.value.encrypt # false
      disk_size = try(node_info_list.value.disk_size, 100) # Node disk size. Unit is GB, and default value is 100.
      disk_type = try(node_info_list.value.disk_type, "CLOUD_SSD") # Node disk type. Valid values are CLOUD_SSD, CLOUD_PREMIUM, CLOUD_HSSD, CLOUD_BSSD, CLOUD_BIGDATA and CLOUD_HIGHIO. The default value is CLOUD_SSD.
    }
  }

  dynamic "es_acl" {
    for_each = try(var.es_acl.black_list, null) == null && try(var.es_acl.white_list, null) == null ? [] : [1]
    content {
      black_list = try(var.es_acl.black_list, null)
      white_list = try(var.es_acl.white_list, null)
    }
  }

  dynamic "cos_backup" {
    for_each = var.cos_backup == null ? [] : [1]
    content {
      is_auto_backup = try(var.cos_backup.is_auto_backup ,true)
      backup_time    = try(var.cos_backup.backup_time, "22:00")
    }
  }

  tags = var.tags
}


resource "tencentcloud_elasticsearch_security_group" "security_group" {
  count = var.security_group_ids == null ? 0 : 1
  instance_id = local.instance_id
  security_group_ids = var.security_group_ids
}



resource "tencentcloud_elasticsearch_index" "indices" {
  for_each = var.indices
  instance_id     = local.instance_id
  index_type      = each.value.index_type # "normal"
  index_name      = each.value.index_name # "test-es-index"
  index_meta_json = try(each.value.index_meta_json, null) # "{\"mappings\":{},\"settings\":{\"index.number_of_replicas\":1,\"index.number_of_shards\":1,\"index.refresh_interval\":\"30s\"}}"
}