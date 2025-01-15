# README

## Overview

This project automates the management of ACME certificates with flexible configurations. It supports two modes of operation:

1. **Environment Variables Mode**: Use Docker environment variables to configure certificate issuance and management.
2. **Configuration File Mode**: Use issue-specific shell scripts in `/myacme/issues` for detailed configurations. These configurations take precedence over global environment variables and ensure isolation between different issues.

---

## Features

- Automatically issues and renews ACME certificates.
- Supports wildcard and non-wildcard certificates.
- Flexible configuration using Docker environment variables or configuration files.
- Independent execution of issue-specific configurations.
- Falls back to global environment variables for missing values in configuration files.
- Ensures isolation between different issue configurations.
- Supports dynamic container restart or reload after certificate issuance.
- Supports file-based and environment-variable-based secret management.

---

## Usage

### 1. Environment Variables Mode

Define configurations directly in the Docker container. If no configuration files are present in `/myacme/issues`, the system will rely entirely on the environment variables for execution.

#### Example: `docker-compose.yml`
```yaml
services:
  acme:
    build:
      context: .
    environment:
      ACME_ISSUE_ENABLE: true
      ACME_ISSUE_DOMAINS: example.com,abc.example.com
      ACME_ISSUE_WILDCARD: false
      ACME_ISSUE_FORCE: false
      ACME_ISSUE_SERVER: zerossl
      ACME_CA_MAIL: user@example.com
      ACME_INSTALL_CERT: true
      ACME_INSTALL_CERT_DIR: /certs
      ACME_INSTALL_CERT_UNIT_NAME: true
      ACME_CERTS_UID: 0
      ACME_CERTS_GID: 1000
      ACME_CERTS_PREMISSIONS: 640
      CF_Account_ID_FILE: /secrets/cloudflare_account_id
      CF_Token_FILE: /secrets/cloudflare_token
      CF_Zone_ID_FILE: /secrets/cloudflare_zone_id
      ACME_CONTAINER_NGINX_RELOAD: nginx-container-id
    volumes:
      - ./certs:/certs
      - /var/run/docker.sock:/var/run/docker.sock:ro
```

### 2. Configuration File Mode
If `/myacme/issues` contains files matching the pattern `[0-9]*.sh`, the system will execute these files in order. Each file represents a specific certificate configuration. Missing variables in these files will be supplemented by global environment variables.

#### Example Configuration File: `/myacme/issues/001-demo.sh`
```bash
ACME_ISSUE_DOMAINS="example.com"
ACME_ISSUE_WILDCARD="false"
ACME_INSTALL_CERT_DIR="/certs/example"
ACME_CA_MAIL="admin@example.com"
```
#### Execution Logic:
1. Configuration files are executed sequentially based on their filenames.
2. Variables not declared in a configuration file will fall back to globally defined environment variables.
3. Each configuration file is executed in isolation to prevent conflicts between different issues.

---

## Environment Variables

| **Environment Variable**      | **Description**                                                                                            | **Default Value** | **Required** | **Example**                      |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------- | ----------------- | ------------ | -------------------------------- |
| `ACME_ISSUE_ENABLE`           | Enable or disable certificate issuance.                                                                    | `true`            | Yes          | `true`                           |
| `ACME_ISSUE_DOMAINS`          | Comma-separated list of domains for the certificate.                                                       |                   | Yes          | `example.com,abc.example.com`    |
| `ACME_ISSUE_WILDCARD`         | Enable wildcard certificate issuance (`true` or `false`).                                                  | `false`           | No           | `true`                           |
| `ACME_ISSUE_FORCE`            | Force re-issuance of certificates regardless of expiry.                                                    | `false`           | No           | `true`                           |
| `ACME_ISSUE_SERVER`           | ACME server to use (`letsencrypt`, `zerossl`, etc.).                                                       | `zerossl`         | No           | `letsencrypt`                    |
| `ACME_CA_MAIL`                | Email address for ACME account registration.                                                               |                   | Yes          | `user@example.com`               |
| `ACME_INSTALL_CERT`           | Enable certificate installation after issuance.                                                            | `true`            | No           | `true`                           |
| `ACME_INSTALL_CERT_DIR`       | Directory to store issued certificates.                                                                    | `/certs`          | No           | `/certs/mydomain`                |
| `ACME_INSTALL_CERT_UNIT_NAME` | Boolean to specify whether to install certificates with standard names (e.g., `fullchain.pem`, `key.pem`). | `false`           | No           | `true`                           |
| `ACME_CERTS_UID`              | UID for setting certificate file ownership.                                                                | `0` (root)        | No           | `1001`                           |
| `ACME_CERTS_GID`              | GID for setting certificate file group ownership.                                                          |                   | No           | `1000`                           |
| `ACME_CERTS_PREMISSIONS`      | File permissions for certificate files (e.g., `640`).                                                      |                   | No           | `640`                            |
| `CF_Account_ID_FILE`          | File path to the Cloudflare account ID secret. If the file does not exist, falls back to environment.      |                   | No           | `/secrets/cloudflare_account_id` |
| `CF_Token_FILE`               | File path to the Cloudflare API token secret. If the file does not exist, falls back to environment.       |                   | Yes (if DNS) | `/secrets/cloudflare_token`      |
| `CF_Zone_ID_FILE`             | File path to the Cloudflare zone ID secret. If the file does not exist, falls back to environment.         |                   | Yes (if DNS) | `/secrets/cloudflare_zone_id`    |
| `ACME_CONTAINER_RESTART`      | Restart containers after certificate issuance (comma-separated list of names).                             |                   | No           | `nginx,web`                      |
| `ACME_CONTAINER_NGINX_RELOAD` | Reload the specified NGINX container after certificate issuance. Requires the container ID.                |                   | No           | `nginx-container-id`             |
| `ACME_STARTUP_INSTALL_CERT` | Install the certs whil the container startup                |       `false`            | No           | `true`             |

---

## Example Workflow

1. **Without Configuration Files**:
   - Set environment variables in `docker-compose.yml`.
   - Start the container:
```bash
docker-compose up -d
```

2. **With Configuration Files**:
   - Place configuration files in `/myacme/issues` (e.g., `001-demo.sh`, `002-another.sh`).
   - Start the container:
```bash
docker-compose up -d
```

3. **Verify Logs**:
   View container logs to monitor certificate issuance:
```bash
docker logs acme
```

### Notes
* **File Fallback**: If any CF_Account_* file does not exist, the system will fall back to reading the value from environment variables.
* **Container Isolation**: Each issue configuration file is executed in isolation to prevent conflicts.
* **Secrets Management**: Ensure sensitive data such as Cloudflare tokens are securely stored and mounted as secrets.

