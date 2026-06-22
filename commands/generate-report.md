# /generate-report

Compile audit findings into a professional security audit report.

## Usage

```
/generate-report --findings=<path> [--template=standard|executive|technical]
```

## Report Structure

1. **Executive Summary**: 1-page overview for non-technical stakeholders
2. **Scope**: What was audited, methodology, timeline
3. **Findings**: Ordered by severity (Critical → Info)
   - Finding title + CVSS score
   - Affected code (file:line)
   - Description + impact analysis
   - Reproduction steps
   - PoC code (if applicable)
   - Remediation (code patch in diff format)
4. **Security Assessment**: Overall risk rating
5. **Recommendations**: Process improvements, monitoring, future audits

## Severity Classification

| Severity | Criteria |
|----------|----------|
| Critical | Direct fund loss, permanent state corruption, no preconditions |
| High | Protocol invariants broken, requires specific preconditions |
| Medium | Degraded security, user impact possible, complex preconditions |
| Low | Best practice violation, information leak, no direct exploit |
| Info | Observation, suggestion, not a vulnerability |
