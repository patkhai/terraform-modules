# image recipe
resource "aws_imagebuilder_container_recipe" "this" {
  name           = var.name
  container_type = var.container_type
  parent_image   = var.parent_image
  version        = var.recipe_version
  tags           = var.tags

    
  instance_configuration {
    block_device_mapping {
      device_name = "/dev/xvda"
      ebs { 
        delete_on_termination = true
        volume_size           = var.ebs_volume_size
        volume_type           = var.ebs_volume_type
        iops                  = var.ebs_iops
        throughput            = var.ebs_throughput 
      }
    }
  }
  dynamic "component"{
    for_each = var.components_arns
    content { 
      component_arn = component.value.arn
    }
  }

  target_repository {
    repository_name = var.repository_name
    service         = "ECR"
  }

  working_directory = var.working_directory_path
  dockerfile_template_data = var.dockerfile_data_path

}
