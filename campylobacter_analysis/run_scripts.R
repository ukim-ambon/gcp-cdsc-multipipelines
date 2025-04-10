library(bigrquery)

# Authenticate BigQuery
bq_auth(path = "/app/key.json")
# Authenticate GCS
cs_auth(json_file = "/app/key.json")

# Set variables
project_id <- "cdsc-projects"
bucket_name <- "cdsc_pipelines"
output_path <- "campylobacter_analysis/outputs/tab_OpenNames.csv"

# Define the SQL query
query <- "SELECT * FROM `dashgcp-452719.qb_ordsur_1_dset.tab_OpenNames` LIMIT 10"
result <- bq_project_query(project_id, query)
df <- bq_table_download(result)

write.csv(df, "/tmp/tab_OpenNames.csv", row.names = FALSE)

# Upload to GCS
gcs_upload(
  file = "/tmp/tab_OpenNames.csv",
  bucket = bucket_name,
  name = output_path,
  predefinedAcl = "bucketLevel"
)
print("CSV uploaded to GCS successfully!")
print("Can be downloaded: https://storage.googleapis.com/cdsc_pipelines/campylobacter_analysis/outputs/tab_OpenNames.csv")
