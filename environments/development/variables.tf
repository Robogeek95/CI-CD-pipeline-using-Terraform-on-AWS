variable "github_oauth_token" {
  description = "Github Oauth token"
  type        = string
}
variable "github_repo_owner" {
  description = "Github repo owner"
  type        = string
  default     = "Robogeek95"
}
variable "github_repo_name" {
  description = "Github repo name"
  type        = string
  default     = "prospa-assessment"
}
variable "region" {
  description = "default region"
  type        = string
  default     = "us-west-2"
}
