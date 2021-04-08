resource "aws_appsync_graphql_api" "api" {
  name                = "CustomersApi"
  authentication_type = "API_KEY"

  schema = file("${path.module}/schema.graphql")
}

resource "aws_appsync_api_key" "api_key" {
  api_id = aws_appsync_graphql_api.api.id
}

resource "aws_appsync_datasource" "datasource" {
  api_id           = aws_appsync_graphql_api.api.id
  name             = "Customers"
  service_role_arn = aws_iam_role.role.arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.table.name
  }
}

resource "aws_appsync_resolver" "create_customer_resolver" {
  api_id      = aws_appsync_graphql_api.api.id
  field       = "createCustomer"
  type        = "Mutation"
  data_source = aws_appsync_datasource.datasource.name

  request_template = <<EOF
{
    "version" : "2017-02-28",
    "operation" : "PutItem",
    "key" : {
        "id": $util.dynamodb.toDynamoDBJson($util.autoId())
    },
    "attributeValues" : $util.dynamodb.toMapValuesJson($ctx.args.input)
}
EOF

  response_template = "$util.toJson($ctx.result)"
}

resource "aws_appsync_resolver" "get_customer_resolver" {
  api_id      = aws_appsync_graphql_api.api.id
  field       = "getCustomer"
  type        = "Query"
  data_source = aws_appsync_datasource.datasource.name

  request_template = <<EOF
{
    "version": "2017-02-28",
    "operation": "GetItem",
    "key": {
        "id": $util.dynamodb.toDynamoDBJson($ctx.args.id)
    }
}
EOF

  response_template = "$util.toJson($ctx.result)"
}

resource "aws_appsync_resolver" "get_customers_resolver" {
  api_id      = aws_appsync_graphql_api.api.id
  field       = "getCustomers"
  type        = "Query"
  data_source = aws_appsync_datasource.datasource.name

  request_template = <<EOF
{
    "version" : "2017-02-28",
    "operation" : "Scan"
}
EOF

  response_template = "$util.toJson($ctx.result.items)"
}

output "api_url" {
  value = aws_appsync_graphql_api.api.uris["GRAPHQL"]
}

output "api_key" {
  value = aws_appsync_api_key.api_key.key
  sensitive = true
}
