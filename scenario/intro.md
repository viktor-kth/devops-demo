# From Imperative to Declarative: From a CLI Docker server to a Terraform infrastructure

Interaction with infrastructure is to begin usually done through something like, spinning up a docker instance using some cloud platform, then you would SSH into the instance and maybe start it using a few `docker run` commands. Its fast but but incredibly cumbersom to update and let alone scale.

This tutorial will walk you through the steps from imperativly spinning up a docker to declarativly defining the infrastructure with terraform. We will deploy the same simple app three times, one time each with the different methods instance with a simple front-end, backend endpoint.

From a step by step perspective the tutorial is outlined as such:

```bash
    +----------------------------------+
    |  Docker CLI (Imperative)         |
    |  - One container at a time       |
    |  - Manual flags and runs         |
    +----------------------------------+
                    │
                    ▼
    +----------------------------------+
    |  Docker Compose (Declarative)    |
    |  - Multi-service config in YAML  |
    |  - Single-host scope             |
    +----------------------------------+
                    │
                    ▼
    +----------------------------------+
    |  Terraform (Full IaC)            |
    |  - Infra across providers        |
    |  - State, plans, drift detection |
    +----------------------------------+
```

## Intended Learning Outcomes (ILO)

By the end, you will be able to:

1. Explain the differences between imperative Docker, declarative Docker Compose, and Infrastructure-as-Code with Terraform.
2. Have an understanding for how each approach handles changes.
3. Have a pratical idea of how to setup and implement a simple front-end, backend service using, Docker CLI, Docker Compose and Terraform.

## Difference between Imperative and Declarative

- Imperative (Docker CLI): You tell the machine how to do each step. This leads to a fast feedback loop, but changes are hard to reproduce.
- Declarative (Compose/Transform): The desired state of the system is declared, and a tool figures out how to reach said state.

## Notes

This container that we are going to be working in is already containing both the `docker compose` files and the `terraform` files, we will use these later on in the tutorial, but feel free to run `ls` to browse the contents.
