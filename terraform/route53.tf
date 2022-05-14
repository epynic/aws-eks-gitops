
# resource "aws_route53_zone" "primary" {
#   name = var.domain
# }

# resource "aws_route53_record" "primary_www_record" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "www"
#   type    = "CNAME"
#   ttl     = "300"

#   records        = ["https://github.com/epynic/aws-eks-gitops"]
# }



resource "aws_route53_zone" "secondary" {
  name = "codeforcookie.com"
}

resource "aws_route53_record" "secondary_record" {
  zone_id = aws_route53_zone.secondary.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = "300"

  records = ["https://github.com/epynic/aws-eks-gitops"]
}
