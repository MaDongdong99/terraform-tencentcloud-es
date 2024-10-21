# tencentcloud ElasticSearch



## usage

```terraform

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
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >1.78.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >1.78.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tencentcloud_elasticsearch_index.indices](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/elasticsearch_index) | resource |
| [tencentcloud_elasticsearch_instance.instance](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/elasticsearch_instance) | resource |
| [tencentcloud_elasticsearch_security_group.security_group](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/elasticsearch_security_group) | resource |
| [tencentcloud_elasticsearch_instances.foo](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/data-sources/elasticsearch_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Availability zone. When create multi-az es, this parameter must be omitted or -. | `string` | `""` | no |
| <a name="input_basic_security_type"></a> [basic\_security\_type](#input\_basic\_security\_type) | Whether to enable X-Pack security authentication in Basic Edition 6.8 and above. Valid values are 1 and 2. 1 is disabled, 2 is enabled, and default value is 1. Notice: this parameter is only take effect on basic license. | `number` | `2` | no |
| <a name="input_charge_period"></a> [charge\_period](#input\_charge\_period) | The tenancy of the prepaid instance, and uint is month. | `number` | `1` | no |
| <a name="input_charge_type"></a> [charge\_type](#input\_charge\_type) | The charge type of instance. Valid values are PREPAID and POSTPAID\_BY\_HOUR. | `string` | `"POSTPAID_BY_HOUR"` | no |
| <a name="input_cos_backup"></a> [cos\_backup](#input\_cos\_backup) | COS automatic backup information. | `any` | `null` | no |
| <a name="input_create_instance"></a> [create\_instance](#input\_create\_instance) | n/a | `bool` | `true` | no |
| <a name="input_deploy_mode"></a> [deploy\_mode](#input\_deploy\_mode) | Valid values are 0 and 1. 0 is single-AZ deployment, and 1 is multi-AZ deployment. Default value is 0. | `number` | `0` | no |
| <a name="input_es_acl"></a> [es\_acl](#input\_es\_acl) | Kibana Access Control Configuration | `any` | `{}` | no |
| <a name="input_indices"></a> [indices](#input\_indices) | see `tencentcloud_elasticsearch_index` | `any` | `{}` | no |
| <a name="input_instance_id"></a> [instance\_id](#input\_instance\_id) | n/a | `string` | `""` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | n/a | `string` | `""` | no |
| <a name="input_instance_version"></a> [instance\_version](#input\_instance\_version) | Version of the instance. Valid values are 5.6.4, 6.4.3, 6.8.2, 7.5.1 and 7.10.1. | `string` | `"7.10.1"` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | License type. Valid values are oss, basic and platinum. The default value is platinum. | `string` | `"basic"` | no |
| <a name="input_multi_zone_infos"></a> [multi\_zone\_infos](#input\_multi\_zone\_infos) | Details of AZs in multi-AZ deployment mode (which is required when deploy\_mode is 1 | `any` | `[]` | no |
| <a name="input_node_info_list"></a> [node\_info\_list](#input\_node\_info\_list) | Node information list, which is used to describe the specification information of various types of nodes in the cluster, such as node type, node quantity, node specification, disk type, and disk size. | `any` | `[]` | no |
| <a name="input_password"></a> [password](#input\_password) | Password to an instance, the password needs to be 8 to 16 characters, including at least two items ([a-z,A-Z], [0-9] and [-!@#$%&^*+=\_:;,.?] special symbols. | `string` | `""` | no |
| <a name="input_renew_flag"></a> [renew\_flag](#input\_renew\_flag) | When enabled, the instance will be renew automatically when it reach the end of the prepaid tenancy. Valid values are RENEW\_FLAG\_AUTO and RENEW\_FLAG\_MANUAL | `string` | `"RENEW_FLAG_AUTO"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | security group ids bind to instance | `list(string)` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of a VPC subnetwork. When create multi-az es, this parameter must be omitted or -. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of a VPC network. | `string` | n/a | yes |
| <a name="input_web_node_type_info"></a> [web\_node\_type\_info](#input\_web\_node\_type\_info) | Visual node configuration. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_elasticsearch_domain"></a> [elasticsearch\_domain](#output\_elasticsearch\_domain) | n/a |
| <a name="output_elasticsearch_port"></a> [elasticsearch\_port](#output\_elasticsearch\_port) | n/a |
| <a name="output_elasticsearch_vip"></a> [elasticsearch\_vip](#output\_elasticsearch\_vip) | n/a |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | n/a |
| <a name="output_instance_name"></a> [instance\_name](#output\_instance\_name) | n/a |
| <a name="output_kibana_url"></a> [kibana\_url](#output\_kibana\_url) | n/a |
