output "arn" {
  description = "ARN of the EC2 Image Builder Recipe"
  value       = aws_imagebuilder_container_recipe.this.arn
}