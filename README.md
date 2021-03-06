This Repo/project is borrowed from: https://github.com/hashicorp/terraform-aws-consul.git
[![Maintained by Gruntwork.io](https://img.shields.io/badge/maintained%20by-gruntwork.io-%235849a6.svg)](https://gruntwork.io/?ref=repo_aws_consul)
# Consul AWS Module

This repo contains a set of modules in the [modules folder](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules) for deploying a [Consul](https://www.consul.io/) cluster on 
[AWS](https://aws.amazon.com/) using [Terraform](https://www.terraform.io/). Consul is a distributed, highly-available 
tool that you can use for service discovery and key/value storage. A Consul cluster typically includes a small number
of server nodes, which are responsible for being part of the [consensus 
quorum](https://www.consul.io/docs/internals/consensus.html), and a larger number of client nodes, which you typically 
run alongside your apps:

![Consul architecture](https://github.com/hashicorp/terraform-aws-consul/blob/master/_docs/architecture.png?raw=true)



## How to use this Module

This repo has the following folder structure:

* [modules](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules): This folder contains several standalone, reusable, production-grade modules that you can use to deploy Consul.
* [examples](https://github.com/hashicorp/terraform-aws-consul/tree/master/examples): This folder shows examples of different ways to combine the modules in the `modules` folder to deploy Consul.
* [test](https://github.com/hashicorp/terraform-aws-consul/tree/master/test): Automated tests for the modules and examples.
* [root folder](https://github.com/hashicorp/terraform-aws-consul/tree/master): The root folder is *an example* of how to use the [consul-cluster module](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/consul-cluster) 
  module to deploy a [Consul](https://www.consul.io/) cluster in [AWS](https://aws.amazon.com/). The Terraform Registry requires the root of every repo to contain Terraform code, so we've put one of the examples there. This example is great for learning and experimenting, but for production use, please use the underlying modules in the [modules folder](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules) directly.

To deploy Consul servers for production using this repo:

1. Create a Consul AMI using a Packer template that references the [install-consul module](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/install-consul).
   Here is an [example Packer template](https://github.com/hashicorp/terraform-aws-consul/tree/master/examples/consul-ami#quick-start). 
   
   If you are just experimenting with this Module, you may find it more convenient to use one of our official public AMIs.
   Check out the `aws_ami` data source usage in `main.tf` for how to auto-discover this AMI.
  
    **WARNING! Do NOT use these AMIs in your production setup. In production, you should build your own AMIs in your own 
    AWS account.**
   
1. Deploy that AMI across an Auto Scaling Group using the Terraform [consul-cluster module](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/consul-cluster) 
   and execute the [run-consul script](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/run-consul) with the `--server` flag during boot on each 
   Instance in the Auto Scaling Group to form the Consul cluster. Here is [an example Terraform 
   configuration](https://github.com/hashicorp/terraform-aws-consul/tree/master/examples/root-example#quick-start) to provision a Consul cluster.

To deploy Consul clients for production using this repo:
 
1. Use the [install-consul module](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/install-consul) to install Consul alongside your application code.
1. Before booting your app, execute the [run-consul script](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/run-consul) with `--client` flag.
1. Your app can now use the local Consul agent for service discovery and key/value storage.
1. Optionally, you can use the [install-dnsmasq module](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/install-dnsmasq) for Ubuntu 16.04 and Amazon Linux 2 or [setup-systemd-resolved](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/setup-systemd-resolved) for Ubuntu 18.04 and Ubuntu 20.04 to configure Consul as the DNS for a
   specific domain (e.g. `.consul`) so that URLs such as `foo.service.consul` resolve automatically to the IP 
   address(es) for a service `foo` registered in Consul (all other domain names will be continue to resolve using the
   default resolver on the OS).
   
 


## What's a Module?

A Module is a canonical, reusable, best-practices definition for how to run a single piece of infrastructure, such 
as a database or server cluster. Each Module is created using [Terraform](https://www.terraform.io/), and
includes automated tests, examples, and documentation. It is maintained both by the open source community and 
companies that provide commercial support. 

Instead of figuring out the details of how to run a piece of infrastructure from scratch, you can reuse 
existing code that has been proven in production. And instead of maintaining all that infrastructure code yourself, 
you can leverage the work of the Module community to pick up infrastructure improvements through
a version number bump.
 
 
 
## Who maintains this Module?

This Module is maintained by [Gruntwork](http://www.gruntwork.io/). If you're looking for help or commercial 
support, send an email to [modules@gruntwork.io](mailto:modules@gruntwork.io?Subject=Consul%20Module). 
Gruntwork can help with:

* Setup, customization, and support for this Module.
* Modules for other types of infrastructure, such as VPCs, Docker clusters, databases, and continuous integration.
* Modules that meet compliance requirements, such as HIPAA.
* Consulting & Training on AWS, Terraform, and DevOps.



## Code included in this Module:

* [install-consul](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/install-consul): This module installs Consul using a
  [Packer](https://www.packer.io/) template to create a Consul 
  [Amazon Machine Image (AMI)](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html).

* [consul-cluster](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/consul-cluster): The module includes Terraform code to deploy a Consul AMI across an [Auto 
  Scaling Group](https://aws.amazon.com/autoscaling/). 
  
* [run-consul](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/run-consul): This module includes the scripts to configure and run Consul. It is used
  by the above Packer module at build-time to set configurations, and by the Terraform module at runtime 
  with [User Data](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html#user-data-shell-scripts)
  to create the cluster.

* [install-dnsmasq module](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/install-dnsmasq): Install [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)
  for Ubuntu 16.04 and Amazon Linux 2 and configure it to forward requests for a specific domain to Consul. This allows you to use Consul as a DNS server
  for URLs such as `foo.service.consul`.

* [setup-systemd-resolved module](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/setup-systemd-resolved): Setup [systemd-resolved](https://www.freedesktop.org/software/systemd/man/resolved.conf.html)
  for Ubuntu 18.04 and Ubuntu 20.04 and configure it to forward requests for a specific domain to Consul. This allows you to use Consul as a DNS server
  for URLs such as `foo.service.consul`.

* [consul-iam-policies](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/consul-iam-policies): Defines the IAM policies necessary for a Consul cluster. 

* [consul-security-group-rules](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/consul-security-group-rules): Defines the security group rules used by a 
  Consul cluster to control the traffic that is allowed to go in and out of the cluster.

* [consul-client-security-group-rules](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/consul-client-security-group-rules): Defines the security group rules
  used by a Consul agent to control the traffic that is allowed to go in and out.



## How do I contribute to this Module?

Contributions are very welcome! Check out the [Contribution Guidelines](https://github.com/hashicorp/terraform-aws-consul/tree/master/CONTRIBUTING.md) for instructions.



## How is this Module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/). You can find each new release, 
along with the changelog, in the [Releases Page](../../releases). 

During initial development, the major version will be 0 (e.g., `0.x.y`), which indicates the code does not yet have a 
stable API. Once we hit `1.0.0`, we will make every effort to maintain a backwards compatible API and use the MAJOR, 
MINOR, and PATCH versions on each release to indicate any incompatibilities. 



## License

This code is released under the Apache 2.0 License. Please see [LICENSE](https://github.com/hashicorp/terraform-aws-consul/tree/master/LICENSE) and [NOTICE](https://github.com/hashicorp/terraform-aws-consul/tree/master/NOTICE) for more 
details.

Copyright &copy; 2017 Gruntwork, Inc.

## Custom Notes - Haaike van der Merwe

To run this module the following will be required on the jump host, or control node you are running terraform from:
1. install the following repos:
subscription-manager repos --enable=rhel-7-server-extras-rpms --enable=rhel-7-server-optional-rpms --enable=rhel-server-rhscl-7-rpms
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
2. install unzip: yum install unzip -y
3. install jq: yum install jq -y
4. install python3: yum install python3 -y
5. awscli installed: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
6. terraform installed: https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started
7. consul installed: https://learn.hashicorp.com/tutorials/consul/get-started-install#install-consul
8. export AWS_ACCESS_KEY_ID=
9. export AWS_SECRET_ACCESS_KEY=
10. export AWS_DEFAULT_REGION=
11. mkdir terraform-aws-consul-non-hcp; cd terraform-aws-consul-non-hcp; git init .; git pull https://github.com/HaaikeV/terraform-aws-consul-non-hcp.git
12. change the "cluster_name" variable in variable.tf if you are running anywhere other than dev
13. execute: terraform init; terraform plan; terraform apply
14. to get the cluster info, execute from the root terraform-aws-consul dir: ./examples/consul-examples-helper/consul-examples-helper.sh
15. the fizz buzz fizzbuzz project can be located in: ./examples/consul-examples-kv/1-100.sh
16. change the consul ip variable in the shell script - the ip you get from step 14.
17. make sure you have python version 3 installed.
18. the python algorithm script can be located at: ./examples/consul-examples-kv/install-algorythm.py
19. to use the python script called install-algorithm.py run: python3 install-algorythm.py and make sure 1-100.sh is in the same directory
20. to test if the script worked you can run: consul kv get -http-addr=$consul_cluster_ip:8500 3




