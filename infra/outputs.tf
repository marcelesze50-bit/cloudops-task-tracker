output "k3s_public_ip" {
  value = aws_instance.k3s.public_ip
}

output "ssh_command" {
  value = "ssh -i ${replace(var.public_key_path, ".pub", "")} ubuntu@${aws_instance.k3s.public_ip}"
}

output "kubeconfig_copy_command" {
  value = "scp -i ${replace(var.public_key_path, ".pub", "")} ubuntu@${aws_instance.k3s.public_ip}:/home/ubuntu/.kube/config ./kubeconfig"
}

output "backend_ecr_repository_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "frontend_ecr_repository_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "k3s_public_dns" {
  value = aws_instance.k3s.public_dns
}
