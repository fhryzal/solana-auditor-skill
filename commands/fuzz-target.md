# /fuzz-target

Generate and run a fuzzing harness for a specific Anchor instruction.

## Usage

```
/fuzz-target <instruction-name> [--duration=24h] [--strategy=honggfuzz|trident|litesvm]
```

## Workflow

1. Parse instruction accounts and data from IDL
2. Generate Trident fuzz harness template
3. Configure Honggfuzz with appropriate dictionary
4. Run campaign for specified duration
5. Triage crashes: categorize, minimize, report
6. Pass exploitable crashes to exploit-developer

## Output

- Fuzzing harness source code
- Coverage report
- Crash log with minimized inputs
- Crash categorization (state corruption / arithmetic / auth bypass)
- Recommendation for fixes
