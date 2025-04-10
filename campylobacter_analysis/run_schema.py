from google.cloud import bigquery

client = bigquery.Client(project='BB')

source = 'dashgcp-452719.qb_ordsur_1_dset.tab_OpenNames'
target = 'cdsc-projects.campylobacter_analysis_dset.tab_OpenNames'

job = client.copy_table(source, target)
job.result()  # Waits for job to finish
