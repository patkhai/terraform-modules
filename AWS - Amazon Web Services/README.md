# terraform-imagebuilder-pipelines

Terraform module to provision and configure EC2 ImageBuilder Pipelines.

## Example

Here's what using the module will look like. Note that this module needs at least one recipe and component to be useful. See examples below for details.

```hcl

#Image Builder Component Example
module "image_builder_component" {
  source             = "/aws//image_component"
  version            = ">= 1.0.0"


  name               = "AmzLnx-InitialSetupBasicHardening"
  platform           = "Linux"
  component_version  = "1.0.8"
  description        = "Component for Amz linux initial setup and basic hardening."
  data               = "${("InitialSetupBasicHardening.yml")}"
  tags               = var.tags
  os_flavor          = "amazon-linux"

}

#Image Builder Distribution Example
module "image_builder_distribution"{
  source             = "/aws//image_distribution"
  version            = ">= 1.0.0"


  name               = "Amazon-Linux-Distribution"
  description        = "Distribution settings for Amazon Linux AMI"
  ami_name           = "V{{imagebuilder:buildVersion}}_AmazonLinux2_{{imagebuilder:buildDate}}"
  ami_tags = {
    "AMI unique key" = "NPRD_AmazonLinux2",
    "Creator"        = "",
    "OwnerID"        = "",
    "Platform"       = "Linux",
    "Name"           = "Amazon-Linux-Distribution",
    "ami_type"       = "Standard",
    "OS"             = "AmazonLinux2"
  }
  ami_region         = var.aws_region
  tags               = var.tags
}

#Image Builder Infrastructure Example
module "image_builder_infrastructure" {
  source                       = "/aws//image_infrastructure"
  version                      = ">= 1.0.0"

  name                          = "AMI-Builds-InfraConfig"
  description                   = "Infrastrucuture Configuration for AMI Builds"
  iam_instance_profile_name     = var.iam_instance_role
  instance_types                = ["t2.small"]
  key_name                      = var.key_name
  security_group_ids            = var.security_group_ids
  subnet_id                     = var.subnet_id
  terminate_instance_on_failure = true
  s3_bucket_name                = "image-builder"
  s3_key_prefix                 = "/"
  tags                          = var.tags

}

#Image Builder Recipe Example
module "image_builder_recipe" {
  source                  = "/aws//image_recipe"
  version                 = ">= 1.0.0"

  name                    = "AmazonLinux-Recipe"
  description             = "Image Recipe for Amazon Linux AMI"
  volume_size             = 8
  volume_type             = "gp3"
  iops                    = 3000
  throughput              = 125
  parent_image            = "arn:aws:imagebuilder:us-west-2:aws:image/amazon-linux-2-x86/x.x.x"
  platform                = "Linux"
  recipe_version          = "1.0.0"
  components_arns         = flatten([
                                [
                                  {arn = "arn:aws:imagebuilder:us-west-2:aws:component/aws-cli-version-2-linux/1.0.3/1"},
                                  {arn = "arn:aws:imagebuilder:us-west-2:aws:component/python-3-linux/1.0.2/1" }
                                ]
                                    ])
  tags                    = var.tags
}

#Image Builder Pipeline Example
module "image_builder_pipeline" {
  source                       = "/aws//image_pipeline"
  version                      = ">= 1.0.0"

  name                         = "AmazonLinux"
  description                  = "Imagebuilder pipeline for AmazonLinux. This is for ENCAP and Affiliated Accounts"
  image_recipe                 = module.image_builder_recipe.arn
  infrastructure_configuration = module.image_builder_infrastructure.arn
  distribution_configuration   = module.image_builder_distribution.arn
  tags                         = var.tags

}

#Image Builder Container Recipe Example
module "image_builder_container_recipe" {
  source                 = "/aws//image_container_recipe"
  version                = ">= 1.0.0"

  name                   = "image name"
  description            = "to ensure it is functioning"
  ebs_volume_size        = 30
  ebs_volume_type        = "gp3"
  ebs_iops               = 3000
  ebs_throughput         = 125
  parent_image           = "arn"
  platform               = "Linux"
  recipe_version         = "1.0.0"
  container_type         = "DOCKER"
  repository_name        = "repo_name"
  working_directory_path = "/home/"
  component_arns        = flatten([
                                [
                                  {arn = "arn:aws:imagebuilder:us-west-2:aws:component/aws-cli-version-2-linux/1.0.3/1"},
                                  {arn = "arn:aws:imagebuilder:us-west-2:aws:component/python-3-linux/1.0.2/1" }
                                ]
                                    ])

  dockerfile_data_path   = file("${path.module}/yourfilepath")
  tags                   = var.tags

}





```

## About

Allows the creation of EC2 Image Builder Pipelines from components, recipe, distribution_configuration, infrastructure_configuration and pipeline.
