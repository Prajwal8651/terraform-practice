`terraform-practice/lessons/day13/README.md`

---

```md
# Day 13 – Terraform Data Sources (AWS)

This project demonstrates how to use **Terraform data sources** to read existing AWS infrastructure and use that data to create resources — without hardcoding values like VPC IDs, subnet IDs, or AMI IDs. This approach makes your infrastructure code dynamic, reliable, and scalable.

---

## 🚀 What You Learn

- How to fetch an existing **VPC** using a data source  
- How to fetch a **subnet** within that VPC  
- How to fetch the **latest Amazon Linux 2 AMI** dynamically  
- How to launch an **EC2 instance** using the values from data sources

---

## 🧠 Why Use Terraform Data Sources?

Terraform data sources let you **query existing resources** instead of creating new ones.  
This is useful when:
- You want to **reuse existing AWS infrastructure**
- You want to avoid **hardcoding IDs**
- You want your Terraform code to be **dynamic and environment-agnostic**

Terraform data sources are read-only and do not create or manage resources — they just fetch information to use in other parts of your configuration. :contentReference[oaicite:0]{index=0}

---

## 📁 Project Structure

```

.
├── provider.tf
├── main.tf
├── outputs.tf
└── README.md

````

---

## ⚙️ Code and Line-by-Line Explanation

### 1️⃣ Provider Configuration (`provider.tf`)

```hcl
provider "aws" {
  region = "ap-south-1"
}
````

This tells Terraform to use the AWS provider and sets the region (`ap-south-1`) for all AWS operations.

---

### 2️⃣ Fetch Existing VPC

```hcl
data "aws_vpc" "selected" {
  default = true
}
```

* `data "aws_vpc"` tells Terraform we want to *read*, not create, a VPC.
* `default = true` selects the default VPC in the AWS account.
* This avoids hardcoding the VPC ID and makes the code flexible.

---

### 3️⃣ Fetch Subnet in the VPC

```hcl
data "aws_subnet" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "availability-zone"
    values = ["ap-south-1a"]
  }
}
```

* We query AWS for a subnet that belongs to the selected VPC.
* The filters use the VPC ID from the previous data source.
* The second filter narrows the subnet by availability zone.

---

### 4️⃣ Fetch Latest Amazon Linux 2 AMI

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
```

* Finds the latest AMI matching Amazon Linux 2 patterns.
* `most_recent = true` ensures you always use the newest image instead of a hardcoded AMI ID.

---

### 5️⃣ Create an EC2 Instance

```hcl
resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.selected.id

  tags = {
    Name = "terraform-ec2-demo"
  }
}
```

* This resource creates an EC2 instance.
* The AMI ID and subnet ID are fetched dynamically from data sources.

---

### 6️⃣ Optional Outputs

```hcl
output "instance_id" {
  value = aws_instance.example.id
}

output "instance_public_ip" {
  value = aws_instance.example.public_ip
}
```

These outputs show the EC2 instance ID and public IP once Terraform apply finishes.

---

## 🛠️ How to Run This

Use the same flow for every Terraform project:

```bash
terraform init
terraform plan
terraform apply
```

---

## 🧩 What I Learned

* The difference between Terraform **resources** and **data sources**
* The importance of avoiding hardcoded values
* How Terraform data sources make configurations more flexible and reusable

---

## 📎 Related Blog

Deep commentary and explanation available here:

👉 [https://prajwal-blog.hashnode.dev/day-13-terraform-data-sources-reading-existing-infrastructure](https://prajwal-blog.hashnode.dev/day-13-terraform-data-sources-reading-existing-infrastructure)

---

## 👨‍💻 About Me

Learning Terraform & AWS hands-on as part of **#30DaysofAWSTerraform**
