# image recipe
resource "aws_imagebuilder_image_recipe" "this" {
  block_device_mapping {
    device_name = "/dev/xvda"
    ebs { 
      delete_on_termination = var.delete_on_termination
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      iops                  = var.iops
      throughput            = var.throughput
    }
  }
  systems_manager_agent {
    uninstall_after_build = false 
  }
 dynamic "component"{
    for_each = var.component_arns 
    content { 
      component_arn = component.value.arn
    }
  }
  
  name              = var.name
  parent_image      = var.parent_image
  version           = var.recipe_version
  working_directory = var.working_directory
  tags              = var.tags
}

