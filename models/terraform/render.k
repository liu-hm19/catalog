import models.terraform.resource
import models.terraform.resource_builder
import models.terraform.palworld

import manifests

_palworld_instances = [inst for inst in palworld.PalWorldServer.instances()]
_palworld_ins = _palworld_instances[0]

_resources: [resource.Resource] = [
    resource_builder.ResourceBuilder(_palworld_ins).alicloudVPC,
    resource_builder.ResourceBuilder(_palworld_ins).alicloudVSwitch,
    resource_builder.ResourceBuilder(_palworld_ins).alicloudSecurityGroup,
    resource_builder.ResourceBuilder(_palworld_ins).alicloudSecurityGroupRule,
    resource_builder.ResourceBuilder(_palworld_ins).alicloudSecurityGroupRuleSSH,
    resource_builder.ResourceBuilder(_palworld_ins).alicloudECSInstance,
    resource_builder.ResourceBuilder(_palworld_ins).alicloudECSCommand,
    resource_builder.ResourceBuilder(_palworld_ins).alicloudECSInvocation,
]

manifests.yaml_stream(_resources)