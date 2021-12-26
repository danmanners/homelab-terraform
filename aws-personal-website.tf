#########################################################################
### Static Website through Cloudfront for Main and Resume Websites
resource "aws_s3_bucket" "danmanners_dot_com" {
  bucket = "danmanners.com"
  acl    = "public-read"

  website {
    index_document = "index.html"
  }
}

// Get the Zone informatoin for danmanners.com
data "aws_route53_zone" "danmanners" {
  name         = "danmanners.com"
  private_zone = false
}

resource "aws_acm_certificate" "danmanners_dot_com" {
  domain_name = "danmanners.com"
  subject_alternative_names = [
    "www.danmanners.com"
  ]
  validation_method = "DNS"
}

resource "aws_route53_record" "danmanners_dot_com" {
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.danmanners.zone_id
  name            = "."
  type            = "A"

  alias {
    name                   = aws_cloudfront_distribution.danmanners.domain_name
    zone_id                = aws_cloudfront_distribution.danmanners.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www_danmanners_dot_com" {
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.danmanners.zone_id
  name            = "www"
  type            = "A"

  alias {
    name                   = aws_cloudfront_distribution.danmanners.domain_name
    zone_id                = aws_cloudfront_distribution.danmanners.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "danmanners_dot_com_validation" {
  for_each = {
    for domain_validation in aws_acm_certificate.danmanners_dot_com.domain_validation_options : domain_validation.domain_name => {
      name    = domain_validation.resource_record_name
      record  = domain_validation.resource_record_value
      type    = domain_validation.resource_record_type
      zone_id = data.aws_route53_zone.danmanners.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "danmanners_dot_com" {
  certificate_arn = aws_acm_certificate.danmanners_dot_com.arn
  validation_record_fqdns = [
    for record in aws_route53_record.danmanners_dot_com_validation : record.fqdn
  ]
}

resource "aws_cloudfront_distribution" "danmanners" {
  origin {
    domain_name = aws_s3_bucket.danmanners_dot_com.website_endpoint
    origin_id   = aws_s3_bucket.danmanners_dot_com.id

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
  aliases             = ["danmanners.com", "www.danmanners.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.danmanners_dot_com.id

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
    acm_certificate_arn = aws_acm_certificate.danmanners_dot_com.arn
  }
}
