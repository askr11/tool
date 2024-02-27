variable "region"{
    type=string
    description="region of the vpc"
}
variable "addr"{
    type=string
    default="10.0.2.0/18"
}
variable "sdr"{
    type=list(string)
   # default="10.2.2.0/18"
}
variable "nam"{
    type=string
}
variable "subnet_name"{
    type=list(string)
}
variable "priname"{
    type=list(string)
}
variable "pdr"{
    type=list(string)
}

variable "am"{
    type=string
}

#gateway name
variable "gateway_name"{
    type=string
}
variable "all"{
    type=list(string)
}
variable "sshdr"{
    type=list(string)
   # default="10.2.2.0/18"
}
variable "bastionuser"{
type=string
}
variable "vpc_jenkins_server"{
type=string
}
variable "jenkins_route_table"{
type=string
}
variable "avail_zone"{
type=list(string)
}
variable "jenkins_cidr"{
type=string
}
