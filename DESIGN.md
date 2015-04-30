# Role Design

## Scenario

Role A
Role A inherits Role A1
Role A inherits Role B

Role A scoped by A
Role A1 scoped by A
Role B scoped by B

Scope A
Scope B

Owner A owns Role A
Owner B owns Role B

## Queries

Scope A owned by Owner A
Scope A owned by Owner A via Role A
Scope A owned by Owner A via Role A1 inherited by Role A

Scope B owned by Owner A
Scope B owned by Owner A via Role B inherited by Role A

Scope B owned by Owner B
Scope B owned by Owner B via Role B
