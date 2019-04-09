## Terraform Enterprise Private Module Registry Demo

**NOTE:** This demo is designed for Terraform Enterprise to demonstrate the use of Sentinel policies and the private module registry through the TFE user interface.

To begin, make sure you have a Terraform Enterprise user account, and login to Terraform Enterprise.

### Use Case: Marketing

**Problem**

A marketing department often runs campaigns using simple websites and drives traffic to them. Traditionally, they have been required to coordinate with IT at least 6 weeks in advance of a campaign execution, which negatively impacts the timeliness of responding to market trends and activities. The security, networking, and operations teams are required to understand the amount of traffic they need to handle for each campaign as well as security considerations.

Because the marketing department works tirelessly to obtain more leads, IT is sometimes a little overwhelmed with these website requests. And after the campaign has ended, they must ensure the site is taken down and traffic rerouted to the main site.

**Solution**

Using Terraform Enterprise, the IT organization created a solution to not only ease the workload they receive from the marketing department, but it also exponetially decreases their delivery time. In fact, using their workspace in Terraform Enterprise, they can deliver campaign sites to the public in a self-service manner.

Marketing's engineering team can now write a simple Terraform script to deploy their website to a private subnet in AWS, and the modules provided by IT make it available to the public while adhering to corporate governance and compliance policies.

### Prerequisites

Before getting started, you'll want to fork or [duplicate](https://help.github.com/en/articles/duplicating-a-repository) these three repositories into your repo:

* https://github.com/kevincloud/terraform-aws-peered-vpcs
* https://github.com/kevincloud/terraform-aws-nginx-cdn
* https://github.com/kevincloud/terraform-solution

Next, make sure your VCS repository has been added to Terraform Enterprise.

### Step 1: Add Modules

There are two modules we'll use with our application.

**VPC Peering Module**

The first module creates three VPCs in the following AWS regions:

* us-east-1
* us-west-2
* eu-west-1

The VPCs are peered to us-east-1, where the new application will be deployed in the private subnet.

To add this module:

1. Click on **Modules** located in the top navigation menu
2. To the upper right, click on the **+ Add Module** button
3. Select *your-repo/terraform-aws-peered-vpcs* module from the **Module Source Repository** dropdown
4. Click **Publish Module**

**nginx Content Servers**

In each public subnet of each VPC, an nginx content server will be created to serve out the website in the private subnet in us-east-1.

To add this modules:

1. Click on **Modules** located in the top navigation menu
2. To the upper right, click on the **+ Add Module** button
3. Select *your-repo/terraform-aws-nginx-cdn* module from the **Module Source Repository** dropdown
4. Click **Publish Module**

### Step 2: Create a Workspace

The workspace is where Terraform will do the work of managing the infrastructure from your VCS repository.

To create a workspace:

1. Click on **Workspaces** located in the top navigation menu
2. To the upper right, click on the **+ New Workspace** button
3. Enter a name for your workspace, such as *my-workspace*
4. Select *your-repo/terraform-solution* module from the **Repository** dropdown
5. Click **Create Workspace**

**Configure Your Workspace**

Once your workspace has finished creating, we need to setup a couple of variables. For now, we'll just stick with using Terraform variables and will not use any environment variables.

1. Click on **Variables** located in the upper-right workspace nav menu
2. Under **Terraform Variables**, click **+ Add Variable**
3. For *key*, enter `aws_access_key`
4. For *value*, enter your AWS Access Key
5. To the right, click **Sensitive**
6. Click **Save Variable**
7. Repeat for the following additional variables:
   a. `aws_secret_key` - Sensitive; your AWS Secret Key
   b. `key_pair_use` - Not Sensitive; your key pair for use in us-east-1
   c. `key_pair_usw` - Not Sensitive; your key pair for use in us-west-2
   d. `key_pair_euw` - Not Sensitive; your key pair for use in eu-west-1
   e. `dns_hostname` - DNS hostname to use with hashidemos.io

### Step 3: Add Policies

We'll add two policies: one to control cost and one to ensure guardrail modules are used.

**Instance Policy**

This policy only allows for the use of 4 different instances. Use of any other instance will required approval. This is called *soft-mandatory* and will allow a workspace administrator to approval or reject the plan.

To add this policy:

1. Click on **Settings** located in the top navigation menu
2. From the left navigation menu, click **Policies**
3. To the upper right, click on the **Create a new policy** button
4. Enter a **Policy Name**, such as *small-instances*
5. From the **Enforcement Mode** dropdown, select *soft-mandatory (can override)*
6. Paste the code from the *instance_policy.sentinel* file located in the root of the terraform-solution repo
7. Click **Create policy**

**Module Policy**

The modules policy requires users to include specific modules in their Terraform scripts. For security and operations teams, this ensures the scripts are compliant with security and gonvernance policies.

To add this policy:

1. Click on **Settings** located in the top navigation menu
2. From the left navigation menu, click **Policies**
3. To the upper right, click on the **Create a new policy** button
4. Enter a **Policy Name**, such as *require-modules*
5. From the **Enforcement Mode** dropdown, select *hard-mandatory (cannot override)*
6. Paste the code from the *module_policy.sentinel* file located in the root of the terraform-solution repo
7. Click **Create policy**

**Apply Policies**

In order to make use of our new policies, we need to create a policy set, which bundles policies into a logical group and applies them to specific (or all) workspaces.

To create a policy set:

1. Click on **Settings** located in the top navigation menu
2. From the left navigation menu, click **Policy Sets**
3. To the upper right, click on the **Create a new policy set** button
4. Enter a **Name**, such as *enforce-policies*
5. Under **Scope of Policies**, select *Policies enforced on selected workspaces*
6. Under **Policies**, select *required-modules* from the dropdown and click **Add policy**, the select *small-instances* from the dropdown and click **Add policy**
7. Under **Workspaces**, select *my-workspace* from the dropdown and click **Add workspace**
8. Click **Create policy set**

### Step 4: Run the Demo

Now that we have our environment setup, we can have Terraform build out our solution.

To kickoff a run:

1. Click on **Workspaces** located in the top navigation menu
2. In the workspace list, click on the name of your workspace, such as *my-workspace*
3. To the upper right, click on the **Queue Plan** button
4. Enter a reason for running the plan, such as *First run*, and click **Queue Plan**

### Conclusion: Tweaks and Teardown

You can tweak with various parameters in the policies and the solution to exhibit different behaviors. Once you've completed the demo, you'll need to destroy the intrastructure.

To destroy the infrastructure:

1. Click on **Workspaces** located in the top navigation menu
2. In the workspace list, click on the name of your workspace, such as *my-workspace*
3. To the upper right, click on **Variables** in the navigation menu
4. Under the **Environment Variables** section, click **+ Add Variable**
5. For *key*, enter `CONFIRM_DESTROY`
6. For *value*, enter `1`
7. Click **Save Variable**
8. To the upper right, click on **Settings -> Destruction and Deletion** in the navigation menu
9. Click the **Queue destroy Plan** button

