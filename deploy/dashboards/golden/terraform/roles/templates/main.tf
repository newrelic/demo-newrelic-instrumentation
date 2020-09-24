# TODO make the dashboard title configurable from the deployment configuration. ALEC!!!
terraform {
    required_providers {
        newrelic = {
        source  = "newrelic/newrelic"
        version = "~> 2.6.0"
        }
    }
}

provider "newrelic" {
    api_key       = var.newrelic_api_key
    admin_api_key = var.newrelic_admin_api_key
    account_id    = var.newrelic_account_id
    region        = var.newrelic_region
}

{% if s3_bucketname_tfstate is defined %}
provider "aws" {
  access_key  = "{{ aws_access_key }}"
  secret_key  = "{{ aws_secret_key }}"
  region      = "{{ aws_region }}"
}
terraform {
  backend "s3" {
    bucket = "{{ s3_bucketname_tfstate }}"
    key    = "{{ deployment_name }}-dashboards-golden.tfstate"
    access_key  = "{{ aws_access_key }}"
    secret_key  = "{{ aws_secret_key }}"
    region      = "{{ aws_region }}"
  }
}
{% endif %}

variable "newrelic_api_key" {
    description = "The New Relic API key"
    type = string
}
variable "newrelic_admin_api_key" {
    description = "The New Relic Admin API key"
    type = string
}
variable "newrelic_account_id" {
    description = "The New Relic AccountId"
    type = string
}
variable "newrelic_region" {
    description = "The New Relic region for the account, typically US"
    type = string
}

resource "newrelic_dashboard" "golden_dashboard" {
  title             = "Golden {{ deployment_name }}"
  icon              = "line-chart"
  grid_column_count = 12
  visibility        = "all"
  editable          = "editable_by_all"

  widget {
    title         = "Errors"
    visualization = "billboard"
    nrql          = "SELECT count(*) FROM Transaction FACET appName WHERE httpResponseCode = '500' AND appName IN ('Telco-Web Portal')"
    row           = 1
    column        = 1
  }

  widget {
    title         = "Slowest Endpoints (95th percentile)"
    visualization = "facet_pie_chart"
    nrql          = "SELECT average(duration) FROM Transaction FACET appName, name WHERE appName IN ('Telco-Web Portal')"
    row           = 1
    column        = 2
  }

  widget {
    title         = "Request Breakdown by Application"
    visualization = "facet_pie_chart"
    nrql          = "SELECT count(*) FROM Transaction FACET appName LIMIT MAX Where appName IN ('Telco-Web Portal')"
    row           = 1
    column        = 3
  }

  widget {
    title         = "Host Memory Usage (percentage)"
    visualization = "faceted_line_chart"
    nrql          = "SELECT average(memoryUsedPercent) as '% Used' FROM SystemSample TIMESERIES FACET entityName WHERE entityName IN ('simuhost')"
    row           = 2
    column        = 1
  }

  widget {
    title         = "HTTP Responses"
    visualization = "faceted_area_chart"
    nrql          = "SELECT count(*) FROM Transaction TIMESERIES FACET httpResponseCode WHERE appName IN ('Telco-Web Portal')"
    row           = 2
    column        = 2
  }

  widget {
    title         = "Heap Memory Used (percentage)"
    visualization = "faceted_line_chart"
    nrql          = "SELECT average(`apm.service.memory.heap.used`)/average(`apm.service.memory.heap.max`)*100 FROM Metric FACET appName WHERE appName IN ('Telco-Web Portal')"
    row           = 2
    column        = 3
  }

}
