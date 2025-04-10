library(bigrquery)

# Authenticate using the service account key
bq_auth(path = "/app/key.json")

# Set project ID
project_id <- "cdsc-projects"

# Define the SQL query
query <- "SELECT * FROM `dashgcp-452719.qb_ordsur_1_dset.tab_OpenNames` LIMIT 10"

# Execute the query
result <- bq_project_query(project_id, query)

# Convert to dataframe
df <- bq_table_download(result)

# Print the results
print("show dataframe...")
print(df)
