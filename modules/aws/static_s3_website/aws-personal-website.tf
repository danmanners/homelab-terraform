#########################################################################
### Static Website through Cloudfront utilizing S3
resource "aws_s3_bucket" "bucket_name" {
  bucket = lower(var.domain_name)
  // This **must** be public-read so that files can be served correctly.
  acl = "public-read"

  website {
    index_document = "index.html"
  }
}

// Get the Zone information for the given domain
data "aws_route53_zone" "domain" {
  name         = lower(var.root_domain)
  private_zone = false
}

resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alt_names
  validation_method         = "DNS"
}

resource "aws_route53_record" "records" {
  for_each        = toset(var.all_route53_records)
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.domain.zone_id
  name            = each.value
  type            = "A"

  alias {
    name                   = aws_cloudfront_distribution.server.domain_name
    zone_id                = aws_cloudfront_distribution.server.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for domain_validation in aws_acm_certificate.cert.domain_validation_options : domain_validation.domain_name => {
      name    = domain_validation.resource_record_name
      record  = domain_validation.resource_record_value
      type    = domain_validation.resource_record_type
      zone_id = data.aws_route53_zone.domain.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [
    for record in aws_route53_record.cert_validation : record.fqdn
  ]
}

resource "aws_cloudfront_distribution" "server" {
  origin {
    domain_name = aws_s3_bucket.bucket_name.website_endpoint
    origin_id   = aws_s3_bucket.bucket_name.id

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2",
      ]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = concat(
    [var.domain_name],
    var.subject_alt_names
  )

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.bucket_name.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 600
    max_ttl                = 3600
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    ssl_support_method  = "sni-only"
    acm_certificate_arn = aws_acm_certificate.cert.arn
  }
}
