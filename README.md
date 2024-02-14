# Infrastructure (Tooling)

Terraform Infrastructure as Code (IaC) to provision the required infrastructure for any tooling required by the Planning Inspectorate application environments. This includes resources such as a container registry, Azure build agents, a Hub network, etc.

## Tooling

- IaC defined using [Terraform](https://www.terraform.io/)
- Validation and linting with [TFLint](https://github.com/terraform-linters/tflint)
- [Checkov](https://www.checkov.io/) for static analysis of the code for security issues and misconfigurations
- [Pre-commit](https://pre-commit.com/) hooks run checks to identify issues before code submission
- [Azure DevOps YAML pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/?view=azure-devops) to deploy the infrastructure
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) required for deployments
- Custom build agents configured using [Packer](https://www.packer.io/)

## Installation / Setup

The main tool required to work with this repo is Terraform. Instructrions to install can be found via the Terraform website (see [Tooling](#tooling) section).

However, if you are running macOS or Linux it is recommended you use a version manager for ease in case working with multiple Terraform versions. For this you can use [tfenv](https://github.com/tfutils/tfenv).

### Install tfenv and Terraform

Install tfenv ([Homebrew](https://brew.sh/)):

```bash
brew install tfenv
```

Install tfenv manually by checking out the repo and adding `.tfenv/bin` to your `$PATH`:

```bash
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
```

Install Terraform using tfenv:

```bash
tfenv install 1.1.6
```

### Install pre-commit hooks

Install pre-commit (requires Python/Pip):

```bash
pip install pre-commit
```

Install pre-commit ([Homebrew](https://brew.sh/)):

```bash
brew install pre-commit
```

Once pre-commit is installed, configure it in the project by running from the root:

```bash
pre-commit install
```

Pre-commit is configured using the `.pre-commit-config.yaml` file in the root of the project. In order for it to run, the required tools need to be installed which is covered below, and in the [Tooling](#tooling) section.

### Install and use Terraform-docs

Install terraform-docs ([Homebrew](https://brew.sh/)):

```bash
brew install terraform-docs
```

Install terraform-docs ([Chocolatey](https://chocolatey.org/)):

```bash
choco install terraform-docs
```

Terraform-docs automates Terraform documentation and makes it available in Markdown syntax. These have been placed in `README.md` files within each Terraform module throughout the repository.

This documentation has been automated using pre-commit hooks (see above). The `README.md` file for each Terraform module contains tags:

```bash
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
```

When the pre-commit hook runs then Terraform-docs will generate the documentation and add to the space between the tags.

If you create a new Terraform module, simply add a `README.md` file and add the above tags. Terraform-docs will then run for this module each time you make a commit.

To run Terraform-docs for the whole repository, run:

```bash
pre-commit run -a terraform-docs
```

### Install and use TFLint

Install tflint (Bash script Linux):

```bash
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
```

Install tflint ([Homebrew](https://brew.sh/)):

```bash
brew install tflint
```

Install tflint ([Choolatey](https://chocolatey.org/)):

```bash
choco install tflint
```

TFLint is configured via the `.tflint.hcl` file in the project root. It needs to be initialised before running.

```bash
tflint --init
```

### Install and use Checkov

Install Checkov (Python/Pip):

```bash
pip install checkov
```

Install Checkov ([Homebrew](https://brew.sh/)):

```bash
brew install checkov
```

Checkov runs a scan of the infrastructure as code, and can be pointed a Terraform module using the -d flag:

```bash
checkov -d /path/to/module
```

In some scenarios Checkov may report configuration issues that are intentional. In order to bypass these checks, you can add a comment to the Terraform resource it complains about like so:

```bash
resource "azurerm_storage_account" "my_storage_account" {
  #checkov:skip=CKV_AZURE_109: Skip reason

  ...
}
```

Where in this example, `CKV_AZURE_109` is the check to bypass.

### Packer

Install Packer ([Homebre](https://brew.sh/)):

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/packer
```

Install via binary - <https://www.packer.io/downloads>

## Pipelines

The Pipelines run in the Azure DevOps [infrastructure](https://dev.azure.com/planninginspectorate/infrastructure) project. They are defined in YAML templates in the `pipelines` folder.

There is a CI pipeline which runs validation and various checks. This is linked to Pull Requests, so it must pass before it is possible to merge.

The CD pipeline deploys the tooling infrastructure to the Tooling subscription (pins-odt-tooling-shared-sub). This is triggered automatically to the Dev environment when there is a merge to the `main` branch. For manual runs, you must choose the region and stack you wish to deploy.

## Build Agents

The build agents are set up using Packer templates. Therer are 2 pipelines that run using Microsoft Hosted agents. One to build the image, and one to clean up any old images.

The Packer templates can be found within the `packer/azure-agents` folder. The `tools.sh` script contains the setup instructions for the image.

Once the image has been created, the regular CD pipeline can be run to update the Azure Scale Set with the new image.
