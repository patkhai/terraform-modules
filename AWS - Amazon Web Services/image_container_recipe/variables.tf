
variable "components_arns" {
  type = list(object({
    arn = string 
  }))
  description = "The ordered components of the recipe"
}

variable "parent_image" {
  type        = string
  description = "Image that the recipe should start with. SemVers is ok (and encouraged)"
}

variable "ebs_volume_size" {
  type = number
  description = "GiB of the volume size"
}

variable "ebs_volume_type" {
  type = string
  description = "type of the volume"
  default = "gp3"
}

variable "ebs_iops" {
  type = number
  description = "Number of I/O operation to provision"
}


variable "recipe_version" {
  type        = string
  description = "Version of the recipe"
  
}


variable "description" {
  type        = string
  description = "The description of the component."
  default     = "An component for EC2 Image Builder."
}

variable "name" {
  type        = string
  description = "The name of the component."
}

variable "platform" {
  type        = string
  description = "The platform of the component."
}

variable "tags" {
  type        = map(string)
  description = "The tags applied to the component."
  default     = {}
}

variable "dockerfile_data_path" {
  type        = string
  description = "The path to the docker file containing the recipe."
}

variable "container_type" {
  type        = string
  description = "Type of the container"
}

variable "repository_name" {
  type        = string
  description = "The name of the repository." 
}

variable "working_directory_path" {
  type        = string
  description = "The path to the working directory"
}

variable "ebs_throughput" {
  type        = number
  description = "Throughput of the volume type"
  default     = null

}

