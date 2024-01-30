schema PalWorldServer: 
    __settings__:   {str:str} = {"output_type" = "IGNORE"}

    name?:          str = "palworld-server"
    size:           "small" | "medium" | "large"
    bandwidth:      int
