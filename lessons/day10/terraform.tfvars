environment = "production"

ingress_rules = [ {
  port = 22
  protocol = "tcp"
  cidr = "0.0.0.0/0"
},
{
  port = 80
  protocol = "tcp"
  cidr = "0.0.0.0/0"
},
{
  port = 443
  protocol = "tcp"
  cidr = "0.0.0.0/0"
} ]