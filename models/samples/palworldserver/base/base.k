import models.schema.v1 as ac
import models.schema.v1.workload as wl
import models.schema.v1.workload.container as c
import models.schema.v1.workload.network as n
import models.schema.v1.workload.secret as sec

palworldserver = ac.AppConfiguration {
    workload: wl.Service {
        containers: {
            palworldserver: c.Container {
                image: "thijsvanloef/palworld-server-docker"
                env: {
                    "ADMIN_PASSWORD": "secret://palworldserver-secret/rconPassword"
                    "PUID": "1000"
                    "PGID": "1000"
                    "PORT": "8211"
                    "PLAYERS": "16"
                    "SERVER_PASSWORD": "worldofpals"
                    "MULTITHREADING": "true"
                    "RCON_ENABLED": "true"
                    "RCON_PORT": "25575"
                    "TZ": "UTC"
                    "COMMUNITY": "false"
                    "SERVER_NAME": "World of Pals"
                    "SERVER_DESCRIPTION": "This is a palworld server applied with Kusion!"
                }
            }
        }
        secrets: {
            "palworldserver-secret": sec.Secret {
                type: "opaque"
                data: {
                    "rconPassword": "yourRconPassword"
                }
            }
        }
        replicas: 1
        ports: [
            n.Port {
                port: 8211
                protocol: "UDP"
            }
            n.Port {
                port: 27015
                protocol: "UDP"
            }
        ]
    }
}
