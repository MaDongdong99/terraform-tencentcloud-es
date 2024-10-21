variable "create_instance" {
  type = bool
  default = true
}
variable "instance_id" {
  type = string
  default = ""
}

variable "instance_name" {
  default = ""
  type = string

}
variable "deploy_mode" {
  default = 0
  type = number
  description = "Valid values are 0 and 1. 0 is single-AZ deployment, and 1 is multi-AZ deployment. Default value is 0."
}

variable "availability_zone" {
  default = ""
  type = string
  description = "Availability zone. When create multi-az es, this parameter must be omitted or -."
}

variable "instance_version" {
  default = "7.10.1"
  type = string
  description = " Version of the instance. Valid values are 5.6.4, 6.4.3, 6.8.2, 7.5.1 and 7.10.1."
}
variable "vpc_id" {
  description = "The ID of a VPC network."
  type = string
}
variable "subnet_id" {
  default = ""
  type = string
  description = "The ID of a VPC subnetwork. When create multi-az es, this parameter must be omitted or -."
}
variable "password" {
  default = ""
  type = string
  description = "Password to an instance, the password needs to be 8 to 16 characters, including at least two items ([a-z,A-Z], [0-9] and [-!@#$%&^*+=_:;,.?] special symbols."
}
variable "basic_security_type" {
  default = 2
  type = number
  description = "Whether to enable X-Pack security authentication in Basic Edition 6.8 and above. Valid values are 1 and 2. 1 is disabled, 2 is enabled, and default value is 1. Notice: this parameter is only take effect on basic license."
}
variable "multi_zone_infos" {
  default = []
  type = any
  description = "Details of AZs in multi-AZ deployment mode (which is required when deploy_mode is 1"
}
variable "web_node_type_info" {
  default = {}
  type = any
  description = "Visual node configuration."
}
variable "node_info_list" {
  default = []
  type = any
  description = " Node information list, which is used to describe the specification information of various types of nodes in the cluster, such as node type, node quantity, node specification, disk type, and disk size."
}
variable "es_acl" {
  default = {}
  type = any
  description = "Kibana Access Control Configuration"
}
variable "tags" {
  default = {}
  type = map(string)
  description = "tags"
}

variable "license_type" {
  type = string
  description = "License type. Valid values are oss, basic and platinum. The default value is platinum."
  default = "basic"
}

variable "cos_backup" {
  default = null
  type = any
  description = "COS automatic backup information."
}

variable "security_group_ids" {
  default = null
  type = list(string)
  description = "security group ids bind to instance"
}

variable "charge_type" {
  default = "POSTPAID_BY_HOUR"
  type = string
  description = "The charge type of instance. Valid values are PREPAID and POSTPAID_BY_HOUR."
}
variable "charge_period" {
  default = 1
  type = number
  description = "The tenancy of the prepaid instance, and uint is month. "
}
variable "renew_flag" {
  default = "RENEW_FLAG_AUTO"
  type = string
  description = "When enabled, the instance will be renew automatically when it reach the end of the prepaid tenancy. Valid values are RENEW_FLAG_AUTO and RENEW_FLAG_MANUAL"
}


# indices
variable "indices" {
  default = {}
  type = any
  description = "see `tencentcloud_elasticsearch_index`"
}