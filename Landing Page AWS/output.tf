output "landing_page_url" {
  description = "The URL of the deployed S3 website"
  value       = module.landing_page_site.website_endpoint
}