### Open Install Library

The [Open Install Library](https://github.com/newrelic/open-install-library) provides automated installation and setup of New Relic products and integrations.  The Open Install Library can be run on a host and it will attempt to auto-instrument what it can discover.  Optionally you can pass a set of configuration to the Open Install Library and it will attempt to setup instrumentation.

#### Open Install Library - Auto Discovery

This instrument block will run the newrelic cli and attempt to auto discover what is it can and install instrumentation.  Normally this will include installing the Infrastructural agent, configuring it and setting up system logs to forward.

```json
"instrumentations": {
  "resources": [
    {
      "id": "nr_open_installation",
      "resource_ids": ["host1"],
      "provider": "newrelic",
      "source_repository": "https://github.com/newrelic/demo-newrelic-instrumentation.git",
      "deploy_script_path": "deploy/open-install-library/linux/roles",
    }
  ]
}
```

#### Open Install Library - Provide list of install tasks

This instrumentation block will run the newrelic cli feeding it a list of install tasks to run on the host.  The install task listed will setup the Infrastructure agent, configuring it and setting up system logs to forward.  More installation task can be found in the [Open Install Library](https://github.com/newrelic/open-install-library) git repo.

```json
"instrumentations": {
  "resources": [
    {
      "id": "nr_virtuoso",
      "resource_ids": ["host1"],
      "provider": "newrelic",
      "source_repository": "https://github.com/newrelic/demo-newrelic-instrumentation.git",
      "deploy_script_path": "deploy/open-install-library/linux/roles",
      "params": {
      "recipe_content_url": [
        "https://raw.githubusercontent.com/newrelic/open-install-library/main/recipes/newrelic/infrastructure/amazonlinux2.yml",
        "https://raw.githubusercontent.com/newrelic/open-install-library/main/recipes/newrelic/infrastructure/logs/logs.yml"             ],
      }
    }
  ]
}
```

#### Open Install Library - pass parameters

If any of the install tasks need configuration other "params" key/values can be passed along.  Only key starting with "NR_CLI_" passed along to each install task.  The key/value pairs will be set a environment variables for each install task that is run.

In this example the needed configuration for setting up the MySQL on host integration parameters are defined.

```json
"instrumentations": {
  "resources": [
    {
      "id": "nr_virtuoso",
      "resource_ids": ["host1"],
      "provider": "newrelic",
      "source_repository": "https://github.com/newrelic/demo-newrelic-instrumentation.git",
      "deploy_script_path": "deploy/open-install-library/linux/roles",
      "params": {
        "recipe_content_url": [
          "https://raw.githubusercontent.com/newrelic/open-install-library/main/recipes/newrelic/infrastructure/amazonlinux2.yml",
          "https://raw.githubusercontent.com/newrelic/open-install-library/main/recipes/newrelic/infrastructure/logs/logs.yml",
          "https://raw.githubusercontent.com/newrelic/open-install-library/main/recipes/newrelic/infrastructure/ohi/mysql/rhel.yml"
        ],
        "NR_CLI_DB_USERNAME" : "root",
        "NR_CLI_DB_PASSWORD" : "[credential:secrets:database_root_password]",
        "NR_CLI_DB_HOSTNAME" : "localhost",
        "NR_CLI_DB_PORT" : "[service:mariadb1:port]",
        "NR_CLI_DATABASE" : "<<DATABASE_NAME>>"
      }
    }
  ]
}
```

