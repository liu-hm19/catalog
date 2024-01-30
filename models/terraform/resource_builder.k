import models.terraform.resource
import models.terraform.palworld

schema ResourceBuilder[input: palworld.PalWorldServer]: 
    alicloudVPC: resource.Resource = {
        id: "aliyun:alicloud:alicloud_vpc:" + input.name
        type: "Terraform"
        attributes: {
            vpc_name = input.name
            cidr_block = "172.16.0.0/12"
        }
        extensions: {
            provider: "registry.terraform.io/aliyun/alicloud/1.209.1"
            providerMeta: {
                region: "cn-hangzhou"
            }
            resourceType: "alicloud_vpc"
        }
    }

    alicloudVSwitch: resource.Resource = {
        id: "aliyun:alicloud:alicloud_vswitch:" + input.name
        type: "Terraform"
        attributes: {
            vpc_id = "$kusion_path.aliyun:alicloud:alicloud_vpc:" + input.name + ".id"
            vswitch_name = input.name
            cidr_block = "172.16.0.0/24"
            zone_id = "cn-hangzhou-h"
        }
        extensions: {
            provider: "registry.terraform.io/aliyun/alicloud/1.209.1"
            providerMeta: {
                region: "cn-hangzhou"
            }
            resourceType: "alicloud_vswitch"
        }
    }

    alicloudSecurityGroup: resource.Resource = {
        id: "aliyun:alicloud:alicloud_security_group:" + input.name
        type: "Terraform"
        attributes: {
            name = input.name
            vpc_id = "$kusion_path.aliyun:alicloud:alicloud_vpc:" + input.name + ".id"
        }
        extensions: {
            provider: "registry.terraform.io/aliyun/alicloud/1.209.1"
            providerMeta: {
                region: "cn-hangzhou"
            }
            resourceType: "alicloud_security_group"
        }
    }

    alicloudSecurityGroupRule: resource.Resource = {
        id: "aliyun:alicloud:alicloud_security_group_rule:" + input.name
        type: "Terraform"
        attributes: {
            type = "ingress"
            security_group_id = "$kusion_path.aliyun:alicloud:alicloud_security_group:" + input.name + ".id"
            ip_protocol = "udp"
            policy = "accept"
            port_range = "8211/8211"
            priority = 1
            cidr_ip = "0.0.0.0/0"
        }
        extensions: {
            provider: "registry.terraform.io/aliyun/alicloud/1.209.1"
            providerMeta: {
                region: "cn-hangzhou"
            }
            resourceType: "alicloud_security_group_rule"
        }
    }

    alicloudSecurityGroupRuleSSH: resource.Resource = {
        id: "aliyun:alicloud:alicloud_security_group_rule:" + input.name + "-ssh"
        type: "Terraform"
        attributes: {
            type = "ingress"
            security_group_id = "$kusion_path.aliyun:alicloud:alicloud_security_group:" + input.name + ".id"
            ip_protocol = "tcp"
            policy = "accept"
            port_range = "22/22"
            priority = 1
            cidr_ip = "0.0.0.0/0"
        }
        extensions: {
            provider: "registry.terraform.io/aliyun/alicloud/1.209.1"
            providerMeta: {
                region: "cn-hangzhou"
            }
            resourceType: "alicloud_security_group_rule"
        }
    }

    alicloudECSInstance: resource.Resource = {
        id: "aliyun:alicloud:alicloud_instance:" + input.name
        type: "Terraform"
        attributes: {
            vswitch_id = "$kusion_path.aliyun:alicloud:alicloud_vswitch:" + input.name + ".id"
            image_id = "ubuntu_20_04_x64_20G_alibase_20231221.vhd"
            if input.size == "small": 
                instance_type = "ecs.u1-c1m2.large" # ¥0.70/h
            elif input.size == "medium": 
                instance_type = "ecs.c7.xlarge"     # ¥1.20/h
            else:
                instance_type = "ecs.c7.2xlarge"    # ¥2.0/h
            system_disk_category = "cloud_essd"
            instance_name = input.name
            internet_charge_type = "PayByTraffic"
            internet_max_bandwidth_out = input.bandwidth
            security_groups = [
                "$kusion_path.aliyun:alicloud:alicloud_security_group:" + input.name + ".id"
            ]
        }
        extensions: {
            provider: "registry.terraform.io/aliyun/alicloud/1.209.1"
            providerMeta: {
                region: "cn-hangzhou"
            }
            resourceType: "alicloud_instance"
        }
    }

    alicloudECSCommand: resource.Resource = {
        id: "aliyun:alicloud:alicloud_ecs_command:" + input.name
        type: "Terraform"
        attributes: {
            name = input.name
            command_content = "YXB0LWdldCB1cGRhdGUKYXB0LWdldCAteSBpbnN0YWxsIGFwdC10cmFuc3BvcnQtaHR0cHMgY2EtY2VydGlmaWNhdGVzIGN1cmwgc29mdHdhcmUtcHJvcGVydGllcy1jb21tb24KY3VybCAtZnNTTCBodHRwOi8vbWlycm9ycy5jbG91ZC5hbGl5dW5jcy5jb20vZG9ja2VyLWNlL2xpbnV4L3VidW50dS9ncGcgfCBhcHQta2V5IGFkZCAtCmFkZC1hcHQtcmVwb3NpdG9yeSAteSAiZGViIFthcmNoPWFtZDY0XSBodHRwOi8vbWlycm9ycy5jbG91ZC5hbGl5dW5jcy5jb20vZG9ja2VyLWNlL2xpbnV4L3VidW50dSAkKGxzYl9yZWxlYXNlIC1jcykgc3RhYmxlIgphcHQtZ2V0IC15IGluc3RhbGwgZG9ja2VyLWNlCnN5c3RlbWN0bCBzdGFydCBkb2NrZXIKc3lzdGVtY3RsIGVuYWJsZSBkb2NrZXIKUkVHSU9OPSQoY3VybCAtcyAxMDAuMTAwLjEwMC4yMDAvbGF0ZXN0L21ldGEtZGF0YS9yZWdpb24taWQpCmRvY2tlciBwdWxsIHJlZ2lzdHJ5LXZwYy4ke1JFR0lPTn0uYWxpeXVuY3MuY29tL2ltYm9sby9wYWx3b3JsZC1zZXJ2ZXI6bGF0ZXN0CnN1ZG8gZ3JvdXBhZGQgLWcgMTAwMCBzdGVhbSAmJiBzdWRvIHVzZXJhZGQgLXUgMTAwMCAtZyBzdGVhbSAtbSBzdGVhbSAmJiBta2RpciAvUGFsU2F2ZWQgJiYgY2hvd24gLVIgc3RlYW06c3RlYW0gL1BhbFNhdmVkCmRvY2tlciBydW4gLS1yZXN0YXJ0PWFsd2F5cyAtLXVzZXIgMTAwMDoxMDAwIC12IC9QYWxTYXZlZDovaG9tZS9zdGVhbS9TdGVhbS9zdGVhbWFwcHMvY29tbW9uL1BhbFNlcnZlci9QYWwvU2F2ZWQvIC0tbmFtZSBwYWx3b3JsZC1zZXJ2ZXIgLS1uZXQgaG9zdCAtZGl0IHJlZ2lzdHJ5LXZwYy4ke1JFR0lPTn0uYWxpeXVuY3MuY29tL2ltYm9sby9wYWx3b3JsZC1zZXJ2ZXI6bGF0ZXN0"
            description = "Bootstrap PalWorld Server"
            type = "RunShellScript"
            working_dir = "/root"
            timeout = 600
        }
        extensions: {
            provider: "registry.terraform.io/aliyun/alicloud/1.209.1"
            providerMeta: {
                region: "cn-hangzhou"
            }
            resourceType: "alicloud_ecs_command"
        }
    }

    alicloudECSInvocation: resource.Resource = {
        id: "aliyun:alicloud:alicloud_ecs_invocation:" + input.name
        type: "Terraform"
        attributes: {
            command_id = "$kusion_path.aliyun:alicloud:alicloud_ecs_command:" + input.name + ".id"
            instance_id = [
                "$kusion_path.aliyun:alicloud:alicloud_instance:" + input.name + ".id"
            ]
            timeouts = {
                create = "10m"
            }
        }
        extensions: {
            provider: "registry.terraform.io/aliyun/alicloud/1.209.1"
            providerMeta: {
                region: "cn-hangzhou"
            }
            resourceType: "alicloud_ecs_invocation"
        }
    }
