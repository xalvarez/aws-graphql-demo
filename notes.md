## Intro graphql
- what is it
- what problems can it solve

## Use case
- what do we want to accomplish
  - 1 table, 1 read 1 write

# Implementation
1. Create AppSync app
2. Create data source. In our case dynamoDB table. Other supported data sources:
    1. ElasticSearch, RDS, Lambda, HTTP Endpoint
3. Create GraphQL Schema
Schema:
    Customer
        id (autogenerated)
        firstName
        lastName
        age
    get Customers
    get Customer(id)
    post Customer
4. Configure resolvers
5. Test API using "Queries"
5.5. Authorization
6. curl examples

curl --request POST \
  --url https://<api>.appsync-api.eu-central-1.amazonaws.com/graphql \
  --header 'Content-Type: application/json' \
  --header 'x-api-key: <api-key>' \
  --data '{"query":"{customers {id}}"}'

## Conclusion
Link to github with more detailed example
Comparison with REST