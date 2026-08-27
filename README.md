# 📋 Fleet Inventory — The Quartermaster's Clipboard

> *You do not read it to celebrate. You read it so you do not grab something that will crumble the second you put weight on it.*

<img src="assets/images/hero.jpg" alt="The quartermaster's clipboard under a warm lamp — handwritten manifests on a chart table in a navy-dark hold" width="720"/>

Six documents scanning 200+ repos. The honest map of what the fleet has built, what works, what's close, and what's research. Read these before starting new work.

**Created:** August 9, 2026 · **Last scan:** August 9, 2026 · **Total repos:** 200+

---

## Documents

| Document | What It Covers |
|----------|---------------|
| [`FLEET-ASSESSMENT.md`](./FLEET-ASSESSMENT.md) | Deep inventory of all production-ready code. Marine stack (vessel-agent-system, hermes, sensor-bridge), cognitive backbone (Slackwater Python + Rust), game engines (MUD, OQ, Plato's Shell, The Tap, ScummVM), infrastructure (Collective Unconscious, Lucineer, Cloudflare Workers). |
| [`STUDY-REPO-ASSESSMENT.md`](./STUDY-REPO-ASSESSMENT.md) | 85 research/experimental repos assessed. Active vs dormant, paper-backed vs experimental, production-informative vs exploratory. |
| [`DEEP-REPO-ASSESSMENT.md`](./DEEP-REPO-ASSESSMENT.md) | Code-level integration plans for 10 high-value repos. File paths, function signatures, specific wiring instructions. Not READMEs — actual source code analysis. |
| [`integration-matrix.md`](./integration-matrix.md) | Cross-repo connection map. Which repos feed which. Top 10 integrations ranked by leverage. The cognitive triangle: Perception → Collective Unconscious → MUD Engine. |
| [`CUTTING-EDGE-RESEARCH.md`](./CUTTING-EDGE-RESEARCH.md) | August 2026 landscape scan. Multi-agent frameworks, MCP, Cloudflare Workers AI, JEPA, local LLMs, vector DBs, game AI. Competitive analysis: is anyone building SuperInstance? |
| [`NEXT-LEVEL-PLAN.md`](./NEXT-LEVEL-PLAN.md) | Seven ranked projects from multi-model synthesis (DeepSeek Pro + Seed Mini + Hermes 405B). The thesis: we built 70 repos in 2 months. The parts are excellent. The joints don't exist. |

---

## Executive Summary (from FLEET-ASSESSMENT)

**Production-ready:**
- **Slackwater Python stack** — 6 packages, 508+ tests. The cognitive backbone.
- **Slackwater-Rust workspace** — 3 crates, 308 tests, zero unsafe. Performance cores.
- **MUD Engine** — 10-package TypeScript monorepo. The game engine for AI agents.
- **Vessel Agent System (AELMA)** — 178 files, 34 test suites. The marine stack.

**Close but needs polish:**
- [elephant](https://github.com/SuperInstance/elephant) · [platos-shell](https://github.com/SuperInstance/platos-shell) · [the-tap](https://github.com/SuperInstance/the-tap) · [scummvm-arcade](https://github.com/SuperInstance/scummvm-arcade) · [collective-unconscious](https://github.com/SuperInstance/collective-unconscious)

**Highest-leverage integration:**
Slackwater-Perception → Collective Unconscious → MUD Engine. That triangle is the product.

---

## How to Use

1. **Read [FLEET-ASSESSMENT.md](./FLEET-ASSESSMENT.md) first.** It tells you what exists and what condition it's in.
2. **Check [integration-matrix.md](./integration-matrix.md)** to see what's wired and what's not.
3. **Drill into [DEEP-REPO-ASSESSMENT.md](./DEEP-REPO-ASSESSMENT.md)** for code-level integration plans on the top 10 repos.
4. **Consult [NEXT-LEVEL-PLAN.md](./NEXT-LEVEL-PLAN.md)** before planning new work — it ranks the 7 highest-leverage projects.
5. **Scan [CUTTING-EDGE-RESEARCH.md](./CUTTING-EDGE-RESEARCH.md)** to know what the outside world is building.
6. **Check [STUDY-REPO-ASSESSMENT.md](./STUDY-REPO-ASSESSMENT.md)** before creating a new study repo — someone may have already explored it.

---

## Fleet Connections

- [lucineer-fleet-wiki](https://github.com/SuperInstance/lucineer-fleet-wiki) — wiki pulls fleet status from these assessments
- [cocapn-dashboard](https://github.com/SuperInstance/cocapn-dashboard) — dashboard visualizes fleet status data
- [fleet-connections](https://github.com/SuperInstance/fleet-connections) — integration keel implements the wiring plans from DEEP-REPO-ASSESSMENT
- [fleet-envelope](https://github.com/SuperInstance/fleet-envelope) — event grammar for the integrations listed here
- [AI-Writings](https://github.com/SuperInstance/AI-Writings) — corpus sourced from the creative repos assessed here

---

## The Hermit Crab Connection

The inventory IS the shell inventory. Before an agent finds a shell to inhabit, the quartermaster checks the clipboard to see what shells exist and what condition they're in. [mud-engine](https://github.com/SuperInstance/mud-engine) agents reference fleet-inventory to know what tools are available.

---

## Further Reading

### For Developers

- [Fleet Assessment](FLEET-ASSESSMENT.md) — the full inventory
- [Deep Repo Assessment](DEEP-REPO-ASSESSMENT.md) — code-level integration plans
- [Integration Matrix](integration-matrix.md) — cross-repo connection map
- [Cutting-Edge Research](CUTTING-EDGE-RESEARCH.md) — August 2026 landscape scan
- [Next-Level Plan](NEXT-LEVEL-PLAN.md) — 7 ranked projects from multi-model synthesis

### For Project Managers

- [Technical Debt (Wikipedia)](https://en.wikipedia.org/wiki/Technical_debt) — what the assessment measures
- [Software Rot (Wikipedia)](https://en.wikipedia.org/wiki/Software_rot) — why inventory matters
- [Dependency Hell (Wikipedia)](https://en.wikipedia.org/wiki/Dependency_hell) — tracking cross-repo dependencies
- [Code Review (Wikipedia)](https://en.wikipedia.org/wiki/Code_review) — assessment methodology
- [Software Archaeology](https://en.wikipedia.org/wiki/Software_archaeology) — understanding legacy code

### For Architects

- [System Integration (Wikipedia)](https://en.wikipedia.org/wiki/System_integration) — what the integration matrix maps
- [Coupling (Computer Programming)](https://en.wikipedia.org/wiki/Coupling_(computer_programming)) — why loose coupling matters
- [Cohesion (Computer Science)](https://en.wikipedia.org/wiki/Cohesion_(computer_science)) — module-level quality metric
- [Service-Oriented Architecture](https://en.wikipedia.org/wiki/Service-oriented_architecture) — fleet architecture pattern

### For Researchers

- [Multi-Agent Systems (Wikipedia)](https://en.wikipedia.org/wiki/Multi-agent_system) — what the fleet implements
- [Emergence (Wikipedia)](https://en.wikipedia.org/wiki/Emergence) — complex behavior from simple agents
- [Model Context Protocol (MCP)](https://en.wikipedia.org/wiki/Model_Context_Protocol) — agent communication standard
- [Large Language Models (Wikipedia)](https://en.wikipedia.org/wiki/Large_language_model) — the AI substrate

---

## License

MIT · Built by Casey DiGennaro & the SuperInstance Fleet
