region="ap-south-1"
addr="10.8.0.0/16"
sdr=["10.8.128.0/18", "10.8.64.0/18"]
sshdr=["10.0.8.0/22","10.8.128.0/18", "10.8.64.0/18"]
nam="ninja-vpc-01"
subnet_name= ["ninja-pub-sub-01", "ninja-pub-sub-02"]
avail_zone=["ap-south-1a", "ap-south-1b"]
#private cidr block
pdr=["10.8.0.0/25", "10.8.0.128/25"] 
#private subnet name
priname= ["ninja-pri-sub-01", "ninja-pri-sub-02"]
#ami id of instance
am="ami-0a7cf821b91bcccbc"
#gateway name
gateway_name = "ninja-igw-01"

all=["0.0.0.0/0"]
