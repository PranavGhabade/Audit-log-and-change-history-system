# Milestone 9: Partitioning Experiment Results

## Dataset

- Records: 100,000
- Baseline table: `audit_log_partition_test`
- Partitioned table: `audit_log_partitioned_test`
- Partitioning strategy: RANGE partitioning on `changed_at`
- Number of partitions: 6 monthly partitions
- Period: January 2026 to June 2026

## Results

| Query | Non-partitioned | Partitioned |
|---|---:|---:|
| March range | 8.601 ms | 3.819 ms |
| March + changed_by | 6.399 ms | 1.143 ms |
| May range | 8.046 ms | 2.052 ms |

## Observations

1. The non-partitioned table used sequential scans over the full 100,000-row table.
2. The partitioned table used only the relevant monthly partition.
3. PostgreSQL performed partition pruning based on the `changed_at` range condition.
4. Buffer usage decreased from 1334 shared buffers to 229 shared buffers for the tested monthly queries.
5. The controlled experiment demonstrated lower execution time for time-range queries after partitioning.

## Conclusion

Time-based RANGE partitioning is suitable for large audit-log workloads because audit records are naturally queried by time ranges. Partition pruning allows PostgreSQL to avoid scanning partitions that cannot contain matching records.