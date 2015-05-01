# Role Design

## Scenario

Role A
Role A inherits Role A1
Role A inherits Role B

Role A provided by A
Role A1 provided by A
Role B provided by B

Provider A
Provider B

Owner A owns Role A
Owner B owns Role B

## Queries

Provider A owned by Owner A
Provider A owned by Owner A via Role A
Provider A owned by Owner A via Role A1 inherited by Role A

Provider B owned by Owner A
Provider B owned by Owner A via Role B inherited by Role A

Provider B owned by Owner B
Provider B owned by Owner B via Role B
