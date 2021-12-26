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
  bucket_versioning   = true
}
```

## What does this module do/not do?

- This module **DOES** ensure S3 bucket contents are **PUBLIC** and **NOT PRIVATE**! This is to serve content correctly.
- This module **DOES NOT** set up access logging.
- This module **DOES NOT** create and/or associate a WAF
- This module **DOES NOT** handle versioning, by default.
  - It **can** be enabled by setting `bucket_versioning = true`
