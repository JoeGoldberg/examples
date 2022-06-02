# **Serverless job execution with Control-M**

Generally, serverless is a computing paradigm in which the complexities of managing computing infrastructure have been eliminated. When executing a program, one simply writes the program and "submits" it to the serverless environment, which automatically provisions whatever technlogy is required to run the program.

In the case of executing workflows, the desire is to provide a similar level of abstraction in which there is no need to worry about provisioning virtual machines, configuring them, etc.

In a traditional Control-M environment, whether on-prem or cloud, there is usually a requirement to deploy and configure agents, with sufficient compute capabity, to execute jobs that may be submitted. If resources aren't available, jobs enter a "Wait Host" status, where they remain until manual effort is applied to provide the desired resources.

The artifacts in this repository provide an alternative that makes Control-M behave in a somewhat serverless manner. Once the methodology described here is deployed, the arrival of jobs requesting specific resources, results in agents (workers) being dynamically provisioned enabling the jobs to execute and the resources automatically decommissioned upon completion of all the jobs. 

## Details
Jobs are submitted requesting specific hostgroups. If no agents are available, the likely situation, the jobs enter "Wait Host" status. A Control-M job polls for jobs in Wait Host status. For each job in that state, a check is made whether the hostgroup being waited on, is a "serverless" hostgroup. If not, the job is ignored. If yes, the corresponding monitoring workflow for each hostgroup is submitted for execution. The workflow provisions the desired resources in the environment defined for that hostgroup, connects an agent and watches for job execution of all jobs that may be waiting for any of the agents in the newly launched hostgroup. Once they ar eall complete, the process is reversed to decommision the dynamic resources.

### **Artifacts**
A brief description of the contents:

 - **Serverless Hostgroups** - the participating hostgroups are defined by a Control-M condition in the form of "ctm-serverless-hostgroup-name:<< hostgroup >>". See [define-sless-queues.sh](define-sless-queues.sh) for sample definitions.
 - **Monitoring Workflow** - the set of jobs that deploy, monitor and decommission the Hostgroup. This name is defined by a Control-M condition in the form of "ctm-serverless-hostgroup-folder-<< hostgroup >>:<< workflow folder name >>". See [define-sless-queues.sh](define-sless-queues.sh) for sample definitions.
 - **jog-serverless-master.json** - This workflow runs constantly. When a new instance of the workflow begins, a check is made if another instance is already executing. If yes, Control-M conditions are used to request the incumbent instance to shut down and after that has occurred, the new instance starts its monitoring. Most of the work is perfromed by an embedded script.
 - **jog-sless-aws.json** - Jobs to launch an EC2 instance based on a pre-built AMI that starts and configures a Control-M agent. These jobs expect to be run on an EC2 instance an associated IAM Role that has the permission to perform all the required AWS actions. Most of the work is perfromed by embedded scripts.
 - **jog-sless-az.json** - Jobs to create an Azure VM that runs a bootstrap script to install and configure a Control-M agent. These jobs expect to be run on a virtual machine with a Managed Identity that has the access to perform all the required Azure actions. Most of the work is perfromed by embedded scripts.
 - **jog-sless-gcp.json** - Jobs to create a Google Compute virtual machine and run a bootstrap script to install and configure a Control-M agent. These jobs expect to be run on a GCP VM with an associated Service Account that has the access to perform all the required GCP actions. Most of the work is perfromed by embedded scripts.
 - **define-sless-queues.sh** - bash script to define Control-M conditions that define the hostgroups and workflows that perform the required management actions