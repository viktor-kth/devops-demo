# Final Summary: From Docker CLI to Compose to Terraform

In this tutorial we have deployed the same simple app three times using different tools. For each step we have mended the limitations of the previous step by introducing the next one.

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

This has taken us from imperatively defining a container to being able to declare and entire infrastructure which can automatically be reconciliated in-case the actual running infrastructure were to change.  

## To recap

### Docker CLI (Imperative)

- Manually type each command (`docker run ...`)
- Fast but hard to reproduce
- No state, nor any safety checks

### Docker Compose (Declarative)

- Define the state of the container in a YAML file
- One command (`docker compose up -d`) to launch the container.
- Easy to share and reapet
- Great for local development and more structured testing, highly limited in terms of infrastructure change management and it limits us to a single container

### Terraform (Declarative infrastructure)

- Define the full infrastructure (not just container) in `.tf` files
- Supports Docker, AWS, Azure, Kubernetes and many more
- Keeps a state file, creates a change plan and is then able to apply this plan
- Is able to detect drift in the running infrastructure
- Can scale to multi-host and multi-cloud systems.

### Infrastructure as Code (IaC)

We have also briefly introduced the idea of Infrastructure as Code (IaC) which means that we declarativly define the desired final state of the infrastructure and the let a tool like Terraform solve the actual implemenation. This helps us ensure that our infrastructure is easier to mange and reproduce, but through Terraform we can also detect and automatically reconciliate any out-of-band changes that might occur in the infrastructure.

## Key Takeaway

- CLI is great for fast experimentation and one-off tests
- Compose is useful for local development and single host apps
- Terraform is the tool to use when you need a reliable and scaleable infrastructure, which is able to span multiple hosts and environments.

The next natural step after this tutorial would be to look more closely into the concept of IaC.
