# AWS - Static S3 Website

This module provisions an S3 bucket, a CloudFront distribution, an ACM certificate, and the appropriate DNS entries to provision a static-content website hosted on Amazon S3.

## How to use it

You can use this module by loading in the following variables:

- Root Domain
- Domain Name
- Subject Alt Names
- All Route53 Records

```r
### Static Hosted Website - danmanners.com
module "aws_static_website_danmanners" {
  ## Module Source
  source = "./modules/aws/static_s3_website"

  ## Load in Variables
  root_domain         = "danmanners.com"
  domain_name         = "danmanners.com"
  subject_alt_names   = ["www.danmanners.com"]
  all_route53_records = ["www", "."]
}
```

The reason that `root_domain` and `domain_name` are the same here are for the simple reason that they _could_ be different, and by setting the same value twice allows for future flexibility.

Consider this example:

```r
module "aws_static_website" {
  source = "./modules/aws/static_s3_website"

  ## Load in Variables
  root_domain         = "example.com"
  domain_name         = "main.example.com"
  subject_alt_names   = [
    "prod.example.com",
    "dev.example.com"
  ]
  all_route53_records = [
    "main",
    "prod",
    "dev"
  ]
}
```
