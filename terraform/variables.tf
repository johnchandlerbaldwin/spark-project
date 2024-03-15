variable "credentials" {
  description = "My Credentials"
  default     = "keys/my-creds.json"
  #ex: if you have a directory where this file is called keys with your service account json file
  #saved there as my-creds.json you could use default = "./keys/my-creds.json"
}


variable "project" {
  description = "Project"
  default     = "<Your Project ID>"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region
  default     = "us-west1-b"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default     = "US"
}