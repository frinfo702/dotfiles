# Skill tree

Skill ids are lowercase kebab-case. Unknown ids are allowed and land in track `other`.

## Languages

| id | label |
|----|--------|
| go | Go |
| python | Python |
| typescript | TypeScript |
| javascript | JavaScript |
| rust | Rust |
| java | Java |
| c | C |
| cpp | C++ |
| sql | SQL |
| bash | Bash/Shell |

## Engineering

| id | focus |
|----|--------|
| debugging | systematic isolation, bisect, observability |
| testing | unit/integration/e2e, TDD, oracles |
| git | history, PR hygiene, collaboration |
| ci-cd | pipelines, gates, release |
| security | threat models, safe defaults |
| performance | measurement, complexity, profiling |
| tooling | editors, linters, build systems, DX |

## Design & architecture

| id | focus |
|----|--------|
| system-design | capacity, components, trade-offs |
| api-design | contracts, versioning, errors |
| data-modeling | schemas, invariants, migrations |
| architecture | modularity, boundaries, evolution |
| distributed-systems | consistency, failure, consensus-ish judgment |

## Reading & communication

| id | focus |
|----|--------|
| code-reading | navigate large codebases |
| pr-review | constructive, risk-focused review |
| docs-writing | clear technical prose |
| rfc-communication | design docs, ADRs, RFCs |

## ML engineering

| id | focus |
|----|--------|
| ml-engineering | training loops, pipelines, reproducibility |
| mlops | deploy, monitor, drift, rollback |
| data-engineering | ETL, quality, lineage |
| feature-engineering | representations, leakage control |
| model-serving | latency, batching, hardware |
| evaluation-metrics | online/offline metrics, slices |

## ML research

| id | focus |
|----|--------|
| research-method | questions, hypotheses, validity |
| paper-reading | claims vs evidence, related work |
| experiment-design | controls, ablations, power |
| math-foundations | linear algebra, prob, optimization |
| scientific-writing | papers, clarity of claims |
| ablation-analysis | what actually mattered |

## Per-skill levels

Same logarithmic curve as main level but `SCALE=10`, `BASE=40`:

- skill Lv1–3: guided
- Lv4–6: independent on routine tasks
- Lv7–10: strong; teaches others
- Lv11+: specialist depth
