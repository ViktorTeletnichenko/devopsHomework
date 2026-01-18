output "group_id" {
  value = gitlab_group.this.id
}

output "project_ids" {
  value = { for k, p in gitlab_project.this : k => p.id }
}
