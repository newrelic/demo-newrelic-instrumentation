[![Experimental Project header](https://github.com/newrelic/opensource-website/raw/master/src/images/categories/Experimental.png)](https://opensource.newrelic.com/oss-category/#experimental)

# demo-newrelic-instrumentation

This repository is intended to be used by the [demo-deployer](https://github.com/newrelic/demo-deployer).

## Supported NewRelic versions
### On-Host/Infrastructure

#### New Relic
All the current and documented releases on this page are supported
https://docs.newrelic.com/docs/release-notes/infrastructure-release-notes/infrastructure-agent-release-notes

#### demo-deployer 'deploy_script_path'
To instrument a NodeJS service use this path for the deploy script path

      "deploy_script_path": "deploy/linux/roles"

The `params` element `isLoggingEnabled` is optional and when set to `true` indicates the host system logs will be sent to newrelic logging.

Here is a resource instrumentor configuration example to place in your demo-deployer deploy config file:
```json
      {
            "id": "nr_infra_agent",
            "resource_ids": ["host1"],
            "provider": "newrelic",
            "source_repository": "https://github.com/newrelic/demo-newrelic-instrumentation.git",
            "deploy_script_path": "deploy/linux/roles",
            "version": "1.12.4",
            "params": {
                  "isLoggingEnabled": true
            }
      }
```

### demo-deployer

#### User configuration

The current configuration for the demo-deployer is available at https://github.com/newrelic/demo-deployer/tree/main/documentation/user_config/credentials/newrelic

Note, all URLs are optional by default. 

Typically, language agents only need the collector URL.
The Infra agent needs the following URLs: infraCollector, infraCommand and identity.
The Logging product needs the logging URL.


#### Deploy configuration 'deploy_script_path'
To instrument a Linux host use this path for the deploy script path

      "deploy_script_path": "deploy/linux/roles"

### NodeJS

#### New Relic
All the current and documented releases on this page are supported
https://docs.newrelic.com/docs/release-notes/agent-release-notes/nodejs-release-notes/

#### demo-deployer 'deploy_script_path'
To instrument a NodeJS service use this path for the deploy script path

      "deploy_script_path": "deploy/node/linux/roles"

Here is an instrumentor configuration example to place in your demo-deployer deploy config file:
```
 {
      "id": "nr_node_agent",
      "service_ids": ["simulator"],
      "provider": "newrelic",
      "source_repository": "https://github.com/newrelic/demo-newrelic-instrumentation.git",
      "deploy_script_path": "deploy/node/linux/roles",
      "version": "6.2.0"
},
```

Please note, the application should have html files in the /public folder. The instrumentation will deploy them as html template in a /views folder and use EJS to dynamically inject the NewRelic agent.

The node instrumentation would also install the newrelic winston plugin. However, the application should declare a unique winston logger with the syntax below:

```javascript
const logger = winston.createLogger()
```


### Java

#### New Relic
All the current and documented releases on this page are supported
https://docs.newrelic.com/docs/release-notes/agent-release-notes/java-release-notes

#### demo-deployer 'deploy_script_path'

##### Ansible pre-requesite

In order to deploy newrelic instrumentation for java, the following ansible plugin should be installed on the host running the deployer before hand ```ansible-galaxy install newrelic.newrelic_java_agent```

##### deploy_script_path'
To instrument a Java service hosted on Tomcat, use this path for the deploy script path

      "deploy_script_path": "deploy/java/linux/tomcat/roles"

### Python

#### New Relic
All the current and documented releases on this page are supported
https://docs.newrelic.com/docs/release-notes/agent-release-notes/python-release-notes

#### demo-deployer 'deploy_script_path'
To instrument a Python service use this path for the deploy script path

      "deploy_script_path": "deploy/python/linux/roles"

### Logging
The below play is meant to be use with the installation of the Fluentd application as a service in the https://github.com/newrelic/demo-deployer.
Then add a service instrumentation with the below script path to ensure the logs are sent to NR.
Please see the [demo-deployer](https://github.com/newrelic/demo-deployer) documentation for the setup of the NR api keys.

```json
{

  "instrumentations": {
    "services": [
      {
        "id": "nr_logging",
        "service_ids": ["service1"],
        "provider": "newrelic",
        "source_repository": "https://github.com/newrelic/demo-newrelic-instrumentation.git",
        "deploy_script_path": "deploy/logging/roles"
      }
    ]
  }

}
```

This instrumentation is dependent on the application to generate a log file in its directory named `application.log.json`
For example if a service was being deployed with the demo-deployer with an id of "node1" on an AWS EC2 instance, the log file should be in the path /home/ec2-user/node1/application.log.json

Note, Logging requires a service to ship the log files to newrelic. You can do so with the [demo-fluentd](https://github.com/newrelic/demo-fluentd) repository.

#### Logging in Context
Similar to logging, there is also another specific play for instrumenting with Logging in Context.

```json
{

  "instrumentations": {
    "services": [
      {
        "id": "nr_logging_in_context",
        "service_ids": ["service2"],
        "provider": "newrelic",
        "source_repository": "https://github.com/newrelic/demo-newrelic-instrumentation.git",
        "deploy_script_path": "deploy/logging_in_context/roles"
      }
    ]
  }

}
```

This instrumentation is dependent on the application to generate a log file in its directory named `application.log.json`
For example if a service was being deployed with the demo-deployer with an id of "node1" on an AWS EC2 instance, the log file should be in the path /home/ec2-user/node1/application.log.json

Note, Logging requires a service to ship the log files to newrelic. You can do so with the [demo-fluentd](https://github.com/newrelic/demo-fluentd) repository.

### Alerts

Alerts can be created in New Relic through the use of the Terraform provider.
Here is an example of demo [demo-deployer](https://github.com/newrelic/demo-deployer) configuration.
This alert deployment creates an alert for a service `node1` with the 4 golden signals: Low Throughput, High Response Time, High CPU usage, High Error Percentage.
Optionally, you may also provisioned an S3 bucket with the deployer. If you do, beware that tearing down will remove that bucket, without a prompt or confirmation, and potentially impact anyone else who may be using that same bucket.

```json
      {
        "id": "nr_alert_service",
        "service_ids": ["node1"],
        "provider": "newrelic",
        "provider_credential": "aws",
        "source_repository": "https://github.com/newrelic/demo-newrelic-instrumentation.git",
        "deploy_script_path": "deploy/alerts/terraform/roles",
        "params": {
          "s3_bucketname_tfstate": "terraform-alerts",
          "alert_duration": 5,
          "alert_response_time_threshold": 5,
          "alert_throughput_threshold": 10,
          "alert_error_percentage_threshold": 10,
          "alert_cpu_threshold": 80
        }
      }
```

### Dashboards

Dashboards can be created in New Relic through the use of the Terraform provider.
Here is an example of the demo [demo-deployer](https://github.com/newrelic/demo-deployer) configuration.
This dashboard deployment creates a dashboard with 6 visualizations on it: Errors, Slowest Endpoints, Request Breakdown by Application, Host Memory Usage, HTTP Responses, and Heap Memory Used.
Similar to Alerts, you may also provision an S3 bucket with the deployer. If you do, beware that tearing down will remove that bucket, without a prompt or confirmation, and potentially impact anyone else who may be using that same bucket.

```json
      {
        "id": "nr_golden_dashboard",
        "provider": "newrelic",
        "provider_credential": "aws",
        "source_repository": "https://github.com/newrelic/demo-newrelic-instrumentation.git",
        "deploy_script_path": "deploy/dashboards/golden/terraform/roles",
        "params": {
          "s3_bucketname_tfstate": "terraform-dashboards"
        }
      }
```

## Contributing
We encourage your contributions to improve demo-newrelic-instrumentation! Keep in mind when you submit your pull request, you'll need to sign the CLA via the click-through using CLA-Assistant. You only have to sign the CLA one time per project.
If you have any questions, or to execute our corporate CLA, required if your contribution is on behalf of a company, please drop us an email at opensource@newrelic.com.

## License
demo-newrelic-instrumentation is licensed under the [Apache 2.0](http://apache.org/licenses/LICENSE-2.0.txt) License.