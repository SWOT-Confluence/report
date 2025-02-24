# report

Reports on Confluence workflow status by:

1) Aggregates execution data for the Step Function state machine execution.
2) Uploads module data stats and failure data reports to JSON S3 bucket.
3) Sends e-mail report with top-level stats and SoS granules created.
4) [Optional] Can be executed with `-f` to indicate failures in e-mail notification.

This is a docker container meant to be run as an AWS Batch job after any failures in Confluence workflow step function tasks.

## Arguments

- e: Execution ID of step function state machine
- t: Temporal range used to query Hydrocron
- s: SOS S3 bucket name
- r: Run type, 'constrained' or 'unconstrained'
- b: JSON S3 bucket name
- k: JSON S3 bucket key to upload report to
- f: Indicates workflow failure


## installation

Build a Docker image: `docker build -t report .`

## execution

AWS credentials will need to be passed as environment variables to the container so that `report` may access AWS infrastructure to generate JSON files.

```bash
# Credentials
export aws_key=XXXXXXXXXXXXXX
export aws_secret=XXXXXXXXXXXXXXXXXXXXXXXXXX

# Docker run command
docker run --rm --name report -e AWS_ACCESS_KEY_ID=$aws_key -e AWS_SECRET_ACCESS_KEY=$aws_secret -e AWS_DEFAULT_REGION=us-west-2 report:latest
```

## deployment

There is a script to deploy the Docker container image and Terraform AWS infrastructure found in the `deploy` directory.

Script to deploy Terraform and Docker image AWS infrastructure

REQUIRES:

- jq (<https://jqlang.github.io/jq/>)
- docker (<https://docs.docker.com/desktop/>) > version Docker 1.5
- AWS CLI (<https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>)
- Terraform (<https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli>)

Command line arguments:

[1] registry: Registry URI
[2] repository: Name of repository to create
[3] prefix: Prefix to use for AWS resources associated with environment deploying to
[4] s3_state_bucket: Name of the S3 bucket to store Terraform state in (no need for s3:// prefix)
[5] profile: Name of profile used to authenticate AWS CLI commands

Example usage: ``./deploy.sh "account-id.dkr.ecr.region.amazonaws.com" "container-image-name" "prefix-for-environment" "s3-state-bucket-name" "confluence-named-profile"`

Note: Run the script from the deploy directory.
