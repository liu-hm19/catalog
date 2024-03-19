schema Network: 
    """ Network describes the network accessories of Workload, which typically contains the exposed ports, load balancer 
    and other related resource configs. 

    Attributes
    ----------
    ports: [n.Port], default is Undefined, optional. 
        The list of ports which the Workload should get exposed. 

    Examples
    --------
    import catalog.models.schema.v1.network as n

    accessories: {
        "kusionstack/network@v0.1.0": n.Network {
            ports: [
                n.Port {
                    port: 80
                    public: True
                }
                n.Port {
                    port: 8080
                }
            ]
        }
    }
    """

    # The list of ports getting exposed. 
    ports?:                         [Port]
